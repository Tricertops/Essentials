//
//  NSMutableArray+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSMutableArray+Essentials.h"





@implementation NSMutableArray (Essentials)





- (NSMutableArray *)filter:(BOOL(^)(id object))block {
    NSParameterAssert(block);
    
    for (NSInteger index = 0; index < self.count; ) {
        id object = [self objectAtIndex:index];
        BOOL passed = block(object);
        if (passed) index++;
        else [self removeObjectAtIndex:index];
    }
    return self;
}


- (NSMutableArray *)filterIndex:(BOOL(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    for (NSInteger index = 0; index < self.count; ) {
        id object = [self objectAtIndex:index];
        BOOL passed = block(index, object);
        if (passed) index++;
        else [self removeObjectAtIndex:index];
    }
    return self;
}





@end
