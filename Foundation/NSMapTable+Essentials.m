//
//  NSMapTable+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.1.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import "NSMapTable+Essentials.h"



@implementation NSMapTable (Essentials)



- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}


- (void)setObject:(id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}



@end


