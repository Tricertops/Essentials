//
//  NSDictionary+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSDictionary (Essentials)




#pragma mark Accessing Objects


/// Enumerates array of keys and returns first non-nil object.
- (id)objectForAnyKeyInArray:(NSArray *)keys;

/// Enumerates keys and returns first non-nil object.
- (id)objectForAnyKey:(id<NSCopying>)firstKey, ... NS_REQUIRES_NIL_TERMINATION;


/// Returns an array stored under given key, or nil.
- (NSArray *)arrayForKey:(id<NSCopying>)key;

/// Returns a boolValue of object stored under given key, or NO.
- (BOOL)boolForKey:(id<NSCopying>)key;

/// Returns a data stored under given key, or nil. Attempts to decode base64 strings.
- (NSData *)dataForKey:(id<NSCopying>)key;

/// Returns a doubleValue of object stored under given key, or NAN.
- (double)doubleForKey:(id<NSCopying>)key;

/// Returns an integerValue of object stored under given key, or 0.
- (NSInteger)integerForKey:(id<NSCopying>)key;

/// Returns a string stored under given key, or nil.
- (NSString *)stringForKey:(id<NSCopying>)key;

/// Returns an URL stored or created from string stored under given key, or nil. URL is validated.
- (NSURL *)URLForKey:(id<NSCopying>)key;

/// Returns a date stored or date created from doubleValue of stored object under given key. Uses UNIX epoch.
- (NSDate *)dateForKey:(id<NSCopying>)key;

/// Returns a date stored or date created from doubleValue of stored object under given key.
- (NSDate *)dateForKey:(id<NSCopying>)key UNIX:(BOOL)usesUNIXEpoch;




#pragma mark Joining


/// Returns an array of strings, each key and value descriptions joined by the given string.
- (NSArray *)pairsJoinedByString:(NSString *)joiningString;

/// Shorthand for -pairsJoinedByString:
- (NSArray *)join:(NSString *)string;



#pragma mark Merging


/// Returns new dictionary that is a copy of the receiving dictionary with values from the other dictionary added or overwirtten.
- (NSDictionary *)dictionaryByAddingValuesFromDictionary:(NSDictionary *)otherDictionary;


/// Shorthand for -dictionaryByAddingValuesFromDictionary:
- (NSDictionary *)merged:(NSDictionary *)other;



#pragma mark Inverting

/// Returns new dictionary whose keys are receiver's values and whose values are corresponding receiver's keys. Count of the resulting dictionary is the same as count of the receiver unless one value is stored under multiple keys. In that case, only one of those keys will be preserved. Returned object respects the mutability of the receiver.
- (instancetype)invertedDictionary;





@end


