//
//  ESSURLResponse.h
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface ESSURLResponse : NSHTTPURLResponse


- (instancetype)initWithHTTPResponse:(NSHTTPURLResponse *)httpResponse contentData:(NSData *)data temporaryLocation:(NSURL *)location loadingError:(NSError *)error;

@property (readonly) NSString *localizedStatusCodeString;
@property (readonly) NSUInteger length; // data or file
//TODO: Last-Modified with DateFormatter

@property (readonly) NSData *data;
@property (readonly) NSString *string; // lazy
@property (readonly) id JSON; // lazy
@property (readonly) NSString *prettyJSONString; // lazy
@property (readonly) id propertyList; // lazy
//TODO: Platform dependent image.

@property (readonly) NSURL *location;
- (BOOL)loadLocationURLToData; // updates .data
- (BOOL)moveTo:(NSURL *)URL; // updates .location
- (BOOL)moveToCaches; // updates .location

@property (readonly) NSError *error; // loading error or statusCodeError
@property (readonly) NSError *loadingError;
@property (readonly) NSError *statusCodeError;
@property (readonly) BOOL shouldRetry;


@end



typedef void(^ESSURLResponseBlock)(ESSURLResponse *response);


