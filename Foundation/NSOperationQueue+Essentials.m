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





#pragma mark - Creation & Shared


ESSSharedMake(NSOperationQueue *, interactiveQueue) {
    return [self queueWithName:@"UserInteractive" concurrent:YES qualityOfService:NSQualityOfServiceUserInteractive];
}


ESSSharedMake(NSOperationQueue *, userQueue) {
    return [self queueWithName:@"UserInitiated" concurrent:YES qualityOfService:NSQualityOfServiceUserInitiated];
}


ESSSharedMake(NSOperationQueue *, utilityQueue) {
    return [self queueWithName:@"Utility" concurrent:YES qualityOfService:NSQualityOfServiceUtility];
}


ESSSharedMake(NSOperationQueue *, backgroundQueue) {
    return [self queueWithName:@"Background" concurrent:YES qualityOfService:NSQualityOfServiceBackground];
}


+ (instancetype)queueWithName:(NSString *)nameSuffix concurrent:(BOOL)isConcurrent qualityOfService:(NSQualityOfService)qos {
    NSOperationQueue *queue = [NSOperationQueue new];
    NSString *appID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    queue.name = [appID stringByAppendingFormat:@".%@", nameSuffix ?: [[NSUUID UUID] UUIDString]];
    queue.maxConcurrentOperationCount = (isConcurrent? NSOperationQueueDefaultMaxConcurrentOperationCount : 1);
    if ([queue respondsToSelector:@selector(setQualityOfService:)]) {
        queue.qualityOfService = qos;
    }
    return queue;
}




- (BOOL)isCurrent {
    return (self == [NSOperationQueue currentQueue]);
}





#pragma mark - Operations


- (NSOperation *)perform:(void(^)(void))block {
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    if (self == [NSOperationQueue currentQueue]) {
        [operation start];
    }
    else {
        [self addOperation:operation];
    }
    return operation;
}


- (NSOperation *)asynchronous:(void(^)(void))block {
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [self addOperation:operation];
    return operation;
}


- (NSOperation *)delay:(NSTimeInterval)delay asynchronous:(void(^)(void))block {
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [NSTimer after:delay block:^{
        [self addOperation:operation];
    }];
    return operation;
}





+ (void)parallel:(NSUInteger)count block:(void (^)(NSUInteger))block {
    dispatch_apply(count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        block(index);
    });
}





#pragma mark - Deprecated


+ (instancetype)queueWithNameSuffix:(NSString *)nameSuffix {
    return [self queueWithName:nameSuffix concurrent:YES qualityOfService:NSQualityOfServiceBackground];
}


+ (instancetype)serialQueueWithNameSuffix:(NSString *)nameSuffix {
    return [self queueWithName:nameSuffix concurrent:NO qualityOfService:NSQualityOfServiceBackground];
}


+ (instancetype)parallelQueueWithNameSuffix:(NSString *)nameSuffix {
    return [self queueWithName:nameSuffix concurrent:YES qualityOfService:NSQualityOfServiceBackground];
}


- (instancetype)initWithNameSuffix:(NSString *)nameSuffix {
    return [self.class queueWithName:nameSuffix concurrent:YES qualityOfService:NSQualityOfServiceBackground];
}


- (instancetype)initWithNameSuffix:(NSString *)nameSuffix numberOfConcurrentOperations:(NSUInteger)concurrent {
    NSOperationQueue *queue = [self.class queueWithName:nameSuffix concurrent:YES qualityOfService:NSQualityOfServiceBackground];
    queue.maxConcurrentOperationCount = concurrent;
    return queue;
}





@end
