//
//  BFPthreadMutexLock.m
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

#import "BFPthreadMutexLock.h"
#import <pthread.h>

@interface BFPthreadMutexLock () {
    pthread_mutex_t _mutexLock;
}

@end

@implementation BFPthreadMutexLock

+ (pthread_mutexattr_t)sharedNormalMutexAttribute {
    static pthread_mutexattr_t attr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    });

    return attr;
}

+ (pthread_mutexattr_t)sharedRecursiveMutexAttribute {
    static pthread_mutexattr_t attr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    });

    return attr;
}

- (instancetype)init {
    return self = [self initWithPthreadMutexAttr:[[self class] sharedRecursiveMutexAttribute]];
}

- (instancetype)initWithPthreadMutexAttr:(pthread_mutexattr_t)mutexAttr {
    if (self = [super init]) {
        pthread_mutex_init(&_mutexLock, &mutexAttr);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutexLock);
}

- (void)lock {
    pthread_mutex_lock(&_mutexLock);
}

- (void)unlock {
    pthread_mutex_unlock(&_mutexLock);
}

- (BOOL)tryLock {
    return pthread_mutex_trylock(&_mutexLock) == 0;
}

@end
