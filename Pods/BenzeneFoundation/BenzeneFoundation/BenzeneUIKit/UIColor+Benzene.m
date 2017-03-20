//
//  UIColor+Benzene.m
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

#import "UIColor+Benzene.h"
#import "BFFunctionUtilities.h"
#import <objc/runtime.h>

static char UIColorBenzeneHexValueStringAssociationKey;

@implementation UIColor (Benzene)

- (BOOL)isEqualToColor:(UIColor *)color {
    return CGColorEqualToColor(self.CGColor, color.CGColor);
}

+ (instancetype)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B A:(CGFloat)A {
    return [self colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A];
}

+ (instancetype)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0f];
}

+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    unsigned int hexValue = 0;

    BOOL hashPrefixed = [hexString hasPrefix:@"#"];
    BOOL hasAlphaChannel;
    if (hexString.length == (hashPrefixed?1:0) + 6) {
        hasAlphaChannel = NO;
    } else if (hexString.length == (hashPrefixed?1:0) + 8) {
        hasAlphaChannel = YES;
    } else {
        return nil;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if (hashPrefixed) {
        scanner.scanLocation = 1; // bypass '#' character
    }
    [scanner scanHexInt:&hexValue];

    return hasAlphaChannel ? [self colorWithRGBAHexValue:hexValue] : [self colorWithHexValue:hexValue alpha:alpha];
}

+ (instancetype)colorWithHexValue:(NSUInteger)rgbValue {
    return [self colorWithRGBHexValue:rgbValue];
}

+ (instancetype)colorWithRGBHexValue:(NSUInteger)rgbValue {
    return [self colorWithHexValue:rgbValue alpha:1.0f];
}

+ (instancetype)colorWithRGBAHexValue:(NSUInteger)rgbaValue {
    return [self colorWithHexValue:((rgbaValue & 0xffffff00) >> 8) alpha:((rgbaValue & 0x000000ff) / 255.f)];
}

+ (instancetype)colorWithHexValue:(NSUInteger)rgbValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((rgbValue & 0xff0000) >> 16)/255.0f
                           green:((rgbValue & 0x00ff00) >>  8)/255.0f
                            blue:((rgbValue & 0x0000ff) >>  0)/255.0f
                           alpha:alpha];
}

#pragma mark - Color Functions

- (instancetype)saturatedColor:(CGFloat)saturate {
    CGFloat h, s, b, a;
    return [self getHue:&h saturation:&s brightness:&b alpha:&a] ?
        [UIColor colorWithHue:h saturation:MIN(1., s + saturate) brightness:b alpha:a] : nil;
}
- (instancetype)desaturatedColor:(CGFloat)desaturate {
    CGFloat h, s, b, a;
    return [self getHue:&h saturation:&s brightness:&b alpha:&a] ?
        [UIColor colorWithHue:h saturation:MAX(0., s - desaturate) brightness:b alpha:a] : nil;
}
- (instancetype)grayscaledColor {
    CGFloat h, b, a;
    return [self getHue:&h saturation:NULL brightness:&b alpha:&a] ?
        [UIColor colorWithHue:h saturation:0. brightness:b alpha:a] : nil;
}

- (instancetype)lightenColor:(CGFloat)lighten {
    CGFloat h, s, b, a;
    return [self getHue:&h saturation:&s brightness:&b alpha:&a] ?
        [UIColor colorWithHue:h saturation:s brightness:MIN(1., b + lighten) alpha:a] : nil;
}
- (instancetype)darkenColor:(CGFloat)darken {
    CGFloat h, s, b, a;
    return [self getHue:&h saturation:&s brightness:&b alpha:&a] ?
        [UIColor colorWithHue:h saturation:s brightness:MAX(0., b - darken) alpha:a] : nil;
}

- (instancetype)mixedColorWithColor:(UIColor *)anotherColor {
    return [self mixedColorWithColor:anotherColor weight:.5];
}
- (instancetype)mixedColorWithColor:(UIColor *)anotherColor weight:(CGFloat)weight {
    CGFloat myWeight = 1 - weight;
    CGFloat anotherWeight = weight;
    
    CGFloat mR, mG, mB, mA, aR, aG, aB, aA;
    if (![self getRed:&mR green:&mG blue:&mB alpha:&mA] ||
        ![anotherColor getRed:&aR green:&aG blue:&aB alpha:&aA]) {
        return nil;
    }
    
    CGFloat r = (mR * myWeight + aR * anotherWeight);
    CGFloat g = (mG * myWeight + aG * anotherWeight);
    CGFloat b = (mB * myWeight + aB * anotherWeight);
    CGFloat a = (mA * myWeight + aA * anotherWeight);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (instancetype)multipliedColorWithColor:(UIColor *)anotherColor {
    CGFloat mR, mG, mB, mA, aR, aG, aB, aA;
    return ([self getRed:&mR green:&mG blue:&mB alpha:&mA] &&
            [anotherColor getRed:&aR green:&aG blue:&aB alpha:&aA]) ?
        [UIColor colorWithRed:mR*aR green:mG*aG blue:mB*aB alpha:mA*aA] : nil;
}

// http://en.wikipedia.org/wiki/Luma_%28video%29
- (CGFloat)luminance {
    CGFloat r, g, b;
    return [self getRed:&r green:&g blue:&b alpha:NULL] ? (0.2126*r + 0.7152*g + 0.0722*b) : -1.;
}
- (instancetype)contrastColorInLightColor:(UIColor *)lightColor andDarkColor:(UIColor *)darkColor {
    return [self contrastColorInLightColor:lightColor andDarkColor:darkColor threshold:0.43];
}
- (instancetype)contrastColorInLightColor:(UIColor *)lightColor
                             andDarkColor:(UIColor *)darkColor
                                threshold:(CGFloat)threshold {
    CGFloat luminace = self.luminance;
    if (luminace > threshold) {
        return darkColor;
    } else {
        return lightColor;
    }
}

- (NSString *)hexValueString {
    NSString *result = objc_getAssociatedObject(self, &UIColorBenzeneHexValueStringAssociationKey);
    if (!result) {
        CGFloat rf, gf, bf, af;
        if (![self getRed:&rf green:&gf blue:&bf alpha:&af]) {
            return nil;
        }

        NSInteger value = ((((long)round(rf * 255.)) << 24) |
                           (((long)round(gf * 255.)) << 16) |
                           (((long)round(bf * 255.)) << 8) |
                           (((long)round(af * 255.)) << 0));
        result = BFFormatString(@"%08lx", (long)value);
        objc_setAssociatedObject(self,
                                 &UIColorBenzeneHexValueStringAssociationKey,
                                 result,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

+ (instancetype)randomColor {
    return [UIColor colorWithRed:BFDoubleRandomBetween(0., 1.)
                           green:BFDoubleRandomBetween(0., 1.)
                            blue:BFDoubleRandomBetween(0., 1.)
                           alpha:BFDoubleRandomBetween(0., 1.)];
}

@end
