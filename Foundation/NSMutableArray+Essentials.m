//
//  NSMutableArray+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSMutableArray+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSMutableArray (Essentials)





#pragma mark - Mutating


- (void)addObjectIfAny:(id)object {
    if (object) {
        [self addObject:object];
    }
}





#pragma mark Mapping


- (NSMutableArray *)replace:(id(^)(id object))block {
    NSParameterAssert(block);
    
    for (NSUInteger index = 0; index < self.count; ) {
        id object = [self objectAtIndex:index];
        id replacement = block(object);
        
        if (replacement) {
            [self replaceObjectAtIndex:index withObject:replacement];
            index++;
        }
        else {
            [self removeObjectAtIndex:index];
        }
    }
    return self;
}


- (NSMutableArray *)replaceIndex:(id(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    for (NSUInteger index = 0; index < self.count; ) {
        id object = [self objectAtIndex:index];
        id replacement = block(index, object);
        
        if (replacement) {
            [self replaceObjectAtIndex:index withObject:replacement];
            index++;
        }
        else {
            [self removeObjectAtIndex:index];
        }
    }
    return self;
}





#pragma mark Nester Arrays


- (NSMutableArray *)flatten {
    NSMutableArray *builder = [[NSMutableArray alloc] init];
    for (NSArray *subarray in self) {
        [builder addObjectsFromArray:subarray];
    }
    [self setArray:builder];
    return self;
}




#pragma mark Filtering


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

#pragma mark Randomize

- (NSMutableArray *)randomizeOrder {
    
    for (NSInteger i = self.count-1; i > 0; i--)
    {
        [self exchangeObjectAtIndex:i withObjectAtIndex:NSUIntegerRandom(i+1)];
    }
    
    return self;
}



@end
