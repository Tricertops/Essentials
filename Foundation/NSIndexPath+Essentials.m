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


+ (NSArray<NSIndexPath *> *)indexPathsFromRowsInIndexSet:(NSIndexSet *)indexes inSection:(NSUInteger)section {
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger row, BOOL *stop) {
        NSUInteger indexes[2] = { section, row };
        [indexPaths addObject:[NSIndexPath indexPathWithIndexes:indexes length:2]];
    }];
    return indexPaths;
}


+ (NSArray<NSIndexPath *> *)indexPathsFromRowsInRange:(NSRange)range inSection:(NSUInteger)section {
    return [self indexPathsFromRowsInIndexSet:[NSIndexSet indexSetWithIndexesInRange:range] inSection:section];
}





@end


