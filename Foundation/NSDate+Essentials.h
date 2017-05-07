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

/// Shorter alias for -dateWithTimeIntervalSinceNow:
+ (instancetype)after:(NSTimeInterval)interval;

/// Shorter alias for +timeIntervalSinceReferenceDate
+ (NSTimeInterval)timestamp;

/// Returns time interval since UNIX epoch.
+ (NSTimeInterval)UNIXTimestamp;

/// Returns current date rounded to the beginning of the day.
+ (NSDate *)midnight;

/// Returns receiver rounded to the beginning of the day.
- (NSDate *)midnight;



#pragma mark - Components

/// Returns new date from given components using current calendar.
+ (instancetype)dateFromComponents:(NSDateComponents *)components;

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

/// Whether the receiver and other date share the same component (week, month, day, year, ...).
- (BOOL)isWithinUnit:(NSCalendarUnit)unit ofDate:(NSDate *)other;

/// Whether the receiver shared the same day component as current date.
- (BOOL)isToday;

/// Whether the receiver happened in previous number of units.
- (BOOL)isInLast:(NSTimeInterval)interval unit:(NSCalendarUnit)unit;



#pragma mark - ISO 8601

//! Date parsed from ISO 8601 formatted string. On iOS 10, it uses NSISO8601DateFormatter, on older iOS, it uses predefined NSDateFormatters.
+ (instancetype)dateFromISOString:(NSString *)string;

//! Formatted string using ISO 8601 standard: '2017-05-07' or '2017-05-07T11:35:14Z'
- (NSString *)ISOStringWithTime:(BOOL)includeTime;



#pragma mark - Debug

// Deprecated, use +[NSObject measure:log:] to measure creating an instance fo given class.
+ (NSTimeInterval)measureTime:(void(^)(void))block log:(NSString *)logName __deprecated;



@end
