//
//  BFPullToRefreshControl.m
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

#import <QuartzCore/QuartzCore.h>
#import "BFPullToRefreshControl.h"
#import "NSBundle+BenzeneUIKit.h"
#import "UIImage+BenzeneDIP.h"
#import "UILabel+Benzene.h"
#import "BFDefines_Internal.h"
#import "BFLog.h"
#import <libextobjc/extobjc.h>

static void *BFPullToRefreshControlKVOContext = &BFPullToRefreshControlKVOContext;

#define ImageViewSize CGSizeMake(30.0f, 44.0f)

@interface BFPullToRefreshControl () {
    CALayer *borderLayer;
    
    CGFloat _bottomBorderWidth;
    UIColor *_bottomBorderColor;
    UIColor *_arrowTintColor;
    UIImage *_arrowImage;
    NSDictionary *_titleTextAttributes;
    NSDictionary *_detailTextAttributes;

    UIEdgeInsets originalContentInset;
}

@property (nonatomic, readwrite) BFPullToRefreshControlPullDirection pullDirection;
@property (nonatomic, readwrite) BFPullToRefreshControlState refresherState;
@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIView *labelContainer;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *detailTextLabel;
@property (nonatomic, weak, readwrite) UIScrollView *scrollableView;
@property (nonatomic, weak, readwrite) UITableView *tableView;

/**
 * Image used to show as the drag indicator
 *
 * @return     image comes from property, tinted default image or original default image.
 */
- (UIImage *)finalImageOfArrow;

/** 
 * Core update function
 * @return     YES if it really triggers an update event. NO if it doesn't trigger.
 *             (i.e. Already doing a updating job)
 */
- (BOOL)startToUpdateWithValueChangeEvent:(BOOL)sendEvent animated:(BOOL)animated;

- (id)initWithPullDirection:(BFPullToRefreshControlPullDirection)direction;

@end

@implementation BFPullToRefreshControl

+ (BFPullToRefreshControl *)pullToRefreshControlWithPullDirection:(BFPullToRefreshControlPullDirection)direction {
    return [[BFPullToRefreshControl alloc] initWithPullDirection:direction];
}

+ (BFPullToRefreshControl *)pullToRefreshControl {
    return [self pullToRefreshControlWithPullDirection:BFPullToRefreshControlPullDirectionDown];
}

