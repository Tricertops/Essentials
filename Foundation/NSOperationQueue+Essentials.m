//
//  NSOperationQueue+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSOperationQueue+Essentials.h"
#import "Foundation+Essentials.h"





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





#pragma mark - Blocks


- (NSOperation *)asynchronous:(void(^)(void))block {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [self addOperation:operation];
    return operation;
}


- (void)synchronous:(void(^)(void))block {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    if (self == [NSOperationQueue currentQueue]) {
        [operation start];
    }
    else {
        [self addOperation:operation];
        [operation waitUntilFinished];
    }
}





#pragma mark - Delayed


- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [self performSelector:@selector(addOperation:) withObject:operation afterDelay:delay inModes:@[NSRunLoopCommonModes]];
    return operation;
}





@end
