//
//  NSMutableArray+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSMutableArray (Essentials)




#pragma mark Mapping

///
- (NSMutableArray *)replace:(id(^)(id object))block;

///
- (NSMutableArray *)replaceIndex:(id(^)(NSUInteger index, id object))block;



#pragma mark Nester Arrays

- (NSMutableArray *)flatten;



#pragma mark Filtering

/// Removes all objects from the receiver for which the block returns NO. Method returns receiver.
- (NSMutableArray *)filter:(BOOL(^)(id object))block;

/// Removes all objects from the receiver for which the block returns NO. Method returns receiver.
- (NSMutableArray *)filterIndex:(BOOL(^)(NSUInteger index, id object))block;
    

#pragma mark Randomize

/// Changes positions of all objects in array, in random order. Method returns reordered array.
- (NSMutableArray *)randomizeOrder;



@end




