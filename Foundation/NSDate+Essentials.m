//
//  NSDate+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 13.10.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSDate+Essentials.h"






@implementation NSDate (Essentials)





#pragma mark Comparisons


- (BOOL)isBefore:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}


- (BOOL)isAfter:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
}


- (BOOL)isPast {
    return [self isBefore:[NSDate new]];
}


- (BOOL)isFuture {
    return [self isAfter:[NSDate new]];
}





#pragma mark - Timestamps


+ (instancetype)dateWithTimestamp:(NSTimeInterval)timestamp {
    return [self dateWithTimeIntervalSinceReferenceDate:timestamp];
}


+ (instancetype)dateWithUNIXTimestamp:(NSTimeInterval)unixTimestamp {
    return [self dateWithTimeIntervalSince1970:unixTimestamp];
}


- (NSTimeInterval)timestamp {
    return self.timeIntervalSinceReferenceDate;
}


- (NSTimeInterval)UNIXTimestamp {
    return self.timeIntervalSince1970;
}





+ (instancetype)now {
    return [self new];
}


+ (NSTimeInterval)timestamp {
    return [self timeIntervalSinceReferenceDate];
}


+ (NSTimeInterval)UNIXTimestamp {
    return [self timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970;
}


+ (instancetype)midnight {
    return [[self new] midnight];
}


- (NSDate *)midnight {
    return [self startDateOfComponent:NSCalendarUnitDay];
}





#pragma mark - Components


- (NSDateComponents *)components:(NSCalendarUnit)units {
    return [[NSCalendar currentCalendar] components:units fromDate:self];
}


- (NSDateComponents *)components:(NSCalendarUnit)units toDate:(NSDate *)other {
    return [[NSCalendar currentCalendar] components:units fromDate:self toDate:other options:kNilOptions];
}


- (NSDate *)startDateOfComponent:(NSCalendarUnit)unit {
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:unit startDate:&startDate interval:nil forDate:self];
    if ( ! ok) return nil;
    else return startDate;
}


- (NSTimeInterval)durationOfComponent:(NSCalendarUnit)unit {
    NSTimeInterval duration = 0;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:unit startDate:nil interval:&duration forDate:self];
    if ( ! ok) return 0;
    else return duration;
}


- (NSDate *)endDateOfComponent:(NSCalendarUnit)unit {
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:unit startDate:&startDate interval:&duration forDate:self];
    if ( ! ok) return nil;
    else return [startDate dateByAddingTimeInterval:duration];
}





#pragma mark - Debug


+ (NSTimeInterval)measureTime:(void(^)(void))block log:(NSString *)logName {
    NSDate *start = [NSDate new];
    block();
    NSTimeInterval duration = -start.timeIntervalSinceNow;
    if (logName.length) NSLog(@"%@: %.3f seconds", logName, duration);
    return duration;
}





@end
