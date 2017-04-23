//
//  UITableView+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 22.9.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UITableView+Essentials.h"





@implementation UITableView (Essentials)




- (void)updates:(void(^)(void))block {
    [self beginUpdates];
    block();
    [self endUpdates];
}


- (void)reloadDataAndFlashScrolIndicators {
    [self reloadData];
    [self flashScrollIndicators];
}


- (void)endUpdatesAndFlashScrolIndicators {
    [self endUpdates];
    [self flashScrollIndicators];
}


- (void)updatesAndFlashScrollIndicators:(void(^)(void))block {
    [self updates:block];
    [self flashScrollIndicators];
}


- (void)deselectRowsAnimated:(BOOL)animated {
    for (NSIndexPath *indexPath in [self.indexPathsForSelectedRows copy]) {
        [self deselectRowAtIndexPath:indexPath animated:animated];
    }
}


- (NSArray<NSIndexPath *> *)indexPathsForSection:(NSUInteger)section {
    CGRect rect = [self rectForSection:section];
    return [self indexPathsForRowsInRect:rect];
}

- (NSArray<NSIndexPath *> *)allIndexPaths {
    CGRect content = {
        .size = self.contentSize,
    };
    return [self indexPathsForRowsInRect:content];
}



@end
