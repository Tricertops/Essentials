//
//  ESSProxy.m
//  Essentials
//
//  Created by Martin Kiss on 25.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "ESSProxy.h"
#import "NSObject+Essentials.h"
#import "NSOperationQueue+Essentials.h"



typedef id (^ESSProxyDescriptionBlock)(void);
typedef NSMethodSignature *(^ESSProxyMethodSignatureBlock)(SEL selector);
typedef void (^ESSProxyForwardInvocationBlock)(NSInvocation *invocation);



@interface ESSProxy ()


+ (Class)subclass:(NSString *)name;

@property (readonly) ESSProxyDescriptionBlock descriptionBlock;
@property (readonly) ESSProxyMethodSignatureBlock signatureBlock;
@property (readonly) ESSProxyForwardInvocationBlock forwardBlock;

- (id)initWithDescription:(ESSProxyDescriptionBlock)block
                signature:(ESSProxyMethodSignatureBlock)block
                  forward:(ESSProxyForwardInvocationBlock)block;


@end





@implementation ESSProxy



+ (Class)subclass:(NSString *)name {
    return ESSSubclass(self, name);
}



- (id)initWithDescription:(ESSProxyDescriptionBlock)descriptionBlock
                signature:(ESSProxyMethodSignatureBlock)signatureBlock
                  forward:(ESSProxyForwardInvocationBlock)forwardBlock
{
    self->_descriptionBlock = descriptionBlock;
    self->_signatureBlock = signatureBlock;
    self->_forwardBlock = forwardBlock;
    return self;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return (self.signatureBlock? self.signatureBlock(selector) : nil);
}


- (void)forwardInvocation:(NSInvocation *)invocation {
    if (self.forwardBlock) {
        invocation.target = nil;
        self.forwardBlock(invocation);
    }
    // Not invoking the invocation returns zeroes.
}


- (NSString *)description {
    id object = (self.descriptionBlock? self.descriptionBlock() : @"Undefined");
    return [NSString stringWithFormat:@"<%@ %p: %@>", self.class, self, object];
}



@end





@implementation NSObject (ESSProxy)



- (instancetype)threadSafe {
    NSLock *lock = [NSLock new];
    return [[[ESSProxy subclass:@"ESSThreadSafeProxy"] alloc] initWithDescription:^id{
        return self;
    } signature:^NSMethodSignature *(SEL selector) {
        return [self methodSignatureForSelector:selector];
    } forward:^(NSInvocation *invocation) {
        [lock lock];
        [invocation invokeWithTarget:self];
        [lock unlock];
    }];
}



- (instancetype)async {
    return [self asyncOnQueue:[NSOperationQueue utilityQueue]];
}


- (instancetype)asyncOnQueue:(NSOperationQueue *)queue {
    return [[[ESSProxy subclass:@"ESSAsyncProxy"] alloc] initWithDescription:^id{
        return [NSString stringWithFormat:@"%@ on %@", self, queue];
    } signature:^NSMethodSignature *(SEL selector) {
        return [self methodSignatureForSelector:selector];
    } forward:^(NSInvocation *invocation) {
        [invocation retainArguments];
        [queue asynchronous:^{
            [invocation invokeWithTarget:self];
        }];
        // Not invoking the invocation returns zeroes.
    }];
}


- (instancetype)catcher:(void(^)(NSInvocation *invocation))block {
    return [[[ESSProxy subclass:@"ESSCatcherProxy"] alloc] initWithDescription:^id{
        return self;
    } signature:^NSMethodSignature *(SEL selector) {
        return [self methodSignatureForSelector:selector];
    } forward:^(NSInvocation *invocation) {
        block(invocation);
        // Not invoking the invocation returns zeroes.
    }];
}


@end


