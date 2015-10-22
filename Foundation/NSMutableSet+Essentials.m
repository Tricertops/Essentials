//
//  NSMutableSet+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 22.10.15.
//  Copyright © 2015 iAdverti. All rights reserved.
//

#import "NSMutableSet+Essentials.h"



@implementation NSMutableSet (Essentials)



- (void)addObjectIfAny:(id)object {
    if (object) {
        [self addObject:object];
    }
}



@end


