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
#import "NSSortDescriptor+Essentials.h"




@implementation NSArray (Essentials)





- (NSRange)fullRange {
    return NSRangeMake(0, self.count);
}




#pragma mark Building


+ (instancetype)arrayWithCount:(NSUInteger)count object:(NSObject<NSCopying> *)copiedObject {
    BOOL isMutablyCopiable = [copiedObject conformsToProtocol:@protocol(NSMutableCopying)];
    
    return [self arrayWithCount:count builder:^id(NSUInteger index) {
        if (isMutablyCopiable) {
            return [copiedObject mutableCopy];
        }
        else {
            return [copiedObject copy];
        }
    }];
}


+ (instancetype)arrayWithCount:(NSUInteger)count builder:(id(^)(NSUInteger index))block {
    NSMutableArray<id> *array = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index++) {
        [array addObject:block(index)];
    }
    return array;
}





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


- (NSArray *)reversedArray {
    return self.reverseObjectEnumerator.allObjects;
}


- (NSUInteger)insertionIndexOfObject:(id)object usingSortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors equalFirst:(BOOL)insertEqualAsFirst {
    if (object == nil) return NSNotFound;
    if ( ! sortDescriptors.count) return (insertEqualAsFirst? 0 : self.count);
    
    NSBinarySearchingOptions options = NSBinarySearchingInsertionIndex;
    options |= (insertEqualAsFirst? NSBinarySearchingFirstEqual : NSBinarySearchingLastEqual);
    
    return [self indexOfObject:object inSortedRange:self.fullRange options:options usingComparator:[NSSortDescriptor comparatorForSortDescriptors:sortDescriptors]];
}





#pragma mark Mapping


- (NSArray<id> *)map:(id(^)(id object))block {
    NSParameterAssert(block);
    
    NSMutableArray<id> *mutable = [[NSMutableArray alloc] init];
    for (id object in self) {
        id mapped = block(object);
        if (mapped) [mutable addObject:mapped];
    }
    return [mutable copy];
}


- (NSArray<id> *)mapIndex:(id(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    NSMutableArray<id> *mutable = [[NSMutableArray alloc] init];
    NSUInteger index = 0;
    for (id object in self) {
        id mapped = block(index, object);
        if (mapped) [mutable addObject:mapped];
        index++;
    }
    return [mutable copy];
}


- (NSDictionary<id, id> *)dictionaryByKeyPath:(NSString *)keyPath {
    NSArray<id> *keys = [self valueForKeyPath:keyPath];
    return [NSDictionary dictionaryWithObjects:self forKeys:keys];
}


- (NSMutableDictionary<id, id> *)dictionaryByMappingToKeys:(id<NSCopying>(^)(id value))block {
    NSMutableDictionary<id, id> *dictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (id value in self) {
        id<NSCopying> key = block(value);
        if (key) {
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}


- (NSMutableDictionary<id, id> *)dictionaryByMappingToValues:(id(^)(id<NSCopying> key))block {
    NSMutableDictionary<id, id> *dictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (id<NSCopying> key in self) {
        id value = block(key);
        if (value) {
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}






#pragma mark Nested Arrays


- (NSArray<id> *)flattenedArray {
    NSMutableArray<id> *builder = [[NSMutableArray alloc] init];
    for (id object in self) {
        if ([object isKindOfClass: NSArray.class]) {
            [builder addObjectsFromArray:object];
        }
        else {
            [builder addObject:object];
        }
    }
    return builder;
}





#pragma mark Joining


- (NSString *)componentsJoinedByString:(NSString *)separator lastString:(NSString *)lastSeparator {
    if (self.count > 1) {
        NSArray<id> *selfWithoutLast = [self subarrayWithRange:NSMakeRange(0, self.count-1)];
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


- (NSArray<id> *)subarrayToIndex:(NSUInteger)index {
    return [self subarrayWithRange:NSMakeRange(0, index)];
}


- (NSArray<id> *)subarrayFromIndex:(NSUInteger)index {
    return [self subarrayWithRange:NSMakeRange(index, self.count - index)];
}





#pragma mark Randomizing


- (NSArray<id> *)arrayByRandomizingOrder {
   return [self.mutableCopy randomizeOrder];
}


- (id)randomObject {
    NSUInteger randomIndex = NSUIntegerRandom(self.count);
    return [self objectAtIndex:randomIndex];
}


- (NSSet<id> *)distinctObjects {
    return [NSSet setWithArray:self];
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


- (NSArray *)valuesInRange:(NSRange)subrange {
    NSRange intersection = NSRangeIntersection(self.fullRange, subrange);
    if (intersection.length == 0) return @[];
    
    return [self subarrayWithRange:intersection];
}





@end




