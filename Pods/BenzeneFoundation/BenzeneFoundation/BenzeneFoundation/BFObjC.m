//
//  BFObjC.m
//  BenzeneFoundation
//
//  BSD License
//
//  Copyright (c) 2012-2015, Wantoto Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of the Wantoto Inc. nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL Wantoto Inc. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "BFObjC.h"
#import <objc/runtime.h>
#import "BFFunctionUtilities.h"
#import "NSEnumerator+Benzene.h"

#pragma mark - Classes

@interface BFSubclassesEnumerator : NSEnumerator {
    Class _BaseClass;
    unsigned int _classesCount;
    Class *_classes;
    unsigned int _classesEnumerateIndex;
}

- (instancetype)initWithBaseClass:(Class)BaseClass;

@end

@implementation BFSubclassesEnumerator

- (instancetype)initWithBaseClass:(Class)BaseClass {
    if (self = [super init]) {
        _BaseClass = BaseClass;

        _classesCount = objc_getClassList(NULL, 0);
        if (_classesCount <= 0) {
            return self = nil;
        }
        _classes = (Class *)malloc(_classesCount*sizeof(Class));
        if (!_classes) {
            return self = nil;
        }
        memset(_classes, '\0', _classesCount);
        NSAssert(objc_getClassList(_classes, _classesCount) == _classesCount, @"Failed to load class list");

        _classesEnumerateIndex = 0;
    }
    return self;
}

- (void)dealloc {
    if (_classes) {
        free(_classes), _classes = nil;
    }
}

- (id)nextObject {
    while (_classesEnumerateIndex < _classesCount) {
        Class klass = _classes[_classesEnumerateIndex++];
        if (klass != _BaseClass && class_getSuperclass(klass) && [klass isSubclassOfClass:_BaseClass]) {
            return klass;
        }
    }
    return nil;
}

@end

BF_EXTERN NSEnumerator<Class> *BFClassEnumeratorOfSubclasses(Class BaseClass) {
    return [[BFSubclassesEnumerator alloc] initWithBaseClass:BaseClass];
}

BF_EXTERN NSEnumerator<Class> *BFClassesConformedProtocol(Protocol *protocol) {
    return [BFClassEnumeratorOfSubclasses(NSObject.class)
            enumeratorFilteredByPredicate:
            [NSPredicate predicateWithBlock:^BOOL(Class klass, NSDictionary<NSString *,id> *_) {
        return [klass conformsToProtocol:protocol];
    }]];
}

#pragma mark - Properties

BF_EXTERN void BFObjectInspectionEnumerateProperty(Class ObjectClass,
                                                   BFObjectInspectionPropertyEnumerator block) {
    Class CurrentClass = ObjectClass;
    BOOL stop = NO;
    while (CurrentClass && !stop) {
        unsigned int propertiesCount = 0;
        objc_property_t *__block properties = class_copyPropertyList(CurrentClass, &propertiesCount);
        @onExit {
            BFFreeCMemoryBlock(properties);
        };

        for (unsigned int i=0; i<propertiesCount && !stop; ++i) {
            objc_property_t property = properties[i];
            ext_propertyAttributes *attributes = ext_copyPropertyAttributes(property);
            @onExit {
                free(attributes);
            };
            block(property, property_getName(property), attributes, CurrentClass, &stop);
        }

        // Go to super class
        CurrentClass = [CurrentClass superclass];
    }
}

BF_EXTERN void BFObjectInspectionEnumeratePropertyOfProtocol(Protocol *protocol,
                                                             BFObjectInspectionProtocolPropertyEnumerator block) {
    NSMutableArray *ProtocolsToVisit = [NSMutableArray arrayWithObject:protocol];
    BOOL stop = NO;
    while (ProtocolsToVisit.count != 0 && !stop) {
        Protocol *CurrentProtocol = ProtocolsToVisit.firstObject;
        @onExit {
            [ProtocolsToVisit removeObjectAtIndex:0];
        };

        unsigned int propertiesCount = 0;
        objc_property_t *__block properties = protocol_copyPropertyList(CurrentProtocol, &propertiesCount);
        @onExit {
            BFFreeCMemoryBlock(properties);
        };

        for (unsigned int i=0; i<propertiesCount && !stop; ++i) {
            objc_property_t property = properties[i];
            ext_propertyAttributes *attributes = ext_copyPropertyAttributes(property);
            @onExit {
                free(attributes);
            };
            block(property, property_getName(property), attributes, CurrentProtocol, &stop);
        }

        unsigned int protocolsCount = 0;
        Protocol * __unsafe_unretained *__block protocols = protocol_copyProtocolList(CurrentProtocol, &protocolsCount);
        @onExit {
            BFFreeCMemoryBlock(protocols);
        };
        [ProtocolsToVisit addObjectsFromArray:[NSArray arrayWithObjects:protocols count:protocolsCount]];
    }
}

#pragma mark - Protocols

@interface _BFProtocolEnumerator : NSEnumerator {
    NSArray<Protocol *> *_protocols;
    unsigned int _protocolsEnumerateIndex;
}

@end

@implementation _BFProtocolEnumerator

- (instancetype)init {
    if (self = [super init]) {
        unsigned int protocolsCount;
        Protocol *__unsafe_unretained *protocols = objc_copyProtocolList(&protocolsCount);

        NSMutableArray<Protocol *> *result = [[NSMutableArray alloc] initWithCapacity:protocolsCount];
        for (unsigned int i = 0; i < protocolsCount; ++i) {
            [result addObject:protocols[i]];
        }

        _protocols = [NSArray arrayWithArray:result];
        _protocolsEnumerateIndex = 0;
    }
    return self;
}

- (id)nextObject {
    if (_protocolsEnumerateIndex < _protocols.count) {
        return _protocols[_protocolsEnumerateIndex++];
    } else {
        return nil;
    }
}

@end

BF_EXTERN NSEnumerator<Protocol *> *BFProtocolEnumerator() {
    return [[_BFProtocolEnumerator alloc] init];
}

BF_EXTERN NSEnumerator<Protocol *> *BFConformedProtocolsOfClass(Class klass) {
    return [BFProtocolEnumerator()
            enumeratorFilteredByPredicate:
            [NSPredicate predicateWithBlock:^BOOL(Protocol *protocol, NSDictionary<NSString *,id> *_) {
        return [klass conformsToProtocol:protocol];
    }]];
}
