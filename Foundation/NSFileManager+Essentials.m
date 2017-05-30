//
//  NSFileManager+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 30 May 2017.
//  Copyright © 2017 iAdverti. All rights reserved.
//

#import "NSFileManager+Essentials.h"





@implementation NSFileManager (Essentials)





+ (instancetype)shared {
    return [self defaultManager];
}





- (BOOL)isReadableFileAtURL:(NSURL *)URL {
    if ( ! URL.isFileURL) return nil;
    
    return [self isReadableFileAtPath:URL.path];
}


- (NSDate *)creationDateOfFileAtURL:(NSURL *)URL {
    if ( ! URL.isFileURL) return nil;
    
    return [[self attributesOfItemAtPath:URL.path error:nil] fileCreationDate];
}





- (NSURL *)libraryURL {
    return [self URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].firstObject;
}


- (NSURL *)cachesURL {
    return [self URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
}


- (NSURL *)libraryURLForDirectory:(NSString *)directory {
    NSURL *URL = [self.libraryURL URLByAppendingPathComponent:directory isDirectory:YES];
    [self createDirectoryAtPath:URL.path withIntermediateDirectories:YES attributes:nil error:nil];
    return URL;
}


- (NSURL *)cachesURLForDirectory:(NSString *)directory {
    NSURL *URL = [self.cachesURL URLByAppendingPathComponent:directory isDirectory:YES];
    [self createDirectoryAtPath:URL.path withIntermediateDirectories:YES attributes:nil error:nil];
    return URL;
}





@end




