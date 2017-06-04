//
//  NSDictionary+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSDictionary<K, V> (Essentials)




#pragma mark Accessing Objects


/// Enumerates array of keys and returns first non-nil object.
- (V)objectForAnyKeyInArray:(NSArray<K> *)keys;

/// Enumerates keys and returns first non-nil object.
- (V)objectForAnyKey:(K<NSCopying>)firstKey, ... NS_REQUIRES_NIL_TERMINATION;


/// Returns an array stored under given key, or nil.
- (NSArray<id> *)arrayForKey:(K<NSCopying>)key;

/// Returns a boolValue of object stored under given key, or NO.
- (BOOL)boolForKey:(K<NSCopying>)key;

/// Returns a data stored under given key, or nil. Attempts to decode base64 strings.
- (NSData *)dataForKey:(K<NSCopying>)key;

/// Returns a doubleValue of object stored under given key, or NAN.
- (double)doubleForKey:(K<NSCopying>)key;

/// Returns an integerValue of object stored under given key, or 0.
- (NSInteger)integerForKey:(K<NSCopying>)key;

/// Returns a string stored under given key, or nil.
- (NSString *)stringForKey:(K<NSCopying>)key;

/// Returns an URL stored or created from string stored under given key, or nil. URL is validated.
- (NSURL *)URLForKey:(K<NSCopying>)key;

/// Returns a date stored or date created from doubleValue of stored object under given key. Uses UNIX epoch.
- (NSDate *)dateForKey:(K<NSCopying>)key;

/// Returns a date stored or date created from doubleValue of stored object under given key.
- (NSDate *)dateForKey:(K<NSCopying>)key UNIX:(BOOL)usesUNIXEpoch;




#pragma mark Joining


/// Returns an array of strings, each key and value descriptions joined by the given string.
- (NSArray<NSString *> *)pairsJoinedByString:(NSString *)joiningString;

/// Shorthand for -pairsJoinedByString:
- (NSArray<NSString *> *)join:(NSString *)string;



#pragma mark Merging


/// Returns new dictionary that is a copy of the receiving dictionary with values from the other dictionary added or overwirtten.
- (NSDictionary<K, V> *)dictionaryByAddingValuesFromDictionary:(NSDictionary<K, V> *)otherDictionary;


/// Shorthand for -dictionaryByAddingValuesFromDictionary:
- (NSDictionary<K, V> *)merged:(NSDictionary<K, V> *)other;


/// Creates new dictionary that contains the same keys, but with new values.
- (NSMutableDictionary<K, id> *)map:(id (^)(K key, V object))block;



#pragma mark Inverting

/// Returns new dictionary whose keys are receiver's values and whose values are corresponding receiver's keys. Count of the resulting dictionary is the same as count of the receiver unless one value is stored under multiple keys. In that case, only one of those keys will be preserved. Returned object respects the mutability of the receiver.
- (NSDictionary<V, K> *)invertedDictionary;





@end


