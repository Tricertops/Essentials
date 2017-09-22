//
//  ESSEvent.m
//  Essentials
//
//  Created by Martin Kiss on 10.2.16.
//  Copyright © 2016 Martin Kiss. All rights reserved.
//

#import "ESSEvent.h"
#import "Foundation+Essentials.h"



@interface ESSEvent ()


@property NSUInteger notifyCount;
@property (readonly) NSMapTable<NSObject *, NSMutableArray<void (^)(id, id)> *> *handlersByObserver;

@property NSInteger suspendDepth;
@property BOOL isNotifying;


@end





@implementation ESSEvent





- (instancetype)init {
    return [self initWithOwner:nil initialValue:nil];
}


- (instancetype)initWithOwner:(id)owner initialValue:(id)value {
    self = [super init];
    if (self) {
        self->_owner = owner;
        self->_lastValue = value;
        self->_handlersByObserver = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}


- (void)notify {
    [self sendValue:self.lastValue];
}


- (void)sendValue:(id)value {
    if (self.isNotifying)
        return; //! Avoid recursion.
    
    self->_lastValue = value;
    if (self.isSuspended)
        return;
    
    self.isNotifying = YES;
    self.notifyCount ++;
    //! This Event might be mutated while handlers are executed, so copy the collections.
    
    __auto_type handlersByObserver = [self copyHandlersByObservers];
    for (NSObject *observer in handlersByObserver) {
        __auto_type handlers = handlersByObserver[observer];
        for (void (^handler)(id, id) in handlers) {
            handler(observer, value);
        }
    }
    self.isNotifying = NO;
}


- (NSMapTable<NSObject *, NSArray<void (^)(id, id)> *> *)copyHandlersByObservers NS_RETURNS_NOT_RETAINED {
    __auto_type weakCollection = self.handlersByObserver;
    typeof(self.copyHandlersByObservers) strong = [NSMapTable strongToStrongObjectsMapTable];
    for (NSObject *observer in weakCollection) {
        strong[observer] =  [weakCollection[observer] copy];
    }
    return strong;
}





#pragma mark Managing Observers


- (void)addObserver:(NSObject *)observer handler:(void (^)(id, id))handler {
    ESSAssert(observer) else return;
    ESSAssert(handler) else return;
    
    __auto_type handlers = self.handlersByObserver[observer];
    if ( ! handlers) {
        handlers = [NSMutableArray new];
        self.handlersByObserver[observer] = handlers;
    }
    [handlers addObject:handler];
    
    if ( ! self.isSuspended && self.notifyCount > 0)
        //! Initial invocation.
        handler(observer, self.lastValue);
}


- (void)addObserver:(NSObject *)observer selector:(SEL)selector {
    ESSAssert([observer respondsToSelector: selector]) else return;
    
    [self addObserver:observer handler:^(NSObject *observer, id value) {
         [observer performSelector:selector withObject:value];
     }];
}


- (void)chainTo:(__weak ESSEvent *)event {
    ESSAssert(event) else return;
    ESSAssert(event.owner) else return;
    
    [self addObserver:event.owner handler:^(NSObject *owner, id value) {
         [event sendValue:value];
    }];
}


- (void)replaceValue:(id)replacedValue chainTo:(__weak ESSEvent *)event {
    ESSAssert(event) else return;
    ESSAssert(event.owner) else return;
    
    [self addObserver:event.owner handler:^(NSObject *owner, id originalValue) {
        [event sendValue:replacedValue];
    }];
}


- (void)removeObserver:(NSObject *)observer {
    ESSAssert(observer) else return;
   
    [self.handlersByObserver removeObjectForKey: observer];
}


- (void)removeAllObservers {
    [self.handlersByObserver removeAllObjects];
}





#pragma mark - Suspendation


- (BOOL)isSuspended
{
    ESSDebugAssert(self.suspendDepth >= 0)
    else self.suspendDepth = 0; //! Fix the counter.
    
    return (self.suspendDepth > 0);
}


- (void)suspend
{
    ESSDebugAssert(self.suspendDepth >= 0)
    else self.suspendDepth = 0; //! Fix the counter.
    
    self.suspendDepth ++;
}


- (void)resumeAndNotify: (BOOL)alsoNotify
{
    ESSAssert(self.suspendDepth > 0)
    else self.suspendDepth = 1; //! Pretend we are suspended.
    
    if (self.suspendDepth > 0)
        self.suspendDepth --;
    
    if (self.suspendDepth == 0 && alsoNotify)
        [self notify];
}





@end


