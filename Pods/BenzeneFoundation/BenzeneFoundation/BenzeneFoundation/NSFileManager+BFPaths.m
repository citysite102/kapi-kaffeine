//
//  NSFileManager+BFPaths.m
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

#import "NSFileManager+BFPaths.h"
#import "BFDefines_Internal.h"
#import "BFHash.h"
#import "BFFunctionUtilities.h"
#import "NSData+Benzene.h"
#import <objc/runtime.h>

static char BFDocumentFolderAssociationKey;

static char BFLibraryFolderAssociationKey;
static char BFLocalLibraryFolderAssociationKey;
static char BFFrameworkLibraryFolderAssociationKey;

static char BFApplicationSupportFolderAssociationKey;
static char BFLocalApplicationSupportFolderAssociationKey;
static char BFFrameworkApplicationSupportFolderAssociationKey;

static char BFCacheFolderAssociationKey;
static char BFLocalCacheFolderAssociationKey;
static char BFFrameworkCacheFolderAssociationKey;

static inline NSString *_Nullable _NSFileManager_BFPathGet(NSFileManager *fileManager,
                                                           NSSearchPathDirectory directoryName,
                                                           NSString *identifier,
                                                           const void *key,
                                                           NSError *__autoreleasing *error) {
    NSString *path = objc_getAssociatedObject(fileManager, key);
    if (!path) {
        path = [fileManager URLForDirectory:directoryName
                                   inDomain:NSUserDomainMask
                          appropriateForURL:nil
                                     create:YES
                                      error:error].path;
        if (path && identifier) {
            path = [path stringByAppendingPathComponent:identifier];
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:error]) {
                path = nil;
            }
        }
        if (path) {
            objc_setAssociatedObject(fileManager, key, path, OBJC_ASSOCIATION_RETAIN);
        }
    }
    return path;
}

@implementation NSFileManager (BFPaths)

- (NSString *)pathOfDocumentFolder {
    return _NSFileManager_BFPathGet(self, NSDocumentDirectory, nil, &BFDocumentFolderAssociationKey, nil);
}

- (NSString *)pathOfLibraryFolder {
    return _NSFileManager_BFPathGet(self, NSLibraryDirectory, nil, &BFLibraryFolderAssociationKey, nil);
}

- (NSString *)pathOfLocalLibraryFolder {
    return _NSFileManager_BFPathGet(self,
                                    NSLibraryDirectory,
                                    [NSBundle mainBundle].bundleIdentifier,
                                    &BFLocalLibraryFolderAssociationKey,
                                    nil);
}

- (NSString *)pathOfCacheFolder {
    return _NSFileManager_BFPathGet(self, NSCachesDirectory, nil, &BFCacheFolderAssociationKey, nil);
}

- (NSString *)pathOfLocalCacheFolder {
    return _NSFileManager_BFPathGet(self,
                                    NSCachesDirectory,
                                    [NSBundle mainBundle].bundleIdentifier,
                                    &BFLocalCacheFolderAssociationKey,
                                    nil);
}

- (NSString *)pathOfApplicationSupportFolder {
    return _NSFileManager_BFPathGet(self,
                                    NSApplicationSupportDirectory,
                                    nil,
                                    &BFApplicationSupportFolderAssociationKey,
                                    nil);
}

- (NSString *)pathOfLocalApplicationSupportFolder {
    return _NSFileManager_BFPathGet(self,
                                    NSApplicationSupportDirectory,
                                    [NSBundle mainBundle].bundleIdentifier,
                                    &BFLocalApplicationSupportFolderAssociationKey,
                                    nil);
}

- (NSString *)pathOfFrameworkLibraryFolder {
    return _NSFileManager_BFPathGet(self,
                                    NSLibraryDirectory,
                                    BFBenzeneBundleIdentifier,
                                    &BFFrameworkLibraryFolderAssociationKey,
                                    nil);
}

- (NSString *)pathOfFrameworkCacheFolder {
    return _NSFileManager_BFPathGet(self,
                                    NSCachesDirectory,
                                    BFBenzeneBundleIdentifier,
                                    &BFFrameworkCacheFolderAssociationKey,
                                    nil);
}

- (NSString *)pathOfFrameworkApplicationSupportFolder {
    return _NSFileManager_BFPathGet(self,
                                    NSApplicationSupportDirectory,
                                    BFBenzeneBundleIdentifier,
                                    &BFFrameworkApplicationSupportFolderAssociationKey,
                                    nil);
}

- (NSString *)pathOfUniqueTemporaryFolder {
    return [self pathOfUniqueTemporaryFolderWithPrefix:nil];
}

- (NSString *)pathOfUniqueTemporaryFolderWithPrefix:(NSString *)prefix {
    NSString *appTemporaryDirectoryPath = NSTemporaryDirectory();
    NSString *uniqueID = [BFHash hexdigestStringFromData:[NSData randomDataOfLength:8]];
    NSString *folderName = prefix ? BFFormatString(@"%@-%@", prefix, uniqueID) : uniqueID;
    return [appTemporaryDirectoryPath stringByAppendingPathComponent:folderName];
}

- (BOOL)executeBlockWithinTemporaryDirectory:(void(^)(NSString *temporaryDirectoryPath))block {
    return [self executeBlockWithinTemporaryDirectory:nil directoryCleaned:NULL block:block];
}

- (BOOL)executeBlockWithinTemporaryDirectory:(NSError * __autoreleasing *)error
                                       block:(void(^)(NSString *temporaryDirectoryPath))block {
    return [self executeBlockWithinTemporaryDirectory:error directoryCleaned:nil block:block];
}

- (BOOL)executeBlockWithinTemporaryDirectory:(NSError * __autoreleasing *)error
                            directoryCleaned:(out BOOL *)outDirCleaned
                                       block:(void(^)(NSString *temporaryDirectoryPath))block {
    // Generate path
    NSString *localTemporaryDirectoryPath = self.pathOfUniqueTemporaryFolder;
    // Create Directory
    if (![self createDirectoryAtPath:localTemporaryDirectoryPath
         withIntermediateDirectories:YES
                          attributes:nil
                               error:error]) {
        return NO;
    }
    // Execute block
    if (block) {
        block(localTemporaryDirectoryPath);
    }
    // Clean
    BOOL dirCleaned = [self removeItemAtPath:localTemporaryDirectoryPath error:error];
    if (outDirCleaned) {
        *outDirCleaned = dirCleaned;
    }
    return YES;
}

- (BOOL)performAtomicOperationForURL:(NSURL *)fileURL
                               error:(NSError *_Nullable __autoreleasing *_Nullable)outError
                           withBlock:(BOOL(^)(void))block {
    BOOL __block success = NO;
    NSError *__block error;
    BOOL tempDirSuccess =
    [self executeBlockWithinTemporaryDirectory:&error block:^(NSString * _Nonnull temporaryDirectoryPath) {
        NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:temporaryDirectoryPath];
        NSURL *backupURL = [temporaryDirectoryURL
                            URLByAppendingPathComponent:[BFHash hexdigestStringFromData:[NSData randomDataOfLength:8]]];
        if (!(success = [self copyItemAtURL:fileURL toURL:backupURL error:&error])) {
            return;
        }
        if (!block()) {
            success = ([self removeItemAtURL:fileURL error:&error] &&
                       [self copyItemAtURL:backupURL toURL:fileURL error:&error]);
        }
    }];

    if (outError) {
        *outError = error;
    }
    return success && tempDirSuccess;
}

@end