- (id)initWithPullDirection:(BFPullToRefreshControlPullDirection)direction {
    CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 56.0f);
    if (self = [super initWithFrame:frame]) {
        // Initial variables
        _responsiveDistance = direction==BFPullToRefreshControlPullDirectionDown?64.0f:16.0f;
        _refresherState = BFPullToRefreshControlNormal;
        _bottomBorderWidth = 1.0f;
        _bottomBorderColor = [UIColor colorWithWhite:.3f alpha:.7f];
        _arrowRotateAnimationDuration = .3f;
        _scrollAnimationDuration = .3f;
        _pullDirection = direction;
        _shouldDisplayArrowImage = YES;
        
        // view styles
        UIColor *backgroundColor = (UIColor *)[[[self class] appearance] backgroundColor];
        if (!backgroundColor) backgroundColor = [UIColor colorWithWhite:.85f alpha:1.0f];
        self.backgroundColor = backgroundColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        // Label Container
        _labelContainer = [[UIView alloc] init];
        _labelContainer.backgroundColor = [UIColor clearColor];
        _labelContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _labelContainer.clipsToBounds = YES;
        [self addSubview:_labelContainer];
        if (_pullDirection==BFPullToRefreshControlPullDirectionDown) {
            _labelContainer.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
        } else {
            _labelContainer.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
        }
        
        // Detail text label
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        _detailTextLabel.textColor = [UIColor darkGrayColor];
        _detailTextLabel.backgroundColor = [UIColor clearColor];
        _detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_labelContainer addSubview:_detailTextLabel];
        
        // Text label
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_labelContainer addSubview:_textLabel];
        
        // ImageView for arrow
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [self finalImageOfArrow];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.clipsToBounds = YES;
        [self addSubview:_arrowImageView];
        if (_pullDirection==BFPullToRefreshControlPullDirectionDown) {
            _arrowImageView.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
        } else {
            _arrowImageView.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
        }

        // Loading indicator
        _loadingIndicator = [[UIActivityIndicatorView alloc]
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingIndicator.center = _arrowImageView.center;
        _loadingIndicator.hidesWhenStopped = YES;
        [self addSubview:_loadingIndicator];
        if (_pullDirection==BFPullToRefreshControlPullDirectionDown) {
            _loadingIndicator.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
        } else {
            _loadingIndicator.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
        }
        
        // KVO
        [self addObserver:self forKeyPath:@keypath(self.delegate) options:0 context:BFPullToRefreshControlKVOContext];
        
        // Draw a bottom border
        borderLayer = [CALayer layer];
        borderLayer.backgroundColor = _bottomBorderColor.CGColor;
        [self.layer addSublayer:borderLayer];
        
        [self updateTitleLabelsAndUpdateLayout:YES];
        [self layoutBorder];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@keypath(self.delegate) context:BFPullToRefreshControlKVOContext];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context != BFPullToRefreshControlKVOContext) {
        if ([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        return;
    }
    
    if (object==self && [keyPath isEqualToString:@keypath(self.delegate)]) {
        [self updateTitleLabelsAndUpdateLayout:YES];
    }
}

#pragma mark - View Draw

- (UIImage *)finalImageOfArrow {
    UIImage *image = self.arrowImage;
    if (!image) {
        NSString *imagePath = [[NSBundle benzeneUIKitBundle] pathForResource:@"arrow" ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if (self.arrowTintColor) image = [image imageColoredWithColor:self.arrowTintColor];
        if (self.pullDirection==BFPullToRefreshControlPullDirectionUp) {
            image = [image rotatedImageByAngle:M_PI];
        }
    }
    return image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBorder];
    [self updateLayout];
}

- (void)layoutBorder {
    if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
        borderLayer.frame = CGRectMake(0.0f, CGRectGetHeight(self.frame) - self.bottomBorderWidth,
                                       CGRectGetWidth(self.frame), self.bottomBorderWidth);
    } else {
        borderLayer.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), self.bottomBorderWidth);
    }
}

- (void)updateTitleLabelsAndUpdateLayout:(BOOL)updateLayout {
    if (self.indicatorStyle==BFPullToRefreshControlIndicatorDefaultStyle) {
        // Labels
        NSString *titleText = nil;
        id<BFPullToRefreshControlDelegate> delegate = self.delegate;

        if ([delegate respondsToSelector:@selector(pullToRefreshControl:titleForState:)]) {
            titleText = [delegate pullToRefreshControl:self titleForState:self.refresherState];
        } else {
            switch (self.refresherState) {
                case BFPullToRefreshControlNormal:
                    titleText = (self.pullDirection==BFPullToRefreshControlPullDirectionDown)?
                    BFLocalizedString(@"Pull Down to Update"):BFLocalizedString(@"Pull Up to Update");
                    break;
                case BFPullToRefreshControlPulling:
                    titleText = BFLocalizedString(@"Release to Update");
                    break;
                case BFPullToRefreshControlUpdating:
                    titleText = BFLocalizedString(@"Updating...");
                    break;
                default:
                    break;
            }
        }
        self.textLabel.text = titleText;
        
        NSString *detailText = nil;
        if ([delegate respondsToSelector:@selector(pullToRefreshControl:detailTitleForState:)]) {
            detailText = [delegate pullToRefreshControl:self detailTitleForState:self.refresherState];
        }
        self.detailTextLabel.text = detailText;
        
        if (updateLayout) [self updateLayout];
    }
}

