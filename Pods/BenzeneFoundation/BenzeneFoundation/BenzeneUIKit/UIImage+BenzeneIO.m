//
//  UIImage+BenzeneIO.m
//  BenzeneFoundation
//
//  Created by sodas on 10/28/15.
//  Copyright © 2015 Wantoto Inc. All rights reserved.
//

#import "UIImage+BenzeneIO.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <libextobjc/extobjc.h>

@implementation UIImage (BenzeneIO)

- (NSData *)imageDataOfType:(CFStringRef)utiType withOptions:(NSDictionary *)extraOptions {
    CGImageRef selfCGImage = self.CGImage;
    if (!selfCGImage) {
        return nil;
    }

    NSMutableData *result = [NSMutableData data];

    NSMutableDictionary *options = [@{
        (__bridge NSString *)kCGImagePropertyPixelWidth: @(self.size.width),
        (__bridge NSString *)kCGImagePropertyPixelHeight: @(self.size.height),
    } mutableCopy];
    if (extraOptions) {
        [options addEntriesFromDictionary:extraOptions];
    }

    CGImageDestinationRef dest = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)result,
                                                                  utiType,
                                                                  1,
                                                                  NULL);
    @onExit {
        CFRelease(dest);
    };

    CGImageDestinationAddImage(dest, selfCGImage, (__bridge CFDictionaryRef)options);
    return CGImageDestinationFinalize(dest) ? [NSData dataWithData:result] : nil;
}

- (NSData *)pngData {
    return [self imageDataOfType:kUTTypePNG withOptions:nil];
}

- (nullable NSData *)jpegDataWithQuality:(CGFloat)quality {
    return [self imageDataOfType:kUTTypeJPEG withOptions:@{
        (__bridge NSString *)kCGImageDestinationLossyCompressionQuality: @(quality),
    }];
}

@end
