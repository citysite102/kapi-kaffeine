//
//  BFPullToRefreshControl.h
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

/// State of BFPullToRefreshControl
typedef NS_ENUM(NSUInteger, BFPullToRefreshControlState) {
    /// The control is current waiting for user to drag it to responsive distance
    BFPullToRefreshControlNormal,
    /// It is being dragging and the distance is larger then responsive distance
    BFPullToRefreshControlPulling,
    /// The control is released and showing loading indicator
    BFPullToRefreshControlUpdating,
};

typedef NS_ENUM(NSUInteger, BFPullToRefreshControlPullDirection) {
    BFPullToRefreshControlPullDirectionDown,
    BFPullToRefreshControlPullDirectionUp,
};

typedef NS_ENUM(NSUInteger, BFPullToRefreshControlIndicatorStyle) {
    BFPullToRefreshControlIndicatorDefaultStyle,
    BFPullToRefreshControlIndicatorSimpleStyle,
};

@class BFPullToRefreshControl;

/// Delegate of BFPullToRefreshControl
@protocol BFPullToRefreshControlDelegate <NSObject>
@optional
/**
 * Title of BFPullToRefreshControl
 *
 * @param control     the control object who are asking for title
 * @param state       current state of control
 * @return            title of control at specified state
 */
- (NSString *)pullToRefreshControl:(BFPullToRefreshControl *)control
                     titleForState:(BFPullToRefreshControlState)state;
/**
 * Detail text of BFPullToRefreshControl
 *
 * @param control     the control object who are asking for detail text
 * @param state       current state of control
 * @return            detail text of control at specified state
 * @discuss           when returning nil, the detail text label will be hidden.
 */
- (NSString *)pullToRefreshControl:(BFPullToRefreshControl *)control
               detailTitleForState:(BFPullToRefreshControlState)state;
@end

/** 
 * A pull to refresh control
 * You must configure the target and action of the control itself.
 * The control does not initiate the refresh operation directly.
 * Instead, it sends the ```UIControlEventValueChanged``` event when
 * a refresh operation should occur. You must assign an action
 * method to this event and use it to perform whatever actions are needed.
 */
@interface BFPullToRefreshControl : UIControl

/// Get an instance of pull to refresh control
+ (BFPullToRefreshControl *)pullToRefreshControl;
+ (BFPullToRefreshControl *)pullToRefreshControlWithPullDirection:(BFPullToRefreshControlPullDirection)direction;

/// Indicating wheather the control is refreshing or not
@property (nonatomic, getter=isRefreshing, readonly) BOOL refreshing;
@property (nonatomic, readonly) BFPullToRefreshControlPullDirection pullDirection;
@property (nonatomic, readonly) BFPullToRefreshControlState refresherState;

/// Delegate of this control
@property (nonatomic, weak) id<BFPullToRefreshControlDelegate> delegate;
/// The scroll view to work with. Usually a UITableView instance
@property (nonatomic, weak, readonly) UIScrollView *scrollableView;
@property (nonatomic, weak, readonly) UITableView *tableView;
/// Required responsive distance that user has to drag. The default value is 64pt
@property (nonatomic) CGFloat responsiveDistance;
@property (nonatomic) BOOL shouldStartUpdateWithoutReleaseAction;

/// Appearance Style
@property (nonatomic) BFPullToRefreshControlIndicatorStyle indicatorStyle UI_APPEARANCE_SELECTOR;

/// The tint color of arrow image
@property (strong, nonatomic) UIColor *arrowTintColor UI_APPEARANCE_SELECTOR;
/// Image used for showing the dragging direction .The size of this image should be 30pt * 44pt
@property (strong, nonatomic) UIImage *arrowImage UI_APPEARANCE_SELECTOR;
@property (nonatomic) BOOL shouldDisplayArrowImage UI_APPEARANCE_SELECTOR;
/// Color of bottom border of this control. As a separator to the scrollable view
@property (strong, nonatomic) UIColor *bottomBorderColor UI_APPEARANCE_SELECTOR;
/// Width of bottom border of this control. As a separator to the scrollable view
@property (nonatomic) CGFloat bottomBorderWidth UI_APPEARANCE_SELECTOR;
/**
 * Text attributes for title text label. Ref
 * @discuss You can specify the font, text color, text shadow color, and text shadow offset for the title
 *          in the text attributes dictionary, using the text attribute keys described in 
 *          ```NSString UIKit Additions Reference```.
 */
@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;
/**
 * Text attributes for detail text label. Ref
 * @discuss You can specify the font, text color, text shadow color, and text shadow offset for the detail text
 *          in the text attributes dictionary, using the text attribute keys described in
 *          ```NSString UIKit Additions Reference```.
 */
@property (nonatomic, strong) NSDictionary *detailTextAttributes UI_APPEARANCE_SELECTOR;
/// Duration of arrow rotate animation when dragging the scrollable view
@property (nonatomic) NSTimeInterval arrowRotateAnimationDuration UI_APPEARANCE_SELECTOR;
/// Duration of the scrollable view pull up animation when the refreshing is finished
@property (nonatomic) NSTimeInterval scrollAnimationDuration UI_APPEARANCE_SELECTOR;

/// Ask the control to show loading animation and trigger the update function.
- (void)beginRefreshing;
- (void)beginRefreshingWithAnimation:(BOOL)animated;
- (void)beginRefreshingWithValueChangeEvent:(BOOL)sendEvent animated:(BOOL)animated;
/** 
 * Ask the control to stop loading animation and hide it self
 * You should send this message to control when the updating process is finished.
 */
- (void)endRefreshing;
- (void)endRefreshingWithAnimation:(BOOL)animated;

/**
 * Add this control to a scrollable view
 *
 * @param scrollView     the scroll view target
 */
- (void)addToScrollView:(UIScrollView *)scrollView;
- (void)addToTableView:(UITableView *)tableView;

/**
 * Send this message to control in UIScrollViewDelegate
 * - [id<UIScrollViewDelegate> scrollViewDidScroll:]
 * The control require this to detect user dragging
 */
- (void)scrollViewDidScroll;
/**
 * Send this message to control in UIScrollViewDelegate
 * - [id<UIScrollViewDelegate> scrollViewDidEndDragging:]
 * The control require this to detect user releasing
 */
- (void)scrollViewDidEndDragging;

@end
