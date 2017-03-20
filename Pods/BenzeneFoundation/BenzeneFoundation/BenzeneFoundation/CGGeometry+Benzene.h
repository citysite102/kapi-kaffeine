//
//  CGGeometry+Benzene.h
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

#import <CoreGraphics/CoreGraphics.h>
#import <BenzeneFoundation/BFDefines.h>
#import <BenzeneFoundation/BFFunctionUtilities.h>

#pragma mark - Point

BF_STATIC_INLINE CGPoint CGPointMinusPoint(CGPoint point1, CGPoint point2) {
    return (CGPoint){ .x = point1.x - point2.x, .y = point1.y - point2.y };
}

BF_STATIC_INLINE CGPoint CGPointAddPoint(CGPoint point1, CGPoint point2) {
    return (CGPoint){ .x = point1.x + point2.x, .y = point1.y + point2.y };
}

BF_STATIC_INLINE CGPoint CGPointMultiplyScale(CGPoint point, CGFloat scale) {
    return (CGPoint){ .x = point.x * scale, .y = point.y * scale };
}

BF_STATIC_INLINE CGPoint CGPointChangeCoordinateSystemSwitchBetweenBottomLeftAndTopLeft(CGPoint point, CGFloat deltaY) {
    return (CGPoint){.x=point.x, .y=deltaY-point.y};
}

BF_STATIC_INLINE CGPoint CGPointChangeOrigin(CGPoint point, CGPoint originalOrigin, CGPoint newOrigin) {
    return (CGPoint){.x = point.x+originalOrigin.x-newOrigin.x,
                     .y = point.y+originalOrigin.y-newOrigin.y};
}

BF_STATIC_INLINE CGFloat CGPointDistanceBetweenPoints(CGPoint point1, CGPoint point2) {
#if defined(__LP64__) && __LP64__
    return hypot(point1.x-point2.x, point1.y-point2.y);
#else
    return hypotf(point1.x-point2.x, point1.y-point2.y);
#endif
}

BF_EXTERN const CGPoint CGPointNull;

#pragma mark - Size

BF_STATIC_INLINE CGSize CGSizeMulitplyScale(CGSize size, CGFloat scale) {
    return (CGSize){ .width = size.width * scale, .height = size.height * scale };
}

BF_STATIC_INLINE CGFloat CGSizeFitScale(CGSize containerSize, CGSize contentSize) {
    if (containerSize.width < containerSize.height) {
        // Use width to find scale
        return containerSize.width / contentSize.width;
    } else {
        // Use height to find scale
        return containerSize.height / contentSize.height;
    }
}

BF_STATIC_INLINE CGFloat CGSizeArea(CGSize size) {
    return size.width * size.height;
}

BF_STATIC_INLINE BOOL CGSizeIsEmpty(CGSize size) {
#if defined(__LP64__) && __LP64__
    return fzero(CGSizeArea(size));
#else
    return fzerof(CGSizeArea(size));
#endif
}

BF_STATIC_INLINE BOOL CGSizeIsValid(CGSize size) {
#if defined(__LP64__) && __LP64__
    return fgreatequal(size.width, 0.) && fgreatequal(size.height, 0.);
#else
    return fgreatequalf(size.width, 0.) && fgreatequalf(size.height, 0.);
#endif
}

#pragma mark - Frame

BF_STATIC_INLINE CGRect CGRectMulitplyScale(CGRect rect, CGFloat scale) {
    return (CGRect){ .origin=CGPointMultiplyScale(rect.origin, scale), .size=CGSizeMulitplyScale(rect.size, scale) };
}

BF_STATIC_INLINE CGRect CGRectChangeCoordinateSystemSwitchBetweenBottomLeftAndTopLeft(CGRect rect, CGFloat deltaY) {
    return (CGRect){.origin={.x=rect.origin.x,
                             .y=deltaY-rect.origin.y-rect.size.height},
                    .size=rect.size};
}

#pragma mark - Transforms

BF_STATIC_INLINE
CGAffineTransform CGAffineTransformConvertCocoaCoordToCocoaTouchCoord(CGAffineTransform t, CGFloat h) {
    return CGAffineTransformScale(CGAffineTransformTranslate(t, 0., h), 1., -1.);
}
