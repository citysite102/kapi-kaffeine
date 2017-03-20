//
//  BFDictionaryObjectHelper.m
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

#import "BFDictionaryObjectHelper.h"
#import "BFPropertyDeclaration.h"
#import <objc/runtime.h>

/*
 @interface TestObject : BFDictObject

 @property (nonatomic, strong) NSString *title;

 @end

 @implementation TestObject

 @dynamic title;

 @end
 */
/*
 TestObject * __weak wTO;
 {
 TestObject *to = [[TestObject alloc] initWithDictionary:[@{@"title": @"Old
 Title"} mutableCopy]];
 NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)to));
 NSLog(@"-- get title: %@", to.title);
 NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)to));
 to.title = @"New Title";
 NSLog(@"-- set title");
 NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)to));
 NSLog(@"-- get title: %@", to.title);
 NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)to));

 wTO = to;
 to = nil;
 NSLog(@"-- Free TO");

 TestObject *sTO = wTO;
 NSLog(@"%ld", sTO?CFGetRetainCount((__bridge CFTypeRef)sTO):-1);
 }

 NSLog(@"-- Scope end");

 TestObject *sTO = wTO;
 NSLog(@"%ld", sTO?CFGetRetainCount((__bridge CFTypeRef)sTO):-1);
 */

static char DynamicPropertyGetterAssocicationKey;
static char DynamicPropertySetterAssocicationKey;
static char DynamicPropertyTypesAssociationKey;
static char DynamicPropertyNamesAssociationKey;

@implementation BFDictionaryObjectHelper

