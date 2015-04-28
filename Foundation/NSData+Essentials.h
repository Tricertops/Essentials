//
//  NSData+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 4.12.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSData (Essentials)


/// Returns new NSString created from the receiver using UTF-8 encoding. Usefull in debugger.
- (NSString *)stringUsingUTF8Encoding;



+ (NSData *)dataWithHexadecimalString:(NSString *)hexString;

- (NSString *)hexadecimalString; // -hexString is already used by Foundation



@end
