//
//  NSDictionary+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSDictionary+Essentials.h"





@implementation NSDictionary (Essentials)





- (id)objectForAnyKey:(id<NSCopying>)firstKey, ... NS_REQUIRES_NIL_TERMINATION {
    va_list list;
    va_start(list, firstKey);
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    id<NSCopying> key = nil;;
    while ((key = va_arg(list, id))) {
        [keys addObject:key];
    }
    
    va_end(list);
    
    for (key in keys) {
        id value = [self objectForKey:key];
        if (value) return value;
    }
    return nil;
}





@end
