//
//  BFFileMonitor.m
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

#import "BFFileMonitor.h"
#import "BFDefines.h"
#import "BFFunctionUtilities.h"
#import "BFPthreadMutexLock.h"
#import <libextobjc/extobjc.h>

NSString *const BFFileMonitorErrorDomain = @"com.benzene.file-monitor";

@interface BFFileMonitor () {
    int fileDescriptor;
    dispatch_source_t dispatchSource;
    id<NSLocking> lock;
}

@property(nonatomic, copy, readwrite) BFFileMonitorHandler handler;
@property(nonatomic, strong) NSString *path;
//@property(nonatomic, strong, readonly) dispatch_queue_t workingDispatchQueue;
@property (nonatomic, assign, getter=isSuspended, readwrite) BOOL suspended;

@end

@implementation BFFileMonitor

+ (instancetype)fileMonitorWithPath:(NSString *)path block:(BFFileMonitorHandler)block {
    return [[self alloc] initWithPath:path block:block];
}

- (instancetype)initWithPath:(NSString *)path block:(BFFileMonitorHandler)block {
    NSParameterAssert(block!=nil);

    if (self = [super init]) {
        lock = [[BFPthreadMutexLock alloc] init];

        _path = path;
        _handler = block;
        _suspended = NO;
        _mask = DISPATCH_VNODE_WRITE;
    }
    return self;
}

- (void)dealloc {
    [self stopMonitoring];

    if (fileDescriptor) {
        close(fileDescriptor), fileDescriptor = 0;
    }
}

#pragma mark - Method

- (dispatch_queue_t)dispatchQueue {
    if (!_dispatchQueue) {
        _dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    return _dispatchQueue;
}

- (BOOL)isStarted {
    return dispatchSource != nil;
}

- (void)startMonitoring {
    if (self.started) {
        return;
    }
    [lock lock];
    @onExit {
        [self->lock unlock];
    };
    if (self.started) {
        return;
    }

    dispatch_sync(self.dispatchQueue, ^{
        typeof(self) __weak wSelf = self;

        // Create source
        self->fileDescriptor = open(self->_path.fileSystemRepresentation, O_EVTONLY);
        if (!self->fileDescriptor) {
            return;
        }
        self->dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                                self->fileDescriptor,
                                                self.mask,
                                                self.dispatchQueue);

        dispatch_source_set_registration_handler(self->dispatchSource, ^{
            typeof(wSelf) __strong sSelf = wSelf;
            BFExecuteBlock(sSelf.startMonitorHandler, sSelf);
        });

        dispatch_source_set_event_handler(self->dispatchSource, ^{
            typeof(wSelf) __strong sSelf = wSelf;
            BFExecuteBlock(sSelf.handler, sSelf);
        });

        dispatch_source_set_cancel_handler(self->dispatchSource, ^{
            typeof(wSelf) __strong sSelf = wSelf;
            if (sSelf && sSelf->fileDescriptor) {
                close(sSelf->fileDescriptor), sSelf->fileDescriptor = 0;
            }
            BFExecuteBlock(sSelf.stopMonitorHandler, sSelf);
        });

        // Go
        dispatch_resume(self->dispatchSource);
    });
}

- (void)stopMonitoring {
    if (!self.started) {
        return;
    }
    [lock lock];
    @onExit {
        [self->lock unlock];
    };
    if (!self.started) {
        return;
    }

    dispatch_sync(self.dispatchQueue, ^{
        if (self.suspended) {
            dispatch_resume(self->dispatchSource);
        }
        
        dispatch_source_cancel(self->dispatchSource);
        self->dispatchSource = nil;
    });
}

- (void)resumeMonitoring {
    if (!self.started || !self.suspended) {
        return;
    }
    [lock lock];
    @onExit {
        [self->lock unlock];
    };
    if (self.started && self.suspended) {
        dispatch_sync(self.dispatchQueue, ^{
            if (self.started && self.suspended) {
                self.suspended = NO;
                dispatch_resume(self->dispatchSource);
                BFExecuteAsyncBlockOnDispatchQueue(self.dispatchQueue, self.resumeMonitorHandler, self);
            }
        });
    }
}

- (void)pauseMonitoring {
    if (!self.started || self.suspended) {
        return;
    }
    [lock lock];
    @onExit {
        [self->lock unlock];
    };
    if (self.started && !self.suspended) {
        dispatch_sync(self.dispatchQueue, ^{
            if (self.started && !self.suspended) {
                self.suspended = YES;
                dispatch_suspend(self->dispatchSource);
                BFExecuteAsyncBlockOnDispatchQueue(self.dispatchQueue, self.pauseMonitorHandler, self);
            }
        });
    }
}

@end
