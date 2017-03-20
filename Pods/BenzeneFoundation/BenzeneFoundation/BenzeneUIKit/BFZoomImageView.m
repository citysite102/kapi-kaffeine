//
//  BFZoomImageView.m
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

#import "BFZoomImageView.h"
#import "BFDefines.h"
#import "BFFunctionUtilities.h"

static void *BFZoomImageViewKVOContext = &BFZoomImageViewKVOContext;
NSString * const BFZoomImageViewImageKey = @"image";
CGFloat const BFZoomImageViewDoubleTapZoomToMaxScale = -1.f;

@interface BFZoomImageView () {
    struct {
        BOOL updateContentSize;
    } _viewFlags;
}

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation BFZoomImageView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupZoomImageView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupZoomImageView];
    }
    return self;
}

- (void)setupZoomImageView {
    // Set delegate as self by default
    // Thus we can enable zoom feature
    self.delegate = self;
    
    // Setup the scroll view
    self.backgroundColor = [UIColor clearColor];
    self.maximumZoomScale = 5.0f;
    self.clipsToBounds = YES;
    self.alwaysBounceHorizontal = self.alwaysBounceVertical = self.bouncesZoom = self.bounces = YES;
    
    // Setup image view
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeCenter;
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    
    
    // Gesture Recognizers
    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(doubleTapped:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTapGestureRecognizer];
    
    // Add KVO observer for the image key
    [self addObserver:self forKeyPath:BFZoomImageViewImageKey
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionPrior
              context:BFZoomImageViewKVOContext];
    
    // Flags
    _viewFlags.updateContentSize = YES;
    _doubleTapZoomEnabled = YES;
    _doubleTapZoomScale = 2.f;
    _zoomEnabled = YES;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:BFZoomImageViewImageKey context:BFZoomImageViewKVOContext];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context != BFZoomImageViewKVOContext) {
        if ([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        return;
    }
    
    
    if (object==self && [keyPath isEqualToString:BFZoomImageViewImageKey]) {
        BOOL isPrior = [change[NSKeyValueChangeNotificationIsPriorKey] boolValue];
        if (isPrior) {
            if (_viewFlags.updateContentSize) {
                // Reset zoom scale
                self.zoomScale = 1.f;
            }
        } else {
            if (_viewFlags.updateContentSize) {
                self.zoomScale = self.minimumZoomScale = MIN([self fitScaleOfImage:nil], 1.f);
            }
            // Reset flag to YES each time update image.
            // Since main queue is a serial queue, there's no thread-safe problem.
            _viewFlags.updateContentSize = YES;
        }
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        // Resize the content frame when the content size is smaller than bounds size
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        // Keep the content frame attach to the origin of scroll view
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        // Resize the content frame when the content size is smaller than bounds size
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        // Keep the content frame attach to the origin of scroll view
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
    [self layoutIfNeeded];
    
    self.minimumZoomScale = MIN([self fitScaleOfImage:nil], 1.f);
}

#pragma mark - Scale

- (CGFloat)fitScaleOfImage:(UIImage *)image {
    image = image?:self.image;
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return 1.f;
    
    CGFloat scaleWidth = self.bounds.size.width / image.size.width;
    CGFloat scaleHeight = self.bounds.size.height / image.size.height;
    return MIN(scaleWidth, scaleHeight);
}

- (void)zoomToScale:(CGFloat)scale atPoint:(CGPoint)center animated:(BOOL)animated {
    /*
     *
     *  The `zoomToRect:animated:` method zooms image to fit the rect
     *  Hence, if the rect is equal to (or fit to) the size of image, it displays all the image content.
     *
     *
     *                        w
     *       +---------------------------------+
     *       | IMAGE SCALE RECT                |
     *       |                                 |                       w
     *       |                                 |           +-----------------------+
     *       |             bounds.w            |           |        bounds.w       |
     *       |        +---------------+        |           |   +---------------+   |
     *       |        | VIEWER BOUNDS |        |           |   |               |   |
     *       |        |               |        |           |   |               |   |
     *       |        |               |        |           |   |               |   |
     *       |        |       C       |        |           |   |       C       |   |
     *       |        |               |        |           |   |               |   |
     *       |        |               |        |           |   |               |   |
     *       |        |               |        |           |   |               |   |
     *       |        +---------------+        |           |   +---------------+   |
     *       |                                 |           |                       |
     *       |                                 |           +-----------------------+
     *       |                                 |
     *       |                                 |
     *       +---------------------------------+
     *
     *                      @s1                                        @s2
     *
     *       When scale == 50%, the "w" should be 2 times to the "bounds.w"
     *       ----> w = 2 * bounds.w
     *         ---> bounds.w  = w * 50%
     *         ---> w = bounds.w / 50% = bounds.w / scale
     *
     */
    scale = MAX(MIN(scale, self.maximumZoomScale), self.minimumZoomScale);
    
    CGFloat w = self.bounds.size.width / scale;
    CGFloat h = self.bounds.size.height / scale;
    CGFloat x = center.x - w/2;
    CGFloat y = center.y - h/2;
    [self zoomToRect:CGRectMake(x, y, w, h) animated:animated];
}

- (void)zoomToActualSizeAtPoint:(CGPoint)center animated:(BOOL)animated {
    [self zoomToScale:1.f atPoint:center animated:animated];
}

- (void)zoomToMaxScaleAtPoint:(CGPoint)center animated:(BOOL)animated {
    [self zoomToScale:self.maximumZoomScale atPoint:center animated:animated];
}

- (void)zoomToFitScaleWithAnimation:(BOOL)animated {
    [self zoomToScale:[self fitScaleOfImage:nil] atPoint:CGPointZero animated:animated];
}

- (CGRect)visibleRectOfImage {
    CGRect imageRect = (CGRect){.origin=self.contentOffset, .size=self.contentSize};
    CGRect viewBounds = self.bounds;
    CGRect result = CGRectIntersection(imageRect, viewBounds);
    
    CGFloat scale = self.zoomScale;
    result.origin.x /= scale;
    result.origin.y /= scale;
    result.size.width /= scale;
    result.size.height /= scale;
    
    return result;
}

#pragma mark - Gesture Recognizer

- (void)doubleTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (!self.doubleTapZoomEnabled) return;
    
    CGPoint center = [tapGestureRecognizer locationInView:self.imageView];
    CGFloat scale = self.zoomScale;
    
    if (self.zoomScale == self.maximumZoomScale) {
        // Zoom to fit scale
        scale = [self fitScaleOfImage:nil];
    } else {
        if (fequalf(self.doubleTapZoomScale, -1.f)) {
            // Zoom To Full directly
            scale = self.maximumZoomScale;
        } else {
            scale *= self.doubleTapZoomScale;
        }
    }
    
    [self zoomToScale:scale atPoint:center animated:YES];
}

#pragma mark - Property : Image

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setImage:(UIImage *)image updateContentSize:(BOOL)updateContentSize {
    _viewFlags.updateContentSize = updateContentSize;
    self.imageView.image = image;
}

+ (BOOL)automaticallyNotifiesObserversOfImage {
    // We pass the KVO event from original "image" key to "imageView.image" keyPath.
    // (Via following "keyPathsForValuesAffectingImage" method)
    return NO;
}

+ (NSSet *)keyPathsForValuesAffectingImage {
    return [NSSet setWithObjects:@"imageView.image", nil];
}

#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[self class]]) {
        BFZoomImageView *zoomImageView = (BFZoomImageView *)scrollView;
        return zoomImageView.zoomEnabled?zoomImageView.imageView:nil;
    } else {
        return nil;
    }
}

@end
