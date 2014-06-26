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


/// Returns new dictionary whose keys are receiver's values and whose values are corresponding receiver's keys. Count of the resulting dictionary is the same as count of the receiver unless one value is stored under multiple keys. In that case, only one of those keys will be preserved. Returned object respects the mutability of the receiver.
- (instancetype)invertedDictionary;





@end
