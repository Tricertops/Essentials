//
//  ESSThreadSafeProxy.m
//  Essentials
//
//  Created by Martin Kiss on 25.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "ESSThreadSafeProxy.h"





@interface ESSThreadSafeProxy : NSProxy



- (instancetype)initWithObject:(NSObject *)underlying;
@property (readonly) NSObject *underlying;
@property (readonly) NSLock *lock;



@end





@implementation ESSThreadSafeProxy





- (instancetype)initWithObject:(NSObject *)underlying {
    self->_underlying = underlying;
    self->_lock = [NSLock new];
    return self;
}





- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self->_underlying methodSignatureForSelector:selector];
}


- (void)forwardInvocation:(NSInvocation *)invocation {
    [self->_lock lock];
    [invocation invokeWithTarget:self->_underlying];
    [self->_lock unlock];
}





- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass(self.class), [self->_underlying description]];
}


- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass(self.class), [self->_underlying debugDescription]];
}





@end





@implementation NSObject (ESSThreadSafeProxy)



- (instancetype)threadSafe {
    if ([self isKindOfClass:[ESSThreadSafeProxy class]]) {
        return self;
    }
    else {
        return (typeof(self))[[ESSThreadSafeProxy alloc] initWithObject:self];
    }
}



@end


