//
//  NSMutableSet+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 22.10.15.
//  Copyright © 2015 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSMutableSet<T> (Essentials)


/// Adds a given object to the set, if it is not already a member. If the object is nil, does nothing.
- (void)addObjectIfAny:(T)object;


@end


