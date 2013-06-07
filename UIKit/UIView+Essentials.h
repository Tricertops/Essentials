//
//  UIView+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>





@interface UIView (Essentials)



#pragma mark - Snapshots

/// Returns snapshot of the receiver with screen scale.
- (UIImage *)snapshot;

/// Returns snapshot of the receiver with given scale.
- (UIImage *)snapshotWithScale:(CGFloat)scale;

/// Returns image view containing snapshot of the receiver.
- (UIImageView *)makeSnapshotImageView;

/// Creates snapshot image view and inserts it just above the receiver. This is intended to be invisible action for the user.
- (UIImageView *)overlayWithSnapshotImageView;



#pragma mark - Corner Radius

/// Forwards to the underlaying layer.
@property (nonatomic, readwrite) CGFloat cornerRadius;



#pragma mark - Structs Adjustments

/// Allows you to quickly adjust frame.
- (void)adjustFrame:(void(^)(CGRect *))block;

/// Allows you to quickly adjust bounds.
- (void)adjustBounds:(void(^)(CGRect *))block;

/// Allows you to quickly adjust center.
- (void)adjustCenter:(void(^)(CGPoint *))block;

/// Allows you to quickly adjust transform.
- (void)adjustTransform:(CGAffineTransform(^)(CGAffineTransform))block;



@end
