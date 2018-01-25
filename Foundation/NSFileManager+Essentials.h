//
//  NSFileManager+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 30 May 2017.
//  Copyright © 2017 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



@interface NSFileManager (Essentials)


+ (instancetype)shared;


- (BOOL)isReadableFileAtURL:(NSURL *)fileURL;
- (NSDate *)creationDateOfFileAtURL:(NSURL *)fileURL;


@property (readonly) NSURL *libraryURL;
@property (readonly) NSURL *cachesURL;

- (NSURL *)cachesURLForDirectory:(NSString *)directory;
- (NSURL *)libraryURLForDirectory:(NSString *)directory;


@end


