//
//  NSMutableDictionary+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 31.1.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/NSDictionary.h>





@interface NSMutableDictionary (Essentials)



/// Adds the values contained in another given dictionary to the receiving dictionary. Returns the receiver.
- (NSMutableDictionary *)addValuesFromDictionary:(NSDictionary *)otherDictionary;

/// Adds a given key-value pairs to the dictionary.
- (void)setObjects:(NSArray *)objects forKeys:(NSArray *)keys;



@end


