//
//  NSString+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSString+Essentials.h"
#import "NSArray+Essentials.h"
#import "Foundation+Essentials.h"
#import "NSData+Essentials.h"
#import <CommonCrypto/CommonDigest.h>





@implementation NSString (Essentials)





- (NSString *)stringValue {
    return [self copy];
}


- (NSInteger)i {
    return self.integerValue;
}
- (NSUInteger)u {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    unsigned long long value = 0;
    BOOL ok = [scanner scanUnsignedLongLong:&value];
    
    return (ok && value <= NSUIntegerMax ? (NSUInteger)value : 0);
}
- (NSFloat)f {
    return self.doubleValue;
}
- (BOOL)b {
    return self.boolValue;
}





#pragma mark - Range


- (NSRange)fullRange {
    return NSMakeRange(0, self.length);
}


- (NSUInteger)UTF8Length {
    return [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}





#pragma mark - Shortnen Description


- (NSString *)shortenedDescriptionToLength:(NSUInteger)length truncateString:(NSString *)truncateString {
    if (self.length <= length) {
        return [self copy];
    }
    else {
        NSString *truncated = [self substringWithRange:NSMakeRange(0, length)];
        return [truncated stringByAppendingString:truncateString];
    }
}


- (NSString *)shortenedDescriptionToLength:(NSUInteger)length {
    return [self shortenedDescriptionToLength:length truncateString:@"..."];
}


- (NSString *)shortenedDescription {
    return [self shortenedDescriptionToLength:40];
}





#pragma mark Content


- (BOOL)isEmail {
    static NSRegularExpression *regexEmail = nil;
    if ( ! regexEmail) {
        regexEmail = [NSRegularExpression regularExpressionWithPattern:
                      @"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$"
                                                               options:NSRegularExpressionCaseInsensitive
                                                                 error:nil];
    }
    NSUInteger matches = [regexEmail numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return (matches > 0); // Only one match can be found, since the pattern specifies beginning and end of string.
}


- (BOOL)containsSubstring:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return (range.location != NSNotFound);
}


- (BOOL)containsSubstring:(NSString *)string options:(NSStringCompareOptions)options {
    NSRange range = [self rangeOfString:string options:options];
    return (range.location != NSNotFound);
}


- (void)enumerateOccurencesOfString:(NSString *)string options:(NSStringCompareOptions)options usingBlock:(void(^)(NSString *match, NSRange range, BOOL *stop))block {
    NSRange searchRange = NSMakeRange(0, self.length);
    
    while (INFINITY) {
        NSRange range = [self rangeOfString:string options:options range:searchRange];
        if (range.location == NSNotFound) break;
        
        searchRange.location = range.location + range.length;
        searchRange.length = self.length - searchRange.location;
        
        NSString *match = [self substringWithRange:range];
        BOOL stop = NO;
        block(match, range, &stop);
        if (stop) break;
    }
}


- (NSIndexSet *)indexesOfCharactersFromSet:(NSCharacterSet *)charset {
    NSMutableIndexSet *indexes = [NSMutableIndexSet new];
    NSRange searchRange = NSMakeRange(0, self.length);
    
    while (INFINITY) {
        NSRange range = [self rangeOfCharacterFromSet:charset options:kNilOptions range:searchRange];
        if (range.location == NSNotFound) break;
        
        [indexes addIndexesInRange:range];
        
        searchRange.location = range.location + range.length;
        searchRange.length = self.length - searchRange.location;
    }
    
    return indexes;
}


- (NSCharacterSet *)characterSet {
    return [NSCharacterSet characterSetWithCharactersInString:self];
}


+ (NSString *)randomStringWithLength:(NSUInteger)length {
    static NSString * const letters = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    return [self randomStringWithLength:length letters:letters];
}


+ (NSString *)randomStringWithLength:(NSUInteger)length letters:(NSString *)lettersString {
    NSArray<NSString *> *letters = lettersString.letters;
    NSMutableString *string = [NSMutableString new];
    forcount (index, length) {
        [string appendString: [letters randomObject]];
    }
    return string;
}





#pragma mark - Transformation


- (NSURL *)URLValue {
    if (self.length) {
        return [NSURL URLWithString:self];
    }
    else {
        return nil;
    }
}


- (NSString *)stringByDeletingHTML {
    // Delete HTMl tags.
    /// http://stackoverflow.com/questions/277055/remove-html-tags-from-an-nsstring-on-the-iphone
    NSRange range;
    NSMutableString *string = [self mutableCopy];
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    // Replace escaped sequences.
    NSDictionary<NSString *, NSString *> *escapes = @{
                                                      @"&quot;": @"\"",
                                                      @"&apos;": @"'",
                                                      @"&lt;"  : @"<",
                                                      @"&gt;"  : @">",
                                                      @"&amp;" : @"&", // Should be last.
                                                      };
    foreach (toFind, escapes) {
        NSString *toReplace = [escapes objectForKey:toFind];
        [string replaceOccurrencesOfString:toFind withString:toReplace options:0 range:NSMakeRange(0, string.length)];
    }
    
    // Replace &#0000; by corresponding Unicode character.
    while ((range = [string rangeOfString:@"&#[0-9]+;" options:NSRegularExpressionSearch]).location != NSNotFound) {
        NSString *unicodeNumber = [string substringWithRange:NSMakeRange(range.location+2, range.length-3)];
        NSString *replacement = [NSString stringWithFormat:@"%C", (unichar)unicodeNumber.intValue];
        [string replaceCharactersInRange:range withString:replacement];
    }
    
    return string;
}

- (NSString *)trimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)stringByStrippingDiacritics {
    return [self stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
}


- (NSString *)stringByConvertingToASCII {
    NSData *ASCIIData = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [[NSString alloc] initWithData:ASCIIData encoding:NSASCIIStringEncoding];
}


- (NSString *)stringByDeletingCharactersFromSet:(NSCharacterSet *)characterSet {
    NSMutableString *mutable = [self mutableCopy];
    NSRange range;
    while (INFINITY) {
        range = [mutable rangeOfCharacterFromSet:characterSet];
        if (range.location == NSNotFound) break;
        
        [mutable deleteCharactersInRange:range];
    }
    return mutable;
}


- (NSString *)stringByPreservingOnlyCharactersFromSet:(NSCharacterSet *)characterSet {
    return [self stringByDeletingCharactersFromSet:[characterSet invertedSet]];
}


- (NSString *)stringByCapitalizingFirstCharacter {
    return [self stringByCapitalizingFirstCharacterUsingLocale:nil];
}


- (NSString *)stringByCapitalizingFirstCharacterUsingLocale:(NSLocale*)locale {
    if (self.length < 1) return [self copy];
    if (self.length == 1) return [self capitalizedStringWithLocale:locale];
    
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:0];
    NSString *firstCharacter = [self substringToIndex:range.length];
    NSString *theRest = [self substringFromIndex:range.length];
    return [[firstCharacter capitalizedStringWithLocale:locale] : theRest];
}


