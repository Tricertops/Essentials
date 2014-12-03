//
//  ESSProxy.h
//  Essentials
//
//  Created by Martin Kiss on 25.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

@import Foundation;





@interface ESSProxy : NSProxy

@end





@interface NSObject (ESSProxy)


/// Returns a proxy that locks all forwarded messages using NSLock.
- (instancetype)threadSafe;

/// Returns a proxy that passes all messages to a given block. No message is invoked on the receiver.
- (instancetype)catcher:(void(^)(NSInvocation *invocation))block;



@end


