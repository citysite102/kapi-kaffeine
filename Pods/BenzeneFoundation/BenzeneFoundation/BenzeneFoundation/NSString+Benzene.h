//
//  NSString+Benzene.h
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

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Benzene)

@property (readonly) CGFloat CGFloatValue;

- (NSRange)rangeOfWholeString;

- (BOOL)containsString:(NSString *)subString;

- (NSString *)stringByLowercaseInRange:(NSRange)range;
- (NSString *)stringByUppercaseInRange:(NSRange)range;

+ (instancetype)randomStringByLength:(NSUInteger)length NS_SWIFT_NAME(init(randomStringByLength:));

@property (nonatomic, readonly, getter=isNumberString) BOOL numberString;

- (void)enumerateCharacterFromSet:(NSCharacterSet *)characterSet
                        withBlock:(void(^)(unichar character, NSUInteger position, BOOL *stop))block;
- (void)enumerateCharacterFromSet:(NSCharacterSet *)characterSet
                          options:(NSStringCompareOptions)options
                        withBlock:(void(^)(unichar character, NSUInteger position, BOOL *stop))block;
- (void)enumerateCharacterFromSet:(NSCharacterSet *)characterSet
                          options:(NSStringCompareOptions)options
                            range:(NSRange)range
                        withBlock:(void(^)(unichar character, NSUInteger position, BOOL *stop))block;

- (void)enumerateOccurrencesOfString:(NSString *)string
                           withBlock:(void(^)(NSUInteger position, BOOL *stop))block;
- (void)enumerateOccurrencesOfString:(NSString *)string
                          options:(NSStringCompareOptions)options
                        withBlock:(void(^)(NSUInteger position, BOOL *stop))block;
- (void)enumerateOccurrencesOfString:(NSString *)string
                          options:(NSStringCompareOptions)options
                            range:(NSRange)range
                        withBlock:(void(^)(NSUInteger position, BOOL *stop))block;

- (NSString *)stringByReplacingCharactersFromSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement;
- (NSString *)stringByReplacingCharactersFromSet:(NSCharacterSet *)characterSet
                                         options:(NSStringCompareOptions)options
                                      withString:(NSString *)replacement;
- (NSString *)stringByReplacingCharactersFromSet:(NSCharacterSet *)characterSet
                                         options:(NSStringCompareOptions)options
                                           range:(NSRange)range
                                      withString:(NSString *)replacement;

+ (instancetype)stringWithFormat:(NSString *)format argumentsArray:(NSArray *)arguments;

@end

BF_STATIC_INLINE NSString *BFStringFromObject(id object) {
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[@YES class]]) {
        // Boolean
        return [object boolValue]?@"YES":@"NO";
    } else if ([object respondsToSelector:@selector(stringValue)]) {
        // Understand string value
        return [object stringValue];
    } else {
        return [object description];
    }
}

NS_ASSUME_NONNULL_END
