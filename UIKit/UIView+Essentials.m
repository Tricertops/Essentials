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





@implementation UIView (Essentials)





#pragma mark - Snapshots


- (UIImage *)snapshot {
    return [self snapshotWithScale:self.contentScaleFactor];
}


- (UIImage *)snapshotWithScale:(CGFloat)scale {
    if (CGSizeEqualToSize(CGSizeZero, self.bounds.size)) return nil;

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}


- (UIImageView *)makeSnapshotImageView {
    UIImage *image = [self snapshot];
    if ( ! image) return nil;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = self.frame;
    imageView.autoresizingMask = self.autoresizingMask;
    
    return imageView;
}


- (UIImageView *)overlayWithSnapshotImageView {
    UIImageView *imageView = [self makeSnapshotImageView];
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





#pragma mark - Geometry


+ (NSString *)ess_rotationKeyPath {
    return @"layer.transform.rotation.z";
}


- (CGFloat)rotation {
    CGFloat radians = [[self valueForKeyPath:[UIView ess_rotationKeyPath]] doubleValue];
    return CGDegrees(radians);
}


- (void)setRotation:(CGFloat)rotation {
    [self setValue:@(CGRadians(rotation)) forKeyPath:[UIView ess_rotationKeyPath]];
}


+ (NSSet *)keyPathsForValuesAffectingRotation {
    return [NSSet setWithObject:[UIView ess_rotationKeyPath]];
}





#pragma mark - Shadow


- (NSShadow *)shadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = self.layer.shadowOffset;
    UIColor *color = self.shadowColor;
    CGFloat alpha = CGColorGetAlpha(color.CGColor) * self.shadowAlpha;
    shadow.shadowColor = [color colorWithAlphaComponent:alpha];
    shadow.shadowBlurRadius = self.shadowBlurRadius;
    return shadow;
}


- (void)setShadow:(NSShadow *)shadow {
    self.layer.shadowOffset = shadow.shadowOffset;
    self.shadowColor = shadow.shadowColor ?: [UIColor clearColor];
    self.shadowBlurRadius = shadow.shadowBlurRadius;
    self.shadowAlpha = 1;
}


+ (NSSet *)keyPathsForValuesAffectingShadow {
    return [NSSet setWithObjects:@"layer.shadowOffset", @"shadowColor", @"shadowAlpha", @"shadowBlurRadius", nil];
}


- (UIOffset)shadowOffset {
    return UIOffsetMake(self.layer.shadowOffset.width, self.layer.shadowOffset.height);
}


- (void)setShadowOffset:(UIOffset)shadowOffset {
    self.layer.shadowOffset = CGSizeMake(shadowOffset.horizontal, shadowOffset.vertical);
}


+ (NSSet *)keyPathsForValuesAffectingShadowOffset {
    return [NSSet setWithObjects:@"layer.shadowOffset", nil];
}


- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}


- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}


+ (NSSet *)keyPathsForValuesAffectingShadowColor {
    return [NSSet setWithObjects:@"layer.shadowColor", nil];
}


- (CGFloat)shadowBlurRadius {
    return self.layer.shadowRadius;
}


- (void)setShadowBlurRadius:(CGFloat)shadowBlurRadius {
    self.layer.shadowRadius = shadowBlurRadius;
}


+ (NSSet *)keyPathsForValuesAffectingShadowBlurRadius {
    return [NSSet setWithObjects:@"layer.shadowRadius", nil];
}


- (CGFloat)shadowAlpha {
    return self.layer.shadowOpacity;
}


- (void)setShadowAlpha:(CGFloat)shadowAlpha {
    self.layer.shadowOpacity = shadowAlpha;
}


+ (NSSet *)keyPathsForValuesAffectingShadowAlpha {
    return [NSSet setWithObjects:@"layer.shadowOpacity", nil];
}


- (UIBezierPath *)shadowPath {
    return [UIBezierPath bezierPathWithCGPath:self.layer.shadowPath];
}


- (void)setShadowPath:(UIBezierPath *)shadowPath {
    self.layer.shadowPath = [shadowPath CGPath];
}


+ (NSSet *)keyPathsForValuesAffectingShadowPath {
    return [NSSet setWithObjects:@"layer.shadowPath", nil];
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
    self.layer.borderColor = borderColor.CGColor;
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
    CGAffineTransform transform = self.transform;
    transform = block(transform);
    self.transform = transform;
}






- (void)enumerateSubviewsRecursivelyWithBlock:(void (^)(UIView *view, BOOL *stop))block {
    NSMutableArray *stack = [[NSMutableArray alloc] initWithArray:self.subviews];
    BOOL stop = NO;
    while (stack.count) {
        UIView *subview = [stack firstObject];
        [stack removeObjectAtIndex:0];
        
        block(subview, &stop);
        // The block may even change the subviews and they will be enumerated.
        [stack addObjectsFromArray:subview.subviews];
        
        if (stop) break;
    }
}






#pragma mark - Interaction


- (void)addVerticalMotionEffectWithIntensity:(CGFloat)intensity {
    UIInterpolatingMotionEffect *horizontalMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    horizontalMotion.minimumRelativeValue = @(-intensity);
    horizontalMotion.maximumRelativeValue = @(intensity);
    
    [self addMotionEffect:horizontalMotion];
}


- (void)addHorizontalMotionEffectWithIntensity:(CGFloat)intensity {
    UIInterpolatingMotionEffect *horizontalMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotion.minimumRelativeValue = @(-intensity);
    horizontalMotion.maximumRelativeValue = @(intensity);
    
    [self addMotionEffect:horizontalMotion];
}





#pragma mark - Debugging


- (void)debugDisplayBackgrounds {
    self.backgroundColor = [UIColor randomColor];
    [self enumerateSubviewsRecursivelyWithBlock:^(UIView *view, BOOL *stop) {
        view.backgroundColor = [[UIColor randomColor] colorWithAlphaComponent:0.3333];
    }];
}


- (void)debugDisplayBorders {
    self.borderColor = [UIColor randomColor];
    self.borderWidth = 0.5;
    [self enumerateSubviewsRecursivelyWithBlock:^(UIView *view, BOOL *stop) {
        view.borderColor = [[UIColor randomColor] colorWithAlphaComponent:0.6667];
        view.borderWidth = 0.5;
    }];
}


+ (void)debugGuardMainThread {
#if DEBUG
    [UIView swizzleSelector:@selector(setNeedsLayout) with:@selector(ess_mainThreadGuard_setNeedsLayout)];
    [UIView swizzleSelector:@selector(setNeedsDisplay) with:@selector(ess_mainThreadGuard_setNeedsDisplay:)];
    [UIView swizzleSelector:@selector(setNeedsDisplayInRect:) with:@selector(ess_mainThreadGuard_setNeedsDisplayInRect:)];
#endif
}


- (void)ess_mainThreadGuard {
    //TODO: This may throw false positives in UIWebView.
    ESSAssert(NSThread.isMainThread, @"UIKit call off the Main Thread.");
}


- (void)ess_mainThreadGuard_setNeedsLayout {
    [self ess_mainThreadGuard];
    [self ess_mainThreadGuard_setNeedsLayout];
}


- (void)ess_mainThreadGuard_setNeedsDisplay {
    [self ess_mainThreadGuard];
    [self ess_mainThreadGuard_setNeedsDisplay];
}


- (void)ess_mainThreadGuard_setNeedsDisplayInRect:(CGRect)rect {
    [self ess_mainThreadGuard];
    [self ess_mainThreadGuard_setNeedsDisplayInRect:rect];
}





@end
