//
//  BFURLEncoding.h
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

@interface NSString (BFURLEncoding)

/**
 * Return a URL-encoded representation of the receiver.
 *
 * @param encoding     the encoding used to do URL encoding
 *
 * @return    URL-encoded (percent-encoded) representation of the receiver.
 */
- (NSString *)urlEncodedStringUsingEncoding:(NSStringEncoding)encoding;

/**
 * Return a URL-decoded representation of the receiver.
 *
 * @param encoding     the encoding used to do URL decoding
 *
 * @return    URL-decoded (percent-decoded) representation of the receiver.
 */
- (NSString *)urlDecodedStringUsingEncoding:(NSStringEncoding)encoding;

@end

@interface NSDictionary (BFURLEncoding)

/**
 * Return a dictionary that represents URL-decoded value of the `urlEncodedString`
 *
 * @param urlEncodedString     The string that represents a dict in URL encoded form.
 *
 * @return                     String with URL-encoded representation of the receiver.
 */
+ (NSDictionary BFGenerics(NSString *, id) *)dictionaryWithContentsOfURLEncodedString:(NSString *)urlEncodedString;

/**
 * Return a string that represents URL-encoded value of the receiver
 *
 * @return     String with URL-encoded representation of the receiver.
 */
@property (nonatomic, readonly) NSString *stringWithURLEncodedValue;

@end
