//
//  NSMutableArray+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSMutableArray<T> (Essentials)





#pragma mark - Mutating

/// Inserts a given object at the end of the array. If the object is nil, does nothing.
- (void)addObjectIfAny:(T)object;





#pragma mark Mapping

///
- (instancetype)replace:(id(^)(T object))block;

///
- (instancetype)replaceIndex:(id(^)(NSUInteger index, T object))block;



#pragma mark Nester Arrays

- (NSMutableArray<id> *)flatten;



#pragma mark Filtering

/// Removes all objects from the receiver for which the block returns NO. Method returns receiver.
- (instancetype)filter:(BOOL(^)(T object))block;

/// Removes all objects from the receiver for which the block returns NO. Method returns receiver.
- (instancetype)filterIndex:(BOOL(^)(NSUInteger index, T object))block;
    

#pragma mark Randomize

/// Changes positions of all objects in array, in random order. Method returns reordered array.
- (instancetype)randomizeOrder;



@end