- (void)updateLayout {
    if (self.indicatorStyle==BFPullToRefreshControlIndicatorDefaultStyle) {
        self.labelContainer.hidden = self.arrowImageView.hidden = NO;
        
        CGFloat labelContainerFrameHeight = 0;
        if (self.detailTextLabel.text.length) {
            labelContainerFrameHeight = self.textLabel.font.lineHeight + 2.0f + self.detailTextLabel.font.lineHeight;
        } else {
            labelContainerFrameHeight = self.textLabel.font.lineHeight;
        }
        
        // Layout
        CGFloat indicatorOriginX = 20.0f;
        CGFloat indicatorOriginY = 0.0f;
        if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
            indicatorOriginY = CGRectGetHeight(self.frame) - ImageViewSize.height;
        }
        CGRect arrowImageViewFrame = (CGRect){.origin=CGPointMake(indicatorOriginX, indicatorOriginY),
            .size=ImageViewSize};
        self.arrowImageView.frame = arrowImageViewFrame;
        self.loadingIndicator.center = self.arrowImageView.center;
        
        CGFloat labelContainerFrameX = arrowImageViewFrame.origin.x + CGRectGetWidth(arrowImageViewFrame) + 8.0f;
        CGFloat labelContainerFrameWidth = CGRectGetWidth(self.bounds) - 20.0f - labelContainerFrameX;
        CGRect labelContainerFrame = CGRectMake(labelContainerFrameX,
                                                self.arrowImageView.center.y - labelContainerFrameHeight/2,
                                                labelContainerFrameWidth, labelContainerFrameHeight);
        self.labelContainer.frame = labelContainerFrame;
        self.textLabel.frame = CGRectMake(0.0f, 0.0f,
                                          CGRectGetWidth(self.labelContainer.bounds), self.textLabel.font.lineHeight);
        self.detailTextLabel.frame = CGRectMake(0.0f, CGRectGetHeight(self.textLabel.frame) + 2.0f,
                                                CGRectGetWidth(self.labelContainer.bounds),
                                                self.detailTextLabel.font.lineHeight);
    } else if (self.indicatorStyle==BFPullToRefreshControlIndicatorSimpleStyle) {
        self.labelContainer.hidden = self.arrowImageView.hidden = YES;
        self.loadingIndicator.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    }
}

#pragma mark - Setter

- (void)setArrowImage:(UIImage *)arrowImage {
    if (_arrowImage!=arrowImage) {
        [self willChangeValueForKey:@"arrowImage"];
        _arrowImage = arrowImage;
        self.arrowImageView.image = [self finalImageOfArrow];
        [self didChangeValueForKey:@"arrowImage"];
    }
}

- (void)setShouldDisplayArrowImage:(BOOL)shouldDisplayArrowImage {
    if (_shouldDisplayArrowImage!=shouldDisplayArrowImage) {
        [self willChangeValueForKey:@"shouldDisplayArrowImage"];
        _shouldDisplayArrowImage = shouldDisplayArrowImage;
        self.arrowImageView.hidden = !shouldDisplayArrowImage;
        [self didChangeValueForKey:@"shouldDisplayArrowImage"];
    }
}

- (void)setArrowTintColor:(UIColor *)arrowTintColor {
    if (_arrowTintColor!=arrowTintColor) {
        [self willChangeValueForKey:@"arrowTintColor"];
        _arrowTintColor = arrowTintColor;
        self.arrowImageView.image = [self finalImageOfArrow];
        [self didChangeValueForKey:@"arrowTintColor"];
    }
}

- (void)setBottomBorderWidth:(CGFloat)bottomBorderWidth {
    if (_bottomBorderWidth!=bottomBorderWidth) {
        [self willChangeValueForKey:@"bottomBorderWidth"];
        _bottomBorderWidth = bottomBorderWidth;
        [self layoutBorder];
        [self didChangeValueForKey:@"bottomBorderWidth"];
    }
}

- (void)setBottomBorderColor:(UIColor *)bottomBorderColor {
    if (_bottomBorderColor!=bottomBorderColor) {
        [self willChangeValueForKey:@"bottomBorderColor"];
        _bottomBorderColor = bottomBorderColor;
        borderLayer.backgroundColor = _bottomBorderColor.CGColor;
        [self didChangeValueForKey:@"bottomBorderColor"];
    }
}

