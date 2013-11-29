//
//  NSOperationQueue+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSOperationQueue+Essentials.h"
#import "Foundation+Essentials.h"
#import "NSObject+Essentials.h"





@implementation NSOperationQueue (Essentials)





#pragma mark - Creation


+ (instancetype)queueWithNameSuffix:(NSString *)nameSuffix {
    return [[self alloc] initWithNameSuffix:nameSuffix];
}


+ (instancetype)serialQueueWithNameSuffix:(NSString *)nameSuffix {
    return [[self alloc] initWithNameSuffix:nameSuffix numberOfConcurrentOperations:1];
}


+ (instancetype)parallelQueueWithNameSuffix:(NSString *)nameSuffix {
    return [[self alloc] initWithNameSuffix:nameSuffix numberOfConcurrentOperations:NSOperationQueueDefaultMaxConcurrentOperationCount];
}


- (instancetype)initWithNameSuffix:(NSString *)nameSuffix {
    return [self initWithNameSuffix:nameSuffix numberOfConcurrentOperations:1];
}


- (instancetype)initWithNameSuffix:(NSString *)nameSuffix numberOfConcurrentOperations:(NSUInteger)concurrent {
    self = [self init];
    if (self) {
        NSString *appIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
        self.name = [appIdentifier stringByAppendingFormat:@".%@", nameSuffix ?: [[NSUUID UUID] UUIDString]];
        self.maxConcurrentOperationCount = concurrent;
    }
    return self;
}





#pragma mark - Shared


ESSSharedMake(NSOperationQueue *, backgroundQueue) {
    return [NSOperationQueue parallelQueueWithNameSuffix:@"sharedBackgroundQueue"];
}


+ (void)runMainQueue {
    ESSAssertException([NSThread isMainThread], @"Must be called on Main Thread.");
    // To the infinity ...
    dispatch_main();
    // ... and beyond.
}


static NSOperation * NSOperationQueueExitOperation = nil;

- (void)runMainQueueUntilAllQueuesAreEmptyWithFinalBlock:(void(^)(void))finalBlock {
    NSOperationQueueExitOperation = [[NSBlockOperation subclass:@"ESSExitOperation"] blockOperationWithBlock:^{
        if (finalBlock) finalBlock();
        exit(EXIT_SUCCESS);
    }];
    
    for (NSOperation *operation in self.operations) {
        [NSOperationQueue addExitDependencyOperation:operation];
    }
    
    [self addOperation:NSOperationQueueExitOperation];
    [NSOperationQueue runMainQueue];
}


+ (void)addExitDependencyOperation:(NSOperation *)operation {
    if ( ! NSOperationQueueExitOperation) return;
    if (operation == NSOperationQueueExitOperation) return;
    if ([NSOperationQueueExitOperation.dependencies containsObject:operation]) return;
    
    [NSOperationQueueExitOperation addDependency:operation];
}


+ (void)after:(NSTimeInterval)delay block:(void(^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}





#pragma mark - Current


- (BOOL)isCurrent {
    return (self == [NSOperationQueue currentQueue]);
}





#pragma mark - Operations


//TODO: NSOperation+Essentials
- (void)addDependencies:(id<NSFastEnumeration>)dependencies toOperation:(NSOperation *)operation {
    if (operation == NSOperationQueueExitOperation) return;
    
    for (NSOperation *dependency in dependencies) {
        if (dependency == NSOperationQueueExitOperation) continue;
        if (operation == dependency) continue;
        
        BOOL alreadyThere = [operation.dependencies containsObject:dependency];
        if ( ! alreadyThere) {
            [operation addDependency:dependency];
        }
    }
}


- (NSOperation *)asynchronous:(void(^)(void))block {
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [self addAsynchronousOperation:operation];
    return operation;
}


- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block {
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [NSOperationQueue after:delay block:^{
        [self addAsynchronousOperation:operation];
    }];
    return operation;
}


- (void)addAsynchronousOperation:(NSOperation *)operation {
    [self addDependencies:[self barriers] toOperation:operation];
    [self addOperation:operation];
    [NSOperationQueue addExitDependencyOperation:operation];
}





#pragma mark - Barriers


ESSSynthesizeStrongMake(NSHashTable *, barriers, setBarriers) {
    return [NSHashTable weakObjectsHashTable];
}


- (NSOperation *)asynchronousBarrier:(void (^)(void))block {
    NSOperation *barrier = [NSBlockOperation blockOperationWithBlock:block];
    [self addAsynchronousBarrier:barrier];
    return barrier;
}


- (NSOperation *)delay:(NSTimeInterval)delay asynchronousBarrier:(void (^)(void))block {
    NSOperation *barrier = [NSBlockOperation blockOperationWithBlock:block];
    [NSOperationQueue after:delay block:^{
        [self addAsynchronousBarrier:barrier];
    }];
    return barrier;
}


- (void)addAsynchronousBarrier:(NSOperation *)barrier {
    [self addDependencies:self.operations toOperation:barrier];
    [[self barriers] addObject:barrier];
    [self addOperation:barrier];
    [NSOperationQueue addExitDependencyOperation:barrier];
}





@end
