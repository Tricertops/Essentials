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


+ (instancetype)after:(NSTimeInterval)interval {
    return [self dateWithTimeIntervalSinceNow:interval];
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


+ (instancetype)dateFromComponents:(NSDateComponents *)components {
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}


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
    return [[self startDateOfComponent:unit] dateByAddingTimeInterval:[self durationOfComponent:unit]];
}


- (BOOL)isWithinUnit:(NSCalendarUnit)unit ofDate:(NSDate *)other {
    NSDate *startDate = [other startDateOfComponent:unit];
    if ([self isBefore:startDate]) return NO;
    NSDate *endDate = [other endDateOfComponent:unit];
    return [self isBefore:endDate]; // endDate is already out of unit
}


- (BOOL)isToday {
    return [self isWithinUnit:NSCalendarUnitDay ofDate:[NSDate now]];
}


- (BOOL)isInLast:(NSTimeInterval)interval unit:(NSCalendarUnit)unit {
    NSDate *limit = [[NSCalendar currentCalendar] dateByAddingUnit:unit
                                                             value:-interval
                                                            toDate:[NSDate now]
                                                           options:kNilOptions];
    return [self isAfter:limit];
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