- (NSString *)MD5 {
    NSMutableData *data = [NSMutableData dataWithLength:CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.UTF8String, (CC_LONG)self.UTF8Length, data.mutableBytes);
    return data.hexadecimalString;
}


- (NSString *)SHA1 {
    NSMutableData *data = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.UTF8String, (CC_LONG)self.UTF8Length, data.mutableBytes);
    return data.hexadecimalString;
}


- (NSString *)SHA256 {
    NSMutableData *data = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.UTF8String, (CC_LONG)self.UTF8Length, data.mutableBytes);
    return data.hexadecimalString;
}


- (NSData *)UTF8Data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}


- (void)enumerateSubstitutionsWithBlock:(void(^)(NSRange enclosingRange, NSString *content, NSUInteger *continueLocation))block {
    [self enumerateSubstringsBetween:@"{" and:@"}" usingBlock:^(NSString *content, NSRange enclosingRange, NSUInteger *continueLocation) {
        block(enclosingRange, content, continueLocation);
    }];
}


- (NSString *)stringBySubstitutingWithBlock:(NSString *(^)(NSString *placeholderKey))block {
    NSMutableString *mutable = [self mutableCopy];
    
    [mutable enumerateSubstitutionsWithBlock:^(NSRange enclosingRange, NSString *content, NSUInteger *continueLocation) {
        NSString *replacement = block(content);
        [mutable replaceCharactersInRange:enclosingRange withString:replacement ?: @""];
        *continueLocation = enclosingRange.location + replacement.length;
        //TODO: Detect enclosing spaces and remove one of them.
    }];
    return mutable;
}


