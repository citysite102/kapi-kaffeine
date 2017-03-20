//
//  NSEnumerator+Benzene.m
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

#import "NSEnumerator+Benzene.h"
#import <libextobjc/extobjc.h>

@interface BFBlockEnumerator BFGenerics(ObjectType) : NSEnumerator BFGenerics(ObjectType)

@property (nonatomic, copy, readonly) BFGenericType(ObjectType) _Nullable(^block)(void);
- (instancetype)initWithBlock:(BFGenericType(ObjectType) _Nullable(^)(void))block NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

@interface _BFChainedEnumerator BFGenerics(ObjectType) : NSEnumerator BFGenerics(ObjectType) <BFChainedEnumerator> {
    NSUInteger _enumeratorsIndex;
}

@property (nonatomic, strong, readonly) NSArray BFGenerics(NSEnumerator<ObjectType> *) *enumerators;
- (instancetype)initWithEnumerators:(NSArray BFGenerics(NSEnumerator<ObjectType> *) *)enumerators NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

@interface _BFChainedArrayEnumerator BFGenerics(ObjectType) : NSEnumerator BFGenerics(ObjectType) <BFChainedArrayEnumerator> {
    NSUInteger _arraysIndex;
    NSUInteger _arrayContentIndex;
}

@property (nonatomic, strong, readonly) NSArray BFGenerics(NSArray<ObjectType> *) *arrays;
- (instancetype)initWithArrays:(NSArray BFGenerics(NSArray<ObjectType> *) *)arrays NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

@interface BFFlattenEnumerator BFGenerics(ObjectType) : NSEnumerator BFGenerics(ObjectType) {
    NSEnumerator *_currentEnumerator;
}

@property (nonatomic, strong, readonly) NSEnumerator BFGenerics(NSEnumerator<ObjectType> *) *enumerators;
- (instancetype)initWithEnumerators:(NSEnumerator BFGenerics(NSEnumerator<ObjectType> *) *)enumerators NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

@implementation NSEnumerator (BenzeneEnumerate)

- (void)enumerateUsingBlock:(void(^ _Nullable)(id obj, NSUInteger idx, BOOL *stop))block {
    if (!block) {
        return;
    }
    NSUInteger index = 0;
    for (id obj in self) {
        BOOL shouldStop = NO;
        block(obj, index++, &shouldStop);
        if (shouldStop) {
            break;
        }
    }
}

@end

@implementation NSEnumerator (BenzeneCreation)

+ (NSEnumerator<BFChainedArrayEnumerator> *)enumeratorByChainingArrays:(NSArray *)arrays {
    return [[_BFChainedArrayEnumerator alloc] initWithArrays:arrays];
}

+ (NSEnumerator<BFChainedEnumerator> *)enumeratorByChainingEnumerators:(NSArray *)enumerators {
    return [[_BFChainedEnumerator alloc] initWithEnumerators:enumerators];
}

+ (instancetype)enumeratorByFlattingEnumerator:(NSEnumerator BFGenerics(NSEnumerator *) *)enumerator {
    return [[BFFlattenEnumerator alloc] initWithEnumerators:enumerator];
}

+ (instancetype)enumeratorWithBlock:(id _Nullable(^)(void))block {
    return [[BFBlockEnumerator alloc] initWithBlock:block];
}

- (instancetype)enumeratorWithKeyPathOfObjects:(NSString *)keyPath {
    return [self enumeratorWithObjectBlock:^id _Nonnull(NSObject *_Nonnull obj) {
        return (id _Nonnull)([obj valueForKeyPath:keyPath] ?: [NSNull null]);
    }];
}

- (instancetype)enumeratorFilteredByPredicate:(NSPredicate *)predicate {
    return [[self class] enumeratorWithBlock:^id _Nullable{
        id object = nil;
        do {
            object = [self nextObject];
        } while (object && ![predicate evaluateWithObject:object]);
        return object;
    }];
}

- (instancetype)enumeratorWithObjectBlock:(id(^)(id))block {
    return [[self class] enumeratorWithBlock:^id _Nullable{
        id object = [self nextObject];
        return object ? block(object) : nil;
    }];
}

@end

@implementation BFBlockEnumerator

- (instancetype)initWithBlock:(id  _Nullable (^)(void))block {
    if (self = [super init]) {
        _block = [block copy];
    }
    return self;
}

- (id)nextObject {
    return self.block();
}

@end

@implementation _BFChainedEnumerator

@synthesize currentEnumerator = _currentEnumerator;

- (instancetype)initWithEnumerators:(NSArray *)enumerators {
    if (self = [super init]) {
        _enumerators = enumerators;
    }
    return self;
}

- (id)nextObject {
    while (_enumeratorsIndex < self.enumerators.count) {
        _currentEnumerator = self.enumerators[_enumeratorsIndex];
        id result = [_currentEnumerator nextObject];
        if (result) {
            return result;
        } else {
            ++_enumeratorsIndex;
            _currentEnumerator = nil;
        }
    }
    return nil;
}

@end

@implementation _BFChainedArrayEnumerator

@synthesize currentArray = _currentArray;

- (instancetype)initWithArrays:(NSArray *)arrays {
    if (self = [super init]) {
        _arrays = arrays;
    }
    return self;
}

- (id)nextObject {
    while (_arraysIndex < self.arrays.count) {
        _currentArray = self.arrays[_arraysIndex];
        if (_arrayContentIndex < _currentArray.count) {
            return _currentArray[_arrayContentIndex++];
        } else {
            ++_arraysIndex;
            _arrayContentIndex = 0;
            _currentArray = nil;
        }
    }
    return nil;
}

@end

@implementation BFFlattenEnumerator

- (instancetype)initWithEnumerators:(NSEnumerator BFGenerics(NSEnumerator<id> *) *)enumerators {
    if (self = [super init]) {
        _enumerators = enumerators;
    }
    return self;
}

- (id)nextObject {
    do {
        id result = [_currentEnumerator nextObject];
        if (result) {
            return result;
        } else {
            _currentEnumerator = [self.enumerators nextObject];
        }
    } while (_currentEnumerator);
    return nil;
}

@end
