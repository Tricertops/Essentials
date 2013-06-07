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



@end