- (void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes {
    if (_titleTextAttributes!=titleTextAttributes) {
        [self willChangeValueForKey:@"titleTextAttributes"];
        _titleTextAttributes = titleTextAttributes;
        [self.textLabel formatWithTextAttributes:_titleTextAttributes];
        [self didChangeValueForKey:@"titleTextAttributes"];
    }
}

- (void)setDetailTextAttributes:(NSDictionary *)detailTextAttributes {
    if (_detailTextAttributes!=detailTextAttributes) {
        [self willChangeValueForKey:@"detailTextAttributes"];
        _detailTextAttributes = detailTextAttributes;
        [self.detailTextLabel formatWithTextAttributes:_detailTextAttributes];
        [self didChangeValueForKey:@"detailTextAttributes"];
    }
}

- (void)setIndicatorStyle:(BFPullToRefreshControlIndicatorStyle)indicatorStyle {
    if (_indicatorStyle!=indicatorStyle) {
        [self willChangeValueForKey:@"indicatorStyle"];
        _indicatorStyle = indicatorStyle;
        [self updateTitleLabelsAndUpdateLayout:YES];
        [self didChangeValueForKey:@"indicatorStyle"];
    }
}

- (void)setRefresherState:(BFPullToRefreshControlState)refresherState {
    [self setRefresherState:refresherState animated:YES];
}

- (void)setRefresherState:(BFPullToRefreshControlState)refresherState animated:(BOOL)animated {
    if (_refresherState!=refresherState) {
        [self willChangeValueForKey:@"refresherState"];
        
        BFPullToRefreshControlState oldState = _refresherState;
        _refresherState = refresherState;
        BFPullToRefreshControlState newState = _refresherState;
        
        NSTimeInterval animationDuration = animated?self.scrollAnimationDuration:0.0f;
        // Go to New
        [self updateTitleLabelsAndUpdateLayout:YES];
        if (newState == BFPullToRefreshControlNormal) {
            
        } else if (newState == BFPullToRefreshControlPulling) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, -M_PI);
            }];
        } else if (newState == BFPullToRefreshControlUpdating) {
            self.arrowImageView.alpha = 0.0f;
            [self.loadingIndicator startAnimating];
            
            if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
                [UIView animateWithDuration:animationDuration animations:^{
                    UIScrollView *scrollableView = self.scrollableView;
                    // Record the inset for later recovering
                    UIEdgeInsets insets = self->originalContentInset = scrollableView.contentInset;
                    insets.top += CGRectGetHeight(self.bounds);
                    scrollableView.contentInset = insets;
                } completion:^(BOOL finished) {
                    [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
                }];
            } else {
                [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
            }
        }
        // Come from Old
        if (oldState == BFPullToRefreshControlNormal) {
            
        } else if (oldState == BFPullToRefreshControlPulling) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
            }];
        } else if (oldState == BFPullToRefreshControlUpdating) {
            [self.loadingIndicator stopAnimating];
            
            self.arrowImageView.alpha = 1.0f;
            if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView animateWithDuration:animationDuration animations:^{
                        // Done, set the inset back to original position
                        self.scrollableView.contentInset = self->originalContentInset;
                    } completion:^(BOOL finished) {
                        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
                    }];
                });
            } else {
                [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
            }
        }
        [self didChangeValueForKey:@"refresherState"];
    }
}

#pragma mark - Methods