- (NSString *)stringBySubstitutingWithDictionaryBlock:(NSString *(^)(NSString *placeholder, NSDictionary<NSString *, NSString *> *dictionary))block {
    return [self stringBySubstitutingWithBlock:^NSString *(NSString *placeholder) {
        NSMutableDictionary<NSString *, NSString *> *dictionary = [NSMutableDictionary new];
        foreach (pair, [placeholder split:@"|"]) {
            NSArray<NSString *> *components = [pair split:@":"];
            NSString *key = (components.count > 1? components[0] : @"");
            NSString *value = (components.count > 1? components[1] : components[0]);
            dictionary[key] = value;
        }
        return block(placeholder, dictionary);
    }];
}


- (NSRange)rangeOfOpening:(NSString *)opening closing:(NSString *)closing after:(NSUInteger)location {
    NSRange notFound = NSMakeRange(NSNotFound, 0);
    
    if ( ! opening.length) return notFound;
    if ( ! closing.length) return notFound;
    if (location >= self.length) return notFound;
    
    NSRange openingSearchRange = NSMakeRange(location, self.length - location);
    NSRange openingRange = [self rangeOfString:opening options:kNilOptions range:openingSearchRange];
    if (openingRange.location == NSNotFound) return notFound;
    
    NSUInteger openingRangeEnd = openingRange.location + openingRange.length;
    NSRange closingSearchRange = NSMakeRange(openingRangeEnd, self.length - openingRangeEnd);
    NSRange closingRange = [self rangeOfString:closing options:kNilOptions range:closingSearchRange];
    if (closingRange.location == NSNotFound) return notFound;
    
    NSUInteger closingRangeEnd = closingRange.location + closingRange.length;
    return NSMakeRange(openingRange.location, closingRangeEnd - openingRange.location);
}


- (void)enumerateSubstringsBetween:(NSString *)opening and:(NSString *)closing usingBlock:(void(^)(NSString *content, NSRange rangeIncludingDelimiters, NSUInteger *continueLocation))block {
    NSRange enclosingRange = NSMakeRange(0, 0);
    
    while (INFINITY) {
        enclosingRange = [self rangeOfOpening:opening closing:closing after:NSMaxRange(enclosingRange)];
        if (enclosingRange.location == NSNotFound)
            break;
        
        NSRange contentRange = NSMakeRange(enclosingRange.location + opening.length, enclosingRange.length - opening.length - closing.length);
        NSString *content = [self substringWithRange:contentRange];
        
        NSUInteger location = NSMaxRange(enclosingRange);
        block(content, enclosingRange, &location);
        
        enclosingRange.location = location;
        enclosingRange.length = 0; // Used in the next iteration.
    }
}


- (NSString *)stringBySubstitutingWithDictionary:(NSDictionary<NSString *, NSString *> *)substitutions {
    return [self stringBySubstitutingWithBlock:^NSString *(NSString *placeholderKey) {
        return [[substitutions objectForKey:placeholderKey] description];
    }];
}


- (NSString *)substitute:(NSDictionary<NSString *, NSString *> *)substitutions {
    return [self stringBySubstitutingWithDictionary:substitutions];
}


- (NSString *)normalizedString {
    return [self stringByFoldingWithOptions:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)
                                     locale:[NSLocale currentLocale]];
}


- (NSInteger)levenshteinDistanceTo:(NSString *)B {
    //! Copyright © 2014 koyachi (The MIT License)
    //! https://github.com/koyachi/NSString-LevenshteinDistance
    //! Edited for my coding style. In fact, completely rewritten.
    
    let A = self;
    
    // If 16-bits is not enought, just change it here:
    typedef uint16_t type;
    type max = ~(type)0;
    
    let height = A.length + 1;
    let width = B.length + 1;
    var distances = (type*)calloc(height * width, sizeof(type));
    
    let at = ^NSUInteger (NSUInteger x, NSUInteger y) {
        return y * width + x;
    };
    
    forcount (y, height) {
        distances[at(0, y)] = y;
    }
    
    forcount (x, width) {
        distances[at(x, 0)] = x;
    }
    
    unichar charactersA[A.length];
    unichar charactersB[B.length];
    [A getCharacters:charactersA range:A.fullRange];
    [B getCharacters:charactersB range:B.fullRange];
    
    forcount (y, A.length) {
        let charA = charactersA[y];
        forcount (x, B.length) {
            let charB = charactersB[x];
            
            let insert  = distances[at(x+1, y  )] + 1;
            let remove  = distances[at(x,   y+1)] + 1;
            let replace = distances[at(x,   y  )] + (charA == charB ? 0 : 1);
            
            let smallest = MIN(MIN(insert, remove), replace);
            distances[at(x+1, y+1)] = MIN(smallest, max);
        }
    }
    
    let result = distances[at(width-1, height-1)];
    free(distances);
    return result;
}


