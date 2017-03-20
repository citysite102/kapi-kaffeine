//
//  NSURL+Benzene.m
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

#import "NSURL+Benzene.h"
#import "BFFunctionUtilities.h"
#import "NSArray+Benzene.h"

@implementation NSURL (Benzene)

- (NSString *)pathWithTrailingSlash {
    NSString *fullPath = (__bridge_transfer NSString *)CFURLCopyPath((__bridge CFURLRef)self);
    return [fullPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSURL (BenzenePath)

- (BOOL)isSubpathOfURL:(NSURL *)parentURL {
    @autoreleasepool {
        if (self.fileURL && parentURL.fileURL) {
            return [self.path isSubpathOfPath:parentURL.path];
        } else {
            NSString *scheme = self.scheme.lowercaseString;
            NSString *parentScheme = parentURL.scheme.lowercaseString;
            NSString *host = self.host.lowercaseString;
            NSString *parentHost = parentURL.host.lowercaseString;
            NSNumber *port = self.port;
            NSNumber *parentPort = parentURL.port;

            NSString *path = self.standardizedURL.pathWithTrailingSlash;
            path = path.length ? path : @"/";
            NSString *parentPath = parentURL.standardizedURL.pathWithTrailingSlash;
            parentPath = parentPath.length ? parentPath : @"/";

            return ((scheme==parentScheme || (scheme && parentScheme && [scheme isEqualToString:parentScheme])) &&
                    (host==parentHost || (host && parentHost && [host isEqualToString:parentHost])) &&
                    (port==parentPort || (port && parentPort && [port isEqualToNumber:parentPort])) &&
                    [path isSubpathOfPath:parentPath]);
        }
    }
}

- (NSURL *)URLByRelativeURLToDirectory:(NSURL *)dirURL {
    @autoreleasepool {
        if (self.fileURL && dirURL.fileURL) {
            NSString *selfPath = self.path;
            NSString *dirURLPath = dirURL.path;
            if (selfPath && dirURLPath) {
                return [NSURL fileURLWithPath:[selfPath stringByRelativePathToDirectory:dirURLPath]];
            } else {
                return self;
            }
        } else {
            NSString *scheme = self.scheme.lowercaseString;
            NSString *parentScheme = dirURL.scheme.lowercaseString;
            NSString *host = self.host.lowercaseString;
            NSString *parentHost = dirURL.host.lowercaseString;
            NSNumber *port = self.port;
            NSNumber *parentPort = dirURL.port;
            if ((scheme==parentScheme || (scheme && parentScheme && [scheme isEqualToString:parentScheme])) &&
                (host==parentHost || (host && parentHost && [host isEqualToString:parentHost])) &&
                (port==parentPort || (port && parentPort && [port isEqualToNumber:parentPort]))) {
                // Process path
                NSString *path = self.standardizedURL.pathWithTrailingSlash;
                path = path.length ? path : @"/";

                NSString *dirPath = dirURL.standardizedURL.pathWithTrailingSlash;
                if (![dirURL.absoluteString hasSuffix:@"/"]) {
                    dirPath = dirURL.URLByDeletingLastPathComponent.standardizedURL.pathWithTrailingSlash;
                }
                dirPath = dirPath.length ? dirPath : @"/";
                NSString *relativePath = [path stringByRelativePathToDirectory:dirPath];

                if ([path hasSuffix:@"/"] && ![relativePath hasSuffix:@"/"]) {
                    relativePath = BFFormatString(@"%@/", relativePath);
                }

                return [NSURL URLWithString:relativePath relativeToURL:dirURL];
            } else {
                // Cannot be represented by relative URL
                return [self copy];
            }
        }
    }
}

@end

@implementation NSString (BenzenePath)

- (BOOL)isSubpathOfPath:(NSString *)fullPath {
    @autoreleasepool {
        NSArray *fullPathComponents = fullPath.stringByStandardizingPath.pathComponents;
        NSArray *pathComponents = self.stringByStandardizingPath.pathComponents;
        return (fullPathComponents.count < pathComponents.count &&
                [fullPathComponents
                 indexOfLastSameObjectFromHeadWithArray:pathComponents]+1 == fullPathComponents.count);
    }
}

- (void)enumeratePathComponentsUsingBlock:(void (^)(NSString *component, NSUInteger idx, BOOL *stop))block {
    [self.stringByStandardizingPath.pathComponents
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         BFExecuteBlock(block, obj, idx, stop);
     }];
}

- (NSString *)stringByRelativePathToDirectory:(NSString *)dirPath {
    @autoreleasepool {
        NSString *path = self.stringByStandardizingPath;
        dirPath = dirPath.stringByStandardizingPath;

        // Remove the same components from head and then traverse the tree
        /*
         *         /-X-X:  self= /Users/sodas/Desktop/a.png   --> the rest part (X, X)
         *   O-O-O+
         *         \-@-@-@:  dirPath= /Users/sodas/Pictures/GX7/2014  --> number of ".." (@, @, @)
         *
         *   ---->  ../../../Desktop/a.png
         */

        NSArray *pathComponents = path.pathComponents;
        NSArray *dirPathComponents = dirPath.pathComponents;
        NSInteger lastSameComponentIndex = [pathComponents indexOfLastSameObjectFromHeadWithArray:dirPathComponents];
        NSInteger sameComponentCount = lastSameComponentIndex + 1;

        NSInteger resultsComponentsCount = pathComponents.count+dirPathComponents.count - 2*sameComponentCount;
        if (resultsComponentsCount) {
            NSMutableArray *resultComponents = [NSMutableArray arrayWithCapacity:resultsComponentsCount];
            NSInteger dirPathComponentsCount = dirPathComponents.count - sameComponentCount;
            for (NSInteger i=0; i<dirPathComponentsCount; ++i) {
                [resultComponents addObject:@".."];
            }
            [resultComponents addObjectsFromArray:[pathComponents subarrayFromIndex:sameComponentCount]];

            return [resultComponents componentsJoinedByString:@"/"];
        } else {
            return @".";
        }
    }
}

@end
