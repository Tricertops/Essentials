//
//  NSOperationQueue+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>


//TODO: Separate CLI convenience, barriers and regular methods
//TODO: Accessors and constructors for QoS values
//TODO: Swizzle smart description?
//TODO: -perform: with smart detection and avoid enqueueing
//TODO: Something for parralel execution



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



#pragma mark - General

/// Shared parallel queue.
+ (instancetype)backgroundQueue;

/// Executes blocks submitted to the main queue. This methos "parks" the main thread and waits for blocks to be submitted to the main queue.
+ (void)runMainQueue;

//TODO: Remove Exit Operation mechanism?
/// This method calls `runMainQueue`, but it causes the program to exit when all operations submitted to any queue are finished. Exitting waits for all operations submitted AFTER calling this method AND those already in the receving queue. This method is intended to be used by CLI programs that takes advantage of operation queues. You can provide a block that will be called just before calling `exit(0)`.
- (void)runMainQueueUntilAllQueuesAreEmptyWithFinalBlock:(void(^)(void))finalBlock;

/// Uses dispatch_after to delay execution of the block on dispatch queue with default priority. Doesn't use any NSOperationQueue, so can be called by operations on serial queues without being deadlocked.
+ (void)after:(NSTimeInterval)delay block:(void(^)(void))block;

/// Whether the receiver is current queue.
- (BOOL)isCurrent;



//TODO: Better names for methods, maybe swizzle original names?

#pragma mark - Operations

/// Adds block operation to the receiver and returns it. The operation is returned, so can be cancelled or waited. This method respects Barriers.
- (NSOperation *)asynchronous:(void(^)(void))block;

/// Delays call to -asynchronous: using given block. The operation is returned immediatelly, so can be cancelled or waited. This method respects Barriers.
- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block;

/// Can be used to enqueue custom operation with respect to Barriers.
- (void)addAsynchronousOperation:(NSOperation *)operation;



#pragma mark - Barriers

/// Add block operation that will be executed after all existing operations (including other Barriers) are finished. The operation is returned, so can be cancelled or waited.
- (NSOperation *)asynchronousBarrier:(void(^)(void))block;

/// Delays call to -asynchronousBarrier: using given block. The operation is returned immediatelly, so can be cancelled or waited.
- (NSOperation *)delay:(NSTimeInterval)delay asynchronousBarrier:(void(^)(void))block;

/// Can be used to use custom operation as a Barrier.
- (void)addAsynchronousBarrier:(NSOperation *)barrier;





@end
