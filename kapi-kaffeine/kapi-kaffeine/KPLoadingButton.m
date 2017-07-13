//
//  KPLoadingButton.m
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/13.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

#import "KPLoadingButton.h"

CGRect RectMakeWithOriginSize(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

CGRect RectMakeWithSizeCenteredInRect(CGSize size, CGRect rect) {
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGPoint origin = CGPointMake(floorf(center.x - size.width / 2.0f),
                                 floorf(center.y - size.height / 2.0f));
    return RectMakeWithOriginSize(origin, size);
}

@implementation KPLoadingButton

+ (nullable instancetype)loadingButtonWithImage:(nullable UIImage *)image
                                          title:(nullable NSString *)title {
    KPLoadingButton *loadingButton = [[KPLoadingButton alloc] initWithFrame:CGRectZero
                                                                      image:image
                                                                      title:title];
    
    if ((image == nil) && title) {
        loadingButton.loadingButtonType = KPLoadingButtonTypePlainText;
    } else if (image && title == nil) {
        loadingButton.loadingButtonType = KPLoadingButtonTypePlainImage;
    } else if (image && title) {
        loadingButton.loadingButtonType = KPLoadingButtonTypeImage;
    } else {
        return nil;
    }
    
    return loadingButton;
}

- (instancetype)initWithFrame:(CGRect)frame
                        image:(nullable UIImage *)image
                        title:(nullable NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
        self.replaceText = NO;
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.activityIndicator setUserInteractionEnabled:NO];
    }
    
    return self;
}


- (void)layoutSubviews {
    
    // UIButton will only update its frame to original size but without update the transform to CATransform3DIdentity,
    // then it'll cause the button layout issue.
    self.imageView.layer.transform = CATransform3DIdentity;
    
    [super layoutSubviews];
    
    switch (self.loadingButtonType) {
        case KPLoadingButtonTypePlainText: {
            if (!self.replaceText) {
                CGFloat activityIndicatorRightInset = 12.0f;
                CGRect activityIndicatorFrame = RectMakeWithSizeCenteredInRect(self.activityIndicator.bounds.size,
                                                                               self.bounds);
                activityIndicatorFrame.origin.x = (CGRectGetMinX(self.titleLabel.frame)
                                                   - CGRectGetWidth(activityIndicatorFrame)
                                                   - activityIndicatorRightInset);
                self.activityIndicator.frame = activityIndicatorFrame;
            } else {
                self.activityIndicator.center = self.titleLabel.center;
            }
        }
            break;
        case KPLoadingButtonTypeImage: {
            self.imageView.alpha = self.isLoading ? 0.0f : 1.0f;
            self.imageView.layer.transform = CATransform3DScale(self.imageView.layer.transform, 0.7, 0.7, 1.0);
            self.imageView.layer.transform = CATransform3DTranslate(self.imageView.layer.transform, -10, 0, 0);
            self.activityIndicator.center = CGPointMake(self.imageView.frame.origin.x +
                                                        self.imageView.frame.size.width/2,
                                                        self.imageView.frame.origin.y +
                                                        self.imageView.frame.size.height/2);
        }
            break;
        case KPLoadingButtonTypePlainImage: {
            self.imageView.alpha = self.isLoading ? 0.0f : 1.0f;
            self.activityIndicator.center = CGPointMake(self.imageView.frame.origin.x +
                                                        self.imageView.frame.size.width/2,
                                                        self.imageView.frame.origin.y +
                                                        self.imageView.frame.size.height/2);
        }
    }
}

#pragma mark - Setter

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setLoading:(BOOL)loading {
    if (_loading != loading) {
        _loading = loading;
        if (loading) {
            self.titleLabel.alpha = self.replaceText ? 0.0 : 1.0;
            [self addSubview:self.activityIndicator];
            [self.activityIndicator startAnimating];
            [self setEnabled:NO];
            [self setNeedsLayout];
        } else {
            self.titleLabel.alpha = 1.0;
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            [self setEnabled:YES];
        }
        if (self.loadingButtonType == KPLoadingButtonTypeImage) {
            self.imageView.alpha = self.isLoading ? 0.0f : 1.0f;
        }
    }
}

@end
