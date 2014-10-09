//
//  NSURLSession+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSURLSession+Essentials.h"
#import "Foundation+Essentials.h"
#import "NSObject+Essentials.h"





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


- (void(^)(NSData *, NSURLResponse *, NSError *))ess_dataCompletionBlockWithHandler:(ESSURLResponseBlock)block {
    return ^(NSData *data, NSURLResponse *response, NSError *error) {
        ESSURLResponse *r = [[ESSURLResponse alloc] initWithHTTPResponse:[NSHTTPURLResponse cast:response]
                                                             contentData:data
                                                       temporaryLocation:nil
                                                            loadingError:error];
        block(r);
    };
}


- (void(^)(NSURL *, NSURLResponse *, NSError *))ess_locationCompletionBlockWithHandler:(ESSURLResponseBlock)block {
    return ^(NSURL *location, NSURLResponse *response, NSError *error) {
        ESSURLResponse *r = [[ESSURLResponse alloc] initWithHTTPResponse:[NSHTTPURLResponse cast:response]
                                                             contentData:nil
                                                       temporaryLocation:location
                                                            loadingError:error];
        block(r);
    };
}


- (NSURLSessionTask *)performRequest:(NSURLRequest *)request toFile:(BOOL)downloadToFile completionHandler:(ESSURLResponseBlock)handler {
    NSURLSessionTask *task = nil;
    if (downloadToFile) {
        // With or without body. Body is preserved.
        task = [self downloadTaskWithRequest:request completionHandler:[self ess_locationCompletionBlockWithHandler:handler]];
    }
    else {
        NSData *bodyData = request.HTTPBody;
        if (bodyData) {
            task = [self uploadTaskWithRequest:request fromData:bodyData completionHandler:[self ess_dataCompletionBlockWithHandler:handler]];
        }
        else {
            task = [self dataTaskWithRequest:request completionHandler:[self ess_dataCompletionBlockWithHandler:handler]];
        }
    }
    [task resume];
    return task;
}





#pragma mark - Requests Without Body


- (NSURLSessionDataTask *)performMethod:(NSString *)method URL:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    NSURLRequest *request = [NSURLRequest requestWithMethod:method URL:URL headers:nil body:nil];
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:[self ess_dataCompletionBlockWithHandler:handler]];
    [task resume];
    return task;
}


- (NSURLSessionDataTask *)GET:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    NSURLSessionDataTask *task = [self dataTaskWithURL:URL completionHandler:[self ess_dataCompletionBlockWithHandler:handler]];
    [task resume];
    return task;
}


- (NSURLSessionDataTask *)HEAD:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    return [self performMethod:@"HEAD" URL:URL completion:handler];
}


- (NSURLSessionDataTask *)DELETE:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    return [self performMethod:@"DELETE" URL:URL completion:handler];
}





- (NSURLSessionDownloadTask *)downloadFrom:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    NSURLSessionDownloadTask *task = [self downloadTaskWithURL:URL completionHandler:[self ess_locationCompletionBlockWithHandler:handler]];
    [task resume];
    return task;
}


- (NSURLSessionDownloadTask *)resumeDownload:(NSData *)resumeData completion:(ESSURLResponseBlock)handler {
    NSURLSessionDownloadTask *task = [self downloadTaskWithResumeData:resumeData completionHandler:[self ess_locationCompletionBlockWithHandler:handler]];
    [task resume];
    return task;
}





#pragma mark - Requests With Body


- (NSURLSessionUploadTask *)performMethod:(NSString *)method URL:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    NSURLRequest *request = [NSURLRequest requestWithMethod:method URL:URL headers:nil body:nil];
    NSURLSessionUploadTask *task = nil;
    NSURL *payloadURL = [payload essURLRequestBodyFileURL];
    if (payloadURL) {
        task = [self uploadTaskWithRequest:request fromFile:payloadURL completionHandler:[self ess_dataCompletionBlockWithHandler:handler]];
    }
    else {
        task = [self uploadTaskWithRequest:request fromData:[payload essURLRequestBodyData] completionHandler:[self ess_dataCompletionBlockWithHandler:handler]];
    }
    [task resume];
    return task;
}


- (NSURLSessionUploadTask *)POST:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    return [self performMethod:@"POST" URL:URL payload:payload completion:handler];
}


- (NSURLSessionUploadTask *)PUT:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    return [self performMethod:@"PUT" URL:URL payload:payload completion:handler];
}


- (NSURLSessionUploadTask *)PATCH:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    return [self performMethod:@"PATCH" URL:URL payload:payload completion:handler];
}





- (NSURLSessionUploadTask *)uploadTo:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    return [self POST:URL payload:payload completion:handler];
}





@end


