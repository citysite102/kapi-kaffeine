//
//  BFJson.m
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

#import "BFJson.h"
#import <libextobjc/extobjc.h>

BF_STATIC_INLINE NSInteger BFJsonWriteToStream(id object, NSOutputStream *outputStream, NSError *__autoreleasing *err) {
    return [NSJSONSerialization writeJSONObject:object toStream:outputStream options:0 error:err] != 0;
}

BF_STATIC_INLINE BOOL BFJsonWriteToPath(id object, NSString *path, BOOL atomically, NSError *__autoreleasing *error) {
    // Create backup file
    NSString *const backupPath = [path stringByAppendingPathExtension:@"old"];
    if (atomically &&
        [[NSFileManager defaultManager] fileExistsAtPath:path] &&
        ![[NSFileManager defaultManager] copyItemAtPath:path toPath:backupPath error:error]) {
        return NO;  // failed to create backup file
    }

    BOOL __block success = YES;
    @onExit {
        if (atomically) {
            if (!success &&
                ![[NSFileManager defaultManager] copyItemAtPath:backupPath toPath:path error:nil]) {
                return;
            }
            // Clean backup file
            [[NSFileManager defaultManager] removeItemAtPath:backupPath error:nil];
        }
    };

    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [outputStream open];
    if (outputStream.streamStatus != NSStreamStatusOpen) {
        return success = NO;
    }
    @onExit {
        [outputStream close];
    };

    return success = BFJsonWriteToStream(object, outputStream, error) != 0;
}

BF_STATIC_INLINE BOOL BFJsonWriteToURL(id object, NSURL *url, BOOL atomically, NSError *__autoreleasing *error) {
    NSString *filePath = url.path;
    if (!filePath) {
        return NO;
    }
    // Create backup file
    NSURL *const backupURL = [url URLByAppendingPathExtension:@"old"];
    if (atomically &&
        [[NSFileManager defaultManager] fileExistsAtPath:filePath] &&
        ![[NSFileManager defaultManager] copyItemAtURL:url toURL:backupURL error:error]) {
        return NO;  // failed to create backup file
    }

    BOOL __block success = YES;
    @onExit {
        if (atomically) {
            if (!success &&
                ![[NSFileManager defaultManager] copyItemAtURL:backupURL toURL:url error:nil]) {
                return;
            }
            // Clean backup file
            [[NSFileManager defaultManager] removeItemAtURL:backupURL error:nil];
        }
    };

    NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:url append:NO];
    [outputStream open];
    if (outputStream.streamStatus != NSStreamStatusOpen) {
        return success = NO;
    }
    @onExit {
        [outputStream close];
    };

    return success = BFJsonWriteToStream(object, outputStream, error) != 0;
}

#pragma mark - String and Data

@implementation NSString (BFJson)

- (id)jsonObject {
    return BFObjectFromJsonString(self, 0, nil);
}

- (id)objectWithJSONValue {
    return BFObjectFromJsonString(self, 0, nil);
}

@end

@implementation NSData (BFJson)

- (id)jsonObject {
    return BFObjectFromJsonData(self, 0, nil);
}

- (id)objectWithJSONValue {
    return BFObjectFromJsonData(self, 0, nil);
}

@end

#pragma mark - Array

@implementation NSArray (BFJson)

- (NSString *)jsonString {
    return BFJsonString(self, 0, nil);
}
- (NSString *)stringWithJSONObject {
    return BFJsonString(self, 0, nil);
}

- (NSData *)jsonData {
    return BFJsonData(self, 0, nil);
}
- (NSData *)dataWithJSONObject {
    return BFJsonData(self, 0, nil);
}

