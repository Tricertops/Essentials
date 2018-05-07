//
//  NSBundle+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 18.10.15.
//  Copyright © 2015 iAdverti. All rights reserved.
//

#import "NSBundle+Essentials.h"
#import "ESSEnumerator.h"



@implementation NSBundle (Essentials)



- (NSString *)version {
    return [self objectForInfoDictionaryKey:@"CFBundleVersion"];
}


- (NSString *)shortVersionString {
        return [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}



- (NSEnumerator<NSString *> *)classNamesEnumerator {
    unsigned int count = 0;
    let classNames = objc_copyClassNamesForImage(self.executablePath.UTF8String, &count);
    if (classNames == NULL) return nil;
    
    return [[ESSEnumerator alloc] initWithNext:^NSString *(NSUInteger index) {
        if (index >= count) {
            return nil;
        }
        return @(classNames[index]);
    } cleanup:^{
        free(classNames);
    }];
}


@end


