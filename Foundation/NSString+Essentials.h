//
//  NSString+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"
#import "NSNumber+Essentials.h"





@interface NSString (Essentials)



/// Returns immutable self or a copy. Provided for polymorphism compatibility with NSNumber.
@property (readonly) NSString *stringValue;

@property (readonly) NSInteger i;
@property (readonly) NSUInteger u;
@property (readonly) NSFloat f;
@property (readonly) BOOL b;



#pragma mark - Range

/// Range covering all characters of the receiver.
@property (readonly) NSRange fullRange;

/// Returns the number of bytes required to store the receiver in a UTF-8.
@property (readonly) NSUInteger UTF8Length;



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

/// Returns a character set with characters in the receiver.
- (NSCharacterSet*)characterSet;

/// Creates string with random letters in 0-9, A-Z and a-z.
+ (NSString *)randomStringWithLength:(NSUInteger)length;

/// Create string with random letters from given string.
+ (NSString *)randomStringWithLength:(NSUInteger)length letters:(NSString *)letters;



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

/// Converts first character to uppercase using given NSLocale.
- (NSString *)stringByCapitalizingFirstCharacterUsingLocale:(NSLocale*)locale;

/// Returns NSURL created using receiver, unless the receiver is empty.
@property (readonly) NSURL *URLValue;

/// Returns MD5 hash of the receiver.
@property (readonly) NSString *MD5;

/// Returns SHA1 hash of the receiver.
@property (readonly) NSString *SHA1;

/// Returns SHA256 hash of the receiver.
@property (readonly) NSString *SHA256;

/// Returns NSData with receiver in UTF-8 encoding.
@property (readonly) NSData *UTF8Data;

/// Enumerates all substitution tokens of format "{...}". It is safe to mutate the receiver while enumerating, pass new continue location from which to perform next search (to avoid recursion).
- (void)enumerateSubstitutionsWithBlock:(void(^)(NSRange enclosingRange, NSString *content, NSUInteger *continueLocation))block;

/// Replaces {key} placeholders with the return value of the block.
- (NSString *)stringBySubstitutingWithBlock:(NSString *(^)(NSString *placeholderKey))block;

/// Replaces {key:value|key:value} placeholders with the return value of the block.
- (NSString *)stringBySubstitutingWithDictionaryBlock:(NSString *(^)(NSString *placeholder, NSDictionary<NSString *, NSString *> *dictionary))block;

/// Replaces {key} placeholders with the values of substitutions[key]
- (NSString *)stringBySubstitutingWithDictionary:(NSDictionary<NSString *, NSString *> *)substitutions;

/// Shorter form for -stringBySubstitutingWithDictionary:
- (NSString *)substitute:(NSDictionary<NSString *, NSString *> *)substitutions;

/// Returns new string that is normalized for search without case and diacritics sensitivity.
- (NSString *)normalizedString;

/// Enumerate parts of string between opening and closing strings, for example parentheses. It’s safe to mutate the receiver as long as you update continueLocation.
- (void)enumerateSubstringsBetween:(NSString *)opening and:(NSString *)closing usingBlock:(void(^)(NSString *content, NSRange rangeIncludingDelimiters, NSUInteger *continueLocation))block;

/// Calculates Levenshtein edit distance from receiver to the given string.
- (NSInteger)levenshteinDistanceTo:(NSString *)string;


/// If the receiver is non-empty, returns receiver. Otherwise returns nil, so it nevers returns empty string. Useful in ternary expressions
@property (readonly) NSString *nonEmpty NS_SWIFT_NAME(__essentialsNonEmptyNSString);
// string.nonEmpty ?: @"–"



#pragma mark Splitting

/// Shorthand for -componentsSeparatedByString:
- (NSArray<NSString *> *)split:(NSString *)separator;

/// Returns an array of strings, each with length of 1.
- (NSArray<NSString *> *)letters;

/// The first letter.
@property (readonly) NSString *firstLetter;

/// Returns an array of lines.
- (NSArray<NSString *> *)lines;

/// Returns an array of paragraphs.
- (NSArray<NSString *> *)paragraphs;

/// Returns an array of sentences.
- (NSArray<NSString *> *)sentences;

/// Returns an array of words without surrounding punctuation.
- (NSArray<NSString *> *)words;

/// Returns an array of words normalized for search.
- (NSArray<NSString *> *)normalizedWords;



#pragma mark Joining

- (NSString *) :(NSString *)a;
- (NSString *) :(NSString *)a :(NSString *)b;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f;
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f :(NSString *)g;

+ (NSString *)concat:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;

- (NSArray<NSString *> *)stringsByAppendingStrings:(NSArray<NSString *> *)suffixes usingString:(NSString *)joiningString;

- (NSString*)repeat:(NSUInteger)times;



#pragma mark Characters

+ (NSString *)SPACE;
+ (NSString *)THIN_SPACE;
+ (NSString *)NO_BREAK_SPACE;
+ (NSString *)NEW_LINE;





@end



#define ESS(number)      (@(number).stringValue)

#define ESSString(FORMAT...)     [NSString stringWithFormat:FORMAT]

#define NSStringFromFormat(format)\
({\
    va_list __vargs;\
    va_start(__vargs, format);\
    let __string = [[NSString alloc] initWithFormat:format arguments:__vargs];\
    va_end(__vargs);\
    __string;\
})
