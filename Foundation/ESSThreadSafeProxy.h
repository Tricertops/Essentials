//
//  ESSThreadSafeProxy.h
//  Essentials
//
//  Created by Martin Kiss on 25.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

@import Foundation;





@interface NSObject (ESSThreadSafeProxy)


/// Returns a proxy object that forwards all methods to the receiver and encapsulates all calls in lock/unlock.
- (instancetype)threadSafe;



@end


