//
//  UIView+Benzene.m
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

#import "UIView+Benzene.h"
#import "BFKeyedSubscription.h"

const CGPoint CGPointNull = (CGPoint){ .x = INFINITY, .y = INFINITY};

@implementation UIView (Benzene)

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)origin {
    self.frame = (CGRect){origin, self.frame.size};
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)size {
    self.frame = (CGRect){self.frame.origin, size};
}

#pragma mark - Auto Layout Helpers

+ (NSRegularExpression *)_regularExpressionForReplacingVariableInConstraintString {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\$view(\\d+)"
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    });
    return regex;
}

+ (NSRegularExpression *)_regularExpressionForReplacingMetricInConstraintString {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\$metric(\\d+)"
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    });
    return regex;
}

+ (NSCache *)_constraintStringProcessingCache {
    static NSCache *constraintStringProcessingCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ constraintStringProcessingCache = [[NSCache alloc] init]; });
    return constraintStringProcessingCache;
}

+ (NSString *)_processedConstraintStringFromRawString:(NSString *)rawConstraintString {
    NSCache *cache = [self _constraintStringProcessingCache];
    NSString *result = cache[rawConstraintString];
    if (!result) {
        result = rawConstraintString;
        if ([result rangeOfString:@"$view"].location != NSNotFound) {
            NSRegularExpression *regex = [[self class] _regularExpressionForReplacingVariableInConstraintString];
            result = [regex stringByReplacingMatchesInString:result
                                                     options:0
                                                       range:NSMakeRange(0, result.length)
                                                withTemplate:@"view$1"];
        }
        result = [result stringByReplacingOccurrencesOfString:@"$self" withString:@"self_view"];
        
        if ([result rangeOfString:@"$metric"].location != NSNotFound) {
            NSRegularExpression *regex = [[self class] _regularExpressionForReplacingMetricInConstraintString];
            result = [regex stringByReplacingMatchesInString:result
                                                     options:0
                                                       range:NSMakeRange(0, result.length)
                                                withTemplate:@"metric$1"];
        }

        cache[rawConstraintString] = result;
    }
    return result;
}

- (UIView *)_commonSuperViewWithView:(UIView *)view {
    
    if ([self isDescendantOfView:view]) {
        return view;
    } else {
        UIView *superView = view.superview;
        while (superView) {
            if ([self isDescendantOfView:superView]) {
                return superView;
            }
            superView = superView.superview;
        };
    }
    return nil;
}


#pragma mark - Main

- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints {
    return [self addConstraintsFromStringArray:constraints views:nil];
}

- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints views:(NSArray *)views {
    
    return [self addConstraintsFromStringArray:constraints metrics:nil views:views];
}

- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints metrics:(NSArray *)metrics {
    
    return [self addConstraintsFromStringArray:constraints metrics:metrics views:nil];
}

- (NSArray *)addConstraintsFromStringArray:(NSArray *)constraints metrics:(NSArray *)metrics views:(NSArray *)views {
    
    NSMutableArray *allConstraints = [NSMutableArray array];
    [constraints enumerateObjectsUsingBlock:^(NSString *constraintString, NSUInteger idx, BOOL *stop) {
        [allConstraints addObjectsFromArray:[self addConstraintFromString:constraintString metrics:metrics views:views]];
    }];
    return allConstraints;
}

- (NSArray *)addConstraintFromString:(NSString *)constraint {
    return [self addConstraintFromString:constraint views:nil];
}

- (NSArray *)addConstraintFromString:(NSString *)constraint views:(NSArray *)views {
    
    return [self addConstraintFromString:constraint metrics:nil views:views];
}

- (NSArray *)addConstraintFromString:(NSString *)constraint metrics:(NSArray *)metrics {
    
    return [self addConstraintFromString:constraint metrics:metrics views:nil];
}

- (NSArray *)addConstraintFromString:(NSString *)inConstraint metrics:(NSArray *)metrics views:(NSArray *)views {
    
    if (inConstraint == nil || inConstraint.length <= 0)
        return nil;
    
    // Replace Variable
    NSString *constraint = [[self class] _processedConstraintStringFromRawString:inConstraint];
    
    // Generate View Dictionary
    NSMutableDictionary *metricDict = [NSMutableDictionary dictionaryWithCapacity:metrics.count + 1];
    [metrics enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL *stop) {
        
        if ([value isKindOfClass:[NSNumber class]]) {
            NSString *key = [NSString stringWithFormat:@"metric%lu", (unsigned long)idx];
            metricDict[key] = value;
        }
    }];
    NSMutableDictionary *viewDict = [NSMutableDictionary dictionaryWithCapacity:views.count + 1];
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        NSString *key = [NSString stringWithFormat:@"view%lu", (unsigned long)idx];
        viewDict[key] = view;
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }];
    viewDict[@"self_view"] = self;
    
    // Setup views
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview setNeedsUpdateConstraints];
    
    // Add constraints
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:metricDict views:viewDict];
    [self.superview addConstraints:constraints];
    
    return constraints;
}


