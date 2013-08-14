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









@end
