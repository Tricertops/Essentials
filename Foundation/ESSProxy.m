//
//  ESSProxy.m
//  Essentials
//
//  Created by Martin Kiss on 25.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "ESSProxy.h"
#import "NSObject+Essentials.h"
#import "Foundation+Essentials.h"
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

+ (NSMethodSignature *)giveMeAnyMethodSignatureForSelector:(SEL)selector IProceedAtMyOwnRisk:(BOOL)agreed;


@end





@implementation ESSProxy



+ (Class)subclass:(NSString *)name {
    return ESSSubclass(self, name);
}


+ (id)null {
    return [[[ESSProxy subclass:@"ESSNullProxy"] alloc] initWithDescription:^id{
        return NSNull.null;
    } signature:^NSMethodSignature *(SEL selector) {
        return [self giveMeAnyMethodSignatureForSelector:selector IProceedAtMyOwnRisk:YES];
    } forward:^(NSInvocation *invocation) {
        // Not invoking the invocation returns zeroes.
    }];
}


+ (id)multicaster:(id<NSFastEnumeration>)collection {
    return [[[ESSProxy subclass:@"ESSMulticasterProxy"] alloc] initWithDescription:^id{
        return collection;
    } signature:^NSMethodSignature *(SEL selector) {
        for (id object in collection) {
            NSMethodSignature *signature = [object methodSignatureForSelector:selector];
            if (signature) return signature;
        }
        return [self giveMeAnyMethodSignatureForSelector:selector IProceedAtMyOwnRisk:YES];
    } forward:^(NSInvocation *invocation) {
        for (id object in collection) {
            [invocation invokeWithTarget:object];
        }
    }];
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



+ (NSMethodSignature *)giveMeAnyMethodSignatureForSelector:(SEL)selector IProceedAtMyOwnRisk:(BOOL)agreed {
    ESSAssert(agreed, @"You have no idea what you have just done!") ESSNothing;
    
    // I didn’t made this up by myself, it was Nick Lockwood https://github.com/nicklockwood/NullSafe/blob/master/NullSafe/NullSafe.m. Kindly stolen and refactored.
    
    NSString *key = NSStringFromSelector(selector);
    NSCache *cache = [self ess_signatureCache];
    NSMethodSignature *signature = [cache objectForKey:key];
    if ( ! signature) {
        for (NSString *className in [self ess_signatureClassList]) {
            Class class = NSClassFromString(className);
            signature = [class instanceMethodSignatureForSelector:selector];
            if (signature) break;
        }
        ESSAssert(signature, @"There is no method signature for %@ in this program.", key) return nil;
        [cache setObject:signature forKey:key];
    }
    return signature;
}


ESSSharedMake(NSSet *,ess_signatureClassList) {
    NSMutableSet *builder = [[NSMutableSet alloc] init];
    NSMutableSet *excluded = [NSMutableSet set];
    
    int count = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class) * count);
    count = objc_getClassList(classes, count);
    
    for (int index = 0; index < count; index++) {
        Class class = classes[index];
        
        NSArray *superclasses = ESSSuperclasses(class);
        
        for (Class superclass in superclasses) {
            [excluded addObject:NSStringFromClass(superclass)];
        }
        if (superclasses.lastObject == [NSObject class]) {
            [builder addObject:NSStringFromClass(class)];
        }
    }
    free(classes);
    
    [builder minusSet:excluded];
    return builder;
}


ESSSharedCache(ess_signatureCache)




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



- (instancetype)weakProxy {
    Class class = self.class;
    __weak typeof(self) weak = self;
    return [[[ESSProxy subclass:@"ESSWeakProxy"] alloc] initWithDescription:^id{
        return weak ?: [NSString stringWithFormat:@"deallocated instance of %@", class];
    } signature:^NSMethodSignature *(SEL selector) {
        typeof(self) local = weak;
        NSMethodSignature *signature = (local
                                        ? [local methodSignatureForSelector:selector]
                                        : [class instanceMethodSignatureForSelector:selector]);
        return signature ?: [ESSProxy giveMeAnyMethodSignatureForSelector:selector IProceedAtMyOwnRisk:YES];
    } forward:^(NSInvocation *invocation) {
        [invocation invokeWithTarget:weak];
    }];
}


- (instancetype)selectorChecker {
    return [[[ESSProxy subclass:@"ESSSelectorCheckerProxy"] alloc] initWithDescription:^id{
        return self;
    } signature:^NSMethodSignature *(SEL selector) {
        return [self methodSignatureForSelector:selector] ?: [ESSProxy giveMeAnyMethodSignatureForSelector:selector IProceedAtMyOwnRisk:YES];
    } forward:^(NSInvocation *invocation) {
        if ([self respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:self];
        }
        // Not invoking the invocation returns zeroes.
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


- (instancetype)multicasterTo:(NSArray *)objects {
    return [[[ESSProxy subclass:@"ESSMulticasterProxyWithReturn"] alloc] initWithDescription:^id{
        return [NSString stringWithFormat:@"%@ to %@", self, objects];
    } signature:^NSMethodSignature *(SEL selector) {
        return [self methodSignatureForSelector:selector];
    } forward:^(NSInvocation *invocation) {
        NSInvocation *multicasted = [invocation copy]; // Copy before.
        
        [invocation invokeWithTarget:self];
        
        for (NSObject *object in objects) {
            if ([object respondsToSelector:multicasted.selector]) {
                [multicasted invokeWithTarget:object]; // Invoke after.
            }
        }
    }];
}



@end





@implementation NSInvocation (ESSProxy)



- (instancetype)copy {
    __block NSInvocation *copy = nil;
    id catcher = [[[ESSProxy subclass:@"ESSInvocationCopyProxy"] alloc] initWithDescription:^id{
        return self;
    } signature:^NSMethodSignature *(SEL selector) {
        return [ESSProxy giveMeAnyMethodSignatureForSelector:selector IProceedAtMyOwnRisk:YES];
    } forward:^(NSInvocation *invocation) {
        copy = invocation;
        // Not invoking the invocation returns zeroes.
    }];
    [self invokeWithTarget:catcher]; // Leaves the receiver untouched.
    return copy;
}



@end


