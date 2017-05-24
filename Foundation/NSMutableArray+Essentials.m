//
//  NSMutableArray+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSMutableArray+Essentials.h"
#import "Foundation+Essentials.h"





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


- (NSMutableArray<id> *)replace:(id(^)(id object))block {
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


- (NSMutableArray<id> *)replaceIndex:(id(^)(NSUInteger index, id object))block {
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





#pragma mark Nested Arrays


- (NSMutableArray<id> *)flatten {
    NSMutableArray<id> *builder = [[NSMutableArray alloc] init];
    for (NSArray<id> *subarray in self) {
        [builder addObjectsFromArray:subarray];
    }
    [self setArray:builder];
    return self;
}




#pragma mark Filtering


- (NSMutableArray<id> *)filter:(BOOL(^)(id object))block {
    NSParameterAssert(block);
    
    for (NSInteger index = 0; index < self.count; ) {
        id object = [self objectAtIndex:index];
        BOOL passed = block(object);
        if (passed) index++;
        else [self removeObjectAtIndex:index];
    }
    return self;
}


- (NSMutableArray<id> *)filterIndex:(BOOL(^)(NSUInteger index, id object))block {
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

- (NSMutableArray<id> *)randomizeOrder {
    for (NSInteger index = self.count - 1; index > 0; index--) {
        [self exchangeObjectAtIndex:index withObjectAtIndex:NSUIntegerRandom(index+1)];
    }
    return self;
}



@end
