//
//  NSMutableDictionary+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 31.1.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/NSDictionary.h>





@interface NSMutableDictionary<K, V> (Essentials)


// Original method is declared using KeyType<NSCopying> which breaks Clang’s typechecking.
/// Adds a given key-value pair to the dictionary or removes given key from dictionary.
- (void)setObject:(V)object forKeyedSubscript:(K)key;

/// Adds the values contained in another given dictionary to the receiving dictionary. Returns the receiver.
- (instancetype)addValuesFromDictionary:(NSDictionary<K, V> *)otherDictionary;

/// Adds a given key-value pairs to the dictionary.
- (void)setObjects:(NSArray<V> *)objects forKeys:(NSArray<K> *)keys;



@end


