//
//  UIView+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIView+Essentials.h"
#import "UIColor+Essentials.h"
#import "UIKit+Essentials.h"
#import "NSObject+Essentials.h"
#import "ESSDragInteractionDelegate.h"





@implementation UIView (Essentials)





#pragma mark - Snapshots


- (UIImage *)snapshot {
    return [self snapshotWithScale:self.contentScaleFactor];
}


- (UIImage *)snapshotWithScale:(CGFloat)scale {
    if (CGSizeEqualToSize(CGSizeZero, self.bounds.size)) return nil;

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    let screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}


- (UIImageView *)makeSnapshotImageView {
    let image = [self snapshot];
    if ( ! image) return nil;
    
    var imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = self.frame;
    imageView.autoresizingMask = self.autoresizingMask;
    
    return imageView;
}


- (UIImageView *)overlayWithSnapshotImageView {
    var imageView = [self makeSnapshotImageView];
    if (imageView) {
        [self.superview insertSubview:imageView aboveSubview:self];
    }
    return imageView;
}





#pragma mark - Corner Radius

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    if ( ! self.layer.masksToBounds && cornerRadius > 0) {
        self.layer.masksToBounds = YES; // Turn on if not already.
    }
}


- (BOOL)shouldRasterize {
    return self.layer.shouldRasterize;
}


- (void)setShouldRasterize:(BOOL)shouldRasterize {
    self.layer.shouldRasterize = shouldRasterize;
    if (shouldRasterize) {
        self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    }
}





- (CGFloat)backgroundAlpha {
    return self.backgroundColor.alphaComponent;
}


- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha {
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:backgroundAlpha];
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingBackgroundAlpha {
    return [NSSet setWithObject:ESSKeypathClass(UIView, backgroundColor)];
}





- (BOOL)isVisible {
    return ! self.hidden;
}


- (void)setIsVisible:(BOOL)isVisible {
    self.hidden = ! isVisible;
}


+ (NSSet *)keyPathsForValuesAffectingIsVisible {
    return [NSSet setWithObject:ESSKeypathClass(UIView, hidden)];
}





#pragma mark - Geometry


- (CGPoint)position {
    return self.center;
}


