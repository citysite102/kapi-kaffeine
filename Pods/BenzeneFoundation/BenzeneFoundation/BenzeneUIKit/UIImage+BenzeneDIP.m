//
//  UIImage+BenzeneDIP.m
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

#import "UIImage+BenzeneDIP.h"
#import "BFLog.h"
#import <libextobjc/extobjc.h>

//void BF_CGContextDrawImageAtUIKit(CGContextRef context, CGRect rect, CGImageRef image) {
//    // Change Coordinator system for CGContextDrawImage (to UIKit)
//    /*
//     * Context we have now comes from `UIGraphicsBeginImageContextWithOptions`,
//     * so its coordinate system is the same as UIKit.
//     *
//     * But `CGContextDrawImage` is still the same as CoreGraphic,
//     * we have to flip the coordinate system for it.
//     *
//     * Original:
//     *
//     *     o----+-->
//     *     |    |
//     *     |    |
//     *     +----x
//     *     |
//     *     v
//     *
//     * Flipped:
//     *
//     *     ^
//     *     |
//     *     +----+
//     *     |    |
//     *     |    |
//     *     o----x-->
//     */
//    // Save current state ... since you may want back to original context for drawing rest part
//    CGContextSaveGState(context);
//    // Method 1
//    CGContextTranslateCTM(context, .0f, CGImageGetHeight(image)); // TODO: Retina image need /2 ...
//    CGContextScaleCTM(context, 1.0f, -1.0f);
//    // Method 2
//    //CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, CGImageGetHeight(image)));
//    /*
//     * since the coordinate system has been flipped, the value should be multplied by (1, -1)
//     */
//    CGContextDrawImage(context, (CGRect){rect.origin.x, -rect.origin.y, rect.size}, image);
//    // Back to original state
//    CGContextRestoreGState(context);
//}

@implementation UIImage (BenzeneDIP)


#pragma mark - Color Image

- (UIImage *)imageColoredWithColor:(UIColor *)color blendMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGRect rect = (CGRect){.origin=CGPointZero, .size=self.size};
    // Draw the image
    [self drawInRect:rect];
    // Draw the color
    [color setFill];
    UIRectFillUsingBlendMode(rect, blendMode);
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    // Get the image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageColoredWithColor:(UIColor *)color {
    return [self imageColoredWithColor:color blendMode:kCGBlendModeCopy];
}

#pragma mark - Image resize and crop

