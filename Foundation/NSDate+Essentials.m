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





+ (NSTimeInterval)measureTime:(void(^)(void))block log:(NSString *)logName {
    NSDate *start = [NSDate new];
    block();
    NSTimeInterval duration = -start.timeIntervalSinceNow;
    if (logName.length) NSLog(@"%@: %g seconds", logName, duration);
    return duration;
}





@end
