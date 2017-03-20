//
//  UIImage+BenzeneIO.h
//  BenzeneFoundation
//
//  Created by sodas on 10/28/15.
//  Copyright © 2015 Wantoto Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BenzeneIO)

- (nullable NSData *)pngData;
- (nullable NSData *)jpegDataWithQuality:(CGFloat)quality;

@end

NS_ASSUME_NONNULL_END