#pragma mark - Convenience Remove

- (void)removeAllConstraintsInSelf {
    [self removeAllRelatedConstraintsInView:self];
}

- (void)removeAllRelatedConstraintsInSuperView {
    [self removeAllRelatedConstraintsInView:self.superview];
}

- (void)removeAllRelatedConstraintsInView:(UIView *)view {
    
    NSMutableArray *removeConstraints = [NSMutableArray arrayWithCapacity:view.constraints.count];
    
    [view.constraints
     enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
         
         if (constraint.firstItem == self || constraint.secondItem == self) {
             [removeConstraints addObject:constraint];
         }
     }];
    [view removeConstraints:removeConstraints];
}


#pragma mark - Convenience Add Constraints

// Center Alignment
- (NSLayoutConstraint *)addConstraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis {
    
    return [self addConstraintForCenterAligningToSuperviewInAxis:axis constant:0];
}

- (NSLayoutConstraint *)addConstraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis constant:(CGFloat)constant {
    
    return [self addConstraintForCenterAligningToView:self.superview inAxis:axis constant:constant];
}

- (NSLayoutConstraint *)addConstraintForCenterAligningToView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis {
    
    return [self addConstraintForCenterAligningToView:view inAxis:axis constant:0];
}

- (NSLayoutConstraint *)addConstraintForCenterAligningToView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis constant:(CGFloat)constant {
    
    UIView *targetView = [self _commonSuperViewWithView:view];
    NSLayoutConstraint *constraint = [self constraintForCenterAligningToView:view inAxis:axis constant:constant];
    [targetView addConstraint:constraint];
    
    if (targetView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return constraint;
}

// Edge Alignment
- (NSArray *)addConstraintForAligningToEdgeOfSuperview:(UIRectEdge)edge {
    
    return [self addConstraintForAligningToEdgeOfSuperview:edge constant:0];
}

- (NSArray *)addConstraintForAligningToEdgeOfSuperview:(UIRectEdge)edge constant:(CGFloat)constant {
    
    return [self addConstraintForAligningToEdge:edge ofView:self.superview constant:constant];
}

- (NSArray *)addConstraintForAligningToEdge:(UIRectEdge)edge ofView:(UIView *)view {
    
    return [self addConstraintForAligningToEdge:edge ofView:view constant:0];
}

- (NSArray *)addConstraintForAligningToEdge:(UIRectEdge)edge ofView:(UIView *)view constant:(CGFloat)constant {
    
    UIView *targetView = [self _commonSuperViewWithView:view];
    NSArray *constraints = [self constraintForAligningToEdge:edge ofView:view constant:constant];
    [targetView addConstraints:constraints];
    
    if (targetView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return constraints;
}

// Size
- (NSLayoutConstraint *)addConstraintForWidth:(CGFloat)width {
    
    NSLayoutConstraint *constraint = [self constraintForWidth:width];
    [self addConstraint:constraint];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    return constraint;
}

- (NSLayoutConstraint *)addConstraintForHeight:(CGFloat)height {
    
    NSLayoutConstraint *constraint = [self constraintForHeight:height];
    [self addConstraint:constraint];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    return constraint;
}

- (NSLayoutConstraint *)addConstraintForHavingSameHeightWithView:(UIView *)view {
    
    return [self addConstraintForHavingSameHeightWithView:view constant:0];
}

- (NSLayoutConstraint *)addConstraintForHavingSameWidthWithView:(UIView *)view {
    
    return [self addConstraintForHavingSameWidthWithView:view constant:0];
}

- (NSLayoutConstraint *)addConstraintForHavingSameHeightWithView:(UIView *)view constant:(CGFloat)constant {
    
    UIView *targetView = [self _commonSuperViewWithView:view];
    NSLayoutConstraint *constraint = [self constraintForHavingSameHeightWithView:view constant:constant];
    [targetView addConstraint:constraint];
    
    if (targetView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return constraint;
}

- (NSLayoutConstraint *)addConstraintForHavingSameWidthWithView:(UIView *)view constant:(CGFloat)constant {
    
    UIView *targetView = [self _commonSuperViewWithView:view];
    NSLayoutConstraint *constraint = [self constraintForHavingSameWidthWithView:view constant:constant];
    [targetView addConstraint:constraint];
    
    if (targetView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return constraint;
}

- (NSArray *)addConstraintsForExpandingSuperview {
    
    return [self addConstraintsForExpandingSuperviewWithConstant:0];
}

- (NSArray *)addConstraintsForExpandingSuperviewWithConstant:(CGFloat)constant {
    
    return [self addConstraintsForExpandingView:self.superview constant:constant];
}

- (NSArray *)addConstraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)axis {
    
    return [self addConstraintsForExpandingSuperviewInAxis:axis constant:0];
}

- (NSArray *)addConstraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)axis constant:(CGFloat)constant {
    
    return [self addConstraintsForExpandingView:self.superview inAxis:axis constant:constant];
}

- (NSArray *)addConstraintsForExpandingView:(UIView *)view {
    
    return [self addConstraintsForExpandingView:view constant:0];
}

- (NSArray *)addConstraintsForExpandingView:(UIView *)view constant:(CGFloat)constant {
    
    UIView *targetView = [self _commonSuperViewWithView:view];
    NSArray *constraints = [self constraintsForExpandingView:view constant:constant];
    [targetView addConstraints:constraints];
    
    if (targetView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return constraints;
}

- (NSArray *)addConstraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis {
    
    return [self addConstraintsForExpandingView:view inAxis:axis constant:0];
}

- (NSArray *)addConstraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis constant:(CGFloat)constant {
    
    UIView *targetView = [self _commonSuperViewWithView:view];
    NSArray *constraints = [self constraintsForExpandingView:view inAxis:axis constant:constant];
    [targetView addConstraints:constraints];
    
    if (targetView) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return constraints;
}


#pragma mark - Convenience Generate

// Center Alignment
- (NSLayoutConstraint *)constraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis {
    
    return [self constraintForCenterAligningToSuperviewInAxis:axis constant:0];
}

- (NSLayoutConstraint *)constraintForCenterAligningToSuperviewInAxis:(UILayoutConstraintAxis)axis constant:(CGFloat)constant {
    
    return [self constraintForCenterAligningToView:self.superview inAxis:axis constant:constant];
}

- (NSLayoutConstraint *)constraintForCenterAligningToView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis {
    
    return [self constraintForCenterAligningToView:view inAxis:axis constant:0];
}

- (NSLayoutConstraint *)constraintForCenterAligningToView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis constant:(CGFloat)constant {
    
    NSLayoutAttribute attr = axis == UILayoutConstraintAxisHorizontal ?
        NSLayoutAttributeCenterX : NSLayoutAttributeCenterY;
    
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint
        constraintWithItem:self
        attribute:attr
        relatedBy:NSLayoutRelationEqual
        toItem:view
        attribute:attr
        multiplier:1 constant:constant];
    
    return constraint;
}

// Edge Alignment
- (NSArray *)constraintForAligningToEdgeOfSuperview:(UIRectEdge)edge {
    
    return [self constraintForAligningToEdgeOfSuperview:edge constant:0];
}

- (NSArray *)constraintForAligningToEdgeOfSuperview:(UIRectEdge)edge constant:(CGFloat)constant {
    
    return [self constraintForAligningToEdge:edge ofView:self.superview constant:constant];
}

- (NSArray *)constraintForAligningToEdge:(UIRectEdge)edge ofView:(UIView *)view {
    
    return [self constraintForAligningToEdge:edge ofView:view constant:0];
}

- (NSArray *)constraintForAligningToEdge:(UIRectEdge)edge ofView:(UIView *)view constant:(CGFloat)constant {
    
    NSLayoutConstraint * (^addConstraint)(NSLayoutAttribute, CGFloat) = ^(NSLayoutAttribute attr, CGFloat adjustment) {
        
        NSLayoutConstraint *constraint =
        [NSLayoutConstraint
            constraintWithItem:self
            attribute:attr
            relatedBy:NSLayoutRelationEqual
            toItem:view
            attribute:attr
            multiplier:1 constant:adjustment];
        
        return constraint;
    };
    
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:1];
    if (edge == UIRectEdgeLeft) {
        [constraints addObject:addConstraint(NSLayoutAttributeLeft, constant)];
    } else if (edge == UIRectEdgeRight) {
        [constraints addObject:addConstraint(NSLayoutAttributeRight, constant)];
    } else if (edge == UIRectEdgeTop) {
        [constraints addObject:addConstraint(NSLayoutAttributeTop, constant)];
    } else if (edge == UIRectEdgeBottom) {
        [constraints addObject:addConstraint(NSLayoutAttributeBottom, constant)];
    } else if (edge == UIRectEdgeAll) {
        [constraints addObject:addConstraint(NSLayoutAttributeLeft, constant)];
        [constraints addObject:addConstraint(NSLayoutAttributeRight, constant)];
        [constraints addObject:addConstraint(NSLayoutAttributeTop, constant)];
        [constraints addObject:addConstraint(NSLayoutAttributeBottom, constant)];
    }
    
    return constraints;
}

// Size
- (NSLayoutConstraint *)constraintForWidth:(CGFloat)width {
    
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint
        constraintWithItem:self
        attribute:NSLayoutAttributeWidth
        relatedBy:NSLayoutRelationEqual
        toItem:nil
        attribute:NSLayoutAttributeNotAnAttribute
        multiplier:1 constant:width];
    
    return constraint;
}

