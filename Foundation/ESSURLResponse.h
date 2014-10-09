//
//  ESSURLResponse.h
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>




//! Block that receives ESSURLResponse object.
@class ESSURLResponse;
typedef void(^ESSURLResponseBlock)(ESSURLResponse *response);





@interface ESSURLResponse : NSObject



#pragma mark - Origin

//! The original request to which the receiver is a response.
@property (readonly) NSURLRequest *request;
//! The session in which the request did complete and the receiver was the result.
@property (readonly, weak) NSURLSession *session;


#pragma mark - Status Code

//! The HTTP status code. Zero, if invalid.
@property (readonly) NSInteger statusCode;
//! Localized description for status code.
@property (readonly) NSString *localizedStatusCodeString;


#pragma mark - Metadata

//! All header fields with their values.
@property (readonly) NSDictionary *headers;
//! Length of bytes of the received data or size of the file.
@property (readonly) NSUInteger length;
//! The MIME type of the data.
@property (readonly) NSString *MIMEType;
//! The text encoding provided by the response.
@property (readonly) NSStringEncoding encoding;
//TODO: Last-Modified with DateFormatter


#pragma mark - Data

//! Data received as response body.
@property (readonly) NSData *data;
//! Lazily decoded string from .data property using .encoding from headers or UTF-8. Property .decodingError is updated.
@property (readonly) NSString *string;
//! Lazily parsed JSON object from .data property. Property .decodingError is updated.
@property (readonly) id JSON;
//! Lazily serialized pretty JSON string from .JSON property. Property .decodingError is updated.
@property (readonly) NSString *prettyJSONString;
//! Lazily parsed Proeprty List object from .data property. Property .decodingError is updated.
@property (readonly) id propertyList;


#pragma mark - File

//! File URL specifying, where the response contents are stored. Initially at temporary location.
@property (readonly) NSURL *location;
//! Load contents of .data property from file specified by .location property. Property .fileError is updated and success is returned.
- (BOOL)loadLocationURLToData;
//! Moved the file at .location to given new location. Properties .location and .fileError are updated.
- (BOOL)moveTo:(NSURL *)URL;
//! Moved the file at .location to unspecified path inside Caches directory. Properties .location and .fileError are updated.
- (BOOL)moveToCaches;


#pragma mark - Retrying

//! Indicated whether the error that occured could be recovered by retrying the same request. Only loadingError is considered.
@property (readonly) BOOL shouldRetry;
//! Schedules the original request on the original session using the same handler.
- (BOOL)retry;
//! Number of times the request was retried.
@property (readonly) NSUInteger retryCount;


#pragma mark - Errors

//! Returns first non-nil error in this order: loadingError, statusCodeError, fileError, decodingError
@property (readonly) NSError *error;
//! Error that occured while receiveng the response, typically of NSURLErrorDomain.
@property (readonly) NSError *loadingError;
//! Error created from 4xx or 5xx status code, typically of NSURLErrorDomain.
@property (readonly) NSError *statusCodeError;
//! Error that occured while manipulating with the fila at .location, typically of NSCocoaErrorDomain.
@property (readonly) NSError *fileError;
//! Error that occured while processing .data property, typically of NSCocoaErrorDomain.
@property (readonly) NSError *decodingError;



#pragma mark - Private

//! Don’t initialize this class. Used by NSURLSession+Essentials in completion handlers.
- (instancetype)initWithSession:(NSURLSession *)session request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data location:(NSURL *)location error:(NSError *)error handler:(ESSURLResponseBlock)handler;



@end


