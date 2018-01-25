//
//  NSOperationQueue+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"





@interface NSOperationQueue (Essentials)



#pragma mark - Creation & Shared

//! Shared concurrent queue with User Interactive QoS, use for animations.
+ (instancetype)interactiveQueue;
//! Shared concurrent queue with User Initiated QoS, use for loading content tasks.
+ (instancetype)userQueue;
//! Shared concurrent queue with Utility QoS, use for data processing tasks.
+ (instancetype)utilityQueue;
//! Shared concurrent queue with Background QoS, use for invisible tasks.
+ (instancetype)backgroundQueue;

/// Returns new queue with given QoS, cocurrency and composed name by appenting given suffix to app ID. Example: com.iAdverti.App.nameSuffix
+ (instancetype)queueWithName:(NSString *)nameSuffix concurrent:(BOOL)isConcurrent qualityOfService:(NSQualityOfService)qos;


/// Whether the receiver is the current queue.
- (BOOL)isCurrent;


#pragma mark - Operations

/// A number of concurrent operations used for Shared Queues.
+ (NSUInteger)defaultMaxConcurrentOperationCount;

/// Performs given block on the receiver. Async or sync, depends on circumstances.
- (NSOperation *)perform:(void(^)(void))block;

/// Adds block operation to the receiver and returns it, so it can be cancelled or waited for.
- (NSOperation *)asynchronous:(void(^)(void))block;

/// Delays call to -asynchronous:. The operation is returned immediatelly, so can be cancelled or waited.
- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block;


/// First block is invoked on the receiver queue and the returned result is then passed to the second block on current queue.
- (NSOperation *)asynchronous:(id (^)(void))block then:(void(^)(id x))block;


/// Performs given block multiple times and then returns.
+ (void)parallel:(NSUInteger)count block:(void(^)(NSUInteger index))block;


#pragma mark - Deprecated

+ (instancetype)queueWithNameSuffix:(NSString *)nameSuffix __deprecated;
+ (instancetype)serialQueueWithNameSuffix:(NSString *)nameSuffix __deprecated;
+ (instancetype)parallelQueueWithNameSuffix:(NSString *)nameSuffix __deprecated;
- (instancetype)initWithNameSuffix:(NSString *)nameSuffix __deprecated;
- (instancetype)initWithNameSuffix:(NSString *)nameSuffix numberOfConcurrentOperations:(NSUInteger)concurrent __deprecated;





@end
