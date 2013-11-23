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



#pragma mark - Operations

/// Adds block operation to the receiver and returns it. The operation is returned, so can be cancelled or waited. This method respects Barriers.
- (NSOperation *)asynchronous:(void(^)(void))block;

/// Delays call to -asynchronous: using given block. The operation is returned immediatelly, so can be cancelled or waited. This method respects Barriers.
- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block;

/// Can be used to enqueue custom operation with respect to Barriers.
- (void)addAsynchronousOperation:(NSOperation *)operation;


/// Adds block operation to the receiver and waits until it is completed. Deadlock safe, so can be used on the current operation queue.
- (void)synchronous:(void(^)(void))block __attribute__((deprecated("Use -asynchronous: and then -waitUntilCompleted instead.")));



#pragma mark - Barriers

/// Add block operation that will be executed after all existing operations (including other Barriers) are finished. The operation is returned, so can be cancelled or waited.
- (NSOperation *)asynchronousBarrier:(void(^)(void))block;

/// Delays call to -asynchronousBarrier: using given block. The operation is returned immediatelly, so can be cancelled or waited.
- (NSOperation *)delay:(NSTimeInterval)delay asynchronousBarrier:(void(^)(void))block;

/// Can be used to use custom operation as a Barrier.
- (void)addAsynchronousBarrier:(NSOperation *)barrier;





@end
