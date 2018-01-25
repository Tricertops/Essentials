//
//  JSON.h
//  Essentials
//
//  Created by Martin Kiss on 7 May 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "Foundation+Essentials.h"





#pragma mark - JSON Basic Protocol



//! Protocol that unifies all classes that can be JSON encoded.
@protocol JSON <NSObject>

//! Returns YES, if the receiver can be converted to JSON data.
@property (readonly) BOOL isValidForJSONEncoding;

@end





#pragma mark - JSON Type Aliases



//! Type alias for any object type that can je encoded in JSON.
typedef NSObject<JSON> JSON;
//! Type alias for JSON null value.
typedef NSNull JSONNull;
//! Type alias for JSON boolean value.
typedef NSNumber JSONBoolean;
//! Type alias for JSON number value.
typedef NSNumber JSONNumber;
//! Type alias for JSON string value or object key.
typedef NSString JSONString;
//! Type alias for JSON array.
typedef NSArray<JSON *> JSONArray;
//! Type alias for JSON object.
typedef NSDictionary<JSONString *, JSON *> JSONObject;





#pragma mark - JSON Value Classes


//! NSNull represents JSON null value.
@interface NSNull (JSON) <JSON>

@end



//! NSNumber represents JSON number and boolean values.
@interface NSNumber (JSON) <JSON>

//! Returns YES, if the receiver can be converted to JSON data. NaN and Infinity value are not valid for JSON.
@property (readonly) BOOL isValidForJSONEncoding;

@end



//! NSString represents JSON string value or object keys.
@interface NSString (JSON) <JSON>

@end



//! NSArray represents JSON array.
@interface NSArray<T> (JSON) <JSON>

//! Returns YES, if the receiver can be converted to JSON data. Performs recursive validation.
@property (readonly) BOOL isValidForJSONEncoding;

//! Returns object at given index, if the object conforms to JSON protocol. Returns nil for out-of-bounds indexes.
- (JSON *)JSONAtIndex:(NSUInteger)index;
//! Returns object at given index, if the object is JSON null. Returns nil for out-of-bounds indexes.
- (JSONNull *)JSONNullAtIndex:(NSUInteger)index;
//! Returns object at given index, if the object is JSON boolean. Doesn’t return JSON numbers, even if the same class NSNumber is used to represent both. Returns nil for out-of-bounds indexes.
- (JSONBoolean *)JSONBooleanAtIndex:(NSUInteger)index;
//! Returns object at given index, if the object is JSON number. Doesn’t return JSON booleans, even if the same class NSNumber is used to represent both. Returns nil for out-of-bounds indexes.
- (JSONNumber *)JSONNumberAtIndex:(NSUInteger)index;
//! Returns object at given index, if the object is JSON string. Returns nil for out-of-bounds indexes.
- (JSONString *)JSONStringAtIndex:(NSUInteger)index;
//! Returns object at given index, if the object is JSON array. Doesn’t perform recursive content validation. Returns nil for out-of-bounds indexes.
- (JSONArray *)JSONArrayAtIndex:(NSUInteger)index;
//! Returns object at given index, if the object is JSON object. Doesn’t perform recursive content validation. Returns nil for out-of-bounds indexes.
- (JSONObject *)JSONObjectAtIndex:(NSUInteger)index;

@end



//! NSDictionary represents JSON object.
@interface NSDictionary (JSON) <JSON>

//! Returns YES, if the receiver can be converted to JSON data. Performs recursive validation, keys must be JSON strings.
@property (readonly) BOOL isValidForJSONEncoding;

//! Returns object for given key, if the object conforms to JSON protocol.
- (JSON *)JSONForKey:(JSONString *)key;
//! Returns object for given key, if the object is JSON null.
- (JSONNull *)JSONNullForKey:(JSONString *)key;
//! Returns object for given key, if the object is JSON boolean. Doesn’t JSON return numbers, even if the same class NSNumber is used to represent both.
- (JSONBoolean *)JSONBooleanForKey:(JSONString *)key;
//! Returns object for given key, if the object is JSON number. Doesn’t return JSON booleans, even if the same class NSNumber is used to represent both.
- (JSONNumber *)JSONNumberForKey:(JSONString *)key;
//! Returns object for given key, if the object is JSON string.
- (JSONString *)JSONStringForKey:(JSONString *)key;
//! Returns object for given key, if the object is JSON array. Doesn’t perform recursive content validation.
- (JSONArray *)JSONArrayForKey:(JSONString *)key;
//! Returns object for given key, if the object is JSON object. Doesn’t perform recursive content validation.
- (JSONObject *)JSONObjectForKey:(JSONString *)key;

@end





#pragma mark - JSON Encoding & Decoding



//! Object that represents encoded JSON file.
@protocol JSONFile;



//! Convenience extension that allows calling  [JSON decodeJSON:data]
@interface NSObject (JSONCoding)

//! Decodes JSON and returns the root. Performs no extra class validation.
+ (JSON *)decodeJSON:(NSObject<JSONFile> *)file;

@end



//! Sub-protocol of JSON, which unifies all classes that can represent root JSON value.
@protocol JSONRoot <JSON>

//! Encodes the receiver to JSON data using UTF-8 encoding.
- (NSData *)encodeJSONDataPretty:(BOOL)pretty;

//! Encodes the receiver to JSON string using UTF-8 encoding.
- (NSString *)encodeJSONStringPretty:(BOOL)pretty;

//! Encodes the receiver to JSON data using UTF-8 encoding and writes it to the given file. Returns success.
- (BOOL)encodeJSONFile:(NSURL *)fileURL pretty:(BOOL)pretty;

//! Encodes the receiver to JSON data using UTF-8 encoding and writes it to the given stream. Returns success.
- (BOOL)encodeJSONToStream:(NSOutputStream *)stream pretty:(BOOL)pretty;

//! Decodes JSON and returns the root, if it conforms to receiver class. When invoked on mutable receiver class, decoding uses mutable classes.
+ (instancetype)decodeJSON:(NSObject<JSONFile> *)representation;

@end



//! NSArray, which represents JSON array, can be root of JSON file.
@interface NSArray<T> (JSONCoding) <JSONRoot>

@end



//! NSDictionary, which represents JSON object, can be root of JSON file.
@interface NSDictionary (JSONCoding) <JSONRoot>

@end





#pragma mark JSON File Representations



//! Object that represents encoded JSON file.
@protocol JSONFile <NSObject>

//! Method used internally to decode JSON from different representations.
- (id)decodeJSONWithOptions:(NSJSONReadingOptions)options;

@end



//! NSData can be used to represent encoded JSON file.
@interface NSData (JSONEncoded) <JSONFile>

@end



//! NSURL can be used to represent encoded JSON file.
@interface NSURL (JSONEncoded) <JSONFile>

@end



//! NSString can be used to represent encoded JSON file.
@interface NSString (JSONEncoded) <JSONFile>

@end



//! NSInputStream can be used to represent encoded JSON file.
@interface NSInputStream (JSONEncoded) <JSONFile>

@end


