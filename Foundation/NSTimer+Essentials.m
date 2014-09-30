//
//  NSTimer+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 29.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSTimer+Essentials.h"





@implementation NSTimer (Essentials)





#pragma mark - Block-Based Timers


- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void(^)(NSTimer *timer))handler {
    return [self initWithFireDate:date interval:interval target:[self class] selector:@selector(ess_invokeUserInfoBlockHandler:) userInfo:handler repeats:repeats];
}


+ (instancetype)scheduledWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void(^)(NSTimer *timer))handler {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(ess_invokeUserInfoBlockHandler:) userInfo:handler repeats:repeats];
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



@end


