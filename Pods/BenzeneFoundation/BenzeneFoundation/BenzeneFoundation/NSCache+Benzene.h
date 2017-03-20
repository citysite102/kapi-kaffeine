//
//  NSCache+Benzene.h
//  BenzeneFoundation
//
//  Created by sodas on 8/5/15.
//  Copyright © 2015 Wantoto Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BenzeneFoundation/BFDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCache BFGenerics(KeyType, ObjectType) (Benzene)

- (BFGenericType(ObjectType))objectForKey:(BFGenericType(KeyType))key block:(BFGenericType(ObjectType)(^)(void))block;
- (BFGenericType(ObjectType))objectForKey:(BFGenericType(KeyType))key
                                     cost:(NSUInteger)cost
                                    block:(BFGenericType(ObjectType)(^)(void))block;

@end

NS_ASSUME_NONNULL_END
