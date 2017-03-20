//
//  BFFunctionUtilities.h
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

#pragma mark - Numbers

// Number
/**
 *  Return a number between bound
 *
 *  @param VALUE     input value
 *  @param MIN_VALUE min limit of input value
 *  @param MAX_VALUE max limit of input value
 *
 *  For example:
 *      int a = BFBoundary(12, -5, 10);  // a = 10
 *      int b = BFBoundary(2, -5, 10);   // b = 2
 *      int c = BFBoundary(-7, -5, 10);  // c = -5
 *
 *  @return the input value if it's between min and max limit. (else the limit value)
 */
#define BFBoundary(VALUE, MIN_VALUE, MAX_VALUE) (MIN((MAX_VALUE), MAX((MIN_VALUE), (VALUE))))
/**
 *  Return a number between bound
 *
 *  @param VALUE     input value
 *  @param MIN_VALUE min limit of input value
 *  @param MAX_VALUE max limit of input value
 *
 *  For example:
 *      NSNumber *a = BFBoundaryNumber(@12, @-5, @10);  // a = 10
 *      NSNumber *b = BFBoundaryNumber(@2, @-5, @10);   // b = 2
 *      NSNumber *c = BFBoundaryNumber(@-7, @-5, @10);  // c = -5
 *
 *  @return the input value if it's between min and max limit. (else the limit value)
 */
BF_STATIC_INLINE NSNumber *BFBoundaryNumber(NSNumber *value, NSNumber *minValue, NSNumber *maxValue) {
    return @(fmin(maxValue.doubleValue, fmax(minValue.doubleValue, value.doubleValue)));
}

#pragma mark Float comparison

// Float comparison
BF_STATIC_INLINE bool flessf(float floatA, float floatB) { return floatA - floatB < -FLT_EPSILON; }
BF_STATIC_INLINE bool fless(double doubleA, double doubleB) { return doubleA - doubleB < -DBL_EPSILON; }
BF_STATIC_INLINE bool flessl(long double ldA, long double ldB) { return ldA - ldB < -LDBL_EPSILON; }

BF_STATIC_INLINE bool flessequalf(float floatA, float floatB) { return floatA - floatB < FLT_EPSILON; }
BF_STATIC_INLINE bool flessequal(double doubleA, double doubleB) { return doubleA - doubleB < DBL_EPSILON; }
BF_STATIC_INLINE bool flessequall(long double ldA, long double ldB) { return ldA - ldB < LDBL_EPSILON; }

BF_STATIC_INLINE bool fequalf(float floatA, float floatB) { return fabsf(floatA - floatB) <= FLT_EPSILON; }
BF_STATIC_INLINE bool fequal(double doubleA, double doubleB) { return fabs(doubleA - doubleB) <= DBL_EPSILON; }
BF_STATIC_INLINE bool fequall(long double ldA, long double ldB) { return fabsl(ldA - ldB) <= LDBL_EPSILON; }

BF_STATIC_INLINE bool fgreatequalf(float floatA, float floatB) { return floatA - floatB > -FLT_EPSILON; }
BF_STATIC_INLINE bool fgreatequal(double doubleA, double doubleB) { return doubleA - doubleB > -DBL_EPSILON; }
BF_STATIC_INLINE bool fgreatequall(long double ldA, long double ldB) { return ldA - ldB > -LDBL_EPSILON; }

BF_STATIC_INLINE bool fgreatf(float floatA, float floatB) { return floatA - floatB > FLT_EPSILON; }
BF_STATIC_INLINE bool fgreat(double doubleA, double doubleB) { return doubleA - doubleB > DBL_EPSILON; }
BF_STATIC_INLINE bool fgreatl(long double ldA, long double ldB) { return ldA - ldB > LDBL_EPSILON; }

// Float zero
BF_STATIC_INLINE bool fzerof(float floatA) { return fequalf(floatA, .0f); }
BF_STATIC_INLINE bool fzero(double doubleA) { return fequal(doubleA, .0); }
BF_STATIC_INLINE bool fzerol(long double ldA) { return fequall(ldA, .0l); }

