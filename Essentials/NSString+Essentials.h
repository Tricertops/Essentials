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

/// Returns NSURL created using receiver, unless the receiver is empty.
- (NSURL *)URLValue;


@end
