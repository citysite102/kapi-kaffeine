//
//  NSData+Benzene.m
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

#import "NSData+Benzene.h"
#import "BFDefines_Internal.h"
#import "BFError.h"
#import "BFDefines.h"
#import "BFFunctionUtilities.h"
#import <libextobjc/extobjc.h>

BFLoadPartialBytesResultCode BFLoadPartialBytes(void *output, const char *path, size_t location, size_t length) {
    if (!output) {
        return BFLoadPartialBytesNoOutputBuffer;
    }

    FILE *file = fopen(path, "rb");
    if (!file) {
        return BFLoadPartialBytesCannotOpenFile;
    }
    
    if (fseek(file, location, SEEK_SET) != 0) {
        fclose(file);
        return BFLoadPartialBytesCannotSetFilePosition;
    }

    size_t chunk = 1;
    if (fread(output, chunk, length, file) != chunk * length) {
        fclose(file);
        memset(output, '\0', length);
        return BFLoadPartialBytesCannotReadFile;
    }
    
    fclose(file);
    return BFLoadPartialBytesSuccess;
}

@implementation NSData (Benzene)

+ (instancetype)randomDataOfLength:(size_t)length {
    // Ref: http://robnapier.net/aes-commoncrypto
    NSMutableData *data = [[NSMutableData alloc] initWithLength:length];
    return (SecRandomCopyBytes(kSecRandomDefault, length, data.mutableBytes)==0) ? [[self alloc] initWithData:data]:nil;
}

+ (instancetype)dataWithContentsOfFile:(NSString *)path range:(NSRange)range
                                 error:(out NSError *__autoreleasing *)error {
    // Create output buffer
    NSMutableData *data = [[NSMutableData alloc] initWithLength:range.length];
    
    // Go
    const char *_path = path.UTF8String;
    int result = BFLoadPartialBytes(data.mutableBytes, _path, range.location, range.length);
    if (result == BFLoadPartialBytesSuccess) {
        return [NSData dataWithData:data];
    } else {
        NSString *msg = nil;
        if (result == BFLoadPartialBytesCannotOpenFile) {
            msg = @"Cannot open file for reading";
        } else if (result == BFLoadPartialBytesCannotSetFilePosition) {
            msg = @"Cannot set file position indicator";
        } else if (result == BFLoadPartialBytesCannotReadFile) {
            msg = @"Failed to read file";
        }
        
        if (msg) {
            BFOutputError(error, BFBenznenFoundationIOErrorDomain,
                          BFBenzeneFoundationLowLevelIOError, msg);
        }
        return nil;
    }
}

+ (instancetype)dataWithLength:(NSUInteger)length bytes:(uint8_t)byte, ... {
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*length);
    if (!buffer) {
        return nil;
    }

    buffer[0] = byte;
    va_list bytes;
    va_start(bytes, byte);
    for (NSUInteger i=1; i<length; ++i) {  // first byte has been consumed
        buffer[i] = va_arg(bytes, int);
    }
    va_end(bytes);

    return [[self alloc] initWithBytesNoCopy:buffer length:length freeWhenDone:YES];
}

+ (instancetype)dataWithHexString:(NSString *)hexString {
    NSMutableData *data = [[NSMutableData alloc] initWithLength:hexString.length/2];
    uint8_t *mutableBytes = data.mutableBytes;
    BOOL validValue = YES;
    for (NSUInteger i=0; i<hexString.length; i+=2) {
        unsigned int value = 0;
        NSString *subString = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [NSScanner scannerWithString:subString];
        if ((validValue = [scanner scanHexInt:&value] && scanner.atEnd && value < 256)) {
            mutableBytes[i/2] = value;
        }
    }
    return validValue ? [NSData dataWithData:data] : nil;
}

+ (instancetype)dataWithByteArray:(NSArray<NSNumber *> *)byteArray {
    NSMutableData *data = [[NSMutableData alloc] initWithLength:byteArray.count];
    uint8_t *mutableBytes = data.mutableBytes;
    BOOL __block validValue = YES;
    [byteArray enumerateObjectsUsingBlock:^(NSNumber *byte, NSUInteger idx, BOOL *stop) {
        if ((validValue = byte.integerValue < 256)) {
            mutableBytes[idx] = byte.unsignedCharValue;
        } else {
            *stop = YES;
        }
    }];
    return validValue ? [NSData dataWithData:data] : nil;
}

- (instancetype)subdataFromIndex:(NSUInteger)index {
    return [self subdataWithRange:NSMakeRange(index, self.length-index)];
}

- (instancetype)subdataToIndex:(NSUInteger)index {
    return [self subdataWithRange:NSMakeRange(0, index)];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.length) {
        [NSException raise:NSRangeException format:@"Index out of bound. (0..%ld)", (long)self.length];
    }
    const uint8_t *bytes = self.bytes;
    return @(bytes[idx]);
}

- (BOOL)isEqualToLength:(NSUInteger)length bytes:(uint8_t)byte, ... {
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*length);
    if (!buffer) {
        return NO;
    }
    @onExit {
        free(buffer);
    };

    buffer[0] = byte;
    va_list bytes;
    va_start(bytes, byte);
    for (NSUInteger i=1; i<length; ++i) {  // first byte has been consumed
        buffer[i] = va_arg(bytes, int);
    }
    va_end(bytes);

    return memcmp(self.bytes, buffer, length) == 0;
}

- (BOOL)isEqualToBytes:(const void *)bytes length:(NSUInteger)length {
    return memcmp(self.bytes, bytes, length) == 0;
}

@end

@implementation NSMutableData (Benzene)

- (void)appendDataWithLength:(NSUInteger)length bytes:(uint8_t)byte, ... {
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*length);
    if (!buffer) {
        return;
    }

    buffer[0] = byte;
    va_list bytes;
    va_start(bytes, byte);
    for (NSUInteger i=1; i<length; ++i) {  // first byte has been consumed
        buffer[i] = va_arg(bytes, int);
    }
    va_end(bytes);

    [self appendBytes:buffer length:length];
    BFFreeCMemoryBlock(buffer);
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (idx > self.length) {  // `==` for append
        [NSException raise:NSRangeException format:@"Index out of bound. (0..%ld)", (long)self.length];
    }

    uint8_t byteToAppend[1] = {'\0'};
    if ([obj isKindOfClass:[NSData class]]) {
        byteToAppend[0] = ((uint8_t *)[obj bytes])[0];
    } else {
        byteToAppend[0] = [obj unsignedCharValue];
    }

    if (idx == self.length) {
        [self appendBytes:byteToAppend length:1];
    } else {
        uint8_t *mutableBytes = self.mutableBytes;
        memcpy(mutableBytes, byteToAppend, 1);
    }
}

@end