#pragma mark Angle and Degree

// Angle <-> Degree
BF_STATIC_INLINE CGFloat BFDegreeFromAngle(CGFloat angle) { return angle * 180. / M_PI; }
BF_STATIC_INLINE CGFloat BFAngleFromDegree(CGFloat degree) { return degree / 180. * M_PI; }

BF_STATIC_INLINE BOOL BFDegreeIsNormalized360(CGFloat degree) {
#if defined(__LP64__) && __LP64__
    return fless(degree, 360.) && fgreatequal(degree, 0.);
#else
    return flessf(degree, 360.f) && fgreatequalf(degree, 0.f);
#endif
}
BF_STATIC_INLINE CGFloat BFNormalizeDegree360(CGFloat degree) {
#if defined(__LP64__) && __LP64__
    while (fless(degree, 0.)) {
        degree += 360.;
    }
    return fmod(degree, 360.);
#else
    while (flessf(degree, 0.f)) {
        degree += 360.f;
    }
    return fmodf(degree, 360.f);
#endif
}

BF_STATIC_INLINE BOOL BFDegreeIsNormalized180(CGFloat degree) {
#if defined(__LP64__) && __LP64__
    return flessequal(degree, 180.) && fgreat(degree, -180.);
#else
    return flessequalf(degree, 180.f) && fgreatf(degree, -180.f);
#endif
}
BF_STATIC_INLINE CGFloat BFNormalizeDegree180(CGFloat degree) {
#if defined(__LP64__) && __LP64__
    degree = fmod(degree, 360.);
    if (fgreat(degree, 180.)) {
        return degree - 360.;
    } else if (flessequal(degree, -180.)) {
        return degree + 360.;
    } else {
        return degree;
    }
#else
    degree = fmodf(degree, 360.f);
    if (fgreatf(degree, 180.f)) {
        return degree - 360.f;
    } else if (flessequalf(degree, -180.f)) {
        return degree + 360.f;
    } else {
        return degree;
    }
#endif
}

#define BFFullAngle 6.28318530717958647692528676655900576

BF_STATIC_INLINE BOOL BFAngleIsNormalized2PI(CGFloat angle) {
#if defined(__LP64__) && __LP64__
    return fless(angle, BFFullAngle) && fgreatequal(angle, 0.);
#else
    return flessf(angle, BFFullAngle) && fgreatequalf(angle, 0.);
#endif
}
BF_STATIC_INLINE CGFloat BFNormalizeAngle2PI(CGFloat angle) {
#if defined(__LP64__) && __LP64__
    while (fless(angle, 0.)) {
        angle += BFFullAngle;
    }
    return fmod(angle, BFFullAngle);
#else
    while (flessf(angle, 0.)) {
        angle += BFFullAngle;
    }
    return fmodf(angle, BFFullAngle);
#endif
}

BF_STATIC_INLINE BOOL BFAngleIsNormalizedPI(CGFloat angle) {
#if defined(__LP64__) && __LP64__
    return flessequal(angle, M_PI) && fgreat(angle, -M_PI);
#else
    return flessequalf(angle, M_PI) && fgreatf(angle, -M_PI);
#endif
}
BF_STATIC_INLINE CGFloat BFNormalizeAnglePI(CGFloat angle) {
#if defined(__LP64__) && __LP64__
    angle = fmod(angle, BFFullAngle);
    if (fgreat(angle, M_PI)) {
        return angle - BFFullAngle;
    } else if (flessequal(angle, -M_PI)) {
        return angle + BFFullAngle;
    } else {
        return angle;
    }
#else
    angle = fmodf(angle, BFFullAngle);
    if (fgreatf(angle, M_PI)) {
        return angle - BFFullAngle;
    } else if (flessequalf(angle, -M_PI)) {
        return angle + BFFullAngle;
    } else {
        return angle;
    }
#endif
}

