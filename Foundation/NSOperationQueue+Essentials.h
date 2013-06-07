//
//  NSOperationQueue+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSOperationQueue (Essentials)



#pragma mark - Creation

/// Shorthand for -initWithNameSuffix:
+ (instancetype)queueWithNameSuffix:(NSString *)nameSuffix;

/// Initialize new instance and compose the name by appentign given name suffix to application identifier. Example: com.iAdverti.App.nameSuffix
- (id)initWithNameSuffix:(NSString *)nameSuffix;



#pragma mark - Blocks

/// Adds block operation to the receiver and returns it.
- (NSOperation *)asynchronous:(void(^)(void))block;

/// Adds block operation to the receiver and waits until it is completed. Deadlock safe, so can be used on the current operation queue.
- (void)synchronous:(void(^)(void))block;



#pragma mark - Delayed

/// Delays call to -asynchronous: using given block.
- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block;



@end
