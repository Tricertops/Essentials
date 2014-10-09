//
//  NSURLSession+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSURLSession+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSURLSession (Essentials)





#pragma mark - Creating & Shared


ESSSharedMake(NSURLSession *, mainQueueSession) {
    return [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                         delegate:nil
                                    delegateQueue:[NSOperationQueue mainQueue]];
}


+ (instancetype)defaultSessionOnQueue:(NSOperationQueue *)queue {
    if (queue == [NSOperationQueue mainQueue]) {
        return [self mainQueueSession];
    }
    else {
        return [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                             delegate:nil
                                        delegateQueue:queue];
    }
}





#pragma  mark - Requests


- (NSURLSessionTask *)performRequest:(NSURLRequest *)request toFile:(BOOL)downloadToFile completionHandler:(ESSURLResponseBlock)handler {
    //TODO: If body is missing and downloads to a file, use Download Task
    //TODO: If body is missing, use Data Task
    //TODO: If body is present, use Upload Task
    //TODO: If body stream is present, use Data Task
}





#pragma mark - Requests Without Body


- (NSURLSessionDataTask *)performMethod:(NSString *)method URL:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    //TODO: Build request
    //TODO: Start Data Task
}


- (NSURLSessionDataTask *)GET:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    //TODO: Start Data Task
}


- (NSURLSessionDataTask *)HEAD:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    //TODO: Call -performMethod:URL:completion:
}


- (NSURLSessionDataTask *)DELETE:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    //TODO: Call -performMethod:URL:completion:
}





- (NSURLSessionDownloadTask *)downloadFrom:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    //TODO: Start Download Task
}


- (NSURLSessionDownloadTask *)resumeDownload:(NSData *)resumeData completion:(ESSURLResponseBlock)handler {
    //TODO: Resume Download Task
}





#pragma mark - Requests With Body


- (NSURLSessionUploadTask *)performMethod:(NSString *)method URL:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    //TODO: Build request
    //TODO: Start Upload Task
}


- (NSURLSessionUploadTask *)POST:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    //TODO: Call -performMethod:URL:payload:completion:
}


- (NSURLSessionUploadTask *)PUT:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    //TODO: Call -performMethod:URL:payload:completion:
}


- (NSURLSessionUploadTask *)PATCH:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    //TODO: Call -performMethod:URL:payload:completion:
}





- (NSURLSessionUploadTask *)uploadTo:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    //TODO: Call -performMethod:URL:payload:completion:
}





@end


