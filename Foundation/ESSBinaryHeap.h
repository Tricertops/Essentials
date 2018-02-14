//
//  ESSBinaryHeap.h
//  Essentials
//
//  Created by Martin Kiss on 13 Feb 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

@import Foundation;
#import "Typed.h"

NS_ASSUME_NONNULL_BEGIN



/// Container that stores values sorted using a binary search algorithm and can be useful as priority queue.
@interface ESSBinaryHeap<ElementType> : NSObject <NSCopying, TypedNSFastEnumeration>


#pragma mark - Utilities

/// Re-declaring NSComparator, so it uses generic types.
typedef NSComparisonResult (^NSComparator)(ElementType objectA, ElementType objectB);
/// Builds comparator block that uses given sort descriptors to compare objects. Sort descriptors are evaluated in order until one returns result other than NSOrderedSame.
+ (NSComparator)comparatorWithSortDescriptors:(NSArray<NSSortDescriptor *> *)descriptors;
/// Builds comparator block that uses given selector to compare objects, optionally in inversed order.
+ (NSComparator)comparatorWithSelector:(SEL)selector descending:(BOOL)isInversed;


#pragma mark - Initializers

/// Creates new heap that uses -compare: method to compare objects. Good for NSString, NSNumber, NSDate, etc.
- (instancetype)init;
/// Creates new heap that uses given selector to compare objects, optionally in inversed order.
- (instancetype)initWithSelector:(SEL)selector descending:(BOOL)isInversed;
/// Creates new heap that uses sort descriptors to compare objects. Sort descriptors are evaluated in order until one returns result other than NSOrderedSame.
- (instancetype)initWithSortDescriptors:(NSArray<NSSortDescriptor *> *)descriptors;
/// Creates new heap that uses given block to compare objects.
- (instancetype)initWithComparator:(NSComparator)comparator NS_DESIGNATED_INITIALIZER;
/// Creates new heap that is a copy of the argument.
- (instancetype)initWithBinaryHeap:(ESSBinaryHeap *)other NS_DESIGNATED_INITIALIZER;


#pragma mark - Accessors

/// Number of objects in the heap.
@property (readonly) NSUInteger count;
/// The object that is ordered first. If there are several objects that are NSOrderedSame, any one may be returned.
@property (readonly, nullable) ElementType firstObject;

/// If any object in heap is NSOrderedSame as the argument, YES is returned.
- (BOOL)containsObjectOrderedSameAs:(ElementType)object;
/// Number of objects in heap that are NSOrderedSame as the argument.
- (NSUInteger)countOfObjectsOrderedSameAs:(ElementType)object;

/// Block used to order objects as passed to designated initializer or constructed in convenience initializer.
@property (readonly) NSComparator comparator;


#pragma mark - Enumeration

/// Invokes block on every object in the heap in ascending order. Order of objects that are NSOrderedSame is not defined.
- (void)enumerateUsingBlock:(void (^)(ElementType object))block;
/// Ordered collection of all objects in the heap. Order of objects that are NSOrderedSame is not defined.
@property (readonly) NSArray<ElementType> *allObjects;
/// Declaration for foreach() macro as required by TypedNSFastEnumeration.
- (ElementType)Typed_enumeratedType;


#pragma mark - Mutating

/// Adds object to the heap. Object is inserted at appropriate position to keep the heap ordered.
- (void)addObject:(ElementType)object;
/// Adds all objects from given array to the heap. Order of objects in the array is not significant.
- (void)addObjectsFromArray:(NSArray<ElementType> *)array;
/// Adds all objects from given set to the heap. Note that heap doesn’t use -isEqual: for equality.
- (void)addObjectsFromSet:(NSSet<ElementType> *)set;
/// Removes firatObject from the heap and returns it.
- (nullable ElementType)removeFirstObject;
/// Removes all objects from the heap.
- (void)removeAllObjects;


#pragma mark - Equality & Copying

/// Compares two heaps for equality.
- (BOOL)isEqual:(nullable ESSBinaryHeap<ElementType> *)other;
/// Returns a mutable copy of the heap.
- (instancetype)copy;


@end



NS_ASSUME_NONNULL_END