BF_STATIC_INLINE BOOL BFDegreeIsEqual(CGFloat degree1, CGFloat degree2) {
#if defined(__LP64__) && __LP64__
    return fequal(BFNormalizeDegree360(degree1), BFNormalizeDegree360(degree2));
#else
    return fequalf(BFNormalizeDegree360(degree1), BFNormalizeDegree360(degree2));
#endif
}

BF_STATIC_INLINE BOOL BFAngleIsEqual(CGFloat angle1, CGFloat angle2) {
#if defined(__LP64__) && __LP64__
    return fequal(BFNormalizeAngle2PI(angle1), BFNormalizeAngle2PI(angle2));
#else
    return fequalf(BFNormalizeAngle2PI(angle1), BFNormalizeAngle2PI(angle2));
#endif
}

#pragma mark Random

// Random Generator
// (pow(2, 32) - 1), From man page
#define kArc4RandomMax 4294967295
/**
 *  Random Generator (between 2 integers)
 *
 *  @param A lower bound of random result
 *  @param B upper bound of random result
 *
 *  @return an integer between lower and upper bound. (Bounds are included)
 */
BF_STATIC_INLINE int BFIntRandomBetween(int A, int B) { return arc4random_uniform(B - A + 1) + A; }
BF_STATIC_INLINE NSInteger BFIntegerRandomBetween(NSInteger A, NSInteger B) {
    NSUInteger upperBound = B - A + 1;
    NSUInteger safeRange = NSUIntegerMax - NSUIntegerMax % upperBound;
    NSUInteger random = 0;
    do {
        arc4random_buf(&random, sizeof(NSUInteger));
    } while (random >= safeRange);
    return (NSInteger)(random % upperBound) + A;
}

/**
 *  Random Generator (between 2 doubles)
 *
 *  @param A lower bound of random result
 *  @param B upper bound of random result
 *
 *  @return a double value between lower and upper bound. (Bounds are included)
 */
BF_STATIC_INLINE double BFDoubleRandomBetween(double A, double B) {
    return (double)(BFIntegerRandomBetween(0, NSIntegerMax)) / (double)(NSIntegerMax) * (B - A) + A;
}

#pragma mark - Strings

// String Utilities
#define BFFormatString(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define BFJoinStrings(...) [@[ __VA_ARGS__ ] componentsJoinedByString:@""]

#pragma mark - Objects

/*
 * Casting
 *
 * Check type of object before casting.
 *
 * For example:
 *     NSNumber *number = BFObjectCasting(NSNumber, dict[@"key"]);
 *
 */
#define BFObjectCasting(TYPE, VARIABLE) ([(VARIABLE)isKindOfClass:[TYPE class]] ? ((TYPE *)(VARIABLE)) : nil)
#define BFProtocolCasting(_PROTOCOL, VARIABLE)                                                                         \
    ([[(VARIABLE) class] conformsToProtocol:@protocol(_PROTOCOL)] ? ((id<_PROTOCOL>)(VARIABLE)) : nil)
#define BFObjectProtocolCasting(TYPE, _PROTOCOL, VARIABLE)                                                             \
    (([(VARIABLE)isKindOfClass:[TYPE class]] && [[(VARIABLE) class] conformsToProtocol:@protocol(_PROTOCOL)])          \
         ? ((TYPE<_PROTOCOL> *)(VARIABLE))                                                                             \
         : nil)

BF_STATIC_INLINE BOOL BFBoolFromNSNumber(NSNumber *number, BOOL defaultValue) {
    return number ? number.boolValue : defaultValue;
}

#pragma mark - C Array

// Array operation

#define BFReverseArray(ARRAY, LENGTH)                                                                                  \
    {                                                                                                                  \
        typeof(*(ARRAY)) tmp = 0;                                                                                      \
        for (NSUInteger i = 0, j = (LENGTH)-1; i < j; ++i, --j) {                                                      \
            tmp = (ARRAY)[i];                                                                                          \
            (ARRAY)[i] = (ARRAY)[j];                                                                                   \
            (ARRAY)[j] = tmp;                                                                                          \
        }                                                                                                              \
    }

#pragma mark - C/C++ Memory

