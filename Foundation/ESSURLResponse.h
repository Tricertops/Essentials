//
//  ESSURLResponse.h
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface ESSURLResponse : NSHTTPURLResponse



#pragma mark - Status Code

//! The HTTP status code. Zero, if invalid.
@property (readonly) NSInteger statusCode;
//! Localized description for status code.
@property (readonly) NSString *localizedStatusCodeString;


#pragma mark - Headers

//! Length of bytes of the received data or size of the file.
@property (readonly) NSUInteger length;
@property (readonly, copy) NSDictionary *allHeaderFields;
//TODO: Last-Modified with DateFormatter


#pragma mark - Data

//! Data received as response body.
@property (readonly) NSData *data;
//! Lazily decoded UTF-8 string from .data property. Property .decodingError is updated.
@property (readonly) NSString *string;
//! Lazily parsed JSON object from .data property. Property .decodingError is updated.
@property (readonly) id JSON;
//! Lazily serialized pretty JSON string from .JSON property. Property .decodingError is updated.
@property (readonly) NSString *prettyJSONString;
//! Lazily parsed Proeprty List object from .data property. Property .decodingError is updated.
@property (readonly) id propertyList;
//TODO: Platform dependent image object.


#pragma mark - File

//! File URL specifying, where the response contents are stored. Initially at temporary location.
@property (readonly) NSURL *location;
//! Load contents of .data property from file specified by .location property. Property .fileError is updated and success is returned.
- (BOOL)loadLocationURLToData;
//! Moved the file at .location to given new location. Properties .location and .fileError are updated.
- (BOOL)moveTo:(NSURL *)URL;
//! Moved the file at .location to unspecified path inside Caches directory. Properties .location and .fileError are updated.
- (BOOL)moveToCaches;


#pragma mark - Errors

//! Returns first non-nil error in this order: loadingError, statusCodeError, fileError, decodingError
@property (readonly) NSError *error; // loading error or statusCodeError
//! Indicated whether the error that occured could be recovered by retrying the same request. Only loadingError is considered.
@property (readonly) BOOL shouldRetry;

//! Error that occured while receiveng the response, typically of NSURLErrorDomain.
@property (readonly) NSError *loadingError;
//! Error created from 4xx or 5xx status code, typically of NSURLErrorDomain.
@property (readonly) NSError *statusCodeError;
//! Error that occured while manipulating with the fila at .location, typically of NSCocoaErrorDomain.
@property (readonly) NSError *fileError;
//! Error that occured while processing .data property, typically of NSCocoaErrorDomain.
@property (readonly) NSError *decodingError;



#pragma mark - Creating

//! Initializes new instance. No need to call, used by NSURLSession+Essentials.
- (instancetype)initWithHTTPResponse:(NSHTTPURLResponse *)httpResponse contentData:(NSData *)data temporaryLocation:(NSURL *)location loadingError:(NSError *)error;
- (instancetype)initWithURL:(NSURL *)url statusCode:(NSInteger)statusCode HTTPVersion:(NSString *)HTTPVersion headerFields:(NSDictionary *)headerFields __unavailable;
- (instancetype)initWithURL:(NSURL *)URL MIMEType:(NSString *)MIMEType expectedContentLength:(NSInteger)length textEncodingName:(NSString *)name __unavailable;



@end



typedef void(^ESSURLResponseBlock)(ESSURLResponse *response);


