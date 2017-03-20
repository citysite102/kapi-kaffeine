//
//  UITableViewCell+LazyLoading.m
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

#import "UITableViewCell+LazyLoading.h"
#import <objc/runtime.h>
#import "BFDefines.h"
#import "BFFunctionUtilities.h"

static char AsyncOperationAssociationKey;
static char BlockAssociationKey;

#pragma mark - Private

@interface UITableViewCell (_BFLazyLoading)

- (NSOperationQueue *)bf_sharedOperationQueue;
@property (nonatomic, strong, setter=bf_setAsyncOperation:) NSOperation *bf_asyncOperation;
@property (nonatomic, strong, setter=bf_setBlockAddress:) NSString *bf_blockAddress;

@end

@implementation UITableViewCell (_BFLazyLoading)

- (NSString *)bf_blockAddress {
    return objc_getAssociatedObject(self, &BlockAssociationKey);
}

- (void)bf_setBlockAddress:(NSString *)bf_blockAddress {
    return objc_setAssociatedObject(self, &BlockAssociationKey, bf_blockAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSOperation *)bf_asyncOperation {
    return objc_getAssociatedObject(self, &AsyncOperationAssociationKey);
}

- (void)bf_setAsyncOperation:(NSOperation *)asyncOperation {
    objc_setAssociatedObject(self, &AsyncOperationAssociationKey, asyncOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSOperationQueue *)bf_sharedOperationQueue {
    static NSOperationQueue *operationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
        operationQueue.name = @"com.benzenefoundation.cell-lazyloading";
    });
    return operationQueue;
}

@end

#pragma mark - Public

@implementation UITableViewCell (BFLazyLoading)

- (void)performAsynchronousJob:(id(^)(void))block completion:(void (^)(id))completion {
    [self.bf_asyncOperation cancel];
    
    UITableViewCell * __weak weakSelf = self;
    id (^copiedBlock)(void) = [block copy];
    self.bf_blockAddress = [NSString stringWithFormat:@"%p", copiedBlock];
    
    self.bf_asyncOperation = [NSBlockOperation blockOperationWithBlock:^{
        if (block) {
            // Perform the async job
            id asyncResult = block();
            // Call the completion handler
            if (completion &&
                [weakSelf.bf_blockAddress isEqualToString:[NSString stringWithFormat:@"%p", copiedBlock]]) {
                BFExecuteAsyncBlockOnMainQueue(completion, asyncResult);
            }
        }
    }];
    [self.bf_sharedOperationQueue addOperation:self.bf_asyncOperation];
}

- (void)cancelAsynchronousJob {
    [self.bf_asyncOperation cancel];
    self.bf_asyncOperation = nil;
}

@end
