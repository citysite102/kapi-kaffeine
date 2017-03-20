//
//  UIColor+Benzene.h
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

@interface UIColor (Benzene)

- (BOOL)isEqualToColor:(UIColor *)color;

/**
 * Creates and returns a color object using value repsented by the RGBA value
 * RGB (0-255), A (0-1)
 *
 * @param R     Red component (0-255)
 * @param G     Green component value (0-255)
 * @param B     Blue component value (0-255)
 * @param A     Alpha component value (0-1)
 * @return      A color represented by this RGBA set
 */
+ (instancetype)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B A:(CGFloat)A;

/**
 * Creates and returns a color object using value repsented by the Hex String
 * For example, @"#FF0000" gives you a red UIColor. (R=255, G=0, B=0)
 *
 * @param hexString     The Hex repesentation of this color.
 *                      Both @"#FF0000" and @"FF0000" are acceptable.
 * @return              The color object.
 *                      The color information represented by this object is in the device RGB colorspace.
 */
+ (instancetype)colorWithHexString:(NSString *)hexString;

/**
 * Creates and returns a color object using value repsented by the Hex String and specified alpha value
 * For example, @"#FF0000" gives you a red UIColor. (R=255, G=0, B=0)
 *
 * @param hexString     The Hex repesentation of this color.
 *                      Both @"#FF0000" and @"FF0000" are acceptable.
 * @param alpha         The alpha value of this color.
 * @return              The color object.
 *                      The color information represented by this object is in the device RGB colorspace.
 */
+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * Creates and returns a color object using value repsented by the Hex value
 * For example, "0xFF0000" gives you a red UIColor. (R=255, G=0, B=0)
 *
 * @param hexValue      The Hex repesentation of this color.
 * @return              The color object.
 *                      The color information represented by this object is in the device RGB colorspace.
 */
+ (instancetype)colorWithHexValue:(NSUInteger)rgbValue BF_DEPRECATED("Use colorWithRGBHexValue: instead");
+ (instancetype)colorWithRGBHexValue:(NSUInteger)rgbValue;
+ (instancetype)colorWithRGBAHexValue:(NSUInteger)rgbaValue;

/**
 * Creates and returns a color object using value repsented by the Hex value and specified alpha value
 * For example, "0xFF0000" gives you a red UIColor. (R=255, G=0, B=0)
 *
 * @param hexValue      The Hex repesentation of this color.
 * @param alpha         The alpha value of this color.
 * @return              The color object.
 *                      The color information represented by this object is in the device RGB colorspace.
 */
+ (instancetype)colorWithHexValue:(NSUInteger)rgbValue alpha:(CGFloat)alpha;

- (instancetype)saturatedColor:(CGFloat)saturate;
- (instancetype)desaturatedColor:(CGFloat)desaturate;
- (instancetype)grayscaledColor;

- (instancetype)lightenColor:(CGFloat)lighten;
- (instancetype)darkenColor:(CGFloat)darken;

- (instancetype)mixedColorWithColor:(UIColor *)anotherColor;
- (instancetype)mixedColorWithColor:(UIColor *)anotherColor weight:(CGFloat)weight;

- (instancetype)multipliedColorWithColor:(UIColor *)anotherColor;

// http://en.wikipedia.org/wiki/Luma_%28video%29
@property (nonatomic, readonly) CGFloat luminance;
- (instancetype)contrastColorInLightColor:(UIColor *)lightColor andDarkColor:(UIColor *)darkColor;
- (instancetype)contrastColorInLightColor:(UIColor *)lightColor
                             andDarkColor:(UIColor *)darkColor
                                threshold:(CGFloat)threshold;

@property(nonatomic, strong, readonly) NSString *hexValueString;

+ (instancetype)randomColor;

@end
