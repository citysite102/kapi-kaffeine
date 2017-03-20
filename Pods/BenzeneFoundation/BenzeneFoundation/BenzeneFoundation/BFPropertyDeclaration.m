//
//  BFPropertyDeclaration.m
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

// Ref: https://tobias-kraentzer.de/2013/05/15/dynamic-properties-in-objective-c/

#import "BFPropertyDeclaration.h"
#import "BFDefines.h"
#import "BFFunctionUtilities.h"
#import <objc/runtime.h>

@implementation BFPropertyDeclaration

+ (NSArray *)propertiesOfClass:(Class)classPtr {
    return [self propertiesOfClass:classPtr dynamic:YES synthesize:YES];
}

+ (NSArray *)dynamicPropertiesOfClass:(Class)classPtr {
    return [self propertiesOfClass:classPtr dynamic:YES synthesize:NO];
}

+ (NSArray *)propertiesOfClass:(Class)classPtr dynamic:(BOOL)dynamic synthesize:(BOOL)synthesize {
    NSAssert(dynamic || synthesize, @"You must pass at least 1 type of properties");
    
    NSArray *result;
    @autoreleasepool {
        NSMutableArray *_result = [NSMutableArray array];
        
        // Go through classes
        Class _class = classPtr;
        while (_class != [NSObject class]) {
            unsigned int propertiesCount;
            objc_property_t *properties = class_copyPropertyList(_class, &propertiesCount);
            for (unsigned int i = 0; i < propertiesCount; ++i) {
                objc_property_t property = properties[i];
                
                // Check if the property is dynamic (@dynamic).
                BFPropertyDeclaration *pd = [BFPropertyDeclaration propertyWithDeclaration:property];
                
                if ((dynamic && synthesize) ||
                    (pd.dynamic && dynamic && !synthesize) ||
                    (!pd.dynamic && !dynamic && synthesize)) {
                    [_result addObject:pd];
                }
            }
            BFFreeCMemoryBlock(properties);
            _class = [_class superclass];
        }
        
        result = [NSArray arrayWithArray:_result];
    }
    return result;
}

+ (instancetype)propertyWithDeclaration:(objc_property_t)property {
    return [[self alloc] initWithDeclaration:property];
}

- (id)initWithDeclaration:(objc_property_t)property {
    if (self = [super init]) {
        // Get the name of the property
        _name = @(property_getName(property));
        
        // Get the selector for the getter
        char *getterName = property_copyAttributeValue(property, "G");
        if (getterName) {
            _getterSelector = NSSelectorFromString(@(getterName));
            free(getterName);
        } else {
            _getterSelector = NSSelectorFromString(_name);
        }
        
        // Check dynamic
        char *isDynamic = property_copyAttributeValue(property, "D");
        if (isDynamic) {
            _dynamic = YES;
            free(isDynamic);
        }
        
        // Check if the property is read-only
        char *readonly = property_copyAttributeValue(property, "R");
        if (readonly) {
            _readonly = YES;
            free(readonly);
        } else {
            
            // Get the selector for the setter
            char *setterName = property_copyAttributeValue(property, "S");
            if (setterName) {
                _setterSelector = NSSelectorFromString(@(setterName));
                free(setterName);
            } else {
                NSString *selectorString = [_name stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                                          withString:[_name substringToIndex:1].uppercaseString];
                selectorString = [NSString stringWithFormat:@"set%@:", selectorString];
                _setterSelector = NSSelectorFromString(selectorString);
            }
        }
        
        // Get the type encoding of the property
        char *type = property_copyAttributeValue(property, "T");
        if (type) {
            _typeEncoding = @(type);
            free(type);
        }
        
        // Check if the value should be copied
        char *copy = property_copyAttributeValue(property, "C");
        if (copy) {
            _copy = YES;
            free(copy);
        }
        
        // Check if the value should be stored weak
        char *weak = property_copyAttributeValue(property, "W");
        if (weak) {
            _weak = YES;
            free(weak);
        }
    }
    return self;
}

- (NSString *)description {
    return BFFormatString(@"<BFPropertyDeclaration: %@>", self.name);
}

@end
