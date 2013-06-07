//
//  NSObject+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSObject+Essentials.h"





@implementation NSObject (Essentials)





#pragma mark - Delayed Action


- (void)performAfter:(NSTimeInterval)seconds block:(void(^)(void))block {
    [[NSOperationQueue currentQueue] performSelector:@selector(addOperationWithBlock:) withObject:block afterDelay:seconds];
}





#pragma mark - Runtime Associations


- (id)associatedObject:(void *)key {
    return objc_getAssociatedObject(self, key);
}


- (void)associateObject:(id)object forKey:(void *)key policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(self, key, object, policy);
}


- (void)associateStrongObject:(id)object forKey:(void *)key {
    [self associateObject:object forKey:key policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}


- (void)associateCopyObject:(id)object forKey:(void *)key {
    [self associateObject:object forKey:key policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}


- (void)associateAssignObject:(id)object forKey:(void *)key {
    [self associateObject:object forKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}





@end
