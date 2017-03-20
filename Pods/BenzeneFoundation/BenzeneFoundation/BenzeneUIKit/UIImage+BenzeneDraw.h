//
//  UIImage+BenzeneDraw.h
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

@interface UIImage (BenzeneDraw)

/**
 * Get a image which is filled by the color
 *
 * @param color     The color you want to fill in the result image
 * @param size      The size of result image
 * @return          The result image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * Get an image with a rectangle filled with fill color and stroked with stroke color
 * The size of image and border width are also as the specified value
 *
 * @param fillColor       the fill color of this image
 * @param strokeColor     the stroke color of this image
 * @param size            the size of this imagge
 * @param borderWidth     the width of stroke
 * @return                an image of rectangle with above specified properties
 * @discuss     the value of size should include the border
 *              For example, a border width 2pt and a size with both 10pts in width and height
 *              gives you a 10*10 image which has 2pt stroke and 6*6 fill area
 */
+ (UIImage *)imageWithRectFilledWithColor:(UIColor *)fillColor
                              strokeColor:(UIColor *)strokeColor
                                     size:(CGSize)size
                              borderWidth:(CGFloat)borderWidth;
/**
 * Get an image with a rounded rectangle filled with fill color and stroked with stroke color
 * The size of image and border width are also as the specified value
 *
 * @param fillColor       the fill color of this image
 * @param strokeColor     the stroke color of this image
 * @param size            the size of this imagge
 * @param borderWidth     the width of stroke
 * @param radius          the radius of this image
 * @return                an image of rectangle with above specified properties
 * @discuss     the value of size should include the border
 *              For example, a border width 2pt and a size with both 10pts in width and height
 *              gives you a 10*10 image which has 2pt stroke and 6*6 fill area
 */
+ (UIImage *)imageWithRoundedRectFilledWithColor:(UIColor *)fillColor
                                     strokeColor:(UIColor *)strokeColor
                                            size:(CGSize)size
                                     borderWidth:(CGFloat)borderWidth
                                          radius:(CGFloat)radius;

/**
 * Get an image with a rounded rectangle with an arrow filled with fill color and stroked with stroke color
 * The size of image and border width are also as the specified value
 *
 * @param fillColor       the fill color of this image
 * @param strokeColor     the stroke color of this image
 * @param size            the size of this imagge
 * @param borderWidth     the width of stroke
 * @param radius          the radius of this image
 * @param arrowSize       the width of left arrow
 * @return                an image of rectangle with above specified properties
 * @discuss     the value of size should include the border
 *              For example, a border width 2pt and a size with both 10pts in width and height
 *              gives you a 10*10 image which has 2pt stroke and 6*6 fill area
 */
+ (UIImage *)imageWithBackButtonBackgroundFilledWithColor:(UIColor *)fillColor
                                              strokeColor:(UIColor *)strokeColor
                                                     size:(CGSize)size
                                              borderWidth:(CGFloat)borderWidth
                                                   radius:(CGFloat)radius
                                                arrowSize:(CGFloat)arrowSize;

@end
