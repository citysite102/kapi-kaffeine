//
//  BFDigitalSignature.m
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

#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>
#import <libextobjc/extobjc.h>
#import "BFDigitalSignature.h"

#if TARGET_OS_IPHONE

BF_EXTERN SecKeyRef _Nullable BFCreatePublicKeyWithDerData(NSData *certData) {
    SecCertificateRef const cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
    if (!cert) {
        return NULL;
    }
    @onExit {
        CFRelease(cert);
    };

    SecPolicyRef const policy = SecPolicyCreateBasicX509();
    if (!policy) {
        return NULL;
    }
    @onExit {
        CFRelease(policy);
    };

    SecTrustRef trust = NULL;
    if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) != noErr) {
        return NULL;
    }
    @onExit {
        CFRelease(trust);
    };

    SecKeyRef key = NULL;
    SecTrustResultType result;
    if (SecTrustEvaluate(trust, &result) == noErr) {
        key = SecTrustCopyPublicKey(trust);
    }
    return key;
}

BF_EXTERN SecKeyRef _Nullable BFCreatePrivateKeyWithP12Data(NSData *p12Data, NSString *_Nullable passphrase) {
    NSMutableDictionary *const options = [@{} mutableCopy];

    if (passphrase) {
        options[(__bridge id)kSecImportExportPassphrase] = passphrase;
    }

    CFArrayRef __block items = NULL;
    @onExit {
        if (items) {
            CFRelease(items);
        }
    };

    if (SecPKCS12Import((__bridge CFDataRef)p12Data,
                        (__bridge CFDictionaryRef)options,
                        &items) != noErr || CFArrayGetCount(items) == 0) {
        return NULL;
    }

    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);

    SecKeyRef __block privateKeyRef = NULL;
    if (SecIdentityCopyPrivateKey(identityApp, &privateKeyRef) != noErr) {
        if (privateKeyRef) {
            CFRelease(privateKeyRef);
        }
        return NULL;
    }

    return privateKeyRef;
}

@implementation BFDigitalSignature

+ (nullable NSData *)signatureOfPlainData:(NSData *)data
                      privateKeyAtP12File:(NSString *)path
                               passphrase:(nullable NSString *)passphrase {
    NSData *privateKeyData = [NSData dataWithContentsOfFile:path];
    return privateKeyData ? [self signatureOfPlainData:data
                                   privateKeyAtP12Data:privateKeyData
                                            passphrase:passphrase] : nil;
}

+ (nullable NSData *)signatureOfPlainData:(NSData *)plainData
                      privateKeyAtP12Data:(NSData *)p12Data
                               passphrase:(nullable NSString *)passphrase {
    SecKeyRef const privateKey = BFCreatePrivateKeyWithP12Data(p12Data, passphrase);
    if (!privateKey) {
        return nil;
    }
    @onExit {
        CFRelease(privateKey);
    };

    size_t signedHashDataLength = SecKeyGetBlockSize(privateKey);
    NSMutableData *const signedHashData = [NSMutableData dataWithLength:signedHashDataLength];
    NSMutableData *const hashedData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];

    if (!CC_SHA512(plainData.bytes, (CC_LONG)plainData.length, hashedData.mutableBytes)) {
        return nil;
    }

    SecKeyRawSign(privateKey,
                  kSecPaddingPKCS1SHA512,
                  hashedData.bytes,
                  hashedData.length,
                  signedHashData.mutableBytes,
                  &signedHashDataLength);

    signedHashData.length = signedHashDataLength;
    return [NSData dataWithData:signedHashData];
}

+ (BOOL)verifySignature:(NSData *)signature withPlainData:(NSData *)plainData publicKeyInCertFile:(NSString *)path {
    NSData *publicKeyData = [NSData dataWithContentsOfFile:path];
    return publicKeyData ? [self verifySignature:signature
                                   withPlainData:plainData
                             publicKeyInCertData:publicKeyData] : NO;
}

+ (BOOL)verifySignature:(NSData *)signature withPlainData:(NSData *)plainData publicKeyInCertData:(NSData *)certData {
    NSMutableData *hashedData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    if (!CC_SHA512(plainData.bytes, (CC_LONG)plainData.length, hashedData.mutableBytes)) {
        return NO;
    }

    SecKeyRef publicKey = BFCreatePublicKeyWithDerData(certData);
    if (!publicKey) {
        return NO;
    }
    @onExit {
        CFRelease(publicKey);
    };

    return errSecSuccess == SecKeyRawVerify(publicKey,
                                            kSecPaddingPKCS1SHA512,
                                            hashedData.bytes,
                                            hashedData.length,
                                            signature.bytes,
                                            signature.length);
}

@end

#endif
