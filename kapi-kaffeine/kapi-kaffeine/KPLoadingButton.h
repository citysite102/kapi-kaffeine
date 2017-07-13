//
//  KPLoadingButton.h
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/13.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(uint8_t, KPLoadingButtonType) {
    KPLoadingButtonTypePlainText,
    KPLoadingButtonTypeImage,
    KPLoadingButtonTypePlainImage,
    
};

@interface KPLoadingButton : UIButton

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, assign) BOOL replaceText;
@property (nonatomic, assign) KPLoadingButtonType loadingButtonType;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

+ (nullable instancetype)loadingButtonWithImage:(nullable UIImage *)image
                                          title:(nullable NSString *)title;
- (instancetype)initWithFrame:(CGRect)frame
                        image:(nullable UIImage *)image
                        title:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
