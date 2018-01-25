//
//  NSIndexPath+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 11.7.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



@interface NSIndexPath (Essentials)


#pragma mark - Multiple

+ (NSArray<NSIndexPath *> *)indexPathsForRowsInIndexSet:(NSIndexSet *)indexes inSection:(NSUInteger)section;
+ (NSArray<NSIndexPath *> *)indexPathsForRowsInRange:(NSRange)range inSection:(NSUInteger)section;


@end


