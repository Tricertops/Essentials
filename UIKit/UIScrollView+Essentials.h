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



#pragma mark Content Progress

@property (nonatomic, readwrite, assign) CGPoint contentProgress;



@end
