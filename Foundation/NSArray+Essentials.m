//
//  NSArray+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSArray+Essentials.h"
#import "NSMutableArray+Essentials.h"




@implementation NSArray (Essentials)





#pragma mark Iterating


- (id)firstObject {
    if (self.count) return [self objectAtIndex:0];
    else return nil;
}


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

- (NSArray *)arrayByRandomizingOrder {
    
   return [self.mutableCopy randomizeOrder];
}



@end
