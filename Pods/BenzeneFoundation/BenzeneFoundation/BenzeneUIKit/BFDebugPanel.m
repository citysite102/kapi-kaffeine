//
//  BFDebugPanel.m
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

#import "BFDebugPanel.h"
#import "CGGeometry+Benzene.h"
#import "BFLog_Internal.h"

#define BFDebugPanelViewToolbarHeight 44.
#define BFDebugPanelViewTextViewDefaultText @"DEBUG PANEL\n====================================\n"

@interface BFDebugPanelView ()

@property (nonatomic, strong, readonly) UITextView *textView;
@property (nonatomic, strong, readonly) UIToolbar *toolbar;

@end

@implementation BFDebugPanelView

@synthesize textView = _textView, toolbar = _toolbar;

static BOOL BFDebugPanelViewEnabled = NO;

+ (void)setEnabled {
    BFDebugPanelViewEnabled = YES;
}

+ (instancetype)sharedPanel {
    if (!BFDebugPanelViewEnabled) {
        return nil;
    }

    static BFDebugPanelView *sharedPanel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPanel = [[self alloc] initWithFrame:CGRectMake(0., 0., 300., 300.)];
    });
    return sharedPanel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

- (void)setupSubviews {
    [self toolbar];
    [self textView];
}

#pragma mark - Property

- (UITextView *)textView {
    if (!_textView) {
        // toolbar must be created before text view (for autolayout)
        [self toolbar];
        // Create view
        CGRect frame = CGRectMake(0.,
                                  BFDebugPanelViewToolbarHeight,
                                  self.bounds.size.width,
                                  self.bounds.size.height - BFDebugPanelViewToolbarHeight);
        _textView = [[UITextView alloc] initWithFrame:frame];
        [self addSubview:_textView];
        _textView.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                                      UIViewAutoresizingFlexibleWidth);


        // Setup text view
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor colorWithWhite:0. alpha:.7];
        _textView.textColor = [UIColor colorWithWhite:1. alpha:1.];
        _textView.font = [UIFont fontWithName:@"Menlo-Regular" size:11.];
        [self clean:nil];
    }
    return _textView;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.,
                                                               0.,
                                                               self.bounds.size.width,
                                                               BFDebugPanelViewToolbarHeight)];
        [self addSubview:_toolbar];
        _toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleBottomMargin);

        // Setup bar items
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                              target:nil
                                              action:nil];
        UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil
                                           action:nil];
        fixedSpaceItem.width = 8.;
        UIBarButtonItem *clean = [[UIBarButtonItem alloc] initWithTitle:@"Clean"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clean:)];
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                               target:self
                                                                               action:@selector(close:)];
        UIBarButtonItem *copy = [[UIBarButtonItem alloc] initWithTitle:@"Copy"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(copy:)];
        _toolbar.items = @[fixedSpaceItem, copy, clean, flexibleSpaceItem, close, fixedSpaceItem];

        // Add pan gesture recognizer
        UIPanGestureRecognizer *panGestureRecongizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(panned:)];
        [_toolbar addGestureRecognizer:panGestureRecongizer];

        _toolbar.alpha = .9;
    }
    return _toolbar;
}

#pragma mark - Actions

- (void)displayAtPosition:(CGPoint)position {
    [self displayAtRect:(CGRect){.origin=position, .size=self.bounds.size}];
}

- (void)displayAtRect:(CGRect)rect {
    self.frame = rect;
    if (self.superview) {
        [self removeFromSuperview];
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window bringSubviewToFront:self];
}

- (void)close:(id)sender {
    id<BFDebugPanelViewDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(debugPanelViewDidClose:)]) {
        [delegate debugPanelViewDidClose:self];
    } else {
        [self removeFromSuperview];
    }
}

- (void)clean:(id)sender {
    _textView.text = BFDebugPanelViewTextViewDefaultText;
}

- (void)copy:(id)sender {
    [UIPasteboard generalPasteboard].string = self.textView.text;
}

- (void)panned:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint delta = [panGestureRecognizer translationInView:self.superview];
    self.center = CGPointAddPoint(self.center, delta);
    [panGestureRecognizer setTranslation:CGPointZero inView:self.superview];
}

@end

void BFDebugLogWithPanel(const char *file, int line, const char *func, NSString *format, ...) {
    va_list ap;
    va_start(ap, format);
    if (![format hasSuffix:@"\n"]) {
        format = [format stringByAppendingString:@"\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);

    NSString *msg = _BFDebugLog(file, line, func, body);
    dispatch_async(dispatch_get_main_queue(), ^{
        BFDebugPanelView *debugPanel = [BFDebugPanelView sharedPanel];
        debugPanel.textView.text = [debugPanel.textView.text stringByAppendingString:msg];
    });
}

void BFSimpleDebugLogWithPanel(NSString *format, ...) {
    va_list ap;
    va_start(ap, format);
    if (![format hasSuffix:@"\n"]) {
        format = [format stringByAppendingString:@"\n"];
    }
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);

    NSString *msg = _BFSimpleDebugLog(body);
    dispatch_async(dispatch_get_main_queue(), ^{
        BFDebugPanelView *debugPanel = [BFDebugPanelView sharedPanel];
        debugPanel.textView.text = [debugPanel.textView.text stringByAppendingString:msg];
    });
}
