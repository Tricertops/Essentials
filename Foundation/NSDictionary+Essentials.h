//
//  NSDictionary+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSDictionary (Essentials)



- (id)objectForAnyKey:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;



@end
