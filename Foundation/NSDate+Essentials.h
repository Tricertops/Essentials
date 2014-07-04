//
//  NSDate+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 13.10.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>






@interface NSDate (Essentials)



#pragma mark - Comparisons

/// Whether the receiver comes before the argument.
- (BOOL)isBefore:(NSDate *)date;
/// Whether the receiver comes after the argument.
- (BOOL)isAfter:(NSDate *)date;
/// Whether the receiver is earlier than current date.
- (BOOL)isPast;
/// Whether the receiver is later than current date.
- (BOOL)isFuture;



#pragma mark - Timestamps

/// Shorter alias for -dateWithTimeIntervalSinceReferenceDate:
+ (instancetype)dateWithTimestamp:(NSTimeInterval)timestamp;
/// Shorter alias for -dateWithTimeIntervalSince1970:
+ (instancetype)dateWithUNIXTimestamp:(NSTimeInterval)unixTimestamp;

/// Shorter alias for -timeIntervalSinceReferenceDate
@property (atomic, readonly, assign) NSTimeInterval timestamp;
/// Shorter alias for -timeIntervalSince1970
@property (atomic, readonly, assign) NSTimeInterval UNIXTimestamp;

/// Returns current date.
+ (instancetype)now;

/// Shorter alias for +timeIntervalSinceReferenceDate
+ (NSTimeInterval)timestamp;

/// Returns time interval since UNIX epoch.
+ (NSTimeInterval)UNIXTimestamp;

/// Returns current date rounded to the beginning of the day.
+ (NSDate *)midnight;

/// Returns receiver rounded to the beginning of the day.
- (NSDate *)midnight;



#pragma mark - Components

/// Returns given date components using current calendar.
- (NSDateComponents *)components:(NSCalendarUnit)units;

/// Returns given date components between the receiver and other date using current calendar.
- (NSDateComponents *)components:(NSCalendarUnit)units toDate:(NSDate *)other;

/// Returns start date of calendar unit in which is the reciever.
- (NSDate *)startDateOfComponent:(NSCalendarUnit)unit;

/// Returns duration of calendar unit in which is the reciever.
- (NSTimeInterval)durationOfComponent:(NSCalendarUnit)unit;

/// Returns end date of calendar unit in which is the reciever.
- (NSDate *)endDateOfComponent:(NSCalendarUnit)unit;



#pragma mark - Debug

/// Invokes the block while measuring its execution time. Returns the measured time and optionally log it to the console.
+ (NSTimeInterval)measureTime:(void(^)(void))block log:(NSString *)logName;



@end
