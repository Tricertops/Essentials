//
//  NSDictionary+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSDictionary+Essentials.h"
#import "NSArray+Essentials.h"
#import "NSMutableDictionary+Essentials.h"
#import "NSObject+Essentials.h"





@implementation NSDictionary (Essentials)





#pragma mark Accessing Objects


- (id)objectForAnyKeyInArray:(NSArray<id> *)keys {
    for (NSString *key in keys) {
        id value = [self objectForKey:key];
        if (value) return value;
    }
    return nil;
}


- (id)objectForAnyKey:(id<NSCopying>)firstKey, ... NS_REQUIRES_NIL_TERMINATION {
    return [self objectForAnyKeyInArray:NSArrayFromVariadicArguments(firstKey)];
}


- (NSArray<id> *)arrayForKey:(id<NSCopying>)key {
    return [NSArray cast:self[key]];
}


- (BOOL)boolForKey:(id<NSCopying>)key {
    id object = self[key];
    return ([object respondsToSelector:@selector(boolValue)]
            && [object boolValue]);
}


- (NSData *)dataForKey:(id<NSCopying>)key {
    id object = self[key];
    NSData *data = [NSData cast:object];
    if (data) return data;
    
    NSString *base64 = [NSString cast:object];
    if ( ! base64) return nil;
    
    return [[NSData alloc] initWithBase64EncodedString:base64 options:kNilOptions];
}


- (double)doubleForKey:(id<NSCopying>)key {
    id object = self[key];
    return ([object respondsToSelector:@selector(doubleValue)]
            ? [object doubleValue]
            : NAN);
}


- (NSInteger)integerForKey:(id<NSCopying>)key {
    id object = self[key];
    return ([object respondsToSelector:@selector(integerValue)]
            ? [object integerValue]
            : 0);
}


- (NSString *)stringForKey:(id<NSCopying>)key {
    return [NSString cast:self[key]];
}


- (NSURL *)URLForKey:(id<NSCopying>)key {
    NSURL *URL = [NSURL cast:self[key]];
    if (URL) return (URL.scheme? URL : nil);
    
    NSString *string = [NSString cast:self[key]];
    if ( ! string) return nil;
    
    URL = [NSURL URLWithString:string];
    return (URL.scheme? URL : nil);
}


- (NSDate *)dateForKey:(id<NSCopying>)key {
    return [self dateForKey:key UNIX:YES];
}


- (NSDate *)dateForKey:(id<NSCopying>)key UNIX:(BOOL)usesUNIXEpoch {
    NSDate *date = [NSDate cast:self[key]];
    if (date) return date;
    
    double seconds = [self doubleForKey:key];
    if (isnan(seconds)) return nil;
    
    return (usesUNIXEpoch
            ? [NSDate dateWithTimeIntervalSince1970:seconds]
            : [NSDate dateWithTimeIntervalSinceReferenceDate:seconds]);
}





#pragma mark Joining


- (NSArray<NSString *> *)pairsJoinedByString:(NSString *)joiningString {
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray<NSString *> *pair = @[ [key description], [obj description] ];
        [array addObject:[pair join:joiningString]];
    }];
    return [array copy];
}


- (NSArray<NSString *> *)join:(NSString *)string {
    return [self pairsJoinedByString:string];
}





#pragma mark Merging


- (NSDictionary<id, id> *)dictionaryByAddingValuesFromDictionary:(NSDictionary<id, id> *)otherDictionary {
    return [[self mutableCopy] addValuesFromDictionary:otherDictionary];
}


- (NSDictionary<id, id> *)merged:(NSDictionary<id, id> *)other {
    return [self dictionaryByAddingValuesFromDictionary:other];
}





#pragma mark Inverting


- (NSDictionary<id, id> *)invertedDictionary {
    NSArray<id> *keys = self.allKeys;
    NSArray<id> *values = [self objectsForKeys:keys notFoundMarker:NSNull.null];
    return [self.class dictionaryWithObjects:keys forKeys:values];
}





@end


