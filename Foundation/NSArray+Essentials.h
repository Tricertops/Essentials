//
//  NSArray+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSArray (Essentials)





#pragma mark Building

/// Returns newly initialized array populated by N copies of given object. Preserves mutability.
+ (instancetype)arrayWithCount:(NSUInteger)count object:(id<NSCopying>)copiedObject;

/// Returns newly initialized array populated by N objects returned from builder block.
+ (instancetype)arrayWithCount:(NSUInteger)count builder:(id(^)(NSUInteger index))block;



#pragma mark Iterating

/// Enumerates contents of the receiver.
- (void)forEach:(void(^)(id object))block;

/// Enumerates contents of the receiver providing index.
- (void)forEachIndex:(void(^)(NSUInteger index, id object))block;



#pragma mark Mapping

/// Returns new array with mapped objects using given block. The block takes object.
- (NSArray *)map:(id(^)(id object))block;

/// Returns new array with mapped objects using given block. The block takes index and object.
- (NSArray *)mapIndex:(id(^)(NSUInteger index, id object))block;

/// Returns new dictionary, whose values are objects from the receiver and keys are obejcts returned for given key-path.
- (NSDictionary *)dictionaryByKeyPath:(NSString *)keyPath;

/// Returns new dictionary, whose values are objects from the receiver and keys are corresponding value returned by block.
- (NSMutableDictionary *)dictionaryByMappingToKeys:(id<NSCopying>(^)(id value))block;

/// Returns new dictionary, whose keys are objects from the receiver and values are corresponding value returned by block.
- (NSMutableDictionary *)dictionaryByMappingToValues:(id(^)(id<NSCopying> key))block;



#pragma mark Nested Arrays

/// Combines nested subarrays to single array.
- (NSArray *)flattenedArray;



#pragma mark Joining

/// Extended -componentsJoinedByString: to support different last string.
- (NSString *)componentsJoinedByString:(NSString *)separator lastString:(NSString *)lastSeparator;

/// Shorthand for -componentsJoinedByString:
- (NSString *)join:(NSString *)separator;

/// Shorthand for -componentsJoinedByString:lastString:
- (NSString *)join:(NSString *)separator last:(NSString *)last;

/// Returns a new array containing the receiving array’s elements up to given index.
- (NSArray *)subarrayToIndex:(NSUInteger)index;

/// Returns a new array containing the receiving array’s elements from given index.
- (NSArray *)subarrayFromIndex:(NSUInteger)index;



#pragma mark Randomizing

///Returns copy with randmized order of elements.
- (NSArray *)arrayByRandomizingOrder;

/// Return object at random index.
- (id)randomObject;

/// Returns a set containing all values from the receiver.
- (NSSet *)set;



#pragma mark Safe Values

/*!
 Returns an object at given index except:
   1. Negative indexes are counted from tail, so -1 is last object.
   2. Indexes that are out of range returns nil.
   3. NSNull is replaced by nil.
 !*/
- (id)valueAtIndex:(NSInteger)index;

/// Convenience methods for `valueAtIndex:`.
- (id)firstValue;
- (id)secondValue;
- (id)thirdValue;
- (id)fourthValue;
- (id)fifthValue;
- (id)sixthValue;
- (id)lastValue;



@end





/// Use inside of a method/function with variable arguments to quickly convert these arguments to NSArray.
#define NSArrayFromVariadicArguments(FIRST)\
(NSMutableArray *)({\
    va_list list;\
    va_start(list, FIRST);\
    NSMutableArray *objects = [[NSMutableArray alloc] init];\
    id object = FIRST;\
    while (object) {\
        [objects addObject:object];\
        object = va_arg(list, id);\
    }\
    va_end(list);\
    objects;\
})