- (NSString *)nonEmpty {
    return (self.length ? self : nil);
}






#pragma mark Splitting


- (NSArray<NSString *> *)split:(NSString *)separator {
    return [self componentsSeparatedByString:separator];
}



- (NSArray<NSString *> *)collect:(NSStringEnumerationOptions)option localized:(BOOL)localized {
    NSMutableArray<NSString *> *builder = [NSMutableArray new];
    NSStringEnumerationOptions localizedOption = (localized? NSStringEnumerationLocalized : kNilOptions);
    [self enumerateSubstringsInRange:self.fullRange
                             options:(option | localizedOption)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [builder addObject:substring];
                          }];
    return builder;
}


- (NSArray<NSString *> *)letters {
    return [self collect:NSStringEnumerationByComposedCharacterSequences localized:NO];
}


- (NSString *)firstLetter {
    if (self.length == 1) return self;
    NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:0];
    return [self substringWithRange:range];
}


- (NSArray<NSString *> *)lines {
    return [self collect:NSStringEnumerationByLines localized:NO];
}


- (NSArray<NSString *> *)paragraphs {
    return [self collect:NSStringEnumerationByParagraphs localized:NO];
}


- (NSArray<NSString *> *)sentences {
    return [self collect:NSStringEnumerationBySentences localized:YES];
}


- (NSArray<NSString *> *)words {
    return [self collect:NSStringEnumerationByWords localized:YES];
}


- (NSArray<NSString *> *)normalizedWords {
    return [[self words] map:^NSString *(NSString *word) {
        return [word normalizedString];
    }];
}








#pragma mark Joining

- (NSString *) :(NSString *)a { return [self.class concat:self, a?:@"", nil]; }
- (NSString *) :(NSString *)a :(NSString *)b { return [NSString concat:self, a?:@"", b?:@"", nil]; }
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c  { return [NSString concat:self, a?:@"", b?:@"", c?:@"", nil]; }
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d { return [NSString concat:self, a?:@"", b?:@"", c?:@"", d?:@"", nil]; }
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e { return [NSString concat:self, a?:@"", b?:@"", c?:@"", d?:@"", e?:@"", nil]; }
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f { return [NSString concat:self, a?:@"", b?:@"", c?:@"", d?:@"", e?:@"", f?:@"", nil]; }
- (NSString *) :(NSString *)a :(NSString *)b :(NSString *)c :(NSString *)d :(NSString *)e :(NSString *)f :(NSString *)g { return [NSString concat:self, a?:@"", b?:@"", c?:@"", d?:@"", e?:@"", f?:@"", g?:@"", nil]; }

+ (NSString *)concat:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION {
    return [NSArrayFromVariadicArguments(firstString) join:@""];
}


- (NSArray<NSString *> *)stringsByAppendingStrings:(NSArray<NSString *> *)suffixes usingString:(NSString *)joiningString {
    return [suffixes map:^NSString *(NSString *suffix) {
        return (suffix.length
                ? [self stringByAppendingFormat:@"%@%@", joiningString ?: @"", suffix]
                : [self copy]);
    }];
}


- (NSString*)repeat:(NSUInteger)times
{
    if (times == 0)
        return @"";
    
    NSMutableString *string = [NSMutableString stringWithCapacity:self.length * times];
    forcount (index, times) {
        [string appendString:self];
    }
    return string;
}





#pragma mark Characters

+ (NSString *)SPACE { return @" "; }
+ (NSString *)THIN_SPACE { return @"\u2009"; }
+ (NSString *)NO_BREAK_SPACE { return @"\u00A0"; }
+ (NSString *)NEW_LINE { return @"\n"; }





@end




