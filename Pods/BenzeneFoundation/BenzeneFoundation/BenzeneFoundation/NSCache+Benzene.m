//
//  NSCache+Benzene.m
//  BenzeneFoundation
//
//  Created by sodas on 8/5/15.
//  Copyright © 2015 Wantoto Inc. All rights reserved.
//

#import "NSCache+Benzene.h"

@implementation NSCache (Benzene)

- (id)objectForKey:(id)key block:(id(^)(void))block {
    return [self objectForKey:key cost:0 block:block];
}

- (id)objectForKey:(id)key cost:(NSUInteger)cost block:(id(^)(void))block {
    id result = [self objectForKey:key];
    if (!result) {
        @synchronized(self) {
            result = [self objectForKey:key];
            if (!result) {
                result = block();
                [self setObject:result forKey:key cost:cost];
            }
        }
    }
    return result;
}

@end
