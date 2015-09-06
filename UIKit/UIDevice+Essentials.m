//
//  UIDevice+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIDevice+Essentials.h"
#import <sys/utsname.h>





@implementation UIDevice (Essentials)





- (NSString *)modelVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


- (NSUInteger)numberOfCores {
    return [[NSProcessInfo processInfo] processorCount];
}


- (BOOL)is64Bit {
    return sizeof(void *) >= 8; // Ready for 128-bit!
}


- (BOOL)iPhone {
    return (self.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}


- (BOOL)iPad {
    return (self.userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

- (NSString *)idiomName {
    NSDictionary<NSNumber *, NSString *> *mapping = @{
                                                      @(UIUserInterfaceIdiomPhone): @"iphone",
                                                      @(UIUserInterfaceIdiomPad): @"ipad",
                                                      };
    return [mapping objectForKey:@(self.userInterfaceIdiom)];
}

- (NSString *)resourceSuffix {
    return [NSString stringWithFormat:@"~%@", self.idiomName];
}


- (NSString *)resource:(NSString *)string {
    return [string stringByAppendingString:self.resourceSuffix];
}





#pragma mark Class Shorthands


+ (NSString *)modelVersion {
    return self.currentDevice.modelVersion;
}


+ (BOOL)iPhone {
    return self.currentDevice.iPhone;
}


+ (BOOL)iPad {
    return self.currentDevice.iPad;
}


+ (NSString *)idiomName {
    return self.currentDevice.idiomName;
}


+ (NSString *)resourceSuffix {
    return self.currentDevice.resourceSuffix;
}


+ (NSString *)resource:(NSString *)string {
    return [self.currentDevice resource:string];
}


+ (NSUInteger)numberOfCores {
    return self.currentDevice.numberOfCores;
}


+ (BOOL)is64Bit {
    return self.currentDevice.is64Bit;
}





@end
