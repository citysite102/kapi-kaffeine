//
//  NSCopying+Benzene.m
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

#import "NSCopying+Benzene.h"

BF_STATIC_INLINE id _BFCollectionDeepCopy(id object, BOOL mutableCopy, BOOL nodeMutableCopy) {
    @autoreleasepool {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = object;
            NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [result addObject:_BFCollectionDeepCopy(obj, mutableCopy, nodeMutableCopy)];
            }];
            return mutableCopy ? result : [NSArray arrayWithArray:result];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = object;
            NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:dict.count];
            [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                result[key] = _BFCollectionDeepCopy(obj, mutableCopy, nodeMutableCopy);
            }];
            return mutableCopy ? result : [NSDictionary dictionaryWithDictionary:result];
        } else if ([object isKindOfClass:[NSSet class]]) {
            NSSet *set = object;
            NSMutableSet *result = [[NSMutableSet alloc] initWithCapacity:set.count];
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                [result addObject:_BFCollectionDeepCopy(obj, mutableCopy, nodeMutableCopy)];
            }];
            return mutableCopy ? result : [NSSet setWithSet:result];
        } else if ([object isKindOfClass:[NSOrderedSet class]]) {
            NSOrderedSet *orderedSet = object;
            NSMutableOrderedSet *result = [[NSMutableOrderedSet alloc] initWithCapacity:orderedSet.count];
            [orderedSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [result addObject:_BFCollectionDeepCopy(obj, mutableCopy, nodeMutableCopy)];
            }];
            return mutableCopy ? result : [NSOrderedSet orderedSetWithOrderedSet:result];
        } else {
            if (nodeMutableCopy && [object conformsToProtocol:@protocol(NSMutableCopying)]) {
                return [object mutableCopy];
            } else if ([object conformsToProtocol:@protocol(NSCopying)]) {
                return [object copy];
            } else {
                [[NSException exceptionWithName:NSInternalInconsistencyException
                                         reason:[NSString stringWithFormat:@"%@ is not copiable.", object]
                                       userInfo:nil] raise];
                return nil;
            }
        }
    }
}

BF_EXTERN id BFCollectionDeepCopy(id object) {
    return _BFCollectionDeepCopy(object, NO, NO);
}

BF_EXTERN id BFCollectionDeepMutableCopy(id object) {
    return _BFCollectionDeepCopy(object, YES, NO);
}

BF_EXTERN id BFCollectionDeepNodeMutableCopy(id object) {
    return _BFCollectionDeepCopy(object, YES, YES);
}

@implementation NSArray (BF_NSCopying)

- (instancetype)deepCopy {
    return _BFCollectionDeepCopy(self, NO, NO);
}

- (instancetype)deepMutableCopy {
    return _BFCollectionDeepCopy(self, YES, NO);
}

@end

@implementation NSDictionary (BF_NSCopying)

- (instancetype)deepCopy {
    return _BFCollectionDeepCopy(self, NO, NO);
}

- (instancetype)deepMutableCopy {
    return _BFCollectionDeepCopy(self, YES, NO);
}

@end

@implementation NSSet (BF_NSCopying)

- (instancetype)deepCopy {
    return _BFCollectionDeepCopy(self, NO, NO);
}

- (instancetype)deepMutableCopy {
    return _BFCollectionDeepCopy(self, YES, NO);
}

@end

@implementation NSOrderedSet (BF_NSCopying)

- (instancetype)deepCopy {
    return _BFCollectionDeepCopy(self, NO, NO);
}

- (instancetype)deepMutableCopy {
    return _BFCollectionDeepCopy(self, YES, NO);
}

@end
