//
//  UITableViewCell+BFStyle.m
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

#import "UITableViewCell+BFStyle.h"
#import <QuartzCore/QuartzCore.h>
#import "BFLog.h"

NSString * const BFTableViewCellAttributeBackgroundColor = @"BFTableViewCellAttributeBackgroundColor";
NSString * const BFTableViewCellAttributeSelectionColor = @"BFTableViewCellAttributeSelectionColor";
NSString * const BFTableViewCellAttributeRoundCorners = @"BFTableViewCellAttributeRoundCorners";
NSString * const BFTableViewCellAttributeCornerRadius = @"BFTableViewCellAttributeCornerRadius";
NSString * const BFTableViewCellAttributeBorderWidth = @"BFTableViewCellAttributeBorderWidth";
NSString * const BFTableViewCellAttributeBorderColor = @"BFTableViewCellAttributeBorderColor";

@implementation UITableViewCell (BFStyle)

- (void)formatWithAttributes:(NSDictionary *)attributes {
    CGRect bounds = self.backgroundView?self.backgroundView.bounds:self.bounds;
    // Background
    UIView *backgroundView = [[UIView alloc] initWithFrame:bounds];
    self.backgroundView = backgroundView;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    backgroundView.opaque = YES;
    
    // Selected Background
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    self.selectedBackgroundView = selectedBackgroundView;
    selectedBackgroundView.autoresizingMask = backgroundView.autoresizingMask;
    selectedBackgroundView.opaque = backgroundView.opaque;
    
    // Background Color
    UIColor *backgroundColor = attributes[BFTableViewCellAttributeBackgroundColor];
    if (!backgroundColor) backgroundColor = [UIColor whiteColor];
    backgroundView.backgroundColor = backgroundColor;
    
    // Selection Color
    UIColor *selectedBackgroundColor = attributes[BFTableViewCellAttributeSelectionColor];
    if (!selectedBackgroundColor) selectedBackgroundColor = [UIColor colorWithRed:0.0f
                                                                            green:122/255.0f
                                                                             blue:239.0f
                                                                            alpha:1.0f];
    selectedBackgroundView.backgroundColor = selectedBackgroundColor;
    
    // Round-corner
    CGFloat radius = [attributes[BFTableViewCellAttributeCornerRadius] floatValue];
    NSInteger roundCorners = [attributes[BFTableViewCellAttributeRoundCorners] integerValue];
    
    if (roundCorners==0) {
        selectedBackgroundView.layer.mask = backgroundView.layer.mask = nil;
        selectedBackgroundView.layer.cornerRadius = backgroundView.layer.cornerRadius = 0.0f;
    } else if (roundCorners==UIRectCornerAllCorners) {
        selectedBackgroundView.layer.cornerRadius = backgroundView.layer.cornerRadius = radius;
        selectedBackgroundView.layer.mask = backgroundView.layer.mask = nil;
    } else {
        CGSize radiusSet = CGSizeMake(radius, radius);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds
                                                       byRoundingCorners:roundCorners cornerRadii:radiusSet];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = backgroundView.bounds;
        maskLayer.path = maskPath.CGPath;
        
        selectedBackgroundView.layer.cornerRadius = backgroundView.layer.cornerRadius = 0.0f;
        selectedBackgroundView.layer.mask = backgroundView.layer.mask = maskLayer;
    }
    
    // Border
    UIColor *borderColor = attributes[BFTableViewCellAttributeBorderColor];
    CGFloat borderWidth = [attributes[BFTableViewCellAttributeBorderWidth] floatValue];
    if (borderColor && borderWidth!=0.0f) {
        backgroundView.layer.borderColor = selectedBackgroundView.layer.borderColor = borderColor.CGColor;
        backgroundView.layer.borderWidth = selectedBackgroundView.layer.borderWidth = borderWidth;
    }
}

@end
