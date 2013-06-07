//
//  NSArray+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSArray+Essentials.h"





@implementation NSArray (Essentials)





#pragma mark Mapping


- (NSArray *)map:(id(^)(id object))block {
    NSParameterAssert(block);
    
    NSMutableArray *mutable = [self mutableCopy];
    for (id object in self) {
        id mapped = block(object);
        if (mapped) [mutable addObject:mapped];
    }
    return [mutable copy];
}


- (NSArray *)mapIndex:(id(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    NSMutableArray *mutable = [self mutableCopy];
    NSUInteger index = 0;
    for (id object in self) {
        id mapped = block(index, object);
        if (mapped) [mutable addObject:mapped];
        index++;
    }
    return [mutable copy];
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





@end