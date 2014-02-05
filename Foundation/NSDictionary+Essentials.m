//
//  NSDictionary+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSDictionary+Essentials.h"
#import "NSArray+Essentials.h"
#import "NSMutableDictionary+Essentials.h"





@implementation NSDictionary (Essentials)





- (id)objectForAnyKey:(id<NSCopying>)firstKey, ... NS_REQUIRES_NIL_TERMINATION {
    NSArray *keys = NSArrayFromVariadicArguments(firstKey);
    for (NSString *key in keys) {
        id value = [self objectForKey:key];
        if (value) return value;
    }
    return nil;
}


- (NSArray *)pairsJoinedByString:(NSString *)joiningString {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *pair = @[ [key description], [obj description] ];
        [array addObject:[pair join:joiningString]];
    }];
    return [array copy];
}


- (NSArray *)join:(NSString *)string {
    return [self pairsJoinedByString:string];
}


- (NSDictionary *)dictionaryByAddingValuesFromDictionary:(NSDictionary *)otherDictionary {
    return [[self mutableCopy] addValuesFromDictionary:otherDictionary];
}


- (NSDictionary *)merged:(NSDictionary *)other {
    return [self dictionaryByAddingValuesFromDictionary:other];
}





@end