// Free Memory

#define BFFreeCMemoryBlock(BLOCK_PTR)                                                                                  \
    {                                                                                                                  \
        if (BLOCK_PTR) {                                                                                               \
            free(BLOCK_PTR), BLOCK_PTR = NULL;                                                                         \
        }                                                                                                              \
    }

#define BFDeleteCppObject(OBJ_PTR)                                                                                     \
    {                                                                                                                  \
        if (OBJ_PTR) {                                                                                                 \
            delete OBJ_PTR, OBJ_PTR = NULL;                                                                            \
        }                                                                                                              \
    }

#pragma mark - Blocks

#define BFExecuteBlock(BLOCK, ...)                                                                                     \
    {                                                                                                                  \
        if (BLOCK) {                                                                                                   \
            BLOCK(__VA_ARGS__);                                                                                        \
        }                                                                                                              \
    }

#define BFExecuteAsyncBlockOnDispatchQueue(DISPATCH_QUEUE, BLOCK, ...)                                                 \
    {                                                                                                                  \
        if (BLOCK) {                                                                                                   \
            dispatch_async((DISPATCH_QUEUE), ^{ BLOCK(__VA_ARGS__); });                                                \
        }                                                                                                              \
    }

#define BFExecuteAsyncBlockOnMainQueue(BLOCK, ...)                                                                     \
    BFExecuteAsyncBlockOnDispatchQueue(dispatch_get_main_queue(), BLOCK, __VA_ARGS__)

#define BFExecuteBlockOnDispatchQueueAfterDelay(DISPATCH_QUEUE, DELAY, BLOCK, ...)                                     \
    {                                                                                                                  \
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((DELAY)*NSEC_PER_SEC));                   \
        dispatch_after(popTime, (DISPATCH_QUEUE), ^(void){BFExecuteBlock(BLOCK, __VA_ARGS__)});                        \
    }

#define BFExecuteBlockOnMainQueueAfterDelay(DELAY, BLOCK, ...)                                                         \
    BFExecuteBlockOnDispatchQueueAfterDelay(dispatch_get_main_queue(), DELAY, BLOCK, __VA_ARGS__)

/**
 *  Execute a block on the main thread and wait until it's finished
 *
 *  @param block the block to excute on the main thread
 *
 *  If this function is called on main thread, it just executes the block.
 *  Or it makes the block executed on the main thread via dispatch_sync
 */
BF_STATIC_INLINE void BFExecuteBlockOnMainQueueAndWait(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 *  Execute a block on thread which is not main one and wait until it's finished
 *
 *  @param block the block to excute
 *
 *  If this function is called on main thread, it makes the block executed on the queue you passed in
 *  and wait with dispatch_group_t.
 *  Or it just executes this block
 */
BF_STATIC_INLINE void BFExecuteBlockOnBackgroundQueueAndWait(dispatch_queue_t queue, dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, block);
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    } else {
        block();
    }
}

#pragma mark - NSRunloop

// Run Loop
BF_STATIC_INLINE void BFHoldRunLoopWithFlag(NSRunLoop *runLoop, NSString *mode, BOOL *doneFlag, NSDate *beforeDate) {
    while (!(*doneFlag)) {
        @autoreleasepool {
            [runLoop runMode:mode beforeDate:beforeDate];
        }
    }
}
BF_STATIC_INLINE void BFHoldCurrentRunLoopWithFlag(BOOL *doneFlag, NSDate *beforeDate) {
    BFHoldRunLoopWithFlag([NSRunLoop currentRunLoop], NSDefaultRunLoopMode, doneFlag, beforeDate);
}
BF_STATIC_INLINE void BFHoldCurrentRunLoopWithFlagBeforeTimeInterval(BOOL *doneFlag, NSTimeInterval timeInterval) {
    BFHoldRunLoopWithFlag([NSRunLoop currentRunLoop], NSDefaultRunLoopMode, doneFlag,
                          [NSDate dateWithTimeIntervalSinceNow:timeInterval]);
}
BF_STATIC_INLINE void BFHoldCurrentRunLoopWithFlagBeforeShortDistance(BOOL *doneFlag) {
    BFHoldRunLoopWithFlag([NSRunLoop currentRunLoop], NSDefaultRunLoopMode, doneFlag,
                          [NSDate dateWithTimeIntervalSinceNow:.1]);
}

