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
    STAssertEqualObjects(string, copy, @"String returned from stringValue is not equal to receiver.");
    STAssertTrue(string != copy, @"String returned from stringValue is identical");
}



@end
