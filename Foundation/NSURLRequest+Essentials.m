//
//  NSURLRequest+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSURLRequest+Essentials.h"





@implementation NSURLRequest (Essentials)


+ (instancetype)requestWithMethod:(NSString *)HTTPMethod URL:(NSURL *)URL headers:(NSDictionary *)headers body:(id<ESSURLRequestBody>)body {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = HTTPMethod;
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *field, NSString *value, BOOL *stop) {
        [request addValue:value forHTTPHeaderField:field];
    }];
    request.body = body;
    return request;
}


@end






@implementation NSMutableURLRequest (Essentials)


- (void)setBody:(id<ESSURLRequestBody>)body {
    NSURL *URL = [body essURLRequestBodyFileURL];
    if (URL) {
        self.HTTPBodyStream = [NSInputStream inputStreamWithURL:URL];
    }
    else {
        self.HTTPBody = [body essURLRequestBodyData];
    }
}


@end





@implementation NSData (ESSURLRequestBody)


- (NSData *)essURLRequestBodyData {
    return self;
}


- (NSURL *)essURLRequestBodyFileURL {
    return nil;
}


@end





@implementation NSString (ESSURLRequestBody)


- (NSData *)essURLRequestBodyData {
    return [NSData dataWithContentsOfURL:[self essURLRequestBodyFileURL]];
}


- (NSURL *)essURLRequestBodyFileURL {
    return (self.isAbsolutePath? [NSURL fileURLWithPath:self] : nil);
}


@end





@implementation NSURL (ESSURLRequestBody)


- (NSData *)essURLRequestBodyData {
    return [NSData dataWithContentsOfURL:[self essURLRequestBodyFileURL]];
}


- (NSURL *)essURLRequestBodyFileURL {
    return (self.isFileURL? self : nil);
}


@end


