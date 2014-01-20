//
//  NSData+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 4.12.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSData+Essentials.h"





@implementation NSData (Essentials)



- (NSString *)stringUsingUTF8Encoding {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}



@end


