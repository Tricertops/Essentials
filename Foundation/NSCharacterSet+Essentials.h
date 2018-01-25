//
//  NSCharacterSet+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 26.3.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



@interface NSCharacterSet (Essentials)



#pragma mark - Constructing

/// Returns a character set containing the characters in given range, including those two.
+ (instancetype)characterSetFrom:(unichar)firstCharacter to:(unichar)lastCharacter;

/// Returns a character set containing the characters in at least one given character set.
+ (instancetype)characterSetByMerging:(NSArray<NSCharacterSet *> *)characterSets;

/// Returns a character set containing the characters in the receiver OR in the argument.
- (instancetype)characterSetByUnionWithSet:(NSCharacterSet *)characterSet;

/// Returns a character set containing the characters in the receiver AND in the argument.
- (instancetype)characterSetByIntersectionWithSet:(NSCharacterSet *)characterSet;


#pragma mark - Common Character Sets

/// Returns a character set containing the characters below 128.
+ (NSCharacterSet *)ASCIICharacterSet;

/// Returns a character set containing the characters below 128 that has printable form.
+ (NSCharacterSet *)printableASCIICharacterSet;

/// Returns a character set containing the characters 0-9 and A-Z and a-z.
+ (NSCharacterSet *)alphanumericASCIICharacterSet;

/// Returns a character set containing printable ASCII characters except 0-9 and A-Z and a-z.
+ (NSCharacterSet *)punctuationASCIICharacterSet;

/// Returns a character set containing the characters 0-9 and a-f.
+ (NSCharacterSet *)lowercaseHexadecimalCharacterSet;

/// Returns a character set containing the characters 0-9 and A-F.
+ (NSCharacterSet *)uppercaseHexadecimalCharacterSet;

/// Returns a character set containing the characters 0-9 and A-F and a-f.
+ (NSCharacterSet *)hexadecimalCharacterSet;



@end