- (UIImage *)resizedImageToFillSize:(CGSize)newSize {
    CGRect newRect = (CGRect){.origin=CGPointZero, .size=newSize};

    // Context
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = (alphaInfo==kCGImageAlphaNone ||
                   alphaInfo==kCGImageAlphaNoneSkipFirst ||
                   alphaInfo==kCGImageAlphaNoneSkipLast);
    UIGraphicsBeginImageContextWithOptions(newSize, opaque, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [self drawInRect:newRect];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage *)proportionallyResizedImageToWidth:(CGFloat)newWidth {
    CGFloat newHeight = newWidth*self.size.height/self.size.width;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return [self resizedImageToFillSize:newSize];
}

- (UIImage *)proportionallyResizedImageToHeight:(CGFloat)newHeight {
    CGFloat newWidth = newHeight*self.size.width/self.size.height;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return [self resizedImageToFillSize:newSize];
}

- (UIImage *)proportionallyResizedImageToFitSize:(CGSize)targetSize {
    CGFloat widthResizingScale = targetSize.width / self.size.width;
    CGFloat heightResizingScale = targetSize.height / self.size.height;
    CGFloat resizingScale = MIN(widthResizingScale, heightResizingScale);
    CGFloat newWidth = self.size.width*resizingScale;
    CGFloat newHeight = self.size.height*resizingScale;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return [self resizedImageToFillSize:newSize];
}

- (UIImage *)proportionallyResizedImageToFillSize:(CGSize)newSize {
    return [self proportionallyResizedImageToFillSize:newSize cropped:YES];
}

- (UIImage *)proportionallyResizedImageToFillSize:(CGSize)targetSize cropped:(BOOL)cropped {
    CGFloat widthResizingScale = targetSize.width / self.size.width;
    CGFloat heightResizingScale = targetSize.height / self.size.height;
    CGFloat resizingScale = MAX(widthResizingScale, heightResizingScale);
    CGFloat newWidth = self.size.width*resizingScale;
    CGFloat newHeight = self.size.height*resizingScale;
    CGSize newSize = CGSizeMake(newWidth, newHeight);

    if (cropped) {
        CGFloat x = (newSize.width - targetSize.width)/2;
        CGFloat y = (newSize.height - targetSize.height)/2;

        //return [[self resizedImageToFillSize:newSize] croppedImageToRect:(CGRect){x, y, targetSize}];
        // Expand for performance (Only create one CGContext)

        // Context
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
        BOOL opaque = (alphaInfo==kCGImageAlphaNone ||
                       alphaInfo==kCGImageAlphaNoneSkipFirst ||
                       alphaInfo==kCGImageAlphaNoneSkipLast);
        UIGraphicsBeginImageContextWithOptions(targetSize, opaque, self.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        [self drawInRect:(CGRect){{-x, -y}, newSize}];

        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return newImage;

    } else {
        return [self resizedImageToFillSize:newSize];
    }
}

- (UIImage *)croppedImageToRect:(CGRect)rect {
    CGRect finalRect = CGRectIntersection(rect, (CGRect){.origin=CGPointZero, .size=self.size});
    if (CGRectIsNull(finalRect)) return nil;

    // Context
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    BOOL opaque = (alphaInfo==kCGImageAlphaNone ||
                   alphaInfo==kCGImageAlphaNoneSkipFirst ||
                   alphaInfo==kCGImageAlphaNoneSkipLast);
    UIGraphicsBeginImageContextWithOptions(finalRect.size, opaque, self.scale);
    // Since the context size is a small bound box, the image has been cropped now
    [self drawAtPoint:(CGPoint){-finalRect.origin.x, -finalRect.origin.y}];

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark - Image Rotate

- (UIImage *)rotatedImageByRadians:(CGFloat)radians {
    return [self rotatedImageByAngle:radians];
}

- (UIImage *)rotatedImageByAngle:(CGFloat)angle {
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect imageRect = (CGRect){.origin=CGPointZero, .size=self.size};
    CGRect rotatedImageRect = CGRectApplyAffineTransform(imageRect, transform);
    CGSize newSize = rotatedImageRect.size;
    CGFloat newWidth = newSize.width;
    CGFloat newHeight = newSize.height;

    CGImageRef cgImage = self.CGImage;
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
    BOOL opaque = (alphaInfo==kCGImageAlphaNone ||
                   alphaInfo==kCGImageAlphaNoneSkipFirst ||
                   alphaInfo==kCGImageAlphaNoneSkipLast);
    UIGraphicsBeginImageContextWithOptions(newSize, opaque, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    // Move origin to center for rotation
    CGContextTranslateCTM(context, newWidth/2, newHeight/2);
    CGContextRotateCTM(context, -angle);
    // Draw at correct point
    [self drawAtPoint:(CGPoint){-self.size.width/2, -self.size.height/2}];

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

@end

CGImageRef BF_CGImageCreateRotatedImage(CGImageRef image, CGFloat angle) {
    return BF_CGImageCreateRotatedAndScaledImage(image, angle, 1., 1.);
}

CGImageRef BF_CGImageCreateScaledImage(CGImageRef image, CGFloat xScale, CGFloat yScale) {
    return BF_CGImageCreateRotatedAndScaledImage(image, 0., xScale, yScale);
}

CGImageRef BF_CGImageCreateRotatedAndScaledImage(CGImageRef image, CGFloat angle, CGFloat xScale, CGFloat yScale) {
    CGFloat originalWidth = CGImageGetWidth(image);
    CGFloat originalHeight = CGImageGetHeight(image);
    CGRect imageRect = (CGRect){.origin=CGPointZero, .size=CGSizeMake(originalWidth*ABS(xScale),
                                                                      originalHeight*ABS(yScale))};
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect newImageRect = CGRectApplyAffineTransform(imageRect, transform);
    CGFloat newWidth = ceil(newImageRect.size.width);
    CGFloat newHeight = ceil(newImageRect.size.height);

    size_t bitsPerComponent = CGImageGetBitsPerComponent(image);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(image);
    size_t nComponents = bitsPerPixel / bitsPerComponent;
    CGContextRef __block context = CGBitmapContextCreate(NULL,
                                                         newWidth,
                                                         newHeight,
                                                         bitsPerComponent,
                                                         nComponents * newWidth * bitsPerComponent / 8,
                                                         CGImageGetColorSpace(image),
                                                         kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    if (!context) {
        return NULL;
    }
    @onExit {
        if (context) {
            CGContextRelease(context);
        }
    };

    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, newWidth/2., newHeight/2.);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -originalWidth*xScale/2., -originalHeight*yScale/2.);
    CGContextScaleCTM(context, copysign(1., xScale), copysign(1., yScale));
    CGContextDrawImage(context, imageRect, image);
    CGContextRestoreGState(context);

    return CGBitmapContextCreateImage(context);
}
