//
//  BFLog.m
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

#import "BFLog_Internal.h"
#include <pthread.h>

// Ref: http://www.karlkraft.com/index.php/2009/03/23/114/

void BFDebugLog(const char *file, int lineNumber, const char *funcName, NSString *format, ...) {
    va_list ap;
	
    va_start(ap, format);
    if (![format hasSuffix:@"\n"]) {
        format = [format stringByAppendingString:@"\n"];
	}
	NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end (ap);
    
    _BFDebugLog(file, lineNumber, funcName, body);
}

NSString *_BFDebugLog(const char *file, int lineNumber, const char *funcName, NSString *body) {
    NSString *processName = [NSProcessInfo processInfo].processName;
    NSString *fileName = @(file).lastPathComponent;
    NSString *timestamp = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    mach_port_t threadID = pthread_mach_thread_np(pthread_self());
    int processID = [NSProcessInfo processInfo].processIdentifier;

    NSString *msg = [NSString stringWithFormat:@"%@, %@[%d:%x], %s, (%@:%d)\n%@",
                     timestamp, processName, processID, threadID, funcName, fileName, lineNumber, body];
    fprintf(stderr, "%s", msg.UTF8String);
    return msg;
}

void BFSimpleDebugLog(NSString *format, ...) {
    va_list ap;
	
    va_start(ap, format);
    if (![format hasSuffix:@"\n"]) {
        format = [format stringByAppendingString:@"\n"];
	}
	NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end (ap);
    
    _BFSimpleDebugLog(body);
}

NSString *_BFSimpleDebugLog(NSString *body) {
    NSString *processName = [NSProcessInfo processInfo].processName;
    NSString *timestamp = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    mach_port_t threadID = pthread_mach_thread_np(pthread_self());
    int processID = [NSProcessInfo processInfo].processIdentifier;

    NSString *msg = [NSString stringWithFormat:@"%@, %@[%d:%x]: %@", timestamp, processName, processID, threadID, body];
    fprintf(stderr, "%s", msg.UTF8String);
    return msg;
}
