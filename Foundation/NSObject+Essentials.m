//
//  NSObject+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSObject+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSObject (Essentials)





#pragma mark - Delayed Action


- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block __deprecated {
    [[NSOperationQueue currentQueue] performSelector:@selector(addOperationWithBlock:) withObject:block afterDelay:seconds];
}





#pragma mark - Runtime Associations


- (id)associatedObjectForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}


- (id)associatedObjectForString:(NSString *const __autoreleasing *)string {
    return [self associatedObjectForKey:(void *)string];
}


- (void)setAssociatedObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(self, key, object, policy);
}


- (void)setAssociatedObject:(id)object forString:(NSString *const __autoreleasing *)string policy:(objc_AssociationPolicy)policy {
    [self setAssociatedObject:object forKey:(void *)string policy:policy];
}


- (void)setAssociatedStrongObject:(id)object forKey:(void *)key {
    [self setAssociatedObject:object forKey:key policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


- (void)setAssociatedStrongObject:(id)object forString:(NSString *const __autoreleasing *)string {
    [self setAssociatedStrongObject:object forKey:(void *)string];
}


- (void)setAssociatedCopyObject:(id)object forKey:(void *)key {
    [self setAssociatedObject:object forKey:key policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}


- (void)setAssociatedCopyObject:(id)object forString:(NSString *const __autoreleasing *)string {
    [self setAssociatedCopyObject:object forKey:(void *)string];
}


- (void)setAssociatedAssignObject:(id)object forKey:(void *)key {
    [self setAssociatedObject:object forKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}


- (void)setAssociatedAssignObject:(id)object forString:(NSString *const __autoreleasing *)string {
    [self setAssociatedAssignObject:object forKey:(void *)string];
}





#pragma mark - Operations


- (BOOL)isNotNull {
    return (self != NSNull.null);
}





#pragma mark - Classes


+ (NSString *)name {
    return NSStringFromClass(self);
}


- (instancetype)ofClass:(Class)class or:(id)replacement {
    return [self isKindOfClass:class] ? self : replacement;
}


+ (Class)subclass:(NSString *)name {
    ESSAssertException(name.length > 0, @"Can not create class with no name!");
    
    Class subclass = NSClassFromString(name);
    
    if ( ! subclass) {
        subclass = objc_allocateClassPair(self, name.UTF8String, 0);
        objc_registerClassPair(subclass);
    }
    else {
        ESSAssert([subclass isSubclassOfClass:self], @"Found existing class '%@' but it's not subclassed from '%@'!", subclass, self) return self;
    }
    
    return subclass ?: self;
}


+ (Class)deriveClass:(NSString *)name {
    return [self subclass:name];
}





@end
