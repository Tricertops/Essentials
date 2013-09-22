//
//  UITableView+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 22.9.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UITableView (Essentials)


/// Grouping begin/end updates calls into block.
- (void)updates:(void(^)(void))block;

/// For you not to forget about flashing scroll indicators.
- (void)reloadDataAndFlashScrolIndicators;
- (void)endUpdatesAndFlashScrolIndicators;
- (void)updatesAndFlashScrollIndicators:(void(^)(void))block;
/// You are welcome!


/// Because deselecting other than selected doesn't make sense.
- (void)deselectRowsAnimated:(BOOL)animated;


@end
