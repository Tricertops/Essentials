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





#pragma mark Method Swizzling


+ (void)swizzleClass:(Class)class selector:(SEL)originalSelector with:(SEL)replacementSelector {
    /// http://nshipster.com/method-swizzling/
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method replacementMethod = class_getInstanceMethod(class, replacementSelector);
    
    BOOL didAdd = class_addMethod(class,
                                  originalSelector,
                                  method_getImplementation(replacementMethod),
                                  method_getTypeEncoding(replacementMethod));
    if (didAdd) {
        class_replaceMethod(class,
                            replacementSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, replacementMethod);
    }
}


+ (void)swizzleSelector:(SEL)original with:(SEL)replacement {
    [NSObject swizzleClass:self selector:original with:replacement];
}


+ (void)swizzleSelector:(SEL)selector usingBlock:(ESSSwizzleBlock)swizzleBlock {
    Method method = class_getInstanceMethod(self, selector);
    IMP originalImplementation = method_getImplementation(method);
    
    id replacementBlock = swizzleBlock(selector, originalImplementation);
    IMP replacementImplementation = imp_implementationWithBlock(replacementBlock);
    
    class_replaceMethod(self, selector, replacementImplementation, method_getTypeEncoding(method));
}





#pragma mark - Operations


- (BOOL)isNotNull {
    return (self != NSNull.null);
}





#pragma mark - Classes


+ (NSString *)name {
    return NSStringFromClass(self);
}


+ (instancetype)cast:(id)something {
    return [something isKindOfClass:self] ? something : nil;
}


- (instancetype)ofClass:(Class)class or:(id)replacement {
    return [self isKindOfClass:class] ? self : replacement;
}


- (instancetype)collectionOfClass:(Class)class or:(id)replacement {
    if ( ! [self conformsToProtocol:@protocol(NSFastEnumeration)]) return replacement;
    
    NSObject<NSFastEnumeration> *collection = (typeof(collection))self;
    for (id object in collection) {
        if ( ! [object isKindOfClass:class]) {
            return replacement;
        }
    }
    return self;
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





#pragma mark - Locking


- (void)locked:(void(^)(void))block {
    if ([self conformsToProtocol:@protocol(NSLocking)]) {
        id<NSLocking> lock = (id<NSLocking>)self;
        [lock lock];
        block();
        [lock unlock];
    }
    else {
        @synchronized(self) {
            block();
        }
    }
}





@end
