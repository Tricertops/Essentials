//
//  NSStringEssentialsTest.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSStringEssentialsTest.h"

#import "NSString+Essentials.h"



@implementation NSStringEssentialsTest



- (void)test_stringValue_shouldReturnEqualButNotIdenticalObject {
    NSString *string = [[NSMutableString alloc] initWithString:@"test"];
    NSString *copy = string.stringValue;
    STAssertEqualObjects(string, copy, @"String returned from stringValue is not equal to receiver");
    STAssertTrue(string != copy, @"String returned from stringValue is identical");
}


- (void)test_shortenedDescriptionToLengthTruncateString_shouldNotCountTruncatingStringToLength {
    NSString *string = @"Lorem ipsum dolor sit amet.";
    NSString *shortened = [string shortenedDescriptionToLength:8 truncateString:@"..."];
    STAssertTrue(shortened.length == 11, @"Shortened description has unexpected length");
}


- (void)test_isEmail {
    STAssertTrue(@"example@server.com".isEmail, @"Email not detected");
    STAssertTrue(@"name.surname.nickname@subdomain.server.co.uk".isEmail, @"Email not detected");
    
    STAssertFalse(@"example@server".isEmail, @"False email detected");
    STAssertFalse(@"example.server.com".isEmail, @"False email detected");
    STAssertFalse(@"@server.com".isEmail, @"False email detected");
    STAssertFalse(@".@a.something".isEmail, @"False email detected");;
}



@end
