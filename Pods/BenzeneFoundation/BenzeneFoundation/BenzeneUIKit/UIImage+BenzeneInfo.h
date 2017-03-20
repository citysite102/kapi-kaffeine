//
//  UIImage+BenzeneInfo.h
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

typedef void(^BF_CGImagePixelEneumerator)(const void *pixelChannels, size_t x, size_t y, bool *stop);
typedef void(^BFImagePixelEneumerator)(CGFloat r, CGFloat g, CGFloat b, CGFloat a, CGPoint point, bool *stop);

@interface UIImage (BenzeneInfo)

- (UIColor *)colorAtPoint:(CGPoint)point;
- (BOOL)getRed:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a atPoint:(CGPoint)point;

- (BOOL)isTransparentInRect:(CGRect)frame;

@property (nonatomic, assign, readonly) NSUInteger alphaComponentIndex;
@property (nonatomic, assign, readonly) NSUInteger numberOfComponents;

- (void)enumeratePixelsWithBlock:(BFImagePixelEneumerator)block;
- (void)enumeratePixels:(size_t *)bitsPerComponent withBlock:(BFImagePixelEneumerator)block;
- (void)enumeratePixels:(size_t *)bitsPerComponent inRect:(CGRect)rect withBlock:(BFImagePixelEneumerator)block;

@end

BF_EXTERN bool BF_CGImageIsTransparentInRect(CGImageRef image, CGRect frame);

BF_EXTERN NSUInteger BF_CGImageGetIndexOfAlphaComponent(CGImageRef image);
BF_EXTERN void BF_CGImageEneumeratePixelsInRect(CGImageRef image, CGRect rect, BF_CGImagePixelEneumerator block);
BF_EXTERN void BFImageDataEneumeratePixelsInRect(NSData *pixelData,
                                                 size_t imageWidth,
                                                 size_t imageHeight,
                                                 size_t bitsPerPixel,
                                                 size_t bitsPerComponent,
                                                 CGRect rect,
                                                 BF_CGImagePixelEneumerator block);
BF_EXTERN void BF_CGImageEneumeratePixels(CGImageRef image, BF_CGImagePixelEneumerator block);
