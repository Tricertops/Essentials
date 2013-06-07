//
//  NSMutableArray+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSMutableArray (Essentials)



/// Removes all objects from the receiver for which the block returns NO. Method returns receiver.
- (NSMutableArray *)filter:(BOOL(^)(id object))block;

/// Removes all objects from the receiver for which the block returns NO. Method returns receiver.
- (NSMutableArray *)filterIndex:(BOOL(^)(NSUInteger index, id object))block;
    
    
    
@end
