//
//  NSObject+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>




@interface NSObject (Essentials)



#pragma mark - Delayed Action

/// Delayed execution of block
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block __deprecated;



#pragma mark - Runtime Associations

/// Wrapper for objc_getAssociatedObject.
- (id)associatedObjectForKey:(void *)key;
- (id)associatedObjectForString:(NSString * const *)string;

/// Wrapper for objc_setAssociatedObject.
- (void)setAssociatedObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy;
- (void)setAssociatedObject:(id)object forString:(NSString * const *)string policy:(objc_AssociationPolicy)policy;

/// Associates object using nonatomic retain policy.
- (void)setAssociatedStrongObject:(id)object forKey:(void *)key;
- (void)setAssociatedStrongObject:(id)object forString:(NSString * const *)string;

/// Associates object using nonatomic copy policy.
- (void)setAssociatedCopyObject:(id)object forKey:(void *)key;
- (void)setAssociatedCopyObject:(id)object forString:(NSString * const *)string;

/// Associates object using assign policy.
- (void)setAssociatedAssignObject:(id)object forKey:(void *)key;
- (void)setAssociatedAssignObject:(id)object forString:(NSString * const *)string;



#pragma mark - Null

/// Returns YES, if the receiver is not kind of NSNull class, otherwise NO (including case when the method is called on nil).
- (BOOL)isNotNull;



@end
