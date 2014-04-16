//
//  NSDate+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 13.10.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>






@interface NSDate (Essentials)



#pragma mark Comparisons

/// Whether the receiver comes before the argument.
- (BOOL)isBefore:(NSDate *)date;
/// Whether the receiver comes after the argument.
- (BOOL)isAfter:(NSDate *)date;




+ (NSTimeInterval)measureTime:(void(^)(void))block log:(NSString *)logName;



@end
