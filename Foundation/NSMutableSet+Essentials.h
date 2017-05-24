//
//  NSMutableSet+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 22.10.15.
//  Copyright © 2015 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>



#define NSSet(first, other...) \
    ( (NSSet<typeof(first)> *) ({ \
        typeof(first) _objects[] = {first, other}; \
        NSUInteger _count = sizeof(_objects) / sizeof(id); \
        [NSSet setWithObjects:_objects count:_count]; \
    }))

#define NSMutableSet(first, other...) \
    ( (NSMutableSet<typeof(first)> *) ({ \
        typeof(first) _objects[] = {first, other}; \
        NSUInteger _count = sizeof(_objects) / sizeof(id); \
        [NSMutableSet setWithObjects:_objects count:_count]; \
    }))



@interface NSMutableSet<T> (Essentials)


/// Adds a given object to the set, if it is not already a member. If the object is nil, does nothing.
- (void)addObjectIfAny:(T)object;


@end


