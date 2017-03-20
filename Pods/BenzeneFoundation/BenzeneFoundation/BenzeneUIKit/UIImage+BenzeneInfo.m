//
//  UIImage+BenzeneInfo.m
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

#import "UIImage+BenzeneInfo.h"
#import "CGGeometry+Benzene.h"
#import "BFFunctionUtilities.h"
#import <libextobjc/extobjc.h>

bool BF_CGImageIsTransparentInRect(CGImageRef image, CGRect frame) {
    // Check alpha info -> Find location of alpha channel
    NSUInteger aIndex = BF_CGImageGetIndexOfAlphaComponent(image);
    if (aIndex == NSNotFound) {
        return false;
    }

    // zero buffer
    NSUInteger bitsPerComponent = CGImageGetBitsPerComponent(image);
    NSUInteger bytesPerComponent = bitsPerComponent / 8;
    NSUInteger bitsPerPixel = CGImageGetBitsPerPixel(image);
    NSUInteger nComponents = bitsPerPixel / bitsPerComponent;
    if (nComponents <= aIndex) {
        return false;
    }

    NSData *zeroBuffer = [NSMutableData dataWithLength:bytesPerComponent];
    const void *zeroBufferBytes = zeroBuffer.bytes;

    bool __block isTransparent = true;
    BF_CGImageEneumeratePixelsInRect(image, frame, ^(const void *pixelChannels, size_t x, size_t y, bool *stop) {
        if ((isTransparent = !(*stop = (memcmp(zeroBufferBytes, pixelChannels + aIndex * bytesPerComponent,
                                               bytesPerComponent) != 0)))) {
        }
    });
    return isTransparent;
}

NSUInteger BF_CGImageGetIndexOfAlphaComponent(CGImageRef image) {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(image);
    switch (alphaInfo) {
    case kCGImageAlphaFirst:
    case kCGImageAlphaPremultipliedFirst:
        return 0;
        break;
    case kCGImageAlphaPremultipliedLast:
    case kCGImageAlphaLast:
        return 3;
        break;
    default:
        // No alpha channel
        return NSNotFound;
    }
}

void BF_CGImageEneumeratePixels(CGImageRef image, BF_CGImagePixelEneumerator block) {
    if (!image) {
        return;
    }
    BF_CGImageEneumeratePixelsInRect(image, CGRectNull, block);
}

void BF_CGImageEneumeratePixelsInRect(CGImageRef image, CGRect rect, BF_CGImagePixelEneumerator block) {
    if (!image) {
        return;
    }
    CGDataProviderRef dataProvider = CGImageGetDataProvider(image);
    NSData *pixelData = (__bridge_transfer NSData *)CGDataProviderCopyData(dataProvider);
    size_t imageWidth = CGImageGetWidth(image);
    size_t imageHeight = CGImageGetHeight(image);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(image);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(image);
    BFImageDataEneumeratePixelsInRect(pixelData, imageWidth, imageHeight, bitsPerPixel, bitsPerComponent, rect, block);
}

void BFImageDataEneumeratePixelsInRect(NSData *pixelData, size_t imageWidth, size_t imageHeight, size_t bitsPerPixel,
                                       size_t bitsPerComponent, CGRect rect, BF_CGImagePixelEneumerator block) {
    if (!pixelData) {
        return;
    }
    const void *pixelDataBytes = pixelData.bytes;
    // Get image info
    if (CGRectIsNull(rect)) {
        rect = (CGRect){.origin = CGPointZero, .size = CGSizeMake(imageWidth, imageHeight)};
    }
    size_t nComponents = bitsPerPixel / bitsPerComponent;
    size_t bytesPerComponent = bitsPerComponent / 8;
    // Go
    bool shouldStop = NO;
    size_t wIndexBound = MIN(rect.origin.x + rect.size.width, imageWidth);
    size_t hIndexBound = MIN(rect.origin.y + rect.size.height, imageHeight);
    NSMutableData *buffer = [NSMutableData dataWithLength:bitsPerPixel / 8];
    for (size_t hIndex = rect.origin.y; hIndex < hIndexBound; ++hIndex) {
        for (size_t wIndex = rect.origin.x; wIndex < wIndexBound; ++wIndex) {
            NSUInteger pixelIndex = wIndex + hIndex * imageWidth;
            const void *currentPixelData = (pixelDataBytes + pixelIndex * nComponents * bytesPerComponent);
            // Fill buffer
            void *bufferMutableBytes = buffer.mutableBytes;
            for (size_t componentIndex = 0; componentIndex < nComponents; ++componentIndex) {
                memcpy(bufferMutableBytes + componentIndex * bytesPerComponent,
                       currentPixelData + componentIndex * bytesPerComponent, bytesPerComponent);
            }
            // Go
            block(buffer.bytes, wIndex, hIndex, &shouldStop);
            // Check stop
            if (shouldStop) {
                break;
            }
        }
        if (shouldStop) {
            break;
        }
    }
}

