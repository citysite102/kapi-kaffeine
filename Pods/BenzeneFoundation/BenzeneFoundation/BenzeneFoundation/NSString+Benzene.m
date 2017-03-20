//
//  NSString+Benzene.m
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

#import "NSString+Benzene.h"
#import "NSData+Benzene.h"
#import "BFFunctionUtilities.h"
#import "BFHash.h"

@implementation NSString (Benzene)

- (NSRange)rangeOfWholeString {
    return NSMakeRange(0, self.length);
}

- (BOOL)containsString:(NSString *)subString {
    return [self rangeOfString:subString].location != NSNotFound;
}

- (NSString *)stringByLowercaseInRange:(NSRange)range {
    NSString *head = [self substringToIndex:range.location];
    NSString *body = [self substringWithRange:range];
    NSString *tail = [self substringFromIndex:range.location+range.length];
    return [NSString stringWithFormat:@"%@%@%@", head, body.lowercaseString, tail];
}

- (NSString *)stringByUppercaseInRange:(NSRange)range {
    NSString *head = [self substringToIndex:range.location];
    NSString *body = [self substringWithRange:range];
    NSString *tail = [self substringFromIndex:range.location+range.length];
    return [NSString stringWithFormat:@"%@%@%@", head, body.uppercaseString, tail];
}

- (CGFloat)CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return self.floatValue;
#endif
}

+ (NSString *)randomStringByLength:(NSUInteger)length {
    return [[BFHash hexdigestStringFromData:[NSData randomDataOfLength:(length+1)/2]] substringToIndex:length];
}

- (BOOL)isNumberString {
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    return [scanner scanDecimal:NULL] ? scanner.isAtEnd : NO;
}

- (void)enumerateCharacterFromSet:(NSCharacterSet *)characterSet
                        withBlock:(void(^)(unichar character, NSUInteger position, BOOL *stop))block {
    [self enumerateCharacterFromSet:characterSet options:0 range:self.rangeOfWholeString withBlock:block];
}

- (void)enumerateCharacterFromSet:(NSCharacterSet *)characterSet
                          options:(NSStringCompareOptions)options
                        withBlock:(void(^)(unichar character, NSUInteger position, BOOL *stop))block {
    [self enumerateCharacterFromSet:characterSet options:options range:self.rangeOfWholeString withBlock:block];
}

- (void)enumerateCharacterFromSet:(NSCharacterSet *)characterSet
                          options:(NSStringCompareOptions)options
                            range:(NSRange)targetRange
                        withBlock:(void(^)(unichar character, NSUInteger position, BOOL *stop))block {
    // Ref: http://stackoverflow.com/questions/7033574/find-all-locations-of-substring-in-nsstring-not-just-first
    NSRange searchRange = NSMakeRange(targetRange.location, targetRange.length);
    while (searchRange.location < targetRange.location + targetRange.length) {
        searchRange.length = targetRange.location + targetRange.length - searchRange.location;
        NSRange foundRange = [self rangeOfCharacterFromSet:characterSet options:options range:searchRange];
        if (foundRange.location != NSNotFound) {
            searchRange.location = foundRange.location + foundRange.length;
            BOOL shouldStop = NO;
            unichar character = [self characterAtIndex:foundRange.location];
            BFExecuteBlock(block, character, foundRange.location, &shouldStop);
            if (shouldStop) {
                break;
            }
        } else {
            break;
        }
    }
}

- (NSString *)stringByReplacingCharactersFromSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement {
    return [self stringByReplacingCharactersFromSet:characterSet
                                            options:0
                                              range:self.rangeOfWholeString
                                         withString:replacement];
}

- (NSString *)stringByReplacingCharactersFromSet:(NSCharacterSet *)characterSet
                                         options:(NSStringCompareOptions)options
                                      withString:(NSString *)replacement {
    return [self stringByReplacingCharactersFromSet:characterSet
                                            options:options
                                              range:self.rangeOfWholeString
                                         withString:replacement];
}

- (NSString *)stringByReplacingCharactersFromSet:(NSCharacterSet *)characterSet
                                         options:(NSStringCompareOptions)options
                                           range:(NSRange)range
                                      withString:(NSString *)replacement {
    NSMutableString *result = [NSMutableString string];
    NSUInteger __block lastSourceIndex = 0;
    [self enumerateCharacterFromSet:characterSet
                            options:options
                              range:range
                          withBlock:^(unichar character, NSUInteger position, BOOL *stop) {
                              [result appendString:[self substringWithRange:NSMakeRange(lastSourceIndex,
                                                                                        position - lastSourceIndex)]];
                              [result appendString:replacement];
                              lastSourceIndex = position+1;
                          }];
    if (lastSourceIndex < self.length) {
        [result appendString:[self substringFromIndex:lastSourceIndex]];
    }
    return [NSString stringWithString:result];
}

- (void)enumerateOccurrencesOfString:(NSString *)string
                           withBlock:(void(^)(NSUInteger position, BOOL *stop))block {
    [self enumerateOccurrencesOfString:string options:0 range:self.rangeOfWholeString withBlock:block];
}

- (void)enumerateOccurrencesOfString:(NSString *)string
                             options:(NSStringCompareOptions)options
                           withBlock:(void(^)(NSUInteger position, BOOL *stop))block {
    [self enumerateOccurrencesOfString:string options:options range:self.rangeOfWholeString withBlock:block];
}

- (void)enumerateOccurrencesOfString:(NSString *)string
                             options:(NSStringCompareOptions)options
                               range:(NSRange)targetRange
                           withBlock:(void(^)(NSUInteger position, BOOL *stop))block {
    NSRange searchRange = NSMakeRange(targetRange.location, targetRange.length);
    while (searchRange.location < targetRange.location + targetRange.length) {
        searchRange.length = targetRange.location + targetRange.length - searchRange.location;
        NSRange foundRange = [self rangeOfString:string options:options range:searchRange];
        if (foundRange.location != NSNotFound) {
            searchRange.location = foundRange.location + foundRange.length;
            BOOL shouldStop = NO;
            BFExecuteBlock(block, foundRange.location, &shouldStop);
            if (shouldStop) {
                break;
            }
        } else {
            break;
        }
    }
}

+ (NSString *)stringWithFormat:(NSString *)format argumentsArray:(NSArray *)arguments {
    NSMutableString *result = [NSMutableString string];
    NSUInteger __block lastSourceIndex = 0;
    NSUInteger __block argumentsIndex = 0;
    [format enumerateOccurrencesOfString:@"%" withBlock:^(NSUInteger position, BOOL *stop) {
        if ((*stop = position+1 >= format.length)) {
            return;
        }

        [result appendString:[format substringWithRange:NSMakeRange(lastSourceIndex,
                                                                    position - lastSourceIndex)]];

        unichar formatUnit = [format characterAtIndex:position+1];
        if (formatUnit == '@') {
            [result appendFormat:@"%@", arguments[argumentsIndex++]];
        } else if (formatUnit == '%') {
            [result appendString:@"%"];
        } else {
            [NSException raise:NSInternalInconsistencyException format:@"%ld should be %%@", (unsigned long)position];
        }

        lastSourceIndex = position+2;
    }];

    if (lastSourceIndex < format.length) {
        [result appendString:[format substringFromIndex:lastSourceIndex]];
    }
    return [NSString stringWithString:result];
}

@end
