//
//  BFAppSession.m
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

#import "BFAppSession.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

NSString *const BFAppSessionExpiredNotification = @"BFAppSessionExpiredNotification";

@interface BFAppSession () {
    NSMutableDictionary *defaultDictionary;
    NSMutableDictionary *localDictionary;
}

@property (nonatomic, assign, readwrite) NSTimeInterval backgroundTimeIntervalToRefreshSession;
@property (nonatomic, strong, readwrite) NSDate *sessionStartDate;
@property (nonatomic, strong, readwrite) NSDate *lastSessionEndDate;

+ (NSMutableDictionary *)appSessionPool;

@end

@implementation BFAppSession

#pragma mark - Default app session

+ (void)startAppSession {
    [self currentAppSession];
}

+ (BFAppSession *)currentAppSession {
    static BFAppSession *currentAppSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentAppSession = [[self alloc] init];
        currentAppSession.backgroundTimeIntervalToRefreshSession = 0;
    });
    return currentAppSession;
}

#pragma mark - App session with different refresh time interval

+ (void)startAppSessionWithRefreshTimeIntervalInBackground:(NSTimeInterval)refreshTimeInterval {
    BFAppSession *appSession = [[self alloc] init];
    appSession.backgroundTimeIntervalToRefreshSession = refreshTimeInterval;
    [self appSessionPool][@(refreshTimeInterval)] = appSession;
}

+ (BFAppSession *)appSessionWithRefreshTimeIntervalInBackground:(NSTimeInterval)refreshTimeInterval {
    return [self appSessionPool][@(refreshTimeInterval)];
}

#pragma mark - Object Lifecycle

- (id)init {
    if (self = [super init]) {
        defaultDictionary = [NSMutableDictionary dictionary];
        localDictionary = [NSMutableDictionary dictionary];

#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
#else
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                     name:NSApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:NSApplicationWillResignActiveNotification object:nil];
#endif
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Session Pool

+ (NSMutableDictionary *)appSessionPool {
    static NSMutableDictionary *appSessionPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appSessionPool = [NSMutableDictionary dictionary];
    });
    return appSessionPool;
}

#pragma mark - Methods

- (void)registerDefaultObject:(id)object forKey:(id<NSCopying>)key {
    defaultDictionary[key] = object;
}

- (void)deregisterDefaultObjectForKey:(id<NSCopying>)key {
    [defaultDictionary removeObjectForKey:key];
}

- (void)resetToDefaults {
    localDictionary = [NSMutableDictionary dictionary];

    NSNotification *notification = [NSNotification notificationWithName:BFAppSessionExpiredNotification object:self];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP];
}

#pragma - Accessors

- (id)objectForKeyedSubscript:(id)key {
    return localDictionary[key]?:defaultDictionary[key];
}

- (id)objectForKey:(NSString *)key {
    return localDictionary[key]?:defaultDictionary[key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    localDictionary[key] = object;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    localDictionary[key] = object;
}

- (void)removeObjectForKey:(id)key {
    [localDictionary removeObjectForKey:key];
}

#pragma mark - Notification

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    NSDate *sessionStartDate = self.sessionStartDate = [NSDate date];
    NSDate *lastSessionEndDate = self.lastSessionEndDate;

    if (sessionStartDate && lastSessionEndDate &&
        [sessionStartDate timeIntervalSinceDate:lastSessionEndDate] >
        self.backgroundTimeIntervalToRefreshSession) {
        [self resetToDefaults];
    }
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    self.lastSessionEndDate = [NSDate date];
}

#pragma mark - Dictionary

- (NSDictionary *)defaultDictionary {
    return [NSDictionary dictionaryWithDictionary:defaultDictionary];
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *result = [defaultDictionary copy];
    [result addEntriesFromDictionary:localDictionary];
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