#pragma mark - Locks

// Lock Flag
BF_STATIC_INLINE BOOL BFEntryLock(BOOL *flag, id lockTarget) {
    if (!(*flag)) {
        @synchronized(lockTarget) {
            if (!(*flag)) {
                *flag = YES;
                return YES;
            } else {
                return NO;
            }
        }
    } else {
        return NO;
    }
}
BF_STATIC_INLINE void BFLeavingLock(BOOL *flag) { *flag = NO; }

#pragma mark - NSError

BF_STATIC_INLINE NSError *NSErrorWithLocalizedDescription(NSString *domain, NSInteger code, NSString *localDesc) {
    return [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey: localDesc}];
}

BF_STATIC_INLINE void BFOutputErrorWithUserInfo(NSError *__autoreleasing *error, NSString *domain, NSInteger code,
                                                NSDictionary *userInfo) {
    if (error) {
        *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    }
}
BF_STATIC_INLINE void BFOutputError(NSError *__autoreleasing *error, NSString *domain, NSInteger code,
                                    NSString *reason) {
    if (error) {
        *error = NSErrorWithLocalizedDescription(domain, code, reason);
    }
}
BF_STATIC_INLINE void BFOutputErrorWithErrno(NSError *__autoreleasing *error, NSString *domain) {
    BFOutputError(error, domain, errno, @(strerror(errno)));
}

#pragma mark - Device Helpers (Deprecated)

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

// Check ios versions ...
//
// According to Apple's documentation
// It's recommended to check class existence or method respondence first
BF_STATIC_INLINE BOOL BFOSIsOlderThan(NSString *version) {
    return [[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch] == NSOrderedAscending;
}
BF_STATIC_INLINE BOOL BFOSIsNewerThan(NSString *version) {
    return [[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch] == NSOrderedDescending;
}
BF_STATIC_INLINE BOOL BFOSIsOlderThanOrEqualsTo(NSString *version) {
    return [[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch] != NSOrderedDescending;
}
BF_STATIC_INLINE BOOL BFOSIsNewerThanOrEqualsTo(NSString *version) {
    return [[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch] != NSOrderedAscending;
}
BF_STATIC_INLINE BOOL BFOSIsOlderThan80() { return BFOSIsOlderThan(@"8.0"); }
BF_STATIC_INLINE BOOL BFOSIsOlderThan70() { return BFOSIsOlderThan(@"7.0"); }
BF_STATIC_INLINE BOOL BFOSIsNewerThan80() { return BFOSIsNewerThan(@"8.0"); }
BF_STATIC_INLINE BOOL BFOSIsNewerThan70() { return BFOSIsNewerThan(@"7.0"); }
BF_STATIC_INLINE BOOL BFOSIsNewerThanOrEqualsTo80() { return BFOSIsNewerThanOrEqualsTo(@"8.0"); }
BF_STATIC_INLINE BOOL BFOSIsNewerThanOrEqualsTo70() { return BFOSIsNewerThanOrEqualsTo(@"7.0"); }
BF_STATIC_INLINE BOOL BFOSIsOlderThanOrEqualsTo80() { return BFOSIsOlderThanOrEqualsTo(@"8.0"); }
BF_STATIC_INLINE BOOL BFOSIsOlderThanOrEqualsTo70() { return BFOSIsOlderThanOrEqualsTo(@"7.0"); }

// Device type
BF_STATIC_INLINE BOOL BFDeviceIsPad() {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}
BF_STATIC_INLINE BOOL BFDeviceIsPhone() {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}
BF_STATIC_INLINE BOOL BFDeviceIsTallPhone() {
    return BFDeviceIsPhone() && [UIScreen mainScreen].bounds.size.height > 480.;
}

#endif
