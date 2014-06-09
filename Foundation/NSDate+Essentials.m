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





#pragma mark - Timestamps


+ (instancetype)dateWithTimestamp:(NSTimeInterval)timestamp {
    return [self dateWithTimeIntervalSinceReferenceDate:timestamp];
}


+ (instancetype)dateWithUNIXTimstamp:(NSTimeInterval)unixTimestamp {
    return [self dateWithTimeIntervalSince1970:unixTimestamp];
}


- (NSTimeInterval)timestamp {
    return self.timeIntervalSinceReferenceDate;
}


- (NSTimeInterval)UNIXTimestamp {
    return self.timeIntervalSince1970;
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
