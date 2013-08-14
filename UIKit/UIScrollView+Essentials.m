//
//  UIScrollView+Essentials.m
//  Essentials
//
//  Created by Juraj Homola on 26.6.2013.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIScrollView+Essentials.h"





@implementation UIScrollView (Essentials)





#pragma mark - Structs Adjustments


- (void)adjustContentInset:(void (^)(UIEdgeInsets *))block {
    UIEdgeInsets contentInset = self.contentInset;
    block(&contentInset);
    self.contentInset = contentInset;
}


- (void)adjustScrollIndicatorInsets:(void (^)(UIEdgeInsets *))block {
    UIEdgeInsets scrollIndicatorInsets = self.scrollIndicatorInsets;
    block(&scrollIndicatorInsets);
    self.scrollIndicatorInsets = scrollIndicatorInsets;
}





#pragma mark Maximum Content Offset


- (CGPoint)maximumContentOffset {
    CGRect viewport = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    CGSize boundsSize = viewport.size;
    CGSize contentSize = self.contentSize;
    
    CGPoint maximumContentOffset = {
        .x = MAX(contentSize.width - boundsSize.width, 0),
        .y = MAX(contentSize.height - boundsSize.height, 0),
    };
    return maximumContentOffset;
}


+ (NSSet *)keyPathsForValuesAffectingMaximumContentOffset {
    return [NSSet setWithObjects:@"contentSize", @"bounds", nil];
}





#pragma mark Content Progress Offset


- (CGPoint)contentProgressOffset {
    CGPoint contentOffset = self.contentOffset;
    UIEdgeInsets contentInset = self.contentInset;
    CGPoint offset = {
        .x = contentOffset.x + contentInset.left,
        .y = contentOffset.y + contentInset.top,
    };
    return offset;
}


- (void)setContentProgressOffset:(CGPoint)contentProgressOffset {
    UIEdgeInsets contentInset = self.contentInset;
    CGPoint offset = {
        .x = contentProgressOffset.x - contentInset.left,
        .y = contentProgressOffset.y - contentInset.top,
    };
    self.contentOffset = offset;
}


+ (NSSet *)keyPathsForValuesAffectingContentProgressOffset {
    return [NSSet setWithObjects:@"contentOffset", @"contentInset", nil];
}





#pragma mark Content Progress


- (CGPoint)contentProgress {
    CGPoint maximumContentOffset = self.maximumContentOffset;
    CGPoint contentOffset = self.contentProgressOffset;
    CGPoint contentProgress = {
        .x = (maximumContentOffset.x > 0? contentOffset.x / maximumContentOffset.x : 0),
        .y = (maximumContentOffset.y > 0? contentOffset.y / maximumContentOffset.y : 0),
    };
    return contentProgress;
}


- (void)setContentProgress:(CGPoint)contentProgress {
    CGPoint maximumContentOffset = self.maximumContentOffset;
    CGPoint contentOffset = {
        .x = maximumContentOffset.x * contentProgress.x,
        .y = maximumContentOffset.y * contentProgress.y,
    };
    self.contentProgressOffset = contentOffset;
}


+ (NSSet *)keyPathsForValuesAffectingContentProgress {
    return [NSSet setWithObjects:@"contentProgressOffset", @"maximumContentOffset", nil];
}





#pragma mark Bouncing Insets


- (UIEdgeInsets)bouncingInsets {
    CGPoint contentOffset = self.contentProgressOffset;
    CGPoint maximumContentOffset = self.maximumContentOffset;
    
    UIEdgeInsets bouncingInsets = {
        .left = MAX(-contentOffset.x, 0),
        .top = MAX(-contentOffset.y, 0),
        .right = MAX(contentOffset.x - maximumContentOffset.x, 0),
        .bottom = MAX(contentOffset.y - maximumContentOffset.y, 0),
    };
    return bouncingInsets;
}


+ (NSSet *)keyPathsForValuesAffectingBouncingInsets {
    return [NSSet setWithObjects:@"contentProgressOffset", @"maximumContentOffset", nil];
}





#pragma mark Page


- (CGFloat)page {
    if ( self.bounds.size.width <= 0) return 0;
    return self.bounds.origin.x / self.bounds.size.width;
}


- (void)setPage:(CGFloat)page {
    CGRect bounds = self.bounds;
    bounds.origin.x = page * bounds.size.width;
    self.bounds = bounds;
}


+ (NSSet *)keyPathsForValuesAffectingPage {
    return [NSSet setWithObjects:@"bounds", nil];
}





@end
