//
//  NSNumber+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSNumber+Essentials.h"





@implementation NSNumber (Essentials)





- (void)times:(void(^)(void))block {
    NSParameterAssert(block);
    
    NSUInteger count = self.unsignedIntegerValue;
    for (NSUInteger index = 0; index < count; index++) {
        block();
    }
}


- (void)timesIndex:(void(^)(NSUInteger index))block {
    NSParameterAssert(block);
    
    NSUInteger count = self.unsignedIntegerValue;
    for (NSUInteger index = 0; index < count; index++) {
        block(index);
    }
}





@end
