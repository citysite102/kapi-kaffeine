//
//  BFPair.m
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

#import "BFPair.h"
#import "BFFunctionUtilities.h"
#import <libextobjc/extobjc.h>

@interface BFPair BFGenerics(ObjectType1, ObjectType2) () {
    @package
    BFGenericType(ObjectType1) _Nullable _firstObject;
    BFGenericType(ObjectType2) _Nullable _secondObject;
}

@end

@implementation BFPair

@synthesize firstObject = _firstObject, secondObject = _secondObject;

+ (instancetype)pairWithObject:(id)first andObject:(id)second {
    return [[self alloc] initWithObject:first andObject:second];
}

- (instancetype)initWithObject:(id)first andObject:(id)second {
    if (self = [super init]) {
        _firstObject = first;
        _secondObject = second;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return ((self == object) ||
            ([object isKindOfClass:[BFPair class]] && [self isEqualToPair:object]));
}

- (BOOL)isEqualToPair:(BFPair *)pair {
    return [self.firstObject isEqual:pair.firstObject] && [self.secondObject isEqual:pair.secondObject];
}

- (NSUInteger)hash {
    return (NSUInteger)([self.firstObject hash] ^ [self.secondObject hash]);
}

- (NSString *)description {
    return BFFormatString(@"(<%@, %@>)", self.firstObject, self.secondObject);
}

#pragma mark - NSCopying & NSCoding

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[BFMutablePair allocWithZone:zone] initWithObject:self.firstObject andObject:self.secondObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    id first = [aDecoder decodeObjectForKey:@keypath(self.firstObject)];
    id second = [aDecoder decodeObjectForKey:@keypath(self.secondObject)];
    return [self initWithObject:first andObject:second];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.firstObject forKey:@keypath(self.firstObject)];
    [aCoder encodeObject:self.secondObject forKey:@keypath(self.secondObject)];
}

@end

#pragma mark - Dictionary

@implementation NSDictionary (BFPair)

- (NSArray *)arrayWithKeyAndObjectPairs {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [result addObject:[BFPair pairWithObject:key andObject:obj]];
    }];
    return [NSArray arrayWithArray:result];
}

@end

@implementation BFPair (BenzeneDictionary)

- (id)key { return (id _Nonnull)self.firstObject; }
- (id)object { return (id _Nonnull)self.secondObject; }

- (id)value { return (id _Nonnull)self.secondObject; }

@end

@implementation BFMutablePair

@dynamic firstObject, secondObject;

- (id)copyWithZone:(NSZone *)zone {
    return [[BFPair allocWithZone:zone] initWithObject:self.firstObject andObject:self.secondObject];
}

- (void)setFirstObject:(id)firstObject {
    _firstObject = firstObject;
}

- (void)setSecondObject:(id)secondObject {
    _secondObject = secondObject;
}

@end
