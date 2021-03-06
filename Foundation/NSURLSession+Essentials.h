//
//  NSURLSession+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"
#import "NSURLRequest+Essentials.h"
#import "ESSURLResponse.h"





@interface NSURLSession (Essentials)



#pragma mark - Creating & Shared

//! Returns shared session with default configuration that uses Main Queue for calbacks.
+ (instancetype)mainQueueSession;

//! Returns new session with default configuration that uses given queue for callbacks
+ (instancetype)defaultSessionOnQueue:(NSOperationQueue *)queue;


#pragma  mark - Requests

//! Universal method for performing requests, optionally storing the downloaded data. Returns concrete subclass of NSURLSessionTask based on HTTP method and whether the data is stored to a file.
- (NSURLSessionTask *)performRequest:(NSURLRequest *)request toFile:(BOOL)downloadToFile completionHandler:(ESSURLResponseBlock)handler;


#pragma mark - Requests Without Body

//! Starts a GET request to given URL.
- (NSURLSessionDataTask *)download:(NSURL *)URL completion:(ESSURLResponseBlock)handler;
//! Starts a GET request to given URL saving the response data to a file.
- (NSURLSessionDownloadTask *)downloadFile:(NSURL *)URL completion:(ESSURLResponseBlock)handler;
//! Resumes cancelled GET request that was downloading to a file.
- (NSURLSessionDownloadTask *)resumeFileDownload:(NSData *)resumeData completion:(ESSURLResponseBlock)handler;

//! Starts a request with given HTTP method to given URL.
- (NSURLSessionDataTask *)performMethod:(NSString *)method URL:(NSURL *)URL completion:(ESSURLResponseBlock)handler;
//! Starts a GET request to given URL.
- (NSURLSessionDataTask *)GET:(NSURL *)URL completion:(ESSURLResponseBlock)handler;
//! Starts a HEAD request to given URL.
- (NSURLSessionDataTask *)HEAD:(NSURL *)URL completion:(ESSURLResponseBlock)handler;
//! Starts a DELETE request to given URL.
- (NSURLSessionDataTask *)DELETE:(NSURL *)URL completion:(ESSURLResponseBlock)handler;


#pragma mark - Requests With Body

//! Starts a POST request to given URL with given payload object.
- (NSURLSessionUploadTask *)uploadTo:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler;

//! Starts a request with given HTTP method to given URL with given payload object.
- (NSURLSessionUploadTask *)performMethod:(NSString *)method URL:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler;
//! Starts a POST request to given URL with given payload object.
- (NSURLSessionUploadTask *)POST:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler;
//! Starts a PUT request to given URL with given payload object.
- (NSURLSessionUploadTask *)PUT:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler;
//! Starts a PATCH request to given URL with given payload object.
- (NSURLSessionUploadTask *)PATCH:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler;



@end


