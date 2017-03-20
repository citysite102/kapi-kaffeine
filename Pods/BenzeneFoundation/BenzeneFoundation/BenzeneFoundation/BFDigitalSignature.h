//
//  BFDigitalSignature.h
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

#if TARGET_OS_IPHONE

NS_ASSUME_NONNULL_BEGIN

BF_EXTERN SecKeyRef _Nullable BFCreatePublicKeyWithDerData(NSData *certData);
BF_STATIC_INLINE SecKeyRef _Nullable BFCreatePublicKeyWithDerFile(NSString *path) {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data ? BFCreatePublicKeyWithDerData(data) : nil;
}
BF_EXTERN SecKeyRef _Nullable BFCreatePrivateKeyWithP12Data(NSData *p12Data, NSString *_Nullable passphrase);
BF_STATIC_INLINE SecKeyRef _Nullable BFCreatePrivateKeyWithP12File(NSString *path, NSString *_Nullable passphrase) {
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data ? BFCreatePrivateKeyWithP12Data(data, passphrase) : nil;
}

@interface BFDigitalSignature : NSObject

+ (nullable NSData *)signatureOfPlainData:(NSData *)data
                      privateKeyAtP12File:(NSString *)path
                               passphrase:(nullable NSString *)passphrase;

+ (nullable NSData *)signatureOfPlainData:(NSData *)plainData
                      privateKeyAtP12Data:(NSData *)p12Data
                               passphrase:(nullable NSString *)passphrase;

+ (BOOL)verifySignature:(NSData *)signature withPlainData:(NSData *)plainData publicKeyInCertFile:(NSString *)path;

+ (BOOL)verifySignature:(NSData *)signature withPlainData:(NSData *)plainData publicKeyInCertData:(NSData *)certData;

@end

NS_ASSUME_NONNULL_END

#endif