- (NSLayoutConstraint *)constraintForHeight:(CGFloat)height {
    
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint
     constraintWithItem:self
     attribute:NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
     toItem:nil
     attribute:NSLayoutAttributeNotAnAttribute
     multiplier:1 constant:height];
    
    return constraint;
}

- (NSLayoutConstraint *)constraintForHavingSameWidthWithView:(UIView *)view {
    
    return [self constraintForHavingSameWidthWithView:view constant:0];
}

- (NSLayoutConstraint *)constraintForHavingSameWidthWithView:(UIView *)view constant:(CGFloat)constant {
    
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint
     constraintWithItem:self
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
     toItem:view
     attribute:NSLayoutAttributeWidth
     multiplier:1 constant:constant];
    
    return constraint;
}

- (NSLayoutConstraint *)constraintForHavingSameHeightWithView:(UIView *)view {
    
    return [self constraintForHavingSameHeightWithView:view constant:0];
}

- (NSLayoutConstraint *)constraintForHavingSameHeightWithView:(UIView *)view constant:(CGFloat)constant {
    
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint
        constraintWithItem:self
        attribute:NSLayoutAttributeHeight
        relatedBy:NSLayoutRelationEqual
        toItem:view
        attribute:NSLayoutAttributeHeight
        multiplier:1 constant:constant];
    
    return constraint;
}

