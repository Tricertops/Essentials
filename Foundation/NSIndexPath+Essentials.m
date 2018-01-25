//
//  NSIndexPath+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 11.7.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSIndexPath+Essentials.h"





@implementation NSIndexPath (Essentials)





#pragma mark - Multiple


+ (NSArray<NSIndexPath *> *)indexPathsForRowsInIndexSet:(NSIndexSet *)indexes inSection:(NSUInteger)section {
    var indexPaths = [NSMutableArray<NSIndexPath *> new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger row, BOOL *stop) {
        NSUInteger indexes[2] = { section, row };
        [indexPaths addObject:[NSIndexPath indexPathWithIndexes:indexes length:2]];
    }];
    return indexPaths;
}


+ (NSArray<NSIndexPath *> *)indexPathsForRowsInRange:(NSRange)range inSection:(NSUInteger)section {
    return [self indexPathsForRowsInIndexSet:[NSIndexSet indexSetWithIndexesInRange:range] inSection:section];
}





@end


