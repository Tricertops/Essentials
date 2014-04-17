//
//  NSDictionary+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSDictionary (Essentials)





/// Enumerates array of keys and returns first non-nil object.
- (id)objectForAnyKeyInArray:(NSArray *)keys;

/// Enumerates keys and returns first non-nil object.
- (id)objectForAnyKey:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;





/// Returns an array of strings, each key and value descriptions joined by the given string.
- (NSArray *)pairsJoinedByString:(NSString *)joiningString;


/// Shorthand for -pairsJoinedByString:
- (NSArray *)join:(NSString *)string;


/// Returns new dictionary that is a copy of the receiving dictionary with values from the other dictionary added or overwirtten.
- (NSDictionary *)dictionaryByAddingValuesFromDictionary:(NSDictionary *)otherDictionary;


/// Shorthand for -dictionaryByAddingValuesFromDictionary:
- (NSDictionary *)merged:(NSDictionary *)other;





@end
