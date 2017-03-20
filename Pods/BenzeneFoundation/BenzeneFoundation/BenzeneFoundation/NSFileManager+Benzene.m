//
//  NSFileManager+Benzene.m
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

#import "NSFileManager+Benzene.h"
#import "BFDefines.h"
#import "BFFunctionUtilities.h"
#import "NSData+Benzene.h"
#import <sys/xattr.h>

NSString * const NSFileManagerExtendedAttributeErrorDomain = @"com.benzene.file-manager.extended-attribute";

@implementation NSFileManager (BFExtendedAttribute)

- (NSData *)extendedAttributeNamed:(NSString *)attrName ofItemAtPath:(NSString *)path
                             error:(NSError *__autoreleasing *)error {
    const char *attributeName = attrName.UTF8String;
    const char *filePath = path.fileSystemRepresentation;
    
    // Check key and create output buffer
    size_t bufferLength = getxattr(filePath, attributeName, NULL, 0, 0, 0);
    if (bufferLength==-1) {
        BFOutputErrorWithErrno(error, NSFileManagerExtendedAttributeErrorDomain);
        return nil;
    }
    NSMutableData *result = [NSMutableData dataWithLength:bufferLength];
    
    // Go
    size_t resultLength = getxattr(filePath, attributeName, result.mutableBytes, result.length, 0, 0);
    if (resultLength != -1) {
        result.length = resultLength;
        return [NSData dataWithData:result];
    } else {
        BFOutputErrorWithErrno(error, NSFileManagerExtendedAttributeErrorDomain);
        return nil;
    }
}

- (BOOL)setValue:(NSData *)value extendedAttributeNamed:(NSString *)attrName ofItemAtPath:(NSString *)path
           error:(NSError * __autoreleasing *)error {
    const char *attributeName = attrName.UTF8String;
    const char *filePath = path.fileSystemRepresentation;
    
    int result = setxattr(filePath, attributeName, value.bytes, value.length, 0, 0);
    if (result==0) {
        return YES;
    } else {
        BFOutputErrorWithErrno(error, NSFileManagerExtendedAttributeErrorDomain);
        return NO;
    }
}

- (BOOL)removeExtendedAttributeNamed:(NSString *)attrName ofItemAtPath:(NSString *)path
                               error:(NSError * __autoreleasing *)error {
    const char *attributeName = attrName.UTF8String;
    const char *filePath = path.fileSystemRepresentation;
    
    int result = removexattr(filePath, attributeName, 0);
    if (result==0) {
        return YES;
    } else {
        BFOutputErrorWithErrno(error, NSFileManagerExtendedAttributeErrorDomain);
        return NO;
    }
}

- (NSArray *)arrayWithExtendedAttributeNamesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    const char *filePath = path.fileSystemRepresentation;
    
    size_t size = listxattr(filePath, NULL, 0, 0);
    if (size==-1) {
        BFOutputErrorWithErrno(error, NSFileManagerExtendedAttributeErrorDomain);
        return nil;
    }
    
    NSMutableData *data = [NSMutableData dataWithLength:size];
    size_t dataLength = listxattr(filePath, data.mutableBytes, data.length, 0);
    if (dataLength==-1) {
        BFOutputErrorWithErrno(error, NSFileManagerExtendedAttributeErrorDomain);
        return nil;
    }
    
    char *nameList = (char *)data.bytes;
    NSUInteger nameListCharCount = data.length;
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < nameListCharCount; ) {
        char *string = nameList + i;
        [result addObject:@(string)];
        i += strlen(string) + 1; // NULL terminator
    }
    
    return [NSArray arrayWithArray:result];
}

@end

@implementation NSFileManager (BFContentType)

- (BOOL)isZipFileAtPath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path range:NSMakeRange(0, 4) error:nil];
    return [data isEqualToBytes:"\x50\x4b\x03\x04" length:4];
}

@end
