//
//  BFHash.m
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

#import <CommonCrypto/CommonCrypto.h>
#import "BFHash.h"
#import "BFDefines.h"
#import "BFFunctionUtilities.h"
#import "NSData+Benzene.h"

// Ref: https://github.com/JoeKun/FileMD5Hash/blob/master/Library/FileHash.m
/*
 *  FileHash.m
 *  FileMD5Hash
 *
 *  Copyright © 2010-2014 Joel Lopes Da Silva. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

// Constants
static const size_t BFHashDefaultChunkSizeForReadingData = 4096;

// Function pointer types for functions used in the computation
// of a cryptographic hash.
typedef int (*BFHashInitFunction)   (uint8_t *hashObjectPointer[]);
typedef int (*BFHashUpdateFunction) (uint8_t *hashObjectPointer[], const void *data, CC_LONG len);
typedef int (*BFHashFinalFunction)  (unsigned char *md, uint8_t *hashObjectPointer[]);

// Structure used to describe a hash computation context.
typedef struct _BFHashComputationContext {
    BFHashInitFunction initFunction;
    BFHashUpdateFunction updateFunction;
    BFHashFinalFunction finalFunction;
    size_t digestLength;
    uint8_t **hashObjectPointer;
} BFHashComputationContext;

#define BFHashComputationContextInitialize(context, hashAlgorithmName)                                                 \
    CC_##hashAlgorithmName##_CTX hashObjectFor##hashAlgorithmName;                                                     \
    context.initFunction      = (BFHashInitFunction)&CC_##hashAlgorithmName##_Init;                                    \
    context.updateFunction    = (BFHashUpdateFunction)&CC_##hashAlgorithmName##_Update;                                \
    context.finalFunction     = (BFHashFinalFunction)&CC_##hashAlgorithmName##_Final;                                  \
    context.digestLength      = CC_##hashAlgorithmName##_DIGEST_LENGTH;                                                \
    context.hashObjectPointer = (uint8_t **)&hashObjectFor##hashAlgorithmName

@implementation BFHash

+ (NSData *)hashedDataWithInputStream:(NSInputStream *)inputStream
               withComputationContext:(BFHashComputationContext *)context {
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }

    // Initialize the hash object
    (*context->initFunction)(context->hashObjectPointer);

    const NSUInteger bufferSize = BFHashDefaultChunkSizeForReadingData;
    NSMutableData *bufferData = [NSMutableData dataWithLength:bufferSize];
    if (!bufferData) {
        return nil;
    }
    uint8_t *buffer = bufferData.mutableBytes;

    // Feed the data to the hash object.
    BOOL hasMoreData = YES;
    while (hasMoreData) {
        NSInteger readBytesCount = [inputStream read:buffer maxLength:bufferSize];
        if (readBytesCount == -1) {
            break;
        } else if (readBytesCount == 0) {
            hasMoreData = NO;
        } else {
            (*context->updateFunction)(context->hashObjectPointer, (const void *)buffer, (CC_LONG)readBytesCount);
        }
    }

    // Compute the hash digest
    NSMutableData *digestData = [NSMutableData dataWithLength:context->digestLength];
    unsigned char *digest = digestData.mutableBytes;
    (*context->finalFunction)(digest, context->hashObjectPointer);

    // Close the read stream
    [inputStream close];

    if (!hasMoreData) {
        return [NSData dataWithData:digestData];
    } else {
        return nil;
    }
}

#pragma mark - MD5

+ (NSData *)MD5HashDataWithInputStream:(NSInputStream *)inputStream {
    BFHashComputationContext context;
    BFHashComputationContextInitialize(context, MD5);
    return [self hashedDataWithInputStream:inputStream withComputationContext:&context];
}

+ (NSString *)MD5HashStringWithContentsOfFile:(NSString *)path {
    return [self hexdigestStringFromData:
            [self MD5HashDataWithInputStream:[NSInputStream inputStreamWithFileAtPath:path]]];
}

+ (NSString *)MD5HashStringWithWithContentsOfURL:(NSURL *)url {
    return [self hexdigestStringFromData:
            [self MD5HashDataWithInputStream:[NSInputStream inputStreamWithURL:url]]];
}

+ (NSString *)MD5HashString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self hexdigestStringFromData:[self MD5HashDataWithInputStream:[NSInputStream inputStreamWithData:data]]];
}

+ (NSData *)MD5HashDataWithContentsOfFile:(NSString *)path {
    return [self MD5HashDataWithInputStream:[NSInputStream inputStreamWithFileAtPath:path]];
}

+ (NSData *)MD5HashDataWithContentsOfURL:(NSURL *)url {
    return [self MD5HashDataWithInputStream:[NSInputStream inputStreamWithURL:url]];
}

+ (NSData *)MD5HashData:(NSData *)data {
    return [self MD5HashDataWithInputStream:[NSInputStream inputStreamWithData:data]];
}

#pragma mark - SHA

+ (NSData *)SHA1HashDataWithInputStream:(NSInputStream *)inputStream {
    BFHashComputationContext context;
    BFHashComputationContextInitialize(context, SHA1);
    return [self hashedDataWithInputStream:inputStream withComputationContext:&context];
}

+ (NSData *)SHA256HashDataWithInputStream:(NSInputStream *)inputStream {
    BFHashComputationContext context;
    BFHashComputationContextInitialize(context, SHA256);
    return [self hashedDataWithInputStream:inputStream withComputationContext:&context];
}

+ (NSData *)SHA512HashDataWithInputStream:(NSInputStream *)inputStream {
    BFHashComputationContext context;
    BFHashComputationContextInitialize(context, SHA512);
    return [self hashedDataWithInputStream:inputStream withComputationContext:&context];
}

+ (NSString *)SHA1HashString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return data ? [self hexdigestStringFromData:
                   [self SHA1HashDataWithInputStream:
                    [NSInputStream inputStreamWithData:data]]] : nil;
}

+ (NSString *)SHA256HashString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return data ? [self hexdigestStringFromData:
                   [self SHA256HashDataWithInputStream:
                    [NSInputStream inputStreamWithData:data]]] : nil;
}

+ (NSString *)SHA512HashString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return data ? [self hexdigestStringFromData:
                   [self SHA512HashDataWithInputStream:
                    [NSInputStream inputStreamWithData:data]]] : nil;
}

#pragma mark - SHA HMAC

+ (NSData *)SHA256HashDataWithData:(NSData *)data salt:(NSData *)salt {
    NSMutableData* hash = [[NSMutableData alloc] initWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, salt.bytes, salt.length, data.bytes, data.length, hash.mutableBytes);
    return [NSData dataWithData:hash];
}

+ (NSData *)SHA512HashDataWithData:(NSData *)data salt:(NSData *)salt {
    NSMutableData* hash = [[NSMutableData alloc] initWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, salt.bytes, salt.length, data.bytes, data.length, hash.mutableBytes);
    return [NSData dataWithData:hash];
}

#pragma mark - Hex Digest

+ (NSString *)hexdigestStringFromBytes:(unsigned char *)bytes length:(NSUInteger)length {
    NSMutableString *resultString = [[NSMutableString alloc] initWithCapacity:length*2];
    for (NSUInteger i = 0; i < length; ++i) {
        [resultString appendFormat:@"%02x", bytes[i]];
    }
    return [NSString stringWithString:resultString];
}

+ (NSString *)hexdigestStringFromData:(NSData *)data {
    unsigned char buffer;
    NSMutableString *resultString = [[NSMutableString alloc] initWithCapacity:data.length*2];
    for (NSUInteger i = 0; i < data.length; ++i) {
        [data getBytes:&buffer range:NSMakeRange(i, 1)];
        [resultString appendFormat:@"%02x", buffer];
    }
    return [NSString stringWithString:resultString];
}

+ (NSData *)dataFromHexdigestString:(NSString *)string {
    // Create buffer
    NSMutableData *bufferData = [[NSMutableData alloc] initWithLength:sizeof(char)*3];
    char *buffer = bufferData.mutableBytes;
    buffer[2] = '\0';

    // Go
    NSMutableData *data = [NSMutableData dataWithCapacity:string.length/2];
    const char *str = string.UTF8String;
    for (NSUInteger i=0; i < string.length; i+=2) {
        memcpy(buffer, str+i, 2);
        char value = strtol(buffer, NULL, 16);
        [data appendBytes:&value length:1];
    }

    return [NSData dataWithData:data];
}

@end
