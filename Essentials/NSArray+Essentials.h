//
//  NSArray+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSArray (Essentials)



/// Returns new array with mapped objects using given block. The block takes object.
- (NSArray *)map:(id(^)(id object))block;

/// Returns new array with mapped objects using given block. The block takes index and object.
- (NSArray *)mapIndex:(id(^)(NSUInteger index, id object))block;



@end
