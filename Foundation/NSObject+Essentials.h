//
//  NSObject+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



typedef id(^ESSSwizzleBlock)(SEL selector, IMP original);





@interface NSObject (Essentials)



- (id)safelyPerformSelector:(SEL)selector;



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

/// Returns an array of superclasses. First is -superclass and the last is the root class.
+ (NSArray<Class> *)superclasses;

/// Returns an array of classes. First is -class, second is -superclass and the last is the root class.
- (NSArray<Class> *)classes;

/// Return the root superclass.
- (Class)rootClass;

/// Returns bundle from which this class was loaded.
+ (NSBundle *)bundle;

/// When the argument is of receiver's kind, returns the argument, otherwise nil.
+ (instancetype)cast:(id)something;

+ (instancetype)assert:(id)something NS_SWIFT_NAME(assertCast(_:));

/// Returns the receiver if is kind of given class, otherwise returns replacement.
- (instancetype)ofClass:(Class)class or:(id)replacement;

/// Returns the receiver if it conforms to NSFastEnumeration and contains only objects of given class, otherwise returns replacement.
- (instancetype)collectionOfClass:(Class)class or:(id)replacement;

/// Creates subclass with given name or returns existing subclass.
+ (Class)subclass:(NSString *)name;
+ (Class)deriveClass:(NSString *)name __attribute__((deprecated("Use +subclass: instead")));

/// Allocates subclass of receiver’s class, passes it to the block and then sets it to receiver’s class.
- (void)swizzleClassWithSuffix:(NSString *)nameSuffix customizations:(void (^)(Class))block;

/// Adds method for given selector implemented using given block. Extra info is gathered from given class.
+ (BOOL)overrideSelector:(SEL)selector fromSuperclass:(Class)superclass withBlock:(id)anyBlockWithIDArgument;



#pragma mark - Locking

/// If the receiver conforms for to NSLocking protocol, this method uses a pair of lock/unlock calls, otherwise it uses @synchronized
- (void)locked:(void(^)(void))block;





#pragma mark - Benchmarking

/// Invokes the block while measuring its execution time. Returns the object returned by the block and logs the time to the console.
+ (instancetype)measure:(id(^)(void))block log:(NSString *)log, ... NS_FORMAT_FUNCTION(2, 3);



@end





extern Class ESSSubclass(Class superclass, NSString *name, void (^customizations)(Class));

extern NSMutableArray<Class> * ESSSuperclasses(Class class);


