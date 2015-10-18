//
//  NSBundle+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 18.10.15.
//  Copyright © 2015 iAdverti. All rights reserved.
//

#import "NSBundle+Essentials.h"



@implementation NSBundle (Essentials)



- (NSString *)version {
    return [self objectForInfoDictionaryKey:@"CFBundleVersion"];
}


- (NSString *)shortVersionString {
        return [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}



@end


