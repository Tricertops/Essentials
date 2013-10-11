//
//  UIView+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIView+Essentials.h"





@implementation UIView (Essentials)





#pragma mark - Snapshots


- (UIImage *)snapshot {
    return [self snapshotWithScale:0];
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
    self.shadowColor = shadow.shadowColor;
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
    return [NSSet setWithObjects:@"layer.shadowOffset", @"shadow.shadowOffset", nil];
}


- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}


- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}


+ (NSSet *)keyPathsForValuesAffectingShadowColor {
    return [NSSet setWithObjects:@"layer.shadowColor", @"shadow.shadowColor", nil];
}


- (CGFloat)shadowBlurRadius {
    return self.layer.shadowRadius;
}


- (void)setShadowBlurRadius:(CGFloat)shadowBlurRadius {
    self.layer.shadowRadius = shadowBlurRadius;
}


+ (NSSet *)keyPathsForValuesAffectingShadowBlurRadius {
    return [NSSet setWithObjects:@"layer.shadowRadius", @"shadow.shadowBlurRadius", nil];
}


- (CGFloat)shadowAlpha {
    return self.layer.shadowOpacity;
}


- (void)setShadowAlpha:(CGFloat)shadowAlpha {
    self.layer.shadowOpacity = shadowAlpha;
}


+ (NSSet *)keyPathsForValuesAffectingShadowAlpha {
    return [NSSet setWithObjects:@"layer.shadowOpacity", @"shadow.shadowColor", nil];
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





@end