- (NSArray *)constraintsForExpandingSuperview {
    
    return [self constraintsForExpandingSuperviewWithConstant:0];
}

- (NSArray *)constraintsForExpandingSuperviewWithConstant:(CGFloat)constant {
    
    return [self constraintsForExpandingView:self.superview constant:constant];
}

- (NSArray *)constraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)axis {
    
    return [self constraintsForExpandingSuperviewInAxis:axis constant:0];
}

- (NSArray *)constraintsForExpandingSuperviewInAxis:(UILayoutConstraintAxis)Axis constant:(CGFloat)constant {
    
    return [self constraintsForExpandingSuperviewInAxis:Axis constant:constant];
}

- (NSArray *)constraintsForExpandingView:(UIView *)view {
    
    return [self constraintsForExpandingView:view constant:0];
}

- (NSArray *)constraintsForExpandingView:(UIView *)view constant:(CGFloat)constant {
    
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:4];
    [constraints addObjectsFromArray:
     [self constraintsForExpandingView:view
                                inAxis:UILayoutConstraintAxisHorizontal
                              constant:constant]];
    [constraints addObjectsFromArray:
     [self constraintsForExpandingView:view
                                inAxis:UILayoutConstraintAxisVertical
                              constant:constant]];
    return constraints;
}

- (NSArray *)constraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis {
    
    return [self constraintsForExpandingView:view inAxis:axis constant:0];
}

- (NSArray *)constraintsForExpandingView:(UIView *)view inAxis:(UILayoutConstraintAxis)axis constant:(CGFloat)constant {
    
    NSLayoutConstraint *constraint1 = nil;
    NSLayoutConstraint *constraint2 = nil;
    
    if (axis == UILayoutConstraintAxisVertical) {
        constraint1 = [NSLayoutConstraint constraintWithItem:view
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeBottom
                                                  multiplier:1
                                                    constant:constant];
        
        constraint2 = [NSLayoutConstraint constraintWithItem:view
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeTop
                                                  multiplier:1
                                                    constant:-constant];
    } else {
        
        constraint1 = [NSLayoutConstraint constraintWithItem:view
                                                   attribute:NSLayoutAttributeRight
                                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeRight
                                                  multiplier:1
                                                    constant:constant];
        
        constraint2 = [NSLayoutConstraint constraintWithItem:view
                                                   attribute:NSLayoutAttributeLeft
                                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                                      toItem:self
                                                   attribute:NSLayoutAttributeLeft
                                                  multiplier:1
                                                    constant:-constant];
    }
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:2];
    [constraints addObject:constraint1];
    [constraints addObject:constraint2];
    
    return constraints;
}

@end
