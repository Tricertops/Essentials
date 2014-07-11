//
//  NSArray+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSArray+Essentials.h"
#import "NSMutableArray+Essentials.h"
#import "Foundation+Essentials.h"




@implementation NSArray (Essentials)





#pragma mark Iterating


- (void)forEach:(void(^)(id object))block {
    NSParameterAssert(block);
    
    for (id object in self) {
        block(object);
    }
}


- (void)forEachIndex:(void(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    NSUInteger index = 0;
    for (id object in self) {
        block(index, object);
        index++;
    }
}





#pragma mark Mapping


- (NSArray *)map:(id(^)(id object))block {
    NSParameterAssert(block);
    
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    for (id object in self) {
        id mapped = block(object);
        if (mapped) [mutable addObject:mapped];
    }
    return [mutable copy];
}


- (NSArray *)mapIndex:(id(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    NSUInteger index = 0;
    for (id object in self) {
        id mapped = block(index, object);
        if (mapped) [mutable addObject:mapped];
        index++;
    }
    return [mutable copy];
}


- (NSDictionary *)dictionaryByKeyPath:(NSString *)keyPath {
    NSArray *keys = [self valueForKeyPath:keyPath];
    return [NSDictionary dictionaryWithObjects:self forKeys:keys];
}





#pragma mark Nested Arrays


- (NSArray *)flattenedArray {
    NSMutableArray *builder = [[NSMutableArray alloc] init];
    for (NSArray *subarray in self) {
        [builder addObjectsFromArray:subarray];
    }
    return builder;
}





#pragma mark Joining


- (NSString *)componentsJoinedByString:(NSString *)separator lastString:(NSString *)lastSeparator {
    if (self.count > 1) {
        NSArray *selfWithoutLast = [self subarrayWithRange:NSMakeRange(0, self.count-1)];
        NSString *string = [NSString stringWithFormat:@"%@%@%@", [selfWithoutLast componentsJoinedByString:separator], lastSeparator, self.lastObject];
        return string;
    }
    else {
        return [self componentsJoinedByString:separator];
    }
}


- (NSString *)join:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}


- (NSString *)join:(NSString *)separator last:(NSString *)last {
    return [self componentsJoinedByString:separator lastString:last];
}


- (NSArray *)subarrayToIndex:(NSUInteger)index {
    return [self subarrayWithRange:NSMakeRange(0, index + 1)];
}


- (NSArray *)subarrayFromIndex:(NSUInteger)index {
    return [self subarrayWithRange:NSMakeRange(index, self.count - index)];
}





#pragma mark Randomizing


- (NSArray *)arrayByRandomizingOrder {
   return [self.mutableCopy randomizeOrder];
}


- (id)randomObject {
    NSUInteger randomIndex = NSUIntegerRandom(self.count);
    return [self objectAtIndex:randomIndex];
}





#pragma mark Safe Values


- (id)valueAtIndex:(NSInteger)index {
    
    // Negative indexes starts from tail and go backwards.
    NSInteger realIndex = (index >= 0? index : self.count + index);
    
    // Out of range indexes results in nil.
    if (realIndex < 0) return nil;
    if (realIndex >= self.count) return nil;
    
    id value = [self objectAtIndex:realIndex];
    
     // NSNull is replaced by nil.
    if (value == NSNull.null) return nil;
    
    return value;
}


- (id)firstValue  { return [self valueAtIndex:0]; }
- (id)secondValue { return [self valueAtIndex:1]; }
- (id)thirdValue  { return [self valueAtIndex:2]; }
- (id)fourthValue { return [self valueAtIndex:3]; }
- (id)fifthValue  { return [self valueAtIndex:4]; }
- (id)sixthValue  { return [self valueAtIndex:5]; }
- (id)lastValue   { return [self valueAtIndex:-1]; }





@end