+ (void)loadDynamicPropertyInfoForClass:(Class)classPtr {
    @autoreleasepool {
        NSArray *properties = [BFPropertyDeclaration dynamicPropertiesOfClass:classPtr];
        NSUInteger propertiesCount = properties.count;

        NSMutableDictionary *propertyGetter = [NSMutableDictionary dictionaryWithCapacity:propertiesCount];
        NSMutableDictionary *propertySetter = [NSMutableDictionary dictionaryWithCapacity:propertiesCount];
        NSMutableDictionary *propertyTypes = [NSMutableDictionary dictionaryWithCapacity:propertiesCount];
        NSMutableSet *propertyNames = [NSMutableSet setWithCapacity:propertiesCount];

        for (BFPropertyDeclaration *property in properties) {
            [propertyNames addObject:property.name];
            propertyTypes[property.name] = property.typeEncoding;
            propertyGetter[NSStringFromSelector(property.getterSelector)] = property.name;
            if (!property.readonly) {
                propertySetter[NSStringFromSelector(property.setterSelector)] = property.name;
            }
        }

        objc_setAssociatedObject(classPtr, &DynamicPropertyTypesAssociationKey,
                                 [NSDictionary dictionaryWithDictionary:propertyTypes],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(classPtr, &DynamicPropertyGetterAssocicationKey,
                                 [NSDictionary dictionaryWithDictionary:propertyGetter],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(classPtr, &DynamicPropertySetterAssocicationKey,
                                 [NSDictionary dictionaryWithDictionary:propertySetter],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(classPtr, &DynamicPropertyNamesAssociationKey, [NSSet setWithSet:propertyNames],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (void)unloadDynamicPropertyInfoForClass:(Class)classPtr {
    objc_setAssociatedObject(classPtr, &DynamicPropertyGetterAssocicationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(classPtr, &DynamicPropertySetterAssocicationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(classPtr, &DynamicPropertyTypesAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(classPtr, &DynamicPropertyNamesAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Accessors

+ (NSDictionary *)dynamicPropertyGettersOfClass:(Class)classPtr {
    NSDictionary *propertyGetters = objc_getAssociatedObject(classPtr, &DynamicPropertyGetterAssocicationKey);
    if (!propertyGetters) {
        [self loadDynamicPropertyInfoForClass:classPtr];
        propertyGetters = objc_getAssociatedObject(classPtr, &DynamicPropertyGetterAssocicationKey);
    }
    return propertyGetters;
}

+ (NSDictionary *)dynamicPropertySettersOfClass:(Class)classPtr {
    NSDictionary *propertySetters = objc_getAssociatedObject(classPtr, &DynamicPropertySetterAssocicationKey);
    if (!propertySetters) {
        [self loadDynamicPropertyInfoForClass:classPtr];
        propertySetters = objc_getAssociatedObject(classPtr, &DynamicPropertySetterAssocicationKey);
    }
    return propertySetters;
}

+ (NSDictionary *)dynamicPropertyTypesOfClass:(Class)classPtr {
    NSDictionary *propertyTypes = objc_getAssociatedObject(classPtr, &DynamicPropertyTypesAssociationKey);
    if (!propertyTypes) {
        [self loadDynamicPropertyInfoForClass:classPtr];
        propertyTypes = objc_getAssociatedObject(classPtr, &DynamicPropertyTypesAssociationKey);
    }
    return propertyTypes;
}

+ (NSSet *)dynamicPropertyNamesOfClass:(Class)classPtr {
    NSSet *propertyNames = objc_getAssociatedObject(classPtr, &DynamicPropertyNamesAssociationKey);
    if (!propertyNames) {
        [self loadDynamicPropertyInfoForClass:classPtr];
        propertyNames = objc_getAssociatedObject(classPtr, &DynamicPropertyNamesAssociationKey);
    }
    return propertyNames;
}

#pragma mark - Main: Method Forwarding

+ (NSMethodSignature *)methodSignatureForDynamicPropertySelector:(SEL)selector inClass:(Class)classPtr {
    @autoreleasepool {
        NSString *selectorString = NSStringFromSelector(selector);
        NSString *propertyName;

        if ((propertyName = [self dynamicPropertyGettersOfClass:classPtr][selectorString])) {
            // is getter
            NSString *type =
                [NSString stringWithFormat:@"%@@:", [self dynamicPropertyTypesOfClass:classPtr][propertyName]];
            const char *typeUTF8String = type.UTF8String;
            return type ? [NSMethodSignature signatureWithObjCTypes:typeUTF8String] : nil;
        }

        if ((propertyName = [self dynamicPropertySettersOfClass:classPtr][selectorString])) {
            // is setter
            NSString *type =
                [NSString stringWithFormat:@"v@:%@", [self dynamicPropertyTypesOfClass:classPtr][propertyName]];
            const char *typeUTF8String = type.UTF8String;
            return type ? [NSMethodSignature signatureWithObjCTypes:typeUTF8String] : nil;
        }

        return nil;
    }
}

+ (BOOL)forwardInvocation:(NSInvocation *)anInvocation
               dictionary:(NSMutableDictionary *)dictionary
                  inClass:(Class)classPtr {
    NSString *selectorString = NSStringFromSelector(anInvocation.selector);
    NSString *propertyName = nil;
    NSString *typeEncoding = nil;

    propertyName = [self dynamicPropertyGettersOfClass:classPtr][selectorString];
    typeEncoding = [self dynamicPropertyTypesOfClass:classPtr][propertyName];
    if (propertyName && typeEncoding) {
        // is getter
        id rawValue = dictionary[propertyName];

        switch (typeEncoding.UTF8String[0]) {
        case 'c': {
            char value = [rawValue charValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'i': {
            int value = [rawValue intValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 's': {
            short value = [rawValue shortValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'l': {
            long value = [rawValue longValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'q': {
            long long value = [rawValue longLongValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'C': {
            unsigned char value = [rawValue unsignedCharValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'I': {
            unsigned int value = [rawValue unsignedIntValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'S': {
            unsigned short value = [rawValue unsignedShortValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'L': {
            unsigned long value = [rawValue unsignedLongValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'Q': {
            unsigned long long value = [rawValue unsignedLongLongValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'f': {
            float value = [rawValue floatValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'd': {
            double value = [rawValue doubleValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case 'B': {
            BOOL value = [rawValue boolValue];
            [anInvocation setReturnValue:&value];
            break;
        }
        case '{': {
            void *value;
            [rawValue getValue:&value];
            [anInvocation setReturnValue:&value];
            break;
        }
        case '@':
        default: {
            id value = dictionary[propertyName];
            if ([value isKindOfClass:[NSNull class]]) {
                value = nil;
            }
            [anInvocation setReturnValue:&value];
        }
        }
        // TODO: More Types
        return YES;
    }

    propertyName = [self dynamicPropertySettersOfClass:classPtr][selectorString];
    typeEncoding = [self dynamicPropertyTypesOfClass:classPtr][propertyName];
    if (propertyName && typeEncoding) {
        // is setter
        id value;
        switch (typeEncoding.UTF8String[0]) {
        case 'c': {
            char rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'i': {
            int  rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 's': {
            short rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'l': {
            long rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'q': {
            long long rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'C': {
            unsigned char rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'I': {
            unsigned int rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'S': {
            unsigned short rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'L': {
            unsigned long rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'Q': {
            unsigned long long rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'f': {
            float rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'd': {
            double rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case 'B': {
            BOOL rawValue;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = @(rawValue);
            break;
        }
        case '{': {
            const char *typeEncodingChar = typeEncoding.UTF8String;
            void *rawValue = nil;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = [NSValue valueWithBytes:&rawValue objCType:typeEncodingChar];
            break;
        }
        case '@':
        default: {
            void *rawValue = nil;
            [anInvocation getArgument:&rawValue atIndex:2];
            value = (__bridge id)rawValue;
        }
        }

        // KVO
        id currentValue = dictionary[propertyName];
        BOOL shouldSendKVOEvent = ![currentValue isEqual:value];

        // Core
        if (shouldSendKVOEvent)
            [anInvocation.target willChangeValueForKey:propertyName];
        dictionary[propertyName] = value?:[NSNull null];
        if (shouldSendKVOEvent)
            [anInvocation.target didChangeValueForKey:propertyName];

        // TODO: More Types
        return YES;
    }

    return NO;
}

#pragma mark - Main: KVC

+ (BOOL)setValue:(id)value
    forUndefinedKey:(NSString *)key
         dictionary:(NSMutableDictionary *)dictionary
            inClass:(Class)classPtr {
    if (![[self dynamicPropertyNamesOfClass:classPtr] containsObject:key]) {
        return NO;
    }

    dictionary[key] = value;
    return YES;
}

+ (id)valueForUndefinedKey:(NSString *)key dictionary:(NSMutableDictionary *)dictionary inClass:(Class)classPtr {
    if (![[self dynamicPropertyNamesOfClass:classPtr] containsObject:key]) {
        return nil;
    }

    return dictionary[key];
}

@end
