//
//  NSObject+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Foundation+Essentials.h"



typedef id(^ESSSwizzleBlock)(SEL selector, IMP original);





@interface NSObject (Essentials)



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


+ (void)swizzleSelector:(SEL)original with:(SEL)replacement;
+ (void)swizzleSelector:(SEL)selector usingBlock:(ESSSwizzleBlock)block;



#pragma mark - Operations

/// Returns YES, if the receiver is not kind of NSNull class, otherwise NO (including case when the method is called on nil).
- (BOOL)isNotNull;



#pragma mark - Classes

/// Returns name of the receiver using NSStringFromClass().
+ (NSString *)name;

/// When the argument is of receiver's kind, returns the argument, otherwise nil.
+ (instancetype)cast:(id)something;

/// Returns the receiver if is kind of given class, otherwise returns replacement.
- (instancetype)ofClass:(Class)class or:(id)replacement;

/// Returns the receiver if it conforms to NSFastEnumeration and contains only objects of given class, otherwise returns replacement.
- (instancetype)collectionOfClass:(Class)class or:(id)replacement;

/// Creates subclass with given name or returns existing subclass.
+ (Class)subclass:(NSString *)name;
+ (Class)deriveClass:(NSString *)name __attribute__((deprecated("Use +subclass: instead")));



#pragma mark - Locking

/// If the receiver conforms for to NSLocking protocol, this method uses a pair of lock/unlock calls, otherwise it uses @synchronized
- (void)locked:(void(^)(void))block;





#pragma mark - Benchmarking

/// Invokes the block while measuring its execution time. Returns the object returned by the block and logs the time to the console.
+ (instancetype)measure:(id(^)(void))block log:(NSString *)log;



@end





extern Class ESSSubclass(Class superclass, NSString *name);



