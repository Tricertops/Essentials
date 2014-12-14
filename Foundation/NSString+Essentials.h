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



#pragma mark - Range

/// Range covering all characters of the receiver.
@property (readonly) NSRange fullRange;



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

/// Returns YES, if the receiver contains given substring.
- (BOOL)containsSubstring:(NSString *)string;

/// Returns YES, if the receiver contains given substring using given compare option.
- (BOOL)containsSubstring:(NSString *)string options:(NSStringCompareOptions)options;

/// Enumerates all occurrences of a given string within the receiver, subject to given options. Block takes the matched string and its range in the receiver.
- (void)enumerateOccurencesOfString:(NSString *)string options:(NSStringCompareOptions)options usingBlock:(void(^)(NSString *match, NSRange range, BOOL *stop))block;

/// Returns indexes of all characters from given set.
- (NSIndexSet *)indexesOfCharactersFromSet:(NSCharacterSet *)charset;



#pragma mark - Transformation
//TODO: NSMutableString alteratives

/// Removes all html tags (<...>), replaces escaped sequneces and escaped Unicode characters.
- (NSString *)stringByDeletingHTML;

/// Returns a string trimmed of whitespace and new line characters
- (NSString *)trimmedString;

/// Returns a string without diacritics
- (NSString *)stringByStrippingDiacritics;

/// Returns a string that contains only ASCII characters. Slightly faster than -stringByStrippingDiacritics.
- (NSString *)stringByConvertingToASCII;

/// Deletes all characters from given set.
- (NSString *)stringByDeletingCharactersFromSet:(NSCharacterSet *)characterSet;

/// Deletes all characters except for those in given set.
- (NSString *)stringByPreservingOnlyCharactersFromSet:(NSCharacterSet *)characterSet;

/// Converts first character to uppercase.
- (NSString *)stringByCapitalizingFirstCharacter;

/// Returns NSURL created using receiver, unless the receiver is empty.
- (NSURL *)URLValue;

/// Returns MD5 hash of the receiver.
- (NSString *)MD5;

/// Returns SHA1 hash of the receiver.
- (NSString *)SHA1;

/// Replaces {key} placeholders with the return value of the block
- (NSString *)stringBySubstitutingWithBlock:(NSString *(^)(NSString *placeholderKey))block;

/// Replaces {key} placeholders with the values of substitutions[key]
- (NSString *)stringBySubstitutingWithDictionary:(NSDictionary *)substitutions;

/// Returns new string that is normalized for search without case and diacritics sensitivity.
- (NSString *)normalizedString;



#pragma mark Splitting

/// Shorthand for -componentsSeparatedByString:
- (NSArray *)split:(NSString *)separator;

/// Returns an array of strings, each with length of 1.
- (NSArray *)letters;

/// The first letter.
@property (readonly) NSString *firstLetter;

/// Returns an array of lines.
- (NSArray *)lines;

/// Returns an array of paragraphs.
- (NSArray *)paragraphs;

/// Returns an array of sentences.
- (NSArray *)sentences;

/// Returns an array of words without surrounding punctuation.
- (NSArray *)words;

/// Returns an array of words normalized for search.
- (NSArray *)normalizedWords;



#pragma mark Joining

- (NSString *) :(NSString *)a;
- (NSString *) :(NSString *)a :(NSString *)b;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f :(NSString *)g;

+ (NSString *)concat:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;

- (NSArray *)stringsByAppendingStrings:(NSArray *)suffixes usingString:(NSString *)joiningString;


@end



#define ESS(number)      (@(number).stringValue)

#define ESSString(FORMAT...)     [NSString stringWithFormat:FORMAT]

#define NSStringFromFormat(format)\
({\
    va_list __vargs;\
    va_start(__vargs, format);\
    NSString *__string = [[NSString alloc] initWithFormat:format arguments:__vargs];\
    va_end(__vargs);\
    __string;\
})
