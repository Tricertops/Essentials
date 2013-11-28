//
//  NSDictionary+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSDictionary+Essentials.h"
#import "NSArray+Essentials.h"





@implementation NSDictionary (Essentials)





- (id)objectForAnyKey:(id<NSCopying>)firstKey, ... NS_REQUIRES_NIL_TERMINATION {
    NSArray *keys = NSArrayFromVariadicArguments(firstKey);
    for (NSString *key in keys) {
        id value = [self objectForKey:key];
        if (value) return value;
    }
    return nil;
}





@end
