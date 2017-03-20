//
//  BFURLEncoding.m
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

#import "BFURLEncoding.h"
#import "BFDefines.h"
#import "BFFunctionUtilities.h"

@implementation NSString (BFURLEncoding)

- (NSString *)urlEncodedStringUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL,
                                            (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                            CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)urlDecodedStringUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""),
                                                            CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end

@implementation NSDictionary (BFURLEncoding)

+ (NSDictionary *)dictionaryWithContentsOfURLEncodedString:(NSString *)urlEncodedString {
    @autoreleasepool {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        NSArray *encodedStringList = [urlEncodedString componentsSeparatedByString:@"&"];
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:encodedStringList.count];
        
        for (NSString *encodedStringPart in encodedStringList) {
            NSArray *rawKeyValuePair = [encodedStringPart componentsSeparatedByString:@"="];
            
            NSString *key = [rawKeyValuePair.firstObject urlDecodedStringUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [rawKeyValuePair.lastObject urlDecodedStringUsingEncoding:NSUTF8StringEncoding];
            
            // TODO: Convert boolean to NSNumber
            if (key && value) result[key] = [nf numberFromString:value]?:value;
        }
        return [NSDictionary dictionaryWithDictionary:result];
    }
}

- (NSString *)stringWithURLEncodedValue {
    @autoreleasepool {
        NSMutableArray *pairs = [NSMutableArray arrayWithCapacity:self.count];
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *keyString = [BFFormatString(@"%@", key) urlEncodedStringUsingEncoding:NSUTF8StringEncoding];
            NSString *objString = [BFFormatString(@"%@", obj) urlEncodedStringUsingEncoding:NSUTF8StringEncoding];
            
            NSString *pairString = BFFormatString(@"%@=%@", keyString, objString);
            [pairs addObject:pairString];
        }];
        return [pairs componentsJoinedByString:@"&"];
    }
}

@end
