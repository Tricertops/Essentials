//
//  NSInvocation+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSInvocation (Essentials)



#pragma mark Creating

/// Quick way of creating invocations. Arguments are used to obtain method signature and then are assigned to invocation.
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)sel;



#pragma mark Arguments

/// Retrieves object argument at given index. Index should ignore `self` and `_cmd`, so the first argument after those two is at index 0.
- (id)objectArgumentAtIndex:(NSInteger)index;

/// Sets object argument at given index. Index should ignore `self` and `_cmd`, so the first argument after those two is at index 0.
- (void)setObjectArgument:(id)object atIndex:(NSInteger)index;

/// Retrieves integer argument at given index. Index should ignore `self` and `_cmd`, so the first argument after those two is at index 0.
- (NSInteger)integerArgumentAtIndex:(NSInteger)index;

/// Sets integer argument at given index. Index should ignore `self` and `_cmd`, so the first argument after those two is at index 0.
- (void)setIntegerArgument:(NSInteger)integer atIndex:(NSInteger)index;



#pragma mark Return Value

/// Retrieves return value as object.
- (id)objectReturnValue;

/// Sets return value as object.
- (void)setObjectReturnValue:(id)object;

/// Retrieves return value as integer.
- (NSInteger)integerReturnValue;

/// Sets return value as integer.
- (void)setIntegerReturnValue:(NSInteger)integer;



@end
