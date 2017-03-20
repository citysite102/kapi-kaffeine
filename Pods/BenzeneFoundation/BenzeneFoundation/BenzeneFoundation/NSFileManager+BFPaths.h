//
//  NSFileManager+BFPaths.h
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

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (BFPaths)

/**
 *  A quick method to return path of user's documents folder ([App]/Documents)
 *
 *  @return path of user's documents folder
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfDocumentFolder;

/**
 *  A quick method to return path of user's library folder ([App]/Library)
 *
 *  @return path of user's library folder
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfLibraryFolder;
/**
 *  A quick method to return path of user's library folder and append app bundle identifier
 *  ([App]/Library/com.example.app)
 *
 *  @return path of user's local library folder
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfLocalLibraryFolder;

/**
 *  A quick method to return path of user's cache folder ([App]/Library/Cache)
 *
 *  @return path of user's cache folder
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfCacheFolder;
/**
 *  A quick method to return path of user's cache folder and append app bundle identifier
 *  ([App]/Library/Cache/com.example.app)
 *
 *  @return path of user's local cache folder
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfLocalCacheFolder;

/**
 *  A quick method to return path of user's application support folder
 *  ([App]/Library/Application Support/)
 *
 *  @return path of user's application support folder
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfApplicationSupportFolder;
/**
 *  A quick method to return path of user's application support folder and append app bundle identifier
 *  ([App]/Library/Application Support/com.example.app)
 *
 *  @return path of user's local application support folder
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfLocalApplicationSupportFolder;

/**
 *  A quick method to return path of user's tmp folder and append a unique name
 *  ([App]/tmp/asfsoppjjsdfn)
 *
 *  @return path of user's tmp folder with unique name
 */
@property(nonatomic, strong, nullable, readonly) NSString *pathOfUniqueTemporaryFolder;
/**
 *  A quick method to return path of user's tmp folder and append a unique name
 *  ([App]/tmp/prefix-asfsoppjjsdfn)
 *
 *  @param prefix a prefix name to prepend to the folder name
 *
 *  @return path of user's local tmp folder
 */
- (NSString *)pathOfUniqueTemporaryFolderWithPrefix:(nullable NSString *)prefix;

/**
 *  Execute block within a unique temporary directory path
 *
 *  @param block a block to execute
 *
 *  This method is inspired by Python's context "with"
 *
 *  When calling this method, it will create a tmp directory and then pass the
 *  path into your block.
 *
 *  After your block is finished, it removes the tmp directory directly.
 *
 *  @return If the tmp directory has been created successfully.
 */
- (BOOL)executeBlockWithinTemporaryDirectory:(void(^)(NSString *temporaryDirectoryPath))block;
/**
 *  Execute block within a unique temporary directory path
 *
 *  @param error An error indicating tmp directory creation or cleanness
 *  @param block a block to execute
 *
 *  This method is inspired by Python's context "with"
 *
 *  When calling this method, it will create a tmp directory and then pass the
 *  path into your block.
 *
 *  After your block is finished, it removes the tmp directory directly.
 *
 *  @return If the tmp directory has been created successfully.
 */
- (BOOL)executeBlockWithinTemporaryDirectory:(NSError *_Nullable __autoreleasing *_Nullable)error
                                       block:(void(^)(NSString *temporaryDirectoryPath))block;
/**
 *  Execute block within a unique temporary directory path
 *
 *  @param error An error indicating tmp directory creation
 *  @param outDirCleaned a flag indicating directory cleared or not
 *  @param block a block to execute
 *
 *  This method is inspired by Python's context "with"
 *
 *  When calling this method, it will create a tmp directory and then pass the
 *  path into your block.
 *
 *  After your block is finished, it removes the tmp directory directly.
 *
 *  @return If the tmp directory has been created successfully.
 */
- (BOOL)executeBlockWithinTemporaryDirectory:(NSError *_Nullable __autoreleasing *_Nullable)error
                            directoryCleaned:(out BOOL *_Nullable)outDirCleaned
                                       block:(void(^)(NSString *temporaryDirectoryPath))block;

- (BOOL)performAtomicOperationForURL:(NSURL *)fileURL
                               error:(NSError *_Nullable __autoreleasing *_Nullable)error
                           withBlock:(BOOL(^)(void))block;

NS_ASSUME_NONNULL_END

@end
