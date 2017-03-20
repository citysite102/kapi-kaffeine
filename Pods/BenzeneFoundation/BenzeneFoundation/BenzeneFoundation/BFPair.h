//
//  BFPair.h
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

@interface BFPair BFGenerics(ObjectType1, ObjectType2) : NSObject <NSCopying, NSMutableCopying, NSCoding>

+ (instancetype)pairWithObject:(nullable BFGenericType(ObjectType1))first
                     andObject:(nullable BFGenericType(ObjectType2))second;
- (instancetype)initWithObject:(nullable BFGenericType(ObjectType1))first
                     andObject:(nullable BFGenericType(ObjectType2))second;

@property (nonatomic, strong, readonly, nullable) BFGenericType(ObjectType1) firstObject;
@property (nonatomic, strong, readonly, nullable) BFGenericType(ObjectType2) secondObject;

- (BOOL)isEqualToPair:(BFPair *)pair;

@end

@interface BFMutablePair BFGenerics(ObjectType1, ObjectType2) : BFPair BFGenerics(ObjectType1, ObjectType2)

@property (nonatomic, strong, readwrite, nullable) BFGenericType(ObjectType1) firstObject;
@property (nonatomic, strong, readwrite, nullable) BFGenericType(ObjectType2) secondObject;

@end

@interface NSDictionary BFGenerics(KeyType, ObjectType) (BFPair)

@property (nonatomic, readonly) NSArray BFGenerics(BFPair<KeyType, ObjectType> *) *arrayWithKeyAndObjectPairs;

@end

@interface NSDictionary (BFPair_General)

@property (nonatomic, readonly) NSArray BFGenerics(BFPair *) *arrayWithKeyAndObjectPairs;

@end

@interface BFPair BFGenerics(KeyType, ObjectType) (BenzeneDictionary)

@property (nonatomic, strong, readonly, nullable) BFGenericType(KeyType) key;
@property (nonatomic, strong, readonly, nullable) BFGenericType(ObjectType) object;

@property (nonatomic, strong, readonly) id value BF_DEPRECATED("Use `object`.");

@end

NS_ASSUME_NONNULL_END
