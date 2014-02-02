//
//  NSMutableDictionary+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 31.1.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSMutableDictionary+Essentials.h"





@implementation NSMutableDictionary (Essentials)



- (NSMutableDictionary *)addValuesFromDictionary:(NSDictionary *)otherDictionary {
    if ([self isEqualToDictionary:otherDictionary]) return self;
    
    [otherDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setObject:obj forKey:key];
    }];
    return self;
}



@end


