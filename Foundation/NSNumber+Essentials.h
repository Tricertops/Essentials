//
//  NSNumber+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSNumber (Essentials)



#pragma mark - Looping

/// Invokes given block N times, where N is receiver's unsignedIntegerValue.
- (void)times:(void(^)(void))block;

/// Invokes given block N times with iteration indexes, where N is receiver's unsignedIntegerValue.
- (void)timesIndex:(void(^)(NSUInteger index))block;



#pragma mark - Comparisons

/// return [otherNumber compare:self];
- (NSComparisonResult)compareInversed:(NSNumber *)otherNumber;

/// Compares to [NSDecimalNumber notANumber]
@property (readonly) BOOL isNaN;

/// Compares to NSNull and NaN, works for nil too.
@property (readonly) BOOL isNumber;

/// Checks underlaying type, returns YES if it’s bool.
@property (readonly) BOOL isBool;



#pragma mark - Arithmetics

/// Rounds the receiver to nearest multiple of step.
- (NSNumber *)roundedTo:(double)step;



@end
