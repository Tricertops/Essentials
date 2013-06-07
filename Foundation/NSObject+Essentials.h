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
- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;



#pragma mark - Runtime Associations

/// Wrapper for objc_getAssociatedObject.
- (id)associatedObject:(void *)key;

/// Wrapper for objc_setAssociatedObject.
- (void)associateObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy;

/// Associates object using nonatomic retain policy.
- (void)associateStrongObject:(id)object forKey:(void *)key;

/// Associates object using nonatomic copy policy.
- (void)associateCopyObject:(id)object forKey:(void *)key;

/// Associates object using assign policy.
- (void)associateAssignObject:(id)object forKey:(void *)key;



@end
