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

/// Shorthand for -initWithNameSuffix:numberOfConcurrentOperations: with 1 concurrent operation.
+ (instancetype)serialQueueWithNameSuffix:(NSString *)nameSuffix;

/// Shorthand for -initWithNameSuffix:numberOfConcurrentOperations: with default number of concurrent operation.
+ (instancetype)parallelQueueWithNameSuffix:(NSString *)nameSuffix;

/// Initialize new instance of serial queue.
- (instancetype)initWithNameSuffix:(NSString *)nameSuffix;

/// Initialize new instance and compose the name by appenting given name suffix to application identifier. Example: com.iAdverti.App.nameSuffix
- (instancetype)initWithNameSuffix:(NSString *)nameSuffix numberOfConcurrentOperations:(NSUInteger)concurrent;



#pragma mark - Shared

/// Shared parallel queue.
+ (instancetype)backgroundQueue;



#pragma mark - Blocks

/// Adds block operation to the receiver and returns it.
- (NSOperation *)asynchronous:(void(^)(void))block;

/// Adds block operation to the receiver and waits until it is completed. Deadlock safe, so can be used on the current operation queue.
- (void)synchronous:(void(^)(void))block;



#pragma mark - Delayed

/// Delays call to -asynchronous: using given block.
- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block;



@end
