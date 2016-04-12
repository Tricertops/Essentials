//
//  NSMutableDictionary+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 31.1.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSMutableDictionary+Essentials.h"





@implementation NSMutableDictionary (Essentials)


- (void)setObject:(id)object forKeyedSubscript:(id)key {
    if (key && object) {
        [self setObject:object forKey:key];
    }
}


- (NSMutableDictionary<id, id> *)addValuesFromDictionary:(NSDictionary<id, id> *)otherDictionary {
    if ([self isEqualToDictionary:otherDictionary]) return self;
    
    [self addEntriesFromDictionary:otherDictionary];
    return self;
}


- (void)setObjects:(NSArray<id> *)objects forKeys:(NSArray<id> *)keys {
    NSDictionary<id, id> *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [self addEntriesFromDictionary:dictionary];
}



@end


