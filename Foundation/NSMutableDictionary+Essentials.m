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
    
    [self addEntriesFromDictionary:otherDictionary];
    return self;
}


- (void)setObjects:(NSArray *)objects forKeys:(NSArray *)keys {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [self addEntriesFromDictionary:dictionary];
}



@end


