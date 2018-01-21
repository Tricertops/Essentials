//
//  UIScrollView+Essentials.h
//  Essentials
//
//  Created by Juraj Homola on 26.6.2013.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIScrollView (Essentials)



#pragma mark - Structs Adjustments

/// Allows you to quickly adjust content inset.
- (void)adjustContentInset:(void(^)(UIEdgeInsets *insets))block;

/// Allows you to quickly adjust scroll indicator insets.
- (void)adjustScrollIndicatorInsets:(void(^)(UIEdgeInsets *insets))block;

/// Allows you to quickly adjust content size.
- (void)adjustContentSize:(void(^)(CGSize *size))block;



#pragma mark - Content Position

/// Maximum value the content offset can contain (excluding bouncing) in current content size and bounds.
@property (readonly) CGPoint maximumContentOffset;

@property CGPoint contentProgressOffset;

/// Point with values from 0 to 1 (plus bouncing) specifying relative content offset in the content size. Takes into account content insets.
@property CGPoint contentProgress;

/// Provides current bouncing in all directions. Values are never negative and takes into account content insets.
@property (readonly) UIEdgeInsets bouncingInsets;

/// Horizontal page index. This is in fact floating point number, not just page index. Can be used for tracking progress between two pages.
@property CGFloat page;

/// Accessor for .contentInsets.top
@property CGFloat contentInsetTop;

/// Accessor for .scrollIndicatorinsets.top
@property CGFloat scrollIndicatorInsetTop;

/// Backward compatible accessor for .adjustedContentInset
@property (readonly) UIEdgeInsets effectiveContentInsets;



#pragma mark - Touch Handling

/// Cause all scroll views to cancel touches in UIButton subviews. This is the same behavior as with UITableViewCells.
+ (void)enableNaturalButtonHandling;

/// Pauses running scroll animation.
- (void)stopScrolling;



@end
