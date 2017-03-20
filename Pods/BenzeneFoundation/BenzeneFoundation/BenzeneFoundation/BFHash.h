//
//  BFHash.h
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

@interface BFHash : NSObject

#pragma mark - MD5

+ (NSData *)MD5HashDataWithInputStream:(NSInputStream *)inputStream;

+ (NSString *)MD5HashStringWithContentsOfFile:(NSString *)path;
+ (NSString *)MD5HashStringWithWithContentsOfURL:(NSURL *)url;
+ (NSString *)MD5HashString:(NSString *)string;

+ (NSData *)MD5HashDataWithContentsOfFile:(NSString *)path;
+ (NSData *)MD5HashDataWithContentsOfURL:(NSURL *)url;
+ (NSData *)MD5HashData:(NSData *)data;

#pragma mark - SHA

// You should create NSInputStream with NSData, NSURL, or NSString (path) first.
// For NSString content (not file path), convert it to NSData first

+ (NSData *)SHA1HashDataWithInputStream:(NSInputStream *)inputStream;
+ (NSData *)SHA256HashDataWithInputStream:(NSInputStream *)inputStream;
+ (NSData *)SHA512HashDataWithInputStream:(NSInputStream *)inputStream;

+ (NSString *)SHA1HashString:(NSString *)string;
+ (NSString *)SHA256HashString:(NSString *)string;
+ (NSString *)SHA512HashString:(NSString *)string;

#pragma mark - SHA HMAC

+ (NSData *)SHA256HashDataWithData:(NSData *)data salt:(NSData *)salt;
+ (NSData *)SHA512HashDataWithData:(NSData *)data salt:(NSData *)salt;

#pragma mark - AES256

// You should use RNCryptor

#pragma mark - Hex Digest

/**
 *  Make a hexdigest string from data
 *
 *  @param data Input Data
 *
 *  For example:
 *      NSData <6b12fc> --> NSString @"6b12fc"
 *
 *  @return Output hexdigest string
 */
+ (NSString *)hexdigestStringFromData:(NSData *)data;
+ (NSString *)hexdigestStringFromBytes:(unsigned char *)bytes length:(NSUInteger)length;

/**
 *  Make NSData from a hexdigest string
 *
 *  @param string Input hexdigest string
 *
 *  For example:
 *      NSString @"6b12fc" --> NSData <6b12fc>
 *
 *  @return data
 */
+ (NSData *)dataFromHexdigestString:(NSString *)string;

@end
