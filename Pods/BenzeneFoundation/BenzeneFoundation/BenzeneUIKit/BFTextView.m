//
//  BFTextView.m
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

#import "BFTextView.h"
#import "BFDefines.h"
#import <libextobjc/extobjc.h>

static void *BFTextViewKVOContext = &BFTextViewKVOContext;
NSString * const BFTextViewPlaceholderShownKey = @"placeholderShown";

@interface BFTextView () {
    id textChangeListener;
}

@property (nonatomic, getter=isPlaceholderShown) BOOL placeholderShown;

@end

@implementation BFTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupBFTextView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupBFTextView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:textChangeListener];
    [self removeObserver:self forKeyPath:BFTextViewPlaceholderShownKey context:BFTextViewKVOContext];
}

- (void)setupBFTextView {
    self.contentMode = UIViewContentModeTopLeft;
    
    _placeholderShown = self.text.length==0;
    [self addObserver:self forKeyPath:BFTextViewPlaceholderShownKey options:0 context:BFTextViewKVOContext];
    
    // Register for text change event
    @weakify(self);
    textChangeListener = [[NSNotificationCenter defaultCenter]
                          addObserverForName:UITextViewTextDidChangeNotification
                          object:self queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification *note) {
                              @strongify(self);
                              self.placeholderShown = self.text.length == 0;
                          }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context != BFTextViewKVOContext) {
        if ([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        return;
    }
    
    if (object==self && [keyPath isEqualToString:BFTextViewPlaceholderShownKey]) {
        [self setNeedsDisplay];
    }
}

+ (NSSet *)keyPathsForValuesAffectingPlaceholderShown {
    return [NSSet setWithObjects:@"placeholder", @"attributedPlaceholder", @"text", @"attributedText", nil];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.placeholderShown) {
        CGFloat hPadding = 5.f;
        CGFloat vPadding = 8.f;
        CGRect placeholderRect =
            CGRectMake(hPadding + self.contentInset.left,
                       vPadding + self.contentInset.top,
                       CGRectGetWidth(self.bounds) - hPadding*2 + self.contentInset.left + self.contentInset.right,
                       CGRectGetHeight(self.bounds) - vPadding*2 + self.contentInset.top + self.contentInset.bottom);

        if (self.attributedPlaceholder) {
            [self.attributedPlaceholder drawInRect:placeholderRect];
        } else {
            [self.placeholder drawInRect:placeholderRect withAttributes:@{
                NSFontAttributeName: self.font,
                NSForegroundColorAttributeName: [UIColor grayColor],
            }];
        }
    }
}

@end
