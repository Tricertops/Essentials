//
//  NSString+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSString (Essentials)



/// Returns immutable self or a copy. Provided for polymorphism compatibility with NSNumber.
- (NSString *)stringValue;



#pragma mark - Shortnen Description

/// Shortens string to given number of characters and appends given string to the end.
- (NSString *)shortenedDescriptionToLength:(NSUInteger)length truncateString:(NSString *)truncateString;

/// Shortens the string to given number of characters and appends "...".
- (NSString *)shortenedDescriptionToLength:(NSUInteger)length;

/// Shortens the string to 40 characters and appends "...".
- (NSString *)shortenedDescription;



#pragma mark Content

/// Validates the receiver against email regex pattern.
- (BOOL)isEmail;



#pragma mark - Transformation

/// Removes all html tags (<...>), replaces escaped sequneces and escaped Unicode characters.
- (NSString *)stringByDeletingHTML;

/// Returns a string trimmed of whitespace and new line characters
- (NSString *)trimmedString;

/// Returns a string without diacritics
- (NSString *)stringByStrippingDiacritics;

/// Returns NSURL created using receiver, unless the receiver is empty.
- (NSURL *)URLValue;

/// Returns MD5 hash of the receiver.
- (NSString *)MD5;

/// Returns SHA1 hash of the receiver.
- (NSString *)SHA1;



#pragma mark Splitting

/// Shorthand for -componentsSeparatedByString:
- (NSArray *)split:(NSString *)separator;



#pragma mark Joining

- (NSString *) :(NSString *)a;
- (NSString *) :(NSString *)a :(NSString *)b;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f :(NSString *)g;

+ (NSString *)concat:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;



@end
