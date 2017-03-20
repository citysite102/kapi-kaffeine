//
//  NSMetadataQuery+Benzene.m
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

#import "NSMetadataQuery+Benzene.h"
#import "BFFunctionUtilities.h"
#import <objc/message.h>

static char BF_NSMetadataQuery_onceNotificationObserverAssociationKey;

@implementation NSMetadataQuery (Benzene)

- (void)queryOnceWithCompletionHandler:(void (^)(NSMetadataQuery *metadataQuery))handler {
    // Hold this metaquery object until it is finished. Used to keep object by block
    NSMetadataQuery *__block metadataQuery = self;
    // Set handler
    id observer = [[NSNotificationCenter defaultCenter]
        addObserverForName:NSMetadataQueryDidFinishGatheringNotification
                    object:self
                     queue:[NSOperationQueue currentQueue]
                usingBlock:^(NSNotification *notification) {
                    // Remove notification observer
                    id _observer = objc_getAssociatedObject(notification.object,
                                                            &BF_NSMetadataQuery_onceNotificationObserverAssociationKey);
                    if (_observer) {
                        [[NSNotificationCenter defaultCenter] removeObserver:_observer];
                    }

                    // Stop update
                    [metadataQuery disableUpdates];
                    [metadataQuery stopQuery];

                    // Call handler
                    BFExecuteBlock(handler, metadataQuery);
                    metadataQuery = nil;
                }];
    objc_setAssociatedObject(self, &BF_NSMetadataQuery_onceNotificationObserverAssociationKey, observer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    // Go
    dispatch_async(dispatch_get_main_queue(), ^{ [self startQuery]; });
}

@end
