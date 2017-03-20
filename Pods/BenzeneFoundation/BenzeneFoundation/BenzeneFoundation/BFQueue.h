//
//  BFQueue.h
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

#import <Foundation/Foundation.h>
#import <BenzeneFoundation/BFDefines.h>

@protocol BFQueueDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface BFQueue BFGenerics(ObjectType) : NSObject <NSCopying>

@property (nonatomic, weak, nullable) id<BFQueueDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray BFGenerics(ObjectType) *array;
@property (nonatomic, assign, getter=isEmpty, readonly) BOOL empty;
@property (nonatomic, assign, readonly) NSUInteger count;

+ (nonnull instancetype)queue;
+ (nonnull instancetype)queueWithCapacity:(NSUInteger)capacity;

- (void)enqueueObject:(BFGenericType(ObjectType))object;
- (nullable BFGenericType(ObjectType))dequeue;
- (nullable BFGenericType(ObjectType))peek;
- (NSArray BFGenerics(ObjectType) *)dequeueAllObjects;

- (void)compact;

- (BOOL)isEqualToQueue:(BFQueue BFGenerics(ObjectType) *)queue;

@property (nonatomic, strong, readonly) NSEnumerator BFGenerics(ObjectType) *contentEnumerator;

@end

@protocol BFQueueDelegate <NSObject>

@optional

- (void)queue:(BFQueue *)queue willEnqueueObject:(id)object;
- (void)queue:(BFQueue *)queue didEnqueueObject:(id)object;
- (void)queue:(BFQueue *)queue willDequeueObject:(id)object;
- (void)queue:(BFQueue *)queue didDequeueObject:(id)object;

@end

NS_ASSUME_NONNULL_END
