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




// This object is used to indirectly transfer URL request into URL response block. The problem was, that the block is created before the request.
@interface ESSURLResponseRequestTransfer : NSObject
@property NSURLRequest *request;
@end
@implementation ESSURLResponseRequestTransfer
@end





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


- (void(^)(NSData *, NSURLResponse *, NSError *))ess_dataCompletionBlockForRequest:(ESSURLResponseRequestTransfer *)transfer handler:(ESSURLResponseBlock)block {
    __weak NSURLSession *weakSession = self;
    return ^(NSData *data, NSURLResponse *response, NSError *error) {
        ESSURLResponse *r = [[ESSURLResponse alloc] initWithSession:weakSession
                                                            request:transfer.request
                                                           response:[NSHTTPURLResponse cast:response]
                                                               data:data
                                                           location:nil
                                                              error:error
                                                            handler:block];
        block(r);
        //TODO: Clear response
    };
}


- (void(^)(NSURL *, NSURLResponse *, NSError *))ess_locationCompletionBlockForRequest:(ESSURLResponseRequestTransfer *)transfer handler:(ESSURLResponseBlock)block {
    __weak NSURLSession *weakSession = self;
    return ^(NSURL *location, NSURLResponse *response, NSError *error) {
        ESSURLResponse *r = [[ESSURLResponse alloc] initWithSession:weakSession
                                                            request:transfer.request
                                                           response:[NSHTTPURLResponse cast:response]
                                                               data:nil
                                                           location:location
                                                              error:error
                                                            handler:block];
        block(r);
        //TODO: Clear response
    };
}


- (NSURLSessionTask *)ess_configureTask:(NSURLSessionTask *(^)(ESSURLResponseRequestTransfer *transfer))block {
    ESSURLResponseRequestTransfer *transfer = [ESSURLResponseRequestTransfer new];
    NSURLSessionTask *task = block(transfer);
    transfer.request = task.originalRequest;
    [task resume];
    return task;
}


- (NSURLSessionTask *)performRequest:(NSURLRequest *)request toFile:(BOOL)downloadToFile completionHandler:(ESSURLResponseBlock)handler {
    return [self ess_configureTask:^NSURLSessionTask *(ESSURLResponseRequestTransfer *transfer) {
        if (downloadToFile) {
            return [self downloadTaskWithRequest:request completionHandler:[self ess_locationCompletionBlockForRequest:transfer handler:handler]];
        }
        else {
            NSData *bodyData = request.HTTPBody;
            if (bodyData) {
                return [self uploadTaskWithRequest:request fromData:bodyData completionHandler:[self ess_dataCompletionBlockForRequest:transfer handler:handler]];
            }
            else {
                return [self dataTaskWithRequest:request completionHandler:[self ess_dataCompletionBlockForRequest:transfer handler:handler]];
            }
        }
    }];
}





#pragma mark - Requests Without Body


- (NSURLSessionDataTask *)performMethod:(NSString *)method URL:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    return [NSURLSessionDataTask cast:[self ess_configureTask:^NSURLSessionTask *(ESSURLResponseRequestTransfer *transfer) {
        NSURLRequest *request = [NSURLRequest requestWithMethod:method URL:URL headers:nil body:nil];
        return [self dataTaskWithRequest:request completionHandler:[self ess_dataCompletionBlockForRequest:transfer handler:handler]];
    }]];
}


- (NSURLSessionDataTask *)GET:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    return [NSURLSessionDataTask cast:[self ess_configureTask:^NSURLSessionTask *(ESSURLResponseRequestTransfer *transfer) {
        return [self dataTaskWithURL:URL completionHandler:[self ess_dataCompletionBlockForRequest:transfer handler:handler]];
    }]];
}


- (NSURLSessionDataTask *)HEAD:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    return [self performMethod:@"HEAD" URL:URL completion:handler];
}


- (NSURLSessionDataTask *)DELETE:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    return [self performMethod:@"DELETE" URL:URL completion:handler];
}





- (NSURLSessionDownloadTask *)downloadFrom:(NSURL *)URL completion:(ESSURLResponseBlock)handler {
    return [NSURLSessionDownloadTask cast:[self ess_configureTask:^NSURLSessionTask *(ESSURLResponseRequestTransfer *transfer) {
        return [self downloadTaskWithURL:URL completionHandler:[self ess_locationCompletionBlockForRequest:transfer handler:handler]];
    }]];
}


- (NSURLSessionDownloadTask *)resumeDownload:(NSData *)resumeData completion:(ESSURLResponseBlock)handler {
    return [NSURLSessionDownloadTask cast:[self ess_configureTask:^NSURLSessionTask *(ESSURLResponseRequestTransfer *transfer) {
        return [self downloadTaskWithResumeData:resumeData completionHandler:[self ess_locationCompletionBlockForRequest:transfer handler:handler]];
    }]];
}





#pragma mark - Requests With Body


- (NSURLSessionUploadTask *)performMethod:(NSString *)method URL:(NSURL *)URL payload:(id<ESSURLRequestBody>)payload completion:(ESSURLResponseBlock)handler {
    return [NSURLSessionUploadTask cast:[self ess_configureTask:^NSURLSessionTask *(ESSURLResponseRequestTransfer *transfer) {
        NSURLRequest *request = [NSURLRequest requestWithMethod:method URL:URL headers:nil body:nil];
        NSURL *payloadURL = [payload essURLRequestBodyFileURL];
        if (payloadURL) {
            return [self uploadTaskWithRequest:request fromFile:payloadURL completionHandler:[self ess_dataCompletionBlockForRequest:transfer handler:handler]];
        }
        else {
            return [self uploadTaskWithRequest:request fromData:[payload essURLRequestBodyData] completionHandler:[self ess_dataCompletionBlockForRequest:transfer handler:handler]];
        }
    }]];
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


