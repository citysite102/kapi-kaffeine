//
//  UIImage+BenzeneDIP.h
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

#import <UIKit/UIKit.h>
#import <BenzeneFoundation/BFDefines.h>

@interface UIImage (BenzeneDIP)

/**
 * Color the receiver with specified image
 *
 * @param color     Color that should be colored to receiver
 * @return          a copy of receiver that colored with specified color
 */
- (UIImage *)imageColoredWithColor:(UIColor *)color;

/**
 * Color the receiver with specified image using specified blend mode
 *
 * @param color         Color that should be colored to receiver
 * @param blendMode     Blend mode to use
 * @return              a copy of receiver that colored with specified color
 */
- (UIImage *)imageColoredWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode;

- (UIImage *)resizedImageToFillSize:(CGSize)newSize;

- (UIImage *)proportionallyResizedImageToFillSize:(CGSize)newSize;
- (UIImage *)proportionallyResizedImageToFillSize:(CGSize)newSize cropped:(BOOL)cropped;
- (UIImage *)proportionallyResizedImageToFitSize:(CGSize)targetSize;

- (UIImage *)proportionallyResizedImageToWidth:(CGFloat)width;
- (UIImage *)proportionallyResizedImageToHeight:(CGFloat)height;

- (UIImage *)croppedImageToRect:(CGRect)rect;

- (UIImage *)rotatedImageByRadians:(CGFloat)radians BF_DEPRECATED("Use rotatedImageByAngle: instead");
- (UIImage *)rotatedImageByAngle:(CGFloat)angle;

@end

BF_EXTERN CGImageRef BF_CGImageCreateRotatedImage(CGImageRef image, CGFloat angle);
BF_EXTERN CGImageRef BF_CGImageCreateScaledImage(CGImageRef image, CGFloat xScale, CGFloat yScale);
BF_EXTERN CGImageRef BF_CGImageCreateRotatedAndScaledImage(CGImageRef image,
                                                           CGFloat angle,
                                                           CGFloat xScale,
                                                           CGFloat yScale);
