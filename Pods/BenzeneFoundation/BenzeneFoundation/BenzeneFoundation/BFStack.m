//
//  BFStack.m
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

#import "BFStack.h"
#import "NSArray+Benzene.h"
#import "BFPthreadMutexLock.h"
#import <libextobjc/extobjc.h>

@interface BFStackContentEnumerator : NSEnumerator {
    NSInteger currentObjectIndex;
}

@property(nonatomic, strong) BFStack *stack;

- (instancetype)initWithStack:(BFStack *)stack;

@end

@interface BFStack () {
    NSArray *_rep;
    id<NSLocking> _lock;
}

@property (nonatomic, strong) NSMutableArray *content;
@property (nonatomic, assign) NSUInteger head;

@end

@implementation BFStack

+ (instancetype)stack {
    return [[self alloc] initWithCapacity:0];
}

+ (instancetype)stackWithCapacity:(NSUInteger)capacity {
    return [[self alloc] initWithCapacity:capacity];
}

- (id)initWithCapacity:(NSUInteger)capacity {
    if (self = [super init]) {
        _lock = [[BFPthreadMutexLock alloc] init];

        _content = capacity > 0 ? [NSMutableArray arrayWithCapacity:capacity] : [NSMutableArray array];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: HEAD-> %@",
            [self class], [self.array componentsJoinedByString:@", "]];
}

- (BOOL)isEqual:(id)object {
    return ((self == object) || ([object isKindOfClass:[self class]] && [self isEqualToStack:object]));
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    BFStack *stack = [[[self class] allocWithZone:zone] initWithCapacity:self.count];
    stack.content = [self.content copy];
    stack.head = self.head;
    return stack;
}

- (NSUInteger)hash {
    return self.array.hash;
}

- (BOOL)isEqualToStack:(BFStack *)stack {
    return [stack.array isEqualToArray:self.array];
}

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingArray {
    return [NSSet setWithObject:@keypath(BFStack.new, head)];
}

+ (NSSet *)keyPathsForValuesAffectingCount {
    return [NSSet setWithObject:@keypath(BFStack.new, head)];
}

+ (NSSet *)keyPathsForValuesAffectingEmpty {
    return [NSSet setWithObject:@keypath(BFStack.new, count)];
}

#pragma mark - Methods

- (void)pushObject:(id)object {
    NSParameterAssert(object!=nil);
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    id<BFStackDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector:@selector(stack:willPushObject:)]) {
        [delegate stack:self willPushObject:object];
    }

    if (self.head < self.content.count) {
        self.content[self.head] = object;
    } else {
        [self.content addObject:object];
    }
    self.head++;
    _rep = nil;

    if ([delegate respondsToSelector:@selector(stack:didPushObject:)]) {
        [delegate stack:self didPushObject:object];
    }
}

- (id)pop {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    if (!self.empty && --self.head < self.content.count) {
        id result = self.content[self.head];
        id<BFStackDelegate> delegate = self.delegate;

        if ([delegate respondsToSelector:@selector(stack:willPopObject:)]) {
            [delegate stack:self willPopObject:result];
        }

        self.content[self.head] = [NSNull null];
        _rep = nil;

        if ([delegate respondsToSelector:@selector(stack:didPopObject:)]) {
            [delegate stack:self didPopObject:result];
        }
        return result;
    }

    return nil;
}

- (id)peek {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    return (self.head==0 || self.empty) ? nil : self.content[self.head-1];
}

- (NSUInteger)count {
    return self.head;
}

- (BOOL)isEmpty {
    return self.count == 0;
}

- (NSArray *)popAllObjects {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    NSArray *result = [self.array copy];
    id<BFStackDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector:@selector(stack:willPopObject:)]) {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [delegate stack:self willPopObject:obj];
        }];
    }

    [self.content removeAllObjects];
    self.head = 0;
    _rep = nil;

    if ([delegate respondsToSelector:@selector(stack:didPopObject:)]) {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [delegate stack:self didPopObject:obj];
        }];
    }

    return result;
}

#pragma mark - Interface

- (NSArray *)array {
    if (!_rep) {
        [_lock lock];
        @onExit {
            [self->_lock unlock];
        };

        if (!_rep) {
            _rep = [[self.content subarrayWithRange:NSMakeRange(0, self.head)]
                    arrayByReversingArray];
        }
    }
    return _rep;
}

- (void)compact {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    if (self.head==self.content.count) return;
    self.content = [[self.content subarrayWithRange:NSMakeRange(0, self.head)] mutableCopy];
    self.head = self.content.count;
}

- (NSEnumerator *)contentEnumerator {
    return [[BFStackContentEnumerator alloc] initWithStack:self];
}

@end

#pragma mark - Enumerator

@implementation BFStackContentEnumerator

- (instancetype)initWithStack:(BFStack *)stack {
    if (self = [super init]) {
        _stack = stack;
        currentObjectIndex = stack.head;
    }
    return self;
}

- (id)nextObject {
    return currentObjectIndex > 0 ? self.stack.content[--currentObjectIndex] : nil;
}

@end
