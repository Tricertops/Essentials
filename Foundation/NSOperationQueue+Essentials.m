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





#pragma mark - Current


- (BOOL)isCurrent {
    return (self == [NSOperationQueue currentQueue]);
}





#pragma mark - Operations


//TODO: NSOperation+Essentials
- (void)addDependencies:(id<NSFastEnumeration>)dependencies toOperation:(NSOperation *)operation {
    for (NSOperation *dependency in dependencies) {
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
    [self performSelector:@selector(addAsynchronousOperation:)
               withObject:operation
               afterDelay:delay
                  inModes:@[NSRunLoopCommonModes]];
    return operation;
}


- (void)addAsynchronousOperation:(NSOperation *)operation {
    [self addDependencies:[self barriers] toOperation:operation];
    [self addOperation:operation];
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
    [self performSelector:@selector(addAsynchronousBarrier:)
               withObject:block
               afterDelay:delay
                  inModes:@[NSRunLoopCommonModes]];
    return barrier;
}


- (void)addAsynchronousBarrier:(NSOperation *)barrier {
    [self addDependencies:self.operations toOperation:barrier];
    [[self barriers] addObject:barrier];
    [self addOperation:barrier];
}





@end
