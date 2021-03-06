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


NSComparisonResult NSIntegerCompare(NSInteger A, NSInteger B) {
    if (A < B) return NSOrderedAscending;
    if (A > B) return NSOrderedDescending;
    return NSOrderedSame;
}


NSTimeInterval const NSTimeIntervalInfinity = INFINITY;


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





#pragma mark - Range


NSRange const NSRangeZero = (NSRange){
    .location = 0,
    .length = 0,
};


NSRange const NSRangeNotFound = (NSRange){
    .location = NSNotFound,
    .length = 0,
};


NSRange NSRangeMake(NSUInteger location, NSUInteger length) {
    ESSAssert(location <= NSNotFound);
    ESSAssert(length < NSNotFound);
    return NSMakeRange(location, length);
}


NSRange NSRangeMakeFromTo(NSUInteger first, NSUInteger last) {
    ESSAssert(first <= last)
    else return NSRangeMake(first, 0);
    
    return NSRangeMake(first, last - first + 1);
}


BOOL NSRangeIsFound(NSRange range) {
    return (range.location != NSNotFound);
}


NSUInteger NSRangeLastIndex(NSRange range) {
    if (range.length == 0)
        return NSNotFound;
    
    return range.location + range.length - 1;
}


NSUInteger NSRangeFollowingIndex(NSRange range) {
    return range.location + range.length;
}


BOOL NSRangeContainsIndex(NSRange range, NSUInteger index) {
    return (range.location <= index && index < NSRangeFollowingIndex(range));
}


BOOL NSRangeContainsRange(NSRange A, NSRange B) {
    return (A.location <= B.location && NSRangeFollowingIndex(B) <= NSRangeFollowingIndex(A));
}


BOOL NSRangeEqual(NSRange A, NSRange B) {
    return NSEqualRanges(A, B);
}


NSRange NSRangeUnion(NSRange A, NSRange B) {
    return NSUnionRange(A, B);
}


BOOL NSRangeIntersects(NSRange A, NSRange B) {
    return NSRangeIntersection(A, B).length > 0;
}


NSRange NSRangeIntersection(NSRange A, NSRange B) {
    return NSIntersectionRange(A, B);
}


