//
//  NSTimer+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 29.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSTimer+Essentials.h"
#if TARGET_OS_IPHONE
    #import <UIKit/UIApplication.h>
#endif





@implementation NSTimer (Essentials)





#pragma mark - Block-Based Timers


- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void(^)(NSTimer *timer))handler {
    return [self initWithFireDate:date interval:interval target:[self class] selector:@selector(ess_invokeUserInfoBlockHandler:) userInfo:handler repeats:repeats];
}


+ (instancetype)scheduledWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void(^)(NSTimer *timer))handler {
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(ess_invokeUserInfoBlockHandler:) userInfo:handler repeats:repeats];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
#if TARGET_OS_IPHONE
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
#endif
    return timer;
}


+ (void)ess_invokeUserInfoBlockHandler:(NSTimer *)timer {
    void(^handler)(NSTimer *) = timer.userInfo;
    if (handler) handler(timer);
}





#pragma mark - Scheduling


- (void)schedule {
    [self scheduleInRunLoop:nil mode:nil];
}


- (void)scheduleInRunLoop:(NSRunLoop *)runLoop mode:(NSString *)mode {
    NSRunLoop *someRunLoop = runLoop ?: [NSRunLoop currentRunLoop];
    [someRunLoop addTimer:self forMode:mode ?: NSDefaultRunLoopMode];
}


- (void)postponeBy:(NSTimeInterval)delay {
    self.fireDate = [self.fireDate dateByAddingTimeInterval:delay];
}


- (void)hold {
    self.fireDate = [NSDate distantFuture];
}





+ (void)after:(NSTimeInterval)delay block:(void(^)(void))block {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, time, 0, 0);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_source_cancel(timer);
        
        block();
    });
    dispatch_resume(timer);
}





@end


