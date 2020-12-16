//
//  NSArray+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"





@interface NSArray<T> (Essentials)



/// Range containing all indexes of the receiver.
@property (readonly) NSRange fullRange;

/// Index of last object in array, returns NSNotFound for empty array.
@property (readonly) NSUInteger lastIndex;



#pragma mark Building

/// Returns newly initialized array populated by N copies of given object. Preserves mutability.
+ (instancetype)arrayWithCount:(NSUInteger)count object:(T<NSCopying>)copiedObject;

/// Returns newly initialized array populated by N objects returned from builder block.
+ (instancetype)arrayWithCount:(NSUInteger)count builder:(T(^)(NSUInteger index))block;

/// Returns new array with objects sorted using -compare: method.
@property (readonly) NSArray<T> *sorted;



#pragma mark Iterating

/// Enumerates contents of the receiver.
- (void)forEach:(void(^)(T object))block;

/// Enumerates contents of the receiver providing index.
- (void)forEachIndex:(void(^)(NSUInteger index, T object))block;

/// Returns new array that contains the same objects in rever order.
- (NSArray<T> *)reversedArray;

/// Finds best index where given object should be inserted to keep array sorted by given descriptors.
- (NSUInteger)insertionIndexOfObject:(T)object usingSortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors equalFirst:(BOOL)insertEqualAsFirst;



#pragma mark Mapping

/// Returns new array with mapped objects using given block. The block takes object.
- (NSArray<id> *)map:(id(^)(T object))block;

/// Returns new array with mapped objects using given block. The block takes index and object.
- (NSArray<id> *)mapIndex:(id(^)(NSUInteger index, T object))block;

/// Returns new array with only objects for which you return YES.
- (NSArray<T> *)filtered:(BOOL(^)(T object))block;

/// Returns new dictionary, whose values are objects from the receiver and keys are obejcts returned for given key-path.
- (NSDictionary<NSString *, T> *)dictionaryByKeyPath:(NSString *)keyPath;

/// Returns new dictionary, whose values are objects from the receiver and keys are corresponding value returned by block.
- (NSMutableDictionary<id, T> *)dictionaryByMappingToKeys:(id<NSCopying>(^)(T value))block;

/// Returns new dictionary, whose keys are objects from the receiver and values are corresponding value returned by block.
- (NSMutableDictionary<T, id> *)dictionaryByMappingToValues:(id(^)(T key))block;

/// Returns new array without objects from provided set.
- (NSArray<T> *)arrayByRemovingObjectsFromSet:(NSSet<T> *)set;



#pragma mark Nested Arrays

/// Combines nested subarrays to single array.
- (NSArray<id> *)flattenedArray;

/// Returns array of arrays with elements of receiver. Each nested array contains given numebr of elements, except last one (that contains the remainder).
- (NSArray<NSArray<T> *> *)splitArrayByCount:(NSUInteger)count;

/// Returns array of N arrays or less. These arrays contain elements of the receiver.
- (NSArray<NSArray<T> *> *)splitArrayIntoParts:(NSUInteger)count;



#pragma mark Joining

/// Extended -componentsJoinedByString: to support different last string.
- (NSString *)componentsJoinedByString:(NSString *)separator lastString:(NSString *)lastSeparator;

/// Shorthand for -componentsJoinedByString:
- (NSString *)join:(NSString *)separator;

/// Shorthand for -componentsJoinedByString:lastString:
- (NSString *)join:(NSString *)separator last:(NSString *)last;

/// Returns a new array containing the receiving array’s elements up given count. Safe to pass large counts, will be clamped.
- (NSArray<T> *)subarrayWithCount:(NSUInteger)count;

/// Returns a new array containing the receiving array’s elements starting at given index. Safe to pass large indexes, will be clamped.
- (NSArray<T> *)subarrayStartingAtIndex:(NSUInteger)index;

- (NSArray<T> *) :(NSArray<T> *)a;
- (NSArray<T> *) :(NSArray<T> *)a :(NSArray<T> *)b;
- (NSArray<T> *) :(NSArray<T> *)a :(NSArray<T> *)b :(NSArray<T> *)c;
- (NSArray<T> *) :(NSArray<T> *)a :(NSArray<T> *)b :(NSArray<T> *)c :(NSArray<T> *)d;
- (NSArray<T> *) :(NSArray<T> *)a :(NSArray<T> *)b :(NSArray<T> *)c :(NSArray<T> *)d :(NSArray<T> *)e;
- (NSArray<T> *) :(NSArray<T> *)a :(NSArray<T> *)b :(NSArray<T> *)c :(NSArray<T> *)d :(NSArray<T> *)e :(NSArray<T> *)f;
- (NSArray<T> *) :(NSArray<T> *)a :(NSArray<T> *)b :(NSArray<T> *)c :(NSArray<T> *)d :(NSArray<T> *)e :(NSArray<T> *)f :(NSArray<T> *)g;

+ (NSArray<T> *)concat:(NSArray<T> *)firstString, ... NS_REQUIRES_NIL_TERMINATION;



#pragma mark Randomizing

///Returns copy with randmized order of elements.
- (NSArray<T> *)arrayByRandomizingOrder;

/// Return object at random index.
- (T)randomObject;

/// Returns a set containing all values from the receiver.
- (NSSet<T> *)distinctObjects;



#pragma mark Safe Values

/*!
 Returns an object at given index except:
   1. Negative indexes are counted from tail, so -1 is last object.
   2. Indexes that are out of range returns nil.
   3. NSNull is replaced by nil.
 !*/
- (T)valueAtIndex:(NSInteger)index;

/// Convenience methods for `valueAtIndex:`.
- (T)firstValue;
- (T)secondValue;
- (T)thirdValue;
- (T)fourthValue;
- (T)fifthValue;
- (T)sixthValue;
- (T)lastValue;

/// Similar to -subarrayWithRange:, but handles out-of-bounds ranges.
- (NSArray<T> *)valuesInRange:(NSRange)range;



@end





/// Use inside of a method/function with variable arguments to quickly convert these arguments to NSArray.
#define NSArrayFromVariadicArguments(FIRST)\
(NSMutableArray<id> *)({\
    va_list list;\
    va_start(list, FIRST);\
    var objects = [NSMutableArray<id> new];\
    id object = FIRST;\
    while (object) {\
        [objects addObject:object];\
        object = va_arg(list, id);\
    }\
    va_end(list);\
    objects;\
})






