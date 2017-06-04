//
//  NSMapTable+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.1.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import "NSMapTable+Essentials.h"



@implementation NSMapTable (Essentials)



+ (instancetype)mapTableWithIdentityComparision {
    return [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPointerPersonality
                                 valueOptions:NSPointerFunctionsObjectPersonality];
}



- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}


- (void)setObject:(id)object forKeyedSubscript:(id)key {
    if (object) {
        [self setObject:object forKey:key];
    }
    else {
        [self removeObjectForKey:key];
    }
}



- (id)objectForKey:(id)key builder:(id (^)(void))builder {
    id object = self[key];
    if ( ! object) {
        object = builder();
        self[key] = object;
    }
    return object;
}



@end


