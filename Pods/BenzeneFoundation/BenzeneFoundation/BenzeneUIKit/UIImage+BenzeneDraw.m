//
//  UIImage+BenzeneDraw.m
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

#import "UIImage+BenzeneDraw.h"
#import "BFKeyedSubscription.h"
#import "BFLog.h"

@implementation UIImage (BenzeneDraw)

+ (NSCache *)bf_imageCache {
    static NSCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedCache = [[NSCache alloc] init]; });
    return sharedCache;
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size {
    // We use components of the color and the size to make cache key
    NSString *cacheKey = [NSString stringWithFormat:@"%@,w=%.4f,h=%.4f", color, size.width, size.height];
    UIImage *result = [self bf_imageCache][cacheKey];
    if (!result) {
        // Create image
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, (CGRect){.origin = CGPointZero, .size = size});

        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [self bf_imageCache][cacheKey] = result;
    }
    return result;
}

+ (instancetype)imageWithRectFilledWithColor:(UIColor *)fillColor
                                 strokeColor:(UIColor *)strokeColor
                                        size:(CGSize)size
                                 borderWidth:(CGFloat)borderWidth {
    CGRect rect = (CGRect){.origin = CGPointZero, .size = size};

    // Create the context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Set color and line width
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    // Find the rect of "fill"
    CGRect fillRect = CGRectInset(rect, borderWidth / 2, borderWidth / 2);
    CGContextFillRect(context, fillRect);
    CGContextStrokeRect(context, fillRect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (instancetype)imageWithRoundedRectFilledWithColor:(UIColor *)fillColor
                                        strokeColor:(UIColor *)strokeColor
                                               size:(CGSize)size
                                        borderWidth:(CGFloat)borderWidth
                                             radius:(CGFloat)radius {
    CGRect rect = (CGRect){.origin = CGPointZero, .size = size};

    // Create the context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Set color and line width
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    // Find the rect of "fill"
    CGRect fillRect = CGRectInset(rect, borderWidth / 2, borderWidth / 2);

    // Fix the radius if the radius is too big
    CGFloat width = CGRectGetWidth(fillRect);
    CGFloat height = CGRectGetHeight(fillRect);
    if (radius > width / 2.0)
        radius = width / 2.0;
    if (radius > height / 2.0)
        radius = height / 2.0;

    // Add arcs
    CGFloat minx = CGRectGetMinX(fillRect);
    CGFloat midx = CGRectGetMidX(fillRect);
    CGFloat maxx = CGRectGetMaxX(fillRect);
    CGFloat miny = CGRectGetMinY(fillRect);
    CGFloat midy = CGRectGetMidY(fillRect);
    CGFloat maxy = CGRectGetMaxY(fillRect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (instancetype)imageWithBackButtonBackgroundFilledWithColor:(UIColor *)fillColor
                                                 strokeColor:(UIColor *)strokeColor
                                                        size:(CGSize)size
                                                 borderWidth:(CGFloat)borderWidth
                                                      radius:(CGFloat)radius
                                                   arrowSize:(CGFloat)arrowSize {
    CGRect rect = (CGRect){.origin = CGPointZero, .size = size};

    // Create the context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Set color and line width
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    // Find the rect of "fill"
    CGRect fillRect = CGRectInset(rect, borderWidth / 2, borderWidth / 2);

    // Fix the radius if the radius is too big
    CGFloat width = CGRectGetWidth(fillRect);
    CGFloat height = CGRectGetHeight(fillRect);
    if (radius > width / 2.0)
        radius = width / 2.0;
    if (radius > height / 2.0)
        radius = height / 2.0;
    if (arrowSize > width / 2.0)
        arrowSize = width / 2.0;

    // Add arcs
    CGFloat minx = CGRectGetMinX(fillRect);
    CGFloat midx = CGRectGetMidX(fillRect);
    CGFloat maxx = CGRectGetMaxX(fillRect);
    CGFloat miny = CGRectGetMinY(fillRect);
    CGFloat midy = CGRectGetMidY(fillRect);
    CGFloat maxy = CGRectGetMaxY(fillRect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx + arrowSize, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx + arrowSize, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
