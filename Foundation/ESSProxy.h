//
//  ESSProxy.h
//  Essentials
//
//  Created by Martin Kiss on 25.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

@import Foundation;





@interface ESSProxy : NSProxy

+ (id)null;

@end





@interface NSObject (ESSProxy)


/// Returns a proxy that locks all forwarded messages using NSLock.
- (instancetype)threadSafe;

/// Returns a proxy that holds the receiver weakly.
- (instancetype)weakProxy;

/// Returns a proxy that check all messages using -respondsToSelector: method.
- (instancetype)selectorChecker;

/// Returns a proxy that invokes all messages asynchronously on a default Utility queue. Don’t expect the return value !!!!!!!!!!!!!!!!!!!!
- (instancetype)async;

/// Returns a proxy that invokes all messages on a given queue. Don’t expect the return value !!!!!!!!!!!!!!!!!!!!
- (instancetype)asyncOnQueue:(NSOperationQueue *)queue;

/// Returns a proxy that passes all messages to a given block. No message is invoked on the receiver.
- (instancetype)catcher:(void(^)(NSInvocation *invocation))block;

/// Returns a proxy that in addition to invoking messages on the receiver also invokes the messages on the given objects. Returned values of the other objects are ignored.
- (instancetype)multicasterTo:(NSArray *)objects;


@end





@interface NSInvocation (ESSProxy)

/// Returns a copy of the receiver.
- (instancetype)copy;

@end


