//
//  NSData+Benzene.h
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

/**
 Execution result of BFLoadPartialBytes
 */
typedef enum {
    BFLoadPartialBytesSuccess,
    BFLoadPartialBytesCannotOpenFile,
    BFLoadPartialBytesCannotSetFilePosition,
    BFLoadPartialBytesCannotReadFile,
    BFLoadPartialBytesNoOutputBuffer,
} BFLoadPartialBytesResultCode;

/**
 *  Read part of a file into buffer
 *
 *  @param output output buffer
 *  @param path   file path
 *  @param loc    the location start to read
 *  @param length the length should be read
 *
 *  @return execution result
 */
BF_EXTERN BFLoadPartialBytesResultCode BFLoadPartialBytes(void *output, const char *path, size_t loc, size_t length);

@interface NSData (Benzene)

/**
 *  Creates and returns a data object by reading bytes in specified range from the file specified by a given path.
 *
 *  @param path  The absolute path of the file from which to read data.
 *  @param range the range going to be read from the file
 *  @param error error
 *
 *  @return an instance with contents in the range read from file.
 */
+ (nullable instancetype)dataWithContentsOfFile:(NSString *)path
                                          range:(NSRange)range
                                          error:(out NSError *__autoreleasing *)error;

+ (instancetype)randomDataOfLength:(size_t)length;

+ (instancetype)dataWithLength:(NSUInteger)length bytes:(uint8_t)bytes, ...;

+ (nullable instancetype)dataWithHexString:(NSString *)hexString;
+ (nullable instancetype)dataWithByteArray:(NSArray<NSNumber *> *)byteArray;

- (instancetype)subdataFromIndex:(NSUInteger)index;
- (instancetype)subdataToIndex:(NSUInteger)index;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (BOOL)isEqualToLength:(NSUInteger)length bytes:(uint8_t)bytes, ...;
- (BOOL)isEqualToBytes:(const void *)bytes length:(NSUInteger)length;

@end

@interface NSMutableData (Benzene)

- (void)appendDataWithLength:(NSUInteger)length bytes:(uint8_t)bytes, ...;

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
