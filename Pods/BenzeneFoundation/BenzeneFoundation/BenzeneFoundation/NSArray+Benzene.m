//
//  NSArray+Benzene.m
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

#import "NSArray+Benzene.h"
#import "BFFunctionUtilities.h"

@implementation NSArray (Benzene)

- (instancetype)arrayByReversingArray {
    return [self reverseObjectEnumerator].allObjects;
}

- (instancetype)subarrayFromIndex:(NSUInteger)from {
    return from>=self.count ? [[self class] array] : [self subarrayWithRange:NSMakeRange(from, self.count - from)];
}

- (instancetype)subarrayToIndex:(NSUInteger)to {
    return to==0 ? [[self class] array] : [self subarrayWithRange:NSMakeRange(0, MIN(to, self.count))];
}

- (instancetype)filteredArrayByKeypath:(NSString *)keyPath {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
        return [obj valueForKeyPath:keyPath] != nil;
    }]];
}

- (instancetype)filteredArrayByBooleanKeypath:(NSString *)keyPath {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
        return [[obj valueForKeyPath:keyPath] boolValue];
    }]];
}

- (instancetype)filteredArrayByKeypath:(NSString *)keyPath withValue:(id)value {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
        return [[obj valueForKeyPath:keyPath] isEqual:value];
    }]];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    id result = self;
    for (NSUInteger indexPathPosition = 0; indexPathPosition < indexPath.length; ++indexPathPosition) {
        if ([result respondsToSelector:@selector(objectAtIndex:)]) {
            result = result[[indexPath indexAtPosition:indexPathPosition]];
        } else {
            return nil;
        }
    }
    return result;
}

+ (void)enumerateObjectsInArrays:(NSArray *)arrayList usingBlock:(void (^)(id, NSUInteger, BOOL *))block {
    [arrayList enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL *stop) {
        [array enumerateObjectsUsingBlock:block];
    }];
}

- (NSInteger)indexOfLastSameObjectFromHeadWithArray:(NSArray *)array {
    NSUInteger lastSameObjectIndexFromHead = 0;
    while (lastSameObjectIndexFromHead < MIN([self count], [array count])) {
        if ([self[lastSameObjectIndexFromHead] isEqual:array[lastSameObjectIndexFromHead]]) {
            lastSameObjectIndexFromHead++;
        } else {
            break;
        }
    }
    return lastSameObjectIndexFromHead - (NSInteger)1;
}

- (void)enumerateArrayBySlicingIntoBucketSize:(NSUInteger)bucketSize
                                    withBlock:(void(^)(NSArray *subArray, NSUInteger bucketIndex, BOOL *stop))block {
    for (NSUInteger selfObjectIndex=0; selfObjectIndex<self.count; selfObjectIndex+=bucketSize) {
        NSRange subArrayRange = NSMakeRange(selfObjectIndex,
                                            MIN(selfObjectIndex+bucketSize, self.count) - selfObjectIndex);
        BOOL stop = NO;
        BFExecuteBlock(block, [self subarrayWithRange:subArrayRange], selfObjectIndex/bucketSize, &stop);
        if (stop) {
            break;
        }
    }
}

@end

@implementation NSMutableArray (Benzene)

- (instancetype)arrayByReversingArray {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self];
    [mutableArray reverseArray];
    return mutableArray;
}

- (void)reverseArray {
    NSInteger headIndex = 0;
    NSInteger tailIndex = self.count - 1;
    while (headIndex < tailIndex) {
        [self exchangeObjectAtIndex:headIndex++ withObjectAtIndex:tailIndex--];
    }
}
    
@end
