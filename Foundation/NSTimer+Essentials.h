//
//  NSTimer+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 29.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSTimer (Essentials)




#pragma mark - Creating Block-Based Timers

/// Initializes a new NSTimer object using the specified block handler.
- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void(^)(NSTimer *timer))handler;

/// Creates and returns a new NSTimer object and schedules it on the current run loop in the default mode.
+ (instancetype)scheduledWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats handler:(void(^)(NSTimer *timer))handler;



#pragma mark - Scheduling

/// Schedules the receiver on the current run loop in the default mode.
- (void)schedule;

/// Schedules the receiver on the specified run loop in given mode.
- (void)scheduleInRunLoop:(NSRunLoop *)runLoop mode:(NSString *)mode;


/// Invokes block after delay.
+ (void)after:(NSTimeInterval)delay block:(void(^)(void))block;



@end


