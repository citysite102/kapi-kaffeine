//
//  BFFileMonitor.h
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

NS_ASSUME_NONNULL_BEGIN

@class BFFileMonitor;

typedef void (^BFFileMonitorHandler)(BFFileMonitor *);

/**
 *  A file monitor that reports file system change/modification to you
 */
@interface BFFileMonitor : NSObject

// Ref: dispatch_source_create
@property(nonatomic, assign) unsigned long mask;

/**
 *  The path this monitor is targeting to
 */
@property (nonatomic, strong, readonly) NSString *path;
/**
 * The handler bind to this monitor
 */
@property (nonatomic, copy, readonly) BFFileMonitorHandler handler;
/**
 *  The monitor is monitoring or not
 */
@property (nonatomic, assign, getter=isStarted, readonly) BOOL started;

@property (nonatomic, assign, getter=isSuspended, readonly) BOOL suspended;

/**
 *  A dispatch queue which the monitor should work on. It's better to use a serial queue.
 *  By default, it's dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
 */
@property (nonatomic, strong, null_resettable) dispatch_queue_t dispatchQueue;
/**
 *  A handler that will be called when the monitor starts to work
 */
@property (nonatomic, copy, nullable) BFFileMonitorHandler startMonitorHandler;
/**
 *  A handler that will be called when the monitor is stopped from working
 */
@property (nonatomic, copy, nullable) BFFileMonitorHandler stopMonitorHandler;
/**
 *  A handler that will be called when the monitor resumes to work
 */
@property (nonatomic, copy, nullable) BFFileMonitorHandler resumeMonitorHandler;
/**
 *  A handler that will be called when the monitor is paused from working
 */
@property (nonatomic, copy, nullable) BFFileMonitorHandler pauseMonitorHandler;

/**
 *  a file monitor which is listening to path and reports modification by block
 *
 *  @param path  the path should be monitored.
 *  @param block the block should be called when contents of path changed
 *
 *  @return a file monitor which is listening to path and reports modification by block
 */
+ (instancetype)fileMonitorWithPath:(NSString *)path block:(BFFileMonitorHandler)block;
/**
 *  a file monitor which is listening to path and reports modification by block
 *
 *  @param path  the path should be monitored.
 *  @param block the block should be called when contents of path changed
 *
 *  @return a file monitor which is listening to path and reports modification by block
 */
- (instancetype)initWithPath:(NSString *)path block:(BFFileMonitorHandler)block;

- (void)startMonitoring;
- (void)stopMonitoring;

- (void)resumeMonitoring;
- (void)pauseMonitoring;

@end

NS_ASSUME_NONNULL_END
