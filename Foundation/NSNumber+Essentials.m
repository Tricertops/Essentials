//
//  NSNumber+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSNumber+Essentials.h"
#import "NSObject+Essentials.h"





@implementation NSNumber (Essentials)





- (void)times:(void(^)(void))block {
    NSParameterAssert(block);
    
    NSUInteger count = self.unsignedIntegerValue;
    for (NSUInteger index = 0; index < count; index++) {
        block();
    }
}


- (void)timesIndex:(void(^)(NSUInteger index))block {
    NSParameterAssert(block);
    
    NSUInteger count = self.unsignedIntegerValue;
    for (NSUInteger index = 0; index < count; index++) {
        block(index);
    }
}




#pragma mark - Comparisons


- (NSComparisonResult)compareInversed:(NSNumber *)otherNumber {
    return [otherNumber compare:self];
}


- (BOOL)isNaN {
    return [self isEqualToNumber:[NSDecimalNumber notANumber]];
}


- (BOOL)isNumber {
    return ([self isNotNull] && ! [self isNaN]);
}


- (BOOL)isBool {
    return (   self == (id)kCFBooleanFalse
            || self == (id)kCFBooleanTrue);
}





#pragma mark - Arithmetics


- (NSNumber *)roundedTo:(double)step {
    ESSAssert(step != 0)
    else return self;
    ESSAssert(!isnan(step))
    else return self;
    ESSAssert(!isinf(step))
    else return self;
    return @(round(self.doubleValue / step) * step);
}




@end
