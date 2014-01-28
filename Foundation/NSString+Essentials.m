//
//  NSString+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSString+Essentials.h"
#import "NSArray+Essentials.h"
#import <CommonCrypto/CommonDigest.h>





@implementation NSString (Essentials)





- (NSString *)stringValue {
    return [self copy];
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
    NSDictionary *escapes = @{
                              @"&quot;": @"\"",
                              @"&apos;": @"'",
                              @"&lt;"  : @"<",
                              @"&gt;"  : @">",
                              @"&amp;" : @"&", // Should be last.
                              };
    for (NSString *toFind in escapes) {
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
    CFMutableStringRef stringRef = (__bridge CFMutableStringRef)[NSMutableString stringWithString:self]; // -mutableCopy didn't work with the transformation
    Boolean success = CFStringTransform(stringRef, NULL, kCFStringTransformStripDiacritics, false);
    return success ? (__bridge NSString *)stringRef : nil;
}


- (NSString *)stringByConvertingToASCII {
    NSData *ASCIIData = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [[NSString alloc] initWithData:ASCIIData encoding:NSASCIIStringEncoding];
}


- (NSString *)stringByDeletingCharactersFromSet:(NSCharacterSet *)characterSet {
    NSMutableString *mutable = [self mutableCopy];
    NSRange range = NSMakeRange(NSNotFound, 0);
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
    if (self.length < 1) return [self copy];
    if (self.length == 1) return [self uppercaseString];
    
    NSString *firstCharacter = [self substringToIndex:1];
    NSString *theRest = [self substringFromIndex:1];
    return [firstCharacter.uppercaseString : theRest];
}


- (NSString *)MD5 {
	const char *cString = [self UTF8String];
	unsigned char hashBuffer[CC_MD5_DIGEST_LENGTH];
    
	CC_MD5(cString, (unsigned int)strlen(cString), hashBuffer);
    
	NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[hash appendFormat:@"%02x",hashBuffer[i]];
	}
	return hash;
}


- (NSString *)SHA1 {
	const char *cString = [self UTF8String];
	unsigned char hashBuffer[CC_SHA1_DIGEST_LENGTH];
    
	CC_SHA1(cString, (unsigned int)strlen(cString), hashBuffer);
    
	NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[hash appendFormat:@"%02x",hashBuffer[i]];
	}
	return hash;
}





#pragma mark Splitting


- (NSArray *)split:(NSString *)separator {
    return [self componentsSeparatedByString:separator];
}


- (NSArray *)letters {
    NSMutableArray *builder = [[NSMutableArray alloc] initWithCapacity:self.length];
    for (NSUInteger index = 0; index < self.length; index++) {
        NSString *letter = [self substringWithRange:NSMakeRange(index, 1)];
        [builder addObject:letter];
    }
    return builder;
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





@end




