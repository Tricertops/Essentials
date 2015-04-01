//
//  Foundation+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 14.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



NSUInteger NSUIntegerRandom(NSUInteger count) {
    if (count == NSUIntegerMax) return arc4random();
    else return arc4random_uniform((uint32_t)count);
}


NSUInteger ESSIndexFromSignedIndex(NSInteger signedIndex, NSUInteger unsignedCount) {
    if (signedIndex == NSIntegerMax) return NSNotFound;
    if (signedIndex == NSIntegerMin) return NSNotFound;
    if (signedIndex >= 0) return (NSUInteger)signedIndex;
    // Index is negative.
    if (unsignedCount >= (NSUInteger)NSIntegerMax) return NSNotFound; // Prevent signed overflow.
    NSInteger signedCount = (NSUInteger)unsignedCount;
    NSInteger subtractedIndex = signedCount - signedIndex;
    if (subtractedIndex < 0) return NSNotFound;
    return (NSUInteger)subtractedIndex;
}


NSTimeInterval const NSTimeIntervalInfinity = HUGE_VAL;


BOOL NSEqual(NSObject * A, NSObject * B) {
    return (A == B || (A && [B isEqual:A]));
}


BOOL NSStringEqual(NSString * A, NSString * B) {
    return (A == B || (A && [B isEqualToString:A]));
}


NSTimeInterval NSTimeIntervalRandom(NSTimeInterval minimum, NSTimeInterval granularity, NSTimeInterval maximum) {
    NSUInteger steps = ABS(maximum - minimum) / granularity;
    return minimum + NSUIntegerRandom(steps) * granularity;
}