+ (instancetype)arrayWithContentsOfJsonString:(NSString *)jsonString {
    id object = BFObjectFromJsonString(jsonString, 0, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)arrayWithContentsOfJsonData:(NSData *)jsonData {
    id object = BFObjectFromJsonData(jsonData, 0, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)arrayWithContentsOfJsonFile:(NSString *)path {
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)arrayWithContentsOfJsonURL:(NSURL *)url {
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:url];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}


- (BOOL)writeToJsonFile:(NSString *)path atomically:(BOOL)atomically error:(NSError *__autoreleasing *)error {
    return BFJsonWriteToPath(self, path, atomically, error);
}

- (BOOL)writeToJsonFile:(NSString *)path {
    return BFJsonWriteToPath(self, path, YES, nil);
}

- (BOOL)writeToJsonURL:(NSURL *)url atomically:(BOOL)atomically error:(NSError *__autoreleasing *)error {
    return BFJsonWriteToURL(self, url, atomically, error);
}

- (BOOL)writeToJsonURL:(NSURL *)url {
    return BFJsonWriteToURL(self, url, YES, nil);
}

@end

@implementation NSMutableArray (BFJson)

+ (instancetype)arrayWithContentsOfJsonString:(NSString *)jsonString {
    id object = BFObjectFromJsonString(jsonString, NSJSONReadingMutableContainers, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)arrayWithContentsOfJsonData:(NSData *)jsonData {
    id object = BFObjectFromJsonData(jsonData, NSJSONReadingMutableContainers, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)arrayWithContentsOfJsonFile:(NSString *)path {
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)arrayWithContentsOfJsonURL:(NSURL *)url {
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:url];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}

@end

#pragma mark - Dictionary

@implementation NSDictionary (BFJson)

+ (instancetype)dictionaryWithContentsOfJsonString:(NSString *)jsonString {
    id object = BFObjectFromJsonString(jsonString, 0, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)dictionaryWithContentsOfJsonData:(NSData *)jsonData {
    id object = BFObjectFromJsonData(jsonData, 0, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)dictionaryWithContentsOfJsonFile:(NSString *)path {
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)dictionaryWithContentsOfJsonURL:(NSURL *)url {
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:url];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}

- (NSString *)jsonString {
    return BFJsonString(self, 0, nil);
}
- (NSString *)stringWithJSONObject {
    return BFJsonString(self, 0, nil);
}

- (NSData *)jsonData {
    return BFJsonData(self, 0, nil);
}
- (NSData *)dataWithJSONObject {
    return BFJsonData(self, 0, nil);
}

- (BOOL)writeToJsonFile:(NSString *)path atomically:(BOOL)atomically error:(NSError *__autoreleasing *)error {
    return BFJsonWriteToPath(self, path, atomically, error);
}

- (BOOL)writeToJsonFile:(NSString *)path {
    return BFJsonWriteToPath(self, path, YES, nil);
}

- (BOOL)writeToJsonURL:(NSURL *)url {
    return BFJsonWriteToURL(self, url, YES, nil);
}

- (BOOL)writeToJsonURL:(NSURL *)url atomically:(BOOL)atomically error:(NSError *__autoreleasing *)error {
    return BFJsonWriteToURL(self, url, atomically, error);
}

@end

@implementation NSMutableDictionary (BFJson)

+ (instancetype)dictionaryWithContentsOfJsonString:(NSString *)jsonString {
    id object = BFObjectFromJsonString(jsonString, NSJSONReadingMutableContainers, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)dictionaryWithContentsOfJsonData:(NSData *)jsonData {
    id object = BFObjectFromJsonData(jsonData, NSJSONReadingMutableContainers, nil);
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)dictionaryWithContentsOfJsonFile:(NSString *)path {
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}

+ (instancetype)dictionaryWithContentsOfJsonURL:(NSURL *)url {
    NSInputStream *inputStream = [NSInputStream inputStreamWithURL:url];
    [inputStream open];
    if (inputStream.streamStatus != NSStreamStatusOpen) {
        return nil;
    }
    @onExit {
        [inputStream close];
    };

    id object = [NSJSONSerialization JSONObjectWithStream:inputStream
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    return [object isKindOfClass:[self class]] ? object : nil;
}

@end

@implementation NSSet (BFJson)

+ (instancetype)setWithContentsOfJsonString:(NSString *)jsonString {
    NSArray *contentArray = [NSArray arrayWithContentsOfJsonString:jsonString];
    return contentArray ? [self setWithArray:contentArray] : nil;
}

+ (instancetype)setWithContentsOfJsonData:(NSData *)jsonData {
    NSArray *contentArray = [NSArray arrayWithContentsOfJsonData:jsonData];
    return contentArray ? [self setWithArray:contentArray] : nil;
}

- (NSString *)jsonString {
    return BFJsonString(self.allObjects, 0, nil);
}
- (NSString *)stringWithJSONObject {
    return BFJsonString(self.allObjects, 0, nil);
}

- (NSData *)jsonData {
    return BFJsonData(self.allObjects, 0, nil);
}
- (NSData *)dataWithJSONObject {
    return BFJsonData(self.allObjects, 0, nil);
}

@end
