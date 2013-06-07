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





@end
