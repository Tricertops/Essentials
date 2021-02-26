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




@implementation NSArray THIS_IS_NOT_MACRO (Essentials)





- (NSRange)fullRange {
    return NSRangeMake(0, self.count);
}


- (NSUInteger)lastIndex {
    return (self.count > 0? self.count - 1 : NSNotFound);
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
    var array = [NSMutableArray<id> arrayWithCapacity:count];
    forcount (index, count) {
        [array addObject:block(index)];
    }
    return array;
}


- (NSArray<id> *)sorted {
    return [self sortedArrayUsingSelector:@selector(compare:)];
}





#pragma mark Iterating


- (void)forEach:(void(^)(id object))block {
    NSParameterAssert(block);
    
    foreach (object, self) {
        block(object);
    }
}


- (void)forEachIndex:(void(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    NSUInteger index = 0;
    foreach (object, self) {
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
    
    var mutable = [NSMutableArray<id> new];
    foreach (object, self) {
        id mapped = block(object);
        if (mapped) [mutable addObject:mapped];
    }
    return [mutable copy];
}


- (NSArray<id> *)mapIndex:(id(^)(NSUInteger index, id object))block {
    NSParameterAssert(block);
    
    var mutable = [NSMutableArray<id> new];
    NSUInteger index = 0;
    foreach (object, self) {
        id mapped = block(index, object);
        if (mapped) [mutable addObject:mapped];
        index++;
    }
    return [mutable copy];
}


- (NSArray<id> *)filtered:(BOOL(^)(id object))block {
    var mutable = [NSMutableArray<id> new];
    foreach (object, self) {
        if (block(object)) [mutable addObject:object];
    }
    return [mutable copy];
}


- (NSDictionary<id, id> *)dictionaryByKeyPath:(NSString *)keyPath {
    NSArray<id> *keys = [self valueForKeyPath:keyPath];
    return [NSDictionary dictionaryWithObjects:self forKeys:keys];
}


- (NSMutableDictionary<id, id> *)dictionaryByMappingToKeys:(id<NSCopying>(^)(id value))block {
    var dictionary = [NSMutableDictionary<id, id> dictionaryWithCapacity:self.count];
    foreach (value, self) {
        var key = block(value);
        if (key) {
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}


- (NSMutableDictionary<id, id> *)dictionaryByMappingToValues:(id(^)(id key))block {
    var dictionary = [NSMutableDictionary<id, id> dictionaryWithCapacity:self.count];
    foreach (key, self) {
        id value = block(key);
        if (value) {
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}


- (NSArray<id> *)arrayByRemovingObjectsFromSet:(NSSet<id> *)set {
    var mutable = [NSMutableArray<id> new];
    foreach (object, self) {
        if ( ! [set containsObject:object]) {
            [mutable addObject:object];
        }
    }
    return [mutable copy];
}






#pragma mark Nested Arrays


- (NSArray<id> *)flattenedArray {
    var builder = [NSMutableArray<id> new];
    foreach (object, self) {
        if ([object isKindOfClass: NSArray.class]) {
            [builder addObjectsFromArray:object];
        }
        else {
            [builder addObject:object];
        }
    }
    return builder;
}


- (NSArray<NSArray<id> *> *)splitArrayByCount:(NSUInteger)count {
    var builder = [NSMutableArray<id> new];
    forcount (index, self.count, count) {
        let subarray = [self valuesInRange:NSRangeMake(index, count)];
        [builder addObject:subarray];
    }
    return builder;
}


- (NSArray<NSArray<id> *> *)splitArrayIntoParts:(NSUInteger)count {
    return [self splitArrayByCount:ceil(1.0 * self.count / count)];
}





#pragma mark Joining


- (NSString *)componentsJoinedByString:(NSString *)separator lastString:(NSString *)lastSeparator {
    if (self.count > 1) {
        let selfWithoutLast = [self subarrayWithRange:NSMakeRange(0, self.count-1)];
        let string = [NSString stringWithFormat:@"%@%@%@", [selfWithoutLast componentsJoinedByString:separator], lastSeparator, self.lastObject];
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


- (NSArray<id> *)subarrayWithCount:(NSUInteger)count {
    if (self.count == 0) return @[];
    if (count >= self.count) return self;
    
    return [self subarrayWithRange:NSMakeRange(0, count)];
}


- (NSArray<id> *)subarrayStartingAtIndex:(NSUInteger)index {
    if (self.count == 0) return @[];
    if (index >= self.count) return @[];
    if (index == 0) return self;
    
    return [self subarrayWithRange:NSMakeRange(index, self.count - index)];
}


- (NSArray<id> *)insertingObject:(id)object atIndex:(NSUInteger)index {
    NSMutableArray<id> *mutable = [self mutableCopy];
    [mutable insertObject:object atIndex:index];
    return mutable;
}


#pragma mark Concatenaing

- (NSArray *) :(NSArray *)a { return [self.class concat:self, a?:@[], nil]; }
- (NSArray *) :(NSArray *)a :(NSArray *)b { return [NSArray concat:self, a?:@[], b?:@[], nil]; }
- (NSArray *) :(NSArray *)a :(NSArray *)b :(NSArray *)c  { return [NSArray concat:self, a?:@[], b?:@[], c?:@[], nil]; }
- (NSArray *) :(NSArray *)a :(NSArray *)b :(NSArray *)c :(NSArray *)d { return [NSArray concat:self, a?:@[], b?:@[], c?:@[], d?:@[], nil]; }
- (NSArray *) :(NSArray *)a :(NSArray *)b :(NSArray *)c :(NSArray *)d :(NSArray *)e { return [NSArray concat:self, a?:@[], b?:@[], c?:@[], d?:@[], e?:@[], nil]; }
- (NSArray *) :(NSArray *)a :(NSArray *)b :(NSArray *)c :(NSArray *)d :(NSArray *)e :(NSArray *)f { return [NSArray concat:self, a?:@[], b?:@[], c?:@[], d?:@[], e?:@[], f?:@[], nil]; }
- (NSArray *) :(NSArray *)a :(NSArray *)b :(NSArray *)c :(NSArray *)d :(NSArray *)e :(NSArray *)f :(NSArray *)g { return [NSArray concat:self, a?:@[], b?:@[], c?:@[], d?:@[], e?:@[], f?:@[], g?:@[], nil]; }

+ (NSArray *)concat:(NSArray *)firstString, ... NS_REQUIRES_NIL_TERMINATION {
    return [NSArrayFromVariadicArguments(firstString) flattenedArray];
}





#pragma mark Randomizing


- (NSArray<id> *)arrayByRandomizingOrder {
    var mutable = [self mutableCopy];
    [mutable randomizeOrder];
    return [mutable copy];
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




