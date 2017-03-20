//
//  BFQueue.m
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

#import "BFQueue.h"
#import "BFPthreadMutexLock.h"
#import <libextobjc/extobjc.h>

@interface BFQueueContentEnumerator : NSEnumerator{
    NSInteger currentObjectIndex;
    NSInteger objectEndIndex;
    NSUInteger capacity;
}

@property(nonatomic, strong) BFQueue *queue;

- (instancetype)initWithQueue:(BFQueue *)queue;

@end

@interface BFQueue () {
    NSArray *_rep;
    id<NSLocking> _lock;
}

@property (nonatomic, strong, readwrite) NSMutableArray *content;
@property (nonatomic, assign) NSUInteger tail;
@property (nonatomic, assign) NSUInteger head;

@end

@implementation BFQueue

+ (instancetype)queue {
    return [[self alloc] initWithCapacity:0];
}

+ (instancetype)queueWithCapacity:(NSUInteger)capacity {
    return [[self alloc] initWithCapacity:capacity];
}

- (id)initWithCapacity:(NSUInteger)capacity {
    if (self = [super init]) {
        _lock = [[BFPthreadMutexLock alloc] init];

        _content = capacity > 0 ? [NSMutableArray arrayWithCapacity:capacity] : [NSMutableArray array];
    }
    return self;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    BFQueue *queue = [[[self class] allocWithZone:zone] initWithCapacity:self.count];
    queue.content = [self.content copy];
    queue.head = self.head;
    queue.tail = self.tail;
    return queue;
}

- (BOOL)isEqual:(id)object {
    return ((self == object) || ([object isKindOfClass:[self class]] && [self isEqualToQueue:object]));
}

- (NSUInteger)hash {
    return self.array.hash;
}

- (BOOL)isEqualToQueue:(BFQueue *)queue {
    return [queue.array isEqualToArray:self.array];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: TAIL-> %@ <-HEAD",
            [self class], [self.array componentsJoinedByString:@", "]];
}

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingArray {
    return [NSSet setWithObjects:@keypath(BFQueue.new, head), @keypath(BFQueue.new, tail), nil];
}

+ (NSSet *)keyPathsForValuesAffectingCount {
    return [NSSet setWithObjects:@keypath(BFQueue.new, head), @keypath(BFQueue.new, tail), nil];
}

+ (NSSet *)keyPathsForValuesAffectingEmpty {
    return [NSSet setWithObject:@keypath(BFQueue.new, count)];
}

#pragma mark - Methods

- (void)enqueueObject:(id)object {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    id<BFQueueDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector:@selector(queue:willEnqueueObject:)]) {
        [delegate queue:self willEnqueueObject:object];
    }

    [self.content addObject:object];
    self.head++;
    _rep = nil;

    if ([delegate respondsToSelector:@selector(queue:didEnqueueObject:)]) {
        [delegate queue:self didEnqueueObject:object];
    }
}

- (id)dequeue {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    if (!self.empty && self.tail < self.content.count) {
        id result = self.content[self.tail];
        id<BFQueueDelegate> delegate = self.delegate;

        if ([delegate respondsToSelector:@selector(queue:willDequeueObject:)]) {
            [delegate queue:self willDequeueObject:result];
        }

        self.content[self.tail++] = [NSNull null];
        _rep = nil;

        if ([delegate respondsToSelector:@selector(queue:didDequeueObject:)]) {
            [delegate queue:self didDequeueObject:result];
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
    return (self.content.count==0 || self.tail==self.head) ? nil : self.content[self.tail];
}

- (NSUInteger)count {
    return self.head-self.tail;
}

- (BOOL)isEmpty {
    return self.count == 0;
}

- (NSArray *)dequeueAllObjects {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    NSArray *result = [self.array copy];
    id<BFQueueDelegate> delegate = self.delegate;

    if ([delegate respondsToSelector:@selector(queue:willDequeueObject:)]) {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [delegate queue:self willDequeueObject:obj];
        }];
    }

    [self.content removeAllObjects];
    _tail = 0; // Only trigger one KVO event
    self.head = 0;
    _rep = nil;

    if ([delegate respondsToSelector:@selector(queue:didDequeueObject:)]) {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [delegate queue:self didDequeueObject:obj];
        }];
    }

    return result;
}

#pragma mark - Interface

- (NSArray *)array {
    if (!_rep) {
        _rep = [self.content subarrayWithRange:NSMakeRange(self.tail, self.count)];
    }
    return _rep;
}

- (void)compact {
    [_lock lock];
    @onExit {
        [self->_lock unlock];
    };

    if (self.tail==0) return;
    self.content = [self.array mutableCopy];
    self.tail = 0;
    self.head = self.content.count;
}

- (NSEnumerator *)contentEnumerator {
    return [[BFQueueContentEnumerator alloc] initWithQueue:self];
}

@end

#pragma mark - Enumerator

@implementation BFQueueContentEnumerator

- (instancetype)initWithQueue:(BFQueue *)queue {
    if (self = [super init]) {
        _queue = queue;
        currentObjectIndex = queue.tail;
        objectEndIndex = queue.head;
    }
    return self;
}

- (id)nextObject {
    return currentObjectIndex < objectEndIndex ? self.queue.content[currentObjectIndex++] : nil;
}

@end