- (void)setPosition:(CGPoint)position {
    self.center = position;
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingPosition {
    return [NSSet setWithObject:ESSKeypathClass(UIView, center)];
}


- (CGPoint)relativeAnchorPoint {
    return self.layer.anchorPoint;
}


- (void)setRelativeAnchorPoint:(CGPoint)relativeAnchorPoint {
    self.layer.anchorPoint = relativeAnchorPoint;
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingRelativeAnchorPoint {
    return [NSSet setWithObject:ESSKeypathClass(UIView, layer.anchorPoint)];
}


- (CGPoint)anchorPoint {
    return CGScalePoint(self.relativeAnchorPoint, self.bounds.size);
}


- (void)setAnchorPoint:(CGPoint)anchorPoint {
    self.relativeAnchorPoint = CGScalePoint(anchorPoint, CGScaleInvert(self.bounds.size));
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingAnchorPoint {
    return [NSSet setWithObjects:ESSKeypathClass(UIView, bounds), ESSKeypathClass(UIView, relativeAnchorPoint), nil];
}


- (void)moveAnchorPointTo:(CGPoint)anchorPoint {
    CGPoint innerDelta = CGPointSubtract(anchorPoint, self.anchorPoint);
    self.anchorPoint = anchorPoint;
    self.position = CGPointAdd(self.position, innerDelta);
}


- (CGFloat)rotation {
    CGFloat radians = [[self.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    return CGDegrees(radians);
}


- (void)setRotation:(CGFloat)rotation {
    [self.layer setValue:@(CGRadians(rotation)) forKeyPath:@"transform.rotation.z"];
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingRotation {
    return [NSSet setWithObject:@"layer.transform"];
}


- (CGFloat)scale {
    return CGScaleMean(self.scales);
}


- (void)setScale:(CGFloat)scale {
    self.scales = CGSizeMake(scale, scale);
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingScale {
    return [NSSet setWithObject:ESSKeypathClass(UIView, scales)];
}


- (CGSize)scales {
    CGSize scales = CGSizeZero;
    scales.width = [[self.layer valueForKeyPath:@"transform.scale.x"] doubleValue];
    scales.height = [[self.layer valueForKeyPath:@"transform.scale.y"] doubleValue];
    return scales;
}


- (void)setScales:(CGSize)scales {
    [self.layer setValue:@(scales.width) forKeyPath:@"transform.scale.x"];
    [self.layer setValue:@(scales.height) forKeyPath:@"transform.scale.y"];
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingScales {
    return [NSSet setWithObject:@"layer.transform"];
}


- (CGPoint)translation {
    CGPoint tran = CGPointZero;
    tran.x = self.transform.tx;
    tran.y = self.transform.ty;
    return tran;
}


- (void)setTranslation:(CGPoint)translation {
    [self adjustTransform:^CGAffineTransform(CGAffineTransform transform) {
        transform.tx = translation.x;
        transform.ty = translation.y;
        return transform;
    }];
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingTranslation {
    return [NSSet setWithObject:ESSKeypathClass(UIView, transform)];
}


- (void)translateTo:(CGPoint)position {
    self.translation = CGPointMake(position.x - self.center.x,
                                   position.y - self.center.y);
}





#pragma mark - Shadow


- (NSShadow *)shadow {
    var shadow = [NSShadow new];
    shadow.shadowOffset = self.layer.shadowOffset;
    let color = self.shadowColor;
    CGFloat alpha = CGColorGetAlpha(color.CGColor) * self.shadowAlpha;
    shadow.shadowColor = [color colorWithAlphaComponent:alpha];
    shadow.shadowBlurRadius = self.shadowBlurRadius;
    return shadow;
}


- (void)setShadow:(NSShadow *)shadow {
    self.layer.shadowOffset = shadow.shadowOffset;
    self.layer.shadowColor = [shadow.shadowColor CGColor];
    self.shadowBlurRadius = shadow.shadowBlurRadius;
    self.shadowAlpha = 1;
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingShadow {
    return [NSSet setWithObjects:
            ESSKeypathClass(UIView, layer.shadowOffset),
            ESSKeypathClass(UIView, shadowColor),
            ESSKeypathClass(UIView, shadowAlpha),
            ESSKeypathClass(UIView, shadowBlurRadius),
            nil];
}


- (CGPoint)shadowOffset {
    return CGPointMake(self.layer.shadowOffset.width, self.layer.shadowOffset.height);
}


- (void)setShadowOffset:(CGPoint)shadowOffset {
    self.layer.shadowOffset = CGSizeMake(shadowOffset.x, shadowOffset.y);
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingShadowOffset {
    return [NSSet setWithObject:ESSKeypathClass(UIView, layer.shadowOffset)];
}


- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}


- (void)setShadowColor:(UIColor *)shadowColor {
    if (@available(iOS 13, *)) {
        //! We listen for appearance changes and update the color automatically.
        [self.onTraitCollectionChange addObserver:self handler:^(UIView *self, UITraitCollection *previous) {
            UIColor *resolvedColor = [shadowColor resolvedColorWithTraitCollection:self.traitCollection];
            self.layer.shadowColor = resolvedColor.CGColor;
        }];
    }
    else {
        self.layer.shadowColor = shadowColor.CGColor;
    }
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingShadowColor {
    return [NSSet setWithObject:ESSKeypathClass(UIView, layer.shadowColor)];
}


- (CGFloat)shadowBlurRadius {
    return self.layer.shadowRadius;
}


- (void)setShadowBlurRadius:(CGFloat)shadowBlurRadius {
    self.layer.shadowRadius = shadowBlurRadius;
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingShadowBlurRadius {
    return [NSSet setWithObject:ESSKeypathClass(UIView, layer.shadowRadius)];
}


- (CGFloat)shadowAlpha {
    return self.layer.shadowOpacity;
}


- (void)setShadowAlpha:(CGFloat)shadowAlpha {
    self.layer.shadowOpacity = shadowAlpha;
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingShadowAlpha {
    return [NSSet setWithObject:ESSKeypathClass(UIView, layer.shadowOpacity)];
}


- (UIBezierPath *)shadowPath {
    return [UIBezierPath bezierPathWithCGPath:self.layer.shadowPath];
}


- (void)setShadowPath:(UIBezierPath *)shadowPath {
    self.layer.shadowPath = [shadowPath CGPath];
}


+ (NSSet<NSString *> *)keyPathsForValuesAffectingShadowPath {
    return [NSSet setWithObject:ESSKeypathClass(UIView, layer.shadowPath)];
}


#pragma mark - Border

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (@available(iOS 13, *)) {
        //! We listen for appearance changes and update the color automatically.
        [self.onTraitCollectionChange addObserver:self handler:^(UIView *self, UITraitCollection *previous) {
            UIColor *resolvedColor = [borderColor resolvedColorWithTraitCollection:self.traitCollection];
            self.layer.borderColor = resolvedColor.CGColor;
        }];
    }
    else {
        self.layer.borderColor = borderColor.CGColor;
    }
}


#pragma mark - Structs Adjustments


- (void)adjustFrame:(void(^)(CGRect *))block {
    CGRect frame = self.frame;
    block(&frame);
    self.frame = frame;
}


- (void)adjustBounds:(void(^)(CGRect *))block {
    CGRect bounds = self.bounds;
    block(&bounds);
    self.bounds = bounds;
}


- (void)adjustCenter:(void(^)(CGPoint *))block {
    CGPoint center = self.center;
    block(&center);
    self.center = center;
}

- (void)adjustTransform:(CGAffineTransform(^)(CGAffineTransform))block {
    var transform = self.transform;
    transform = block(transform);
    self.transform = transform;
}





#pragma mark - Events


- (ESSEvent<UIColor *> *)onTintColorChange {
    SEL selector = @selector(ess_tintColorDidChange);
    ESSEvent<UIColor *> *event = [self associatedObjectForKey:selector];
    if ( ! event) {
        event = [[ESSEvent alloc] initWithOwner:self initialValue:self.tintColor];
        [event notify]; //! Any future listener is immediatelly notified.
        [self setAssociatedStrongObject:event forKey:selector];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UIView swizzleSelector:@selector(tintColorDidChange) with:selector];
        });
    }
    return event;
}


- (void)ess_tintColorDidChange {
    [self ess_tintColorDidChange];
    
    ESSEvent<UIColor *> *event = [self associatedObjectForKey:@selector(ess_tintColorDidChange)];
    [event sendValue:self.tintColor];
}




- (ESSEvent<UIColor *> *)onTraitCollectionChange {
    //! As of October 2019 on iOS 13, UIImageView didn’t notify on traitCollection properly.
    if ([self isKindOfClass:UIImageView.class]) {
        ESSWarning(@"Observing traitCollection changes doesn’t work on UIImageView.");
    }
    SEL selector = @selector(ess_traitCollectionDidChange:);
    ESSEvent<UIColor *> *event = [self associatedObjectForKey:selector];
    if ( ! event) {
        event = [[ESSEvent alloc] initWithOwner:self initialValue:self.traitCollection];
        [event notify]; //! Any future listener is immediatelly notified.
        [self setAssociatedStrongObject:event forKey:selector];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UIView swizzleSelector:@selector(traitCollectionDidChange:) with:selector];
        });
    }
    
    return event;
}


- (void)ess_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self ess_traitCollectionDidChange:previousTraitCollection];
    
    ESSEvent<UITraitCollection *> *event = [self associatedObjectForKey:@selector(ess_traitCollectionDidChange:)];
    [event sendValue:previousTraitCollection];
}







- (void)enumerateSubviewsRecursivelyWithBlock:(void (^)(UIView *view, BOOL *stop))block {
    var stack = [self.subviews mutableCopy];
    BOOL stop = NO;
    while (stack.count) {
        var subview = [stack firstObject];
        [stack removeObjectAtIndex:0];
        
        block(subview, &stop);
        // The block may even change the subviews and they will be enumerated.
        [stack addObjectsFromArray:subview.subviews];
        
        if (stop) break;
    }
}





- (void)crossDissolveWithDuration:(NSTimeInterval)duration animations:(void(^)(void))animations {
    [UIView transitionWithView:self duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:animations completion:nil];
}






#pragma mark - Interaction


- (void)addVerticalMotionEffectWithIntensity:(CGFloat)intensity {
    var horizontalMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                           type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    horizontalMotion.minimumRelativeValue = @(-intensity);
    horizontalMotion.maximumRelativeValue = @(intensity);
    
    [self addMotionEffect:horizontalMotion];
}


- (void)addHorizontalMotionEffectWithIntensity:(CGFloat)intensity {
    var horizontalMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotion.minimumRelativeValue = @(-intensity);
    horizontalMotion.maximumRelativeValue = @(intensity);
    
    [self addMotionEffect:horizontalMotion];
}


- (UIDragInteraction *)enableDragWithString:(NSString *)string {
    var item = [[NSItemProvider alloc] initWithItem:string typeIdentifier:@"public.text"];
    return [self enableDragWithItem:item];
}


- (UIDragInteraction *)enableDragWithFileURL:(NSURL *)fileURL {
    var item = [[NSItemProvider alloc] initWithContentsOfURL:fileURL];
    return [self enableDragWithItem:item];
}


- (UIDragInteraction *)enableDragWithItem:(NSItemProvider *)itemProvider {
    id<UIDragInteractionDelegate> delegate = [[ESSDragInteractionDelegate alloc] initWithItems:@[itemProvider]];
    [self setAssociatedStrongObject:delegate forKey:_cmd];
    
    var interation = [[UIDragInteraction alloc] initWithDelegate:delegate];
    interation.enabled = YES;
    [self addInteraction:interation];
    return interation;
}


- (void)removeAllInteractions {
    self.interactions = @[];
}





#pragma mark - Debugging


- (void)debugDisplayBackgrounds {
    self.backgroundColor = [[UIColor randomColor] colorWithAlphaComponent:0.25];
    [self enumerateSubviewsRecursivelyWithBlock:^(UIView *view, BOOL *stop) {
        view.backgroundColor = [[UIColor randomColor] colorWithAlphaComponent:0.25];
    }];
}


- (void)debugDisplayBorders {
    self.borderColor = [[UIColor randomColor] colorWithAlphaComponent:0.5];
    self.borderWidth = 0.5;
    [self enumerateSubviewsRecursivelyWithBlock:^(UIView *view, BOOL *stop) {
        view.borderColor = [[UIColor randomColor] colorWithAlphaComponent:0.5];
        view.borderWidth = 0.5;
    }];
}





@end