- (BOOL)startToUpdateWithValueChangeEvent:(BOOL)sendEvent animated:(BOOL)animated {
    [self setRefresherState:BFPullToRefreshControlUpdating animated:animated];
    if (sendEvent) [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

#pragma mark - Interface

- (void)beginRefreshing {
    [self beginRefreshingWithValueChangeEvent:YES animated:YES];
}

- (void)beginRefreshingWithAnimation:(BOOL)animated {
    [self beginRefreshingWithValueChangeEvent:YES animated:animated];
}

- (void)beginRefreshingWithValueChangeEvent:(BOOL)sendEvent animated:(BOOL)animated {
    BOOL stateChanged = [self startToUpdateWithValueChangeEvent:sendEvent animated:animated];
    if (stateChanged) {
        [self.scrollableView scrollRectToVisible:(CGRect){.origin=CGPointZero, .size=self.bounds.size}
                                        animated:animated];
    }
}

- (void)endRefreshing {
    [self endRefreshingWithAnimation:YES];
}

- (void)endRefreshingWithAnimation:(BOOL)animated {
    [self setRefresherState:BFPullToRefreshControlNormal animated:animated];
}

- (BOOL)isRefreshing {
    return self.refresherState == BFPullToRefreshControlUpdating;
}

- (void)addToScrollView:(UIScrollView *)scrollView {
    [self removeFromSuperview];
    self.scrollableView = scrollView;
    
    CGRect frame = self.frame;
    if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
        frame.origin.y = -CGRectGetHeight(self.frame);
    } else {
        frame.origin.y = scrollView.contentSize.height;
    }
    frame.size.width = CGRectGetWidth(scrollView.frame);
    self.frame = frame;
    
    [scrollView addSubview:self];
}

- (void)addToTableView:(UITableView *)tableView {
    if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
        [self addToScrollView:tableView];
        self.tableView = tableView;
    } else {
        [self removeFromSuperview];
        UITableView *originalTableView = self.tableView;
        if (originalTableView.tableFooterView==self) {
            originalTableView.tableFooterView = nil;
        }
        self.tableView = tableView;
        self.scrollableView = tableView;
        tableView.tableFooterView = self;
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll {
    UIScrollView *scrollableView = self.scrollableView;
    if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
        CGFloat dragDistance = -1 * (scrollableView.contentOffset.y + scrollableView.contentInset.top);
        if (self.refresherState == BFPullToRefreshControlNormal && dragDistance >= self.responsiveDistance) {
            if (self.shouldStartUpdateWithoutReleaseAction) {
                // Normal ==> Update
                [self startToUpdateWithValueChangeEvent:YES animated:YES];
            } else {
                // Normal ==> Pull
                self.refresherState = BFPullToRefreshControlPulling;
            }
        } else if (self.refresherState == BFPullToRefreshControlPulling && dragDistance < self.responsiveDistance) {
            // Pull ==> Normal
            self.refresherState = BFPullToRefreshControlNormal;
        } else if (self.refresherState == BFPullToRefreshControlUpdating) {
            // Fix issue when user scrolls higher than the control
            if(scrollableView.contentOffset.y >= -originalContentInset.top) {
                // Current content is up-scrolling out from the screen
                // So use original one. we don't have to show the "loading indicator", so just change to original inset
                scrollableView.contentInset = originalContentInset;
            } else {
                // User scrolling down
                // The content insets should make sure that the "loading indicator" should be shown
                // To show the indicator, the inset should be "original inset + height of indicator"
                // But we wanna make the indicator also scrolled down by user, so the inset is changing with a MIN func.
                UIEdgeInsets insets = originalContentInset;
                insets.top = MIN(-scrollableView.contentOffset.y,
                                 originalContentInset.top + CGRectGetHeight(self.bounds));
                scrollableView.contentInset = insets;
            }
        }
    } else {
        CGFloat dragDistance = scrollableView.contentOffset.y + scrollableView.frame.size.height;
        CGFloat contentHeight = scrollableView.contentSize.height;// - self.frame.size.height;
        CGFloat extraDistance = dragDistance - contentHeight;
        if (self.refresherState == BFPullToRefreshControlNormal && extraDistance >= self.responsiveDistance) {
            if (self.shouldStartUpdateWithoutReleaseAction) {
                // Normal ==> Update
                [self startToUpdateWithValueChangeEvent:YES animated:YES];
            } else {
                // Normal ==> Pull
                self.refresherState = BFPullToRefreshControlPulling;
            }
        } else if (self.refresherState == BFPullToRefreshControlPulling && extraDistance < self.responsiveDistance) {
            // Pull ==> Normal
            self.refresherState = BFPullToRefreshControlNormal;
        }
    }
}

- (void)scrollViewDidEndDragging {
    UIScrollView *scrollableView = self.scrollableView;
    if (self.pullDirection==BFPullToRefreshControlPullDirectionDown) {
        CGFloat dragDistance = -1 * (scrollableView.contentOffset.y + scrollableView.contentInset.top);
        if (dragDistance > self.responsiveDistance &&
            self.refresherState == BFPullToRefreshControlPulling) {
            [self startToUpdateWithValueChangeEvent:YES animated:YES];
        }
    } else {
        CGFloat dragDistance = scrollableView.contentOffset.y + scrollableView.frame.size.height;
        CGFloat contentHeight = scrollableView.contentSize.height - self.frame.size.height;
        CGFloat extraDistance = dragDistance - contentHeight;
        if (extraDistance > self.responsiveDistance &&
            self.refresherState == BFPullToRefreshControlPulling) {
            [self startToUpdateWithValueChangeEvent:YES animated:YES];
        }
    }
}

@end
