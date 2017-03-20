//
//  UIView+Benzene.h
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

@interface UIView (Benzene)

@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;

#pragma mark - Auto Layout Helpers

// --------------------
// Add visual format
// --------------------

- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints;
- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints views:(NSArray *)views;
- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints metrics:(NSArray *)metrics;
- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints metrics:(NSArray *)metrics views:(NSArray *)views;

- (NSArray *)addConstraintFromString:(NSString *)constraint;
- (NSArray *)addConstraintFromString:(NSString *)constraint views:(NSArray *)views;
- (NSArray *)addConstraintFromString:(NSString *)constraint metrics:(NSArray *)metrics;
- (NSArray *)addConstraintFromString:(NSString *)constraint metrics:(NSArray *)metrics views:(NSArray *)views;


// --------------------
// Remove constraints
// --------------------

- (void)removeAllConstraintsInSelf;
- (void)removeAllRelatedConstraintsInSuperView;
- (void)removeAllRelatedConstraintsInView:(UIView *)view;


// --------------------
// Add constraints
// --------------------

/* Center Alignment */
- (NSLayoutConstraint *)addConstraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis;
- (NSLayoutConstraint *)addConstraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis
                                                               constant:(CGFloat)constant;

- (NSLayoutConstraint *)addConstraintForCenterAligningToView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis;
- (NSLayoutConstraint *)addConstraintForCenterAligningToView:(UIView *)view
                                                      inAxis:(UILayoutConstraintAxis)axis
                                                    constant:(CGFloat)constant;

/* Edge Alignment */
- (NSArray *)addConstraintForAligningToEdgeOfSuperview:(UIRectEdge)edge;
- (NSArray *)addConstraintForAligningToEdgeOfSuperview:(UIRectEdge)edge
                                              constant:(CGFloat)constant;

- (NSArray *)addConstraintForAligningToEdge:(UIRectEdge)edge ofView:(UIView *)view;
- (NSArray *)addConstraintForAligningToEdge:(UIRectEdge)edge ofView:(UIView *)view
                                   constant:(CGFloat)constant;

/* Size */
- (NSLayoutConstraint *)addConstraintForWidth:(CGFloat)width;
- (NSLayoutConstraint *)addConstraintForHeight:(CGFloat)height;
- (NSLayoutConstraint *)addConstraintForHavingSameHeightWithView:(UIView *)view;
- (NSLayoutConstraint *)addConstraintForHavingSameWidthWithView:(UIView *)view;
- (NSLayoutConstraint *)addConstraintForHavingSameHeightWithView:(UIView *)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)addConstraintForHavingSameWidthWithView:(UIView *)view constant:(CGFloat)constant;

- (NSArray *)addConstraintsForExpandingSuperview;
- (NSArray *)addConstraintsForExpandingSuperviewWithConstant:(CGFloat)constant;
- (NSArray *)addConstraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)axis;
- (NSArray *)addConstraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)axis
                                              constant:(CGFloat)constant;
- (NSArray *)addConstraintsForExpandingView:(UIView *)view;
- (NSArray *)addConstraintsForExpandingView:(UIView *)view constant:(CGFloat)constant;
- (NSArray *)addConstraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis;
- (NSArray *)addConstraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis
                                   constant:(CGFloat)constant;


// --------------------
// Generate constraints
// --------------------
/* Center Alignment */
- (NSLayoutConstraint *)constraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis;
- (NSLayoutConstraint *)constraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis
                                                            constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintForCenterAligningToView:(UIView *)view
                                                   inAxis:(UILayoutConstraintAxis)axis;
- (NSLayoutConstraint *)constraintForCenterAligningToView:(UIView *)view
                                                   inAxis:(UILayoutConstraintAxis)axis
                                                 constant:(CGFloat)constant;

/* Edge Alignment */
- (NSArray *)constraintForAligningToEdgeOfSuperview:(UIRectEdge)edge;
- (NSArray *)constraintForAligningToEdgeOfSuperview:(UIRectEdge)edge
                                           constant:(CGFloat)constant;
- (NSArray *)constraintForAligningToEdge:(UIRectEdge)edge
                                  ofView:(UIView *)view;
- (NSArray *)constraintForAligningToEdge:(UIRectEdge)edge
                                  ofView:(UIView *)view
                                constant:(CGFloat)constant;

/* Size */
- (NSLayoutConstraint *)constraintForWidth:(CGFloat)width;
- (NSLayoutConstraint *)constraintForHeight:(CGFloat)height;
- (NSLayoutConstraint *)constraintForHavingSameHeightWithView:(UIView *)view;
- (NSLayoutConstraint *)constraintForHavingSameWidthWithView:(UIView *)view;
- (NSLayoutConstraint *)constraintForHavingSameHeightWithView:(UIView *)view constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintForHavingSameWidthWithView:(UIView *)view constant:(CGFloat)constant;

- (NSArray *)constraintsForExpandingSuperview;
- (NSArray *)constraintsForExpandingSuperviewWithConstant:(CGFloat)constant;
- (NSArray *)constraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)axis;
- (NSArray *)constraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)axis
                                           constant:(CGFloat)constant;
- (NSArray *)constraintsForExpandingView:(UIView *)view;
- (NSArray *)constraintsForExpandingView:(UIView *)view constant:(CGFloat)constant;
- (NSArray *)constraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis;
- (NSArray *)constraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis
                             constant:(CGFloat)constant;

@end