@implementation UIImage (BenzeneInfo)

- (NSUInteger)alphaComponentIndex {
    return BF_CGImageGetIndexOfAlphaComponent(self.CGImage);
}

- (NSUInteger)numberOfComponents {
    return CGImageGetBitsPerPixel(self.CGImage) / CGImageGetBitsPerComponent(self.CGImage);
}

- (UIColor *)colorAtPoint:(CGPoint)point {
    CGFloat r = 0., g = 0., b = 0., a = 0.;
    return [self getRed:&r green:&g blue:&b alpha:&a atPoint:point] ? [UIColor colorWithRed:r green:g blue:b alpha:a]
                                                                    : nil;
}

- (void)enumeratePixelsWithBlock:(BFImagePixelEneumerator)block {
    [self enumeratePixels:NULL withBlock:block];
}

- (void)enumeratePixels:(size_t *)bitsPerComponent withBlock:(BFImagePixelEneumerator)block {
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = CGSizeMake(self.size.width, self.size.height)};
    [self enumeratePixels:bitsPerComponent inRect:imageRect withBlock:block];
}

- (void)enumeratePixels:(size_t *)outBitsPerComponent inRect:(CGRect)rect withBlock:(BFImagePixelEneumerator)block {
    CGImageRef image = self.CGImage;
    size_t bitsPerComponent = CGImageGetBitsPerComponent(image);
    if (outBitsPerComponent) {
        *outBitsPerComponent = bitsPerComponent;
    }

    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = CGSizeMake(self.size.width, self.size.height)};
    CGRect targetRectIntersection = CGRectIntersection(imageRect, rect);
    if (CGRectIsEmpty(targetRectIntersection) || CGRectIsNull(targetRectIntersection)) {
        return;
    }

    CGFloat bound = 0.;
    if (bitsPerComponent == 8) {
        bound = 255.;
    } else if (bitsPerComponent == 16) {
        bound = 65535.;
    } else {
        return;
    }

    NSUInteger alphaComponentIndex = BF_CGImageGetIndexOfAlphaComponent(image);
    NSUInteger redComponentIndex = 0, greenComponentIndex = 1, blueComponentIndex = 2;
    if (alphaComponentIndex == 0) {
        redComponentIndex += 1;
        greenComponentIndex += 1;
        blueComponentIndex += 1;
    }

    BF_CGImageEneumeratePixelsInRect(image, CGRectIntegral(CGRectMulitplyScale(rect, self.scale)),
                                     ^(const void *_pc, size_t x, size_t y, bool *stop) {
        CGPoint point = CGPointMake(x, y);
        CGFloat r = 0., g = 0., b = 0., a = 1.0;
        if (alphaComponentIndex == NSNotFound) {
            a = 1.0;
        }
        // TODO: Handle more image types
        if (bitsPerComponent == 8) {
            const uint8_t *pixelComponents = _pc;
            r = pixelComponents[redComponentIndex] / bound;
            g = pixelComponents[greenComponentIndex] / bound;
            b = pixelComponents[blueComponentIndex] / bound;
            a = alphaComponentIndex != NSNotFound ? (pixelComponents[alphaComponentIndex] / bound) : 1.;
        } else if (bitsPerComponent == 16) {
            const uint16_t *pixelComponents = _pc;
            r = pixelComponents[redComponentIndex] / bound;
            g = pixelComponents[greenComponentIndex] / bound;
            b = pixelComponents[blueComponentIndex] / bound;
            a = alphaComponentIndex != NSNotFound ? (pixelComponents[alphaComponentIndex] / bound) : 1.;
        }
        BFExecuteBlock(block, r, g, b, a, point, stop);
    });
}

- (BOOL)getRed:(CGFloat *)oR green:(CGFloat *)oG blue:(CGFloat *)oB alpha:(CGFloat *)oA atPoint:(CGPoint)point {
    BOOL __block success = NO;
    [self enumeratePixels:NULL
                   inRect:CGRectIntegral((CGRect){.origin = point, .size = CGSizeMake(1., 1.)})
                withBlock:^(CGFloat r, CGFloat g, CGFloat b, CGFloat a, CGPoint point, bool *stop) {
                    success = *stop = YES;
                    if (oR) {
                        *oR = r;
                    }
                    if (oG) {
                        *oG = g;
                    }
                    if (oB) {
                        *oB = b;
                    }
                    if (oA) {
                        *oA = a;
                    }
                }];
    return success;
}

- (BOOL)isTransparentInRect:(CGRect)frame {
    @autoreleasepool {
        CGRect contextFrame = CGRectIntegral(CGRectMulitplyScale(frame, self.scale));
        return BF_CGImageIsTransparentInRect(self.CGImage, contextFrame);
    }
}

@end
