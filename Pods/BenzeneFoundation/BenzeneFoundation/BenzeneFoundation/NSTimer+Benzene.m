//
//  NSTimer+Benzene.m
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

#import "NSTimer+Benzene.h"
#import "BFFunctionUtilities.h"

@interface NSObject (BenzeneTimer)

- (void)__bf_blockTimer:(NSTimer *)timer;

@end

@implementation NSTimer (Benzene)

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval
                               target:(id)target
                               repeat:(BOOL)repeat
                                block:(void(^)(id, NSTimer *))block {
    return [NSTimer timerWithTimeInterval:timeInterval
                                   target:target
                                 selector:@selector(__bf_blockTimer:)
                                 userInfo:block
                                  repeats:repeat];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                        repeat:(BOOL)repeat
                                         block:(void(^)(id, NSTimer *))block {
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                            target:target
                                          selector:@selector(__bf_blockTimer:)
                                          userInfo:block
                                           repeats:repeat];
}

- (instancetype)initWithFireDate:(NSDate *)date
                        interval:(NSTimeInterval)timeInterval
                          target:(id)target
                          repeat:(BOOL)repeat
                           block:(void(^)(id, NSTimer *))block {
    return [self initWithFireDate:date
                         interval:timeInterval
                           target:target
                         selector:@selector(__bf_blockTimer:)
                         userInfo:block
                          repeats:repeat];
}

@end

@implementation NSObject (BenzeneTimer)

- (void)__bf_blockTimer:(NSTimer *)timer {
    void(^block)(id, NSTimer *) = timer.userInfo;
    BFExecuteBlock(block, self, timer);
}

@end
