//
//  JSON.m
//  Essentials
//
//  Created by Martin Kiss on 7 May 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "JSON.h"





#pragma mark - JSON Value Classes



@implementation NSNull (JSON)

- (BOOL)isValidForJSONEncoding {
    return [NSJSONSerialization isValidJSONObject:self];
}

@end



@implementation NSNumber (JSON)

- (BOOL)isValidForJSONEncoding {
    return [NSJSONSerialization isValidJSONObject:self];
}

@end



@implementation NSString (JSON)

- (BOOL)isValidForJSONEncoding {
    return [NSJSONSerialization isValidJSONObject:self];
}

@end



@implementation NSArray THIS_IS_NOT_MACRO (JSON)

- (BOOL)isValidForJSONEncoding {
    return [NSJSONSerialization isValidJSONObject:self];
}

- (JSON *)JSONAtIndex:(NSUInteger)index {
    if (index >= self.count) return nil;
    
    id value = self[index];
    if ([value isKindOfClass:NSNull.class]) return value;
    if ([value isKindOfClass:NSNumber.class]) return value;
    if ([value isKindOfClass:NSString.class]) return value;
    if ([value isKindOfClass:NSArray.class]) return value;
    if ([value isKindOfClass:NSDictionary.class]) return value;
    return nil;
}

- (JSONNull *)JSONNullAtIndex:(NSUInteger)index {
    if (index >= self.count) return nil;
    
    id value = self[index];
    BOOL isNull = [value isKindOfClass:NSNull.class];
    return (isNull ? value : nil);
}

- (JSONBoolean *)JSONBooleanAtIndex:(NSUInteger)index {
    if (index >= self.count) return nil;
    
    id value = self[index];
    BOOL isBool = (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse);
    return (isBool ? value : nil);
}

- (JSONNumber *)JSONNumberAtIndex:(NSUInteger)index {
    if (index >= self.count) return nil;
    
    id value = self[index];
    BOOL isNumber = [value isKindOfClass:NSNumber.class];
    BOOL isBool = (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse);
    return (isNumber && !isBool ? value : nil);
}

- (JSONString *)JSONStringAtIndex:(NSUInteger)index {
    if (index >= self.count) return nil;
    
    id value = self[index];
    BOOL isString = [value isKindOfClass:NSString.class];
    return (isString ? value : nil);
}

- (JSONArray *)JSONArrayAtIndex:(NSUInteger)index {
    if (index >= self.count) return nil;
    
    id value = self[index];
    BOOL isArray = [value isKindOfClass:NSArray.class];
    return (isArray ? value : nil);
}

- (JSONObject *)JSONObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) return nil;
    
    id value = self[index];
    BOOL isDictionary = [value isKindOfClass:NSDictionary.class];
    return (isDictionary ? value : nil);
}

@end



@implementation NSDictionary (JSON)

- (BOOL)isValidForJSONEncoding {
    return [NSJSONSerialization isValidJSONObject:self];
}

- (JSON *)JSONForKey:(JSONString *)key {
    id value = self[key];
    if ([value isKindOfClass:NSNull.class]) return value;
    if ([value isKindOfClass:NSNumber.class]) return value;
    if ([value isKindOfClass:NSString.class]) return value;
    if ([value isKindOfClass:NSArray.class]) return value;
    if ([value isKindOfClass:NSDictionary.class]) return value;
    return nil;
}

- (JSONNull *)JSONNullForKey:(JSONString *)key {
    id value = self[key];
    BOOL isNull = [value isKindOfClass:NSNull.class];
    return (isNull ? value : nil);
}

- (JSONBoolean *)JSONBooleanForKey:(JSONString *)key {
    id value = self[key];
    BOOL isBool = (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse);
    return (isBool ? value : nil);
}

- (JSONNumber *)JSONNumberForKey:(JSONString *)key {
    id value = self[key];
    BOOL isNumber = [value isKindOfClass:NSNumber.class];
    BOOL isBool = (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse);
    return (isNumber && !isBool ? value : nil);
}

- (JSONString *)JSONStringForKey:(JSONString *)key {
    id value = self[key];
    BOOL isString = [value isKindOfClass:NSString.class];
    return (isString ? value : nil);
}

