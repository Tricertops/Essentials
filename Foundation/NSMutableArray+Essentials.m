//
//  NSMutableArray+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSMutableArray+Essentials.h"
#import "NSArray+Essentials.h"





@implementation NSMutableArray THIS_IS_NOT_MACRO (Essentials)





#pragma mark - Mutating


- (void)addObjectIfAny:(id)object {
    if (object) {
        [self addObject:object];
    }
}


- (void)insertObject:(id)object usingSortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors equalFirst:(BOOL)insertEqualAsFirst {
    NSUInteger index = [self insertionIndexOfObject:object usingSortDescriptors:sortDescriptors equalFirst:insertEqualAsFirst];
    if (index != NSNotFound) {
        [self insertObject:object atIndex:index];
    }
}





#pragma mark Mapping


- (void)replace:(id(^)(id object))block {
    NSParameterAssert(block);
    
    NSUInteger index = 0;
    while (index < self.count) {
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
}


- (void)replaceIndex:(id(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    NSUInteger index = 0;
    while (index < self.count) {
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
}





#pragma mark Nested Arrays


- (void)flatten {
    NSMutableArray<id> *builder = [[NSMutableArray alloc] init];
    foreach (subarray, self) {
        [builder addObjectsFromArray:(NSArray<id> *)subarray];
    }
    [self setArray:builder];
}




#pragma mark Filtering


- (void)filter:(BOOL(^)(id object))block {
    NSParameterAssert(block);
    
    NSInteger index = 0;
    while (index < self.count) {
        id object = [self objectAtIndex:index];
        BOOL passed = block(object);
        if (passed) index++;
        else [self removeObjectAtIndex:index];
    }
}


- (void)filterIndex:(BOOL(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    NSInteger index = 0;
    while (index < self.count) {
        id object = [self objectAtIndex:index];
        BOOL passed = block(index, object);
        if (passed) index++;
        else [self removeObjectAtIndex:index];
    }
}

#pragma mark Randomize

- (void)randomizeOrder {
    for (NSInteger index = self.count - 1; index > 0; index--) {
        [self exchangeObjectAtIndex:index withObjectAtIndex:NSUIntegerRandom(index+1)];
    }
}



@end
