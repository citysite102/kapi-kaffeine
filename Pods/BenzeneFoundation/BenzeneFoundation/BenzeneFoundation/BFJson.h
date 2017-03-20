//
//  BFJson.h
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

BF_STATIC_INLINE NSData *__nullable BFJsonData(id __nonnull object,
                                               NSJSONWritingOptions options,
                                               NSError *__nullable __autoreleasing * __nullable error) {
    return object ? [NSJSONSerialization dataWithJSONObject:object options:options error:error] : nil;
}
BF_STATIC_INLINE NSString *__nullable BFJsonString(id __nonnull object,
                                                   NSJSONWritingOptions options,
                                                   NSError *__nullable __autoreleasing * __nullable error) {
    NSData *jsonData = BFJsonData(object, options, error);
    return jsonData ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : nil;
}
BF_STATIC_INLINE id __nullable BFObjectFromJsonData(NSData * __nonnull jsonData,
                                                    NSJSONReadingOptions options,
                                                    NSError *__nullable __autoreleasing *__nullable error) {
    return jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:options error:error] : nil;
}
BF_STATIC_INLINE id __nullable BFObjectFromJsonString(NSString *__nonnull jsonString,
                                                      NSJSONReadingOptions options,
                                                      NSError *__nullable __autoreleasing *__nullable error) {
    NSData *jsonStringData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return jsonStringData ? BFObjectFromJsonData(jsonStringData, options, error) : nil;
}

/// This category provides functionality for NSString to objects using JSON.
@interface NSString (BFJson)

/**
 * Return the object encoded with JSON as the content of the receiver.
 *
 * @return     An object parsed as JSON string from the content of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) id jsonObject;
@property(nonatomic, strong, readonly, nullable) id objectWithJSONValue;

@end

/// This category provides functionality for NSData to objects using JSON.
@interface NSData (BFJson)

/**
 * Return the object encoded with JSON as the content of the receiver.
 *
 * @return     An object parsed as JSON data from the content of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) id jsonObject;
@property(nonatomic, strong, readonly, nullable) id objectWithJSONValue;

@end

/// This category provides functionality for NSArray to convert to/from JSON.
@interface NSArray (BFJson)

/**
 * Creates and returns an array using the keys and values found in the specified JSON string.
 *
 * @param jsonString     A JSON string that represents an array object.
 *
 * @return               A new array that contains the content represented by the JSON string.
 *                       `nil` if it is not a valid JSON string or it doesn't represent an array.
 */
+ (nullable instancetype)arrayWithContentsOfJsonString:(NSString * __nonnull)jsonString;

/**
 * Creates and returns an array using the keys and values found in the specified JSON data.
 *
 * @param jsonData     A JSON data that represents an array object.
 *
 * @return             A new array that contains the content represented by the JSON data.
 *                     `nil` if it is not a valid JSON data or it doesn't represent an array.
 */
+ (nullable instancetype)arrayWithContentsOfJsonData:(NSData * __nonnull)jsonData;

+ (nullable instancetype)arrayWithContentsOfJsonFile:(NSString * __nonnull)path;
+ (nullable instancetype)arrayWithContentsOfJsonURL:(NSURL * __nonnull)url;

- (BOOL)writeToJsonFile:(NSString * __nonnull)path atomically:(BOOL)atomically
                  error:(NSError * __nullable __autoreleasing * __nullable)error;
- (BOOL)writeToJsonFile:(NSString * __nonnull)path;
- (BOOL)writeToJsonURL:(NSURL * __nonnull)url
            atomically:(BOOL)atomically
                 error:(NSError *__nullable __autoreleasing * __nullable)error;
- (BOOL)writeToJsonURL:(NSURL * __nonnull)url;

/**
 * Returns a string that represents the receiver in JSON format.
 *
 * @return     string with JSON representation of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) NSString *jsonString;
@property(nonatomic, strong, readonly, nullable) NSString *stringWithJSONObject;

/**
 * Returns a data that represents the receiver in JSON format.
 *
 * @return     data with JSON representation of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) NSData *jsonData;
@property(nonatomic, strong, readonly, nullable) NSData *dataWithJSONObject;

@end

/// This category provides functionality for NSDictionary to convert to/from JSON.
@interface NSDictionary (BFJson)

/**
 * Creates and returns a dictionary using the keys and values found in the specified JSON string.
 *
 * @param jsonString     A JSON string that represents a dict object.
 *
 * @return               A new dictionary that contains the content represented by the JSON string.
 *                       `nil` if it is not a valid JSON string or it doesn't represent a dictionary.
 */
+ (nullable instancetype)dictionaryWithContentsOfJsonString:(NSString * __nonnull)jsonString;

/**
 * Creates and returns a dictionary using the keys and values found in the specified JSON data.
 *
 * @param jsonData     A JSON data that represents a dict object.
 *
 * @return             A new dictionary that contains the content represented by the JSON data.
 *                     `nil` if it is not a valid JSON data or it doesn't represent a dictionary.
 */
+ (nullable instancetype)dictionaryWithContentsOfJsonData:(NSData * __nonnull)jsonData;

+ (nullable instancetype)dictionaryWithContentsOfJsonFile:(NSString * __nonnull)path;
+ (nullable instancetype)dictionaryWithContentsOfJsonURL:(NSURL * __nonnull)url;

- (BOOL)writeToJsonFile:(NSString * __nonnull)path
             atomically:(BOOL)atomically
                  error:(NSError * __nullable __autoreleasing * __nullable)error;
- (BOOL)writeToJsonFile:(NSString * __nonnull)path;
- (BOOL)writeToJsonURL:(NSURL * __nonnull)url
            atomically:(BOOL)atomically
                 error:(NSError * __nullable __autoreleasing * __nullable)error;
- (BOOL)writeToJsonURL:(NSURL * __nonnull)url;

/**
 * Returns a string that represents the receiver in JSON format.
 *
 * @return     string with JSON representation of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) NSString *jsonString;
@property(nonatomic, strong, readonly, nullable) NSString *stringWithJSONObject;

/**
 * Returns a data that represents the receiver in JSON format.
 *
 * @return     data with JSON representation of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) NSData *jsonData;
@property(nonatomic, strong, readonly, nullable) NSData *dataWithJSONObject;

@end

/// This category provides functionality for NSSet to convert to/from JSON.
@interface NSSet (BFJson)

+ (nullable instancetype)setWithContentsOfJsonString:(NSString * __nonnull)jsonString;
+ (nullable instancetype)setWithContentsOfJsonData:(NSData * __nonnull)jsonData;

/**
 * Returns a string that represents the receiver in JSON format.
 *
 * @return     string with JSON representation of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) NSString *jsonString;
@property(nonatomic, strong, readonly, nullable) NSString *stringWithJSONObject;

/**
 * Returns a data that represents the receiver in JSON format.
 *
 * @return     data with JSON representation of this receiver.
 */
@property(nonatomic, strong, readonly, nullable) NSData *jsonData;
@property(nonatomic, strong, readonly, nullable) NSData *dataWithJSONObject;

@end
