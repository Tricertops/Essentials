//
//  NSArray+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSArray (Essentials)



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



#pragma mark Randomizing

///Returns copy with randmized order of elements.
- (NSArray *)arrayByRandomizingOrder;

/// Return object at random index.
- (id)randomObject;



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