- (JSONArray *)JSONArrayForKey:(JSONString *)key {
    id value = self[key];
    BOOL isArray = [value isKindOfClass:NSArray.class];
    return (isArray ? value : nil);
}

- (JSONObject *)JSONObjectForKey:(JSONString *)key {
    id value = self[key];
    BOOL isDictionary = [value isKindOfClass:NSDictionary.class];
    return (isDictionary ? value : nil);
}

@end





#pragma mark - JSON Encoding & Decoding


@implementation NSObject (JSONCoding)

+ (JSON *)decodeJSON:(NSObject<JSONFile> *)file {
    return [file decodeJSONWithOptions:kNilOptions];
}

@end



@implementation NSArray THIS_IS_NOT_MACRO (JSONCoding)

- (NSData *)encodeJSONDataPretty:(BOOL)pretty {
    NSJSONWritingOptions options = (pretty? NSJSONWritingPrettyPrinted : kNilOptions);
    return [NSJSONSerialization dataWithJSONObject:self options:options error:nil];
}

- (NSString *)encodeJSONStringPretty:(BOOL)pretty {
    let data = [self encodeJSONDataPretty:pretty];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)encodeJSONFile:(NSURL *)fileURL pretty:(BOOL)pretty {
    let data = [self encodeJSONDataPretty:pretty];
    return [data writeToURL:fileURL atomically:YES];
}

- (BOOL)encodeJSONToStream:(NSOutputStream *)stream pretty:(BOOL)pretty {
    NSJSONWritingOptions options = (pretty? NSJSONWritingPrettyPrinted : kNilOptions);
    NSInteger length = [NSJSONSerialization writeJSONObject:self toStream:stream options:options error:nil];
    return (length > 0);
}

+ (instancetype)decodeJSON:(NSObject<JSONFile> *)representation {
    BOOL isMutable = [self isSubclassOfClass:NSMutableArray.class];
    NSJSONReadingOptions options = (isMutable ? NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers : kNilOptions);
    return [representation decodeJSONWithOptions:options];
}

@end



@implementation NSDictionary (JSONCoding)

- (NSData *)encodeJSONDataPretty:(BOOL)pretty {
    NSJSONWritingOptions options = (pretty? NSJSONWritingPrettyPrinted : kNilOptions);
    return [NSJSONSerialization dataWithJSONObject:self options:options error:nil];
}

- (NSString *)encodeJSONStringPretty:(BOOL)pretty {
    let data = [self encodeJSONDataPretty:pretty];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)encodeJSONFile:(NSURL *)fileURL pretty:(BOOL)pretty {
    let data = [self encodeJSONDataPretty:pretty];
    return [data writeToURL:fileURL atomically:YES];
}

- (BOOL)encodeJSONToStream:(NSOutputStream *)stream pretty:(BOOL)pretty {
    NSJSONWritingOptions options = (pretty? NSJSONWritingPrettyPrinted : kNilOptions);
    NSInteger length = [NSJSONSerialization writeJSONObject:self toStream:stream options:options error:nil];
    return (length > 0);
}

+ (instancetype)decodeJSON:(NSObject<JSONFile> *)file {
    BOOL isMutable = [self isSubclassOfClass:NSMutableDictionary.class];
    NSJSONReadingOptions options = (isMutable ? NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers : kNilOptions);
    return [file decodeJSONWithOptions:options];
}

@end





#pragma mark JSON File Representations



@implementation NSData (JSONEncoded)

- (id)decodeJSONWithOptions:(NSJSONReadingOptions)options {
    return [NSJSONSerialization JSONObjectWithData:self options:options error:nil];
}

@end



@implementation NSURL (JSONEncoded)

- (id)decodeJSONWithOptions:(NSJSONReadingOptions)options {
    let data = [NSData dataWithContentsOfURL:self];
    return [data decodeJSONWithOptions:options];
}

@end



@implementation NSString (JSONEncoded)

- (id)decodeJSONWithOptions:(NSJSONReadingOptions)options {
    let data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data decodeJSONWithOptions:options];
}

@end



@implementation NSInputStream (JSONEncoded)

- (id)decodeJSONWithOptions:(NSJSONReadingOptions)options {
    return [NSJSONSerialization JSONObjectWithStream:self options:options error:nil];
}

@end


