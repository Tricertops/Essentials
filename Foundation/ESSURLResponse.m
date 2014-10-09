//
//  ESSURLResponse.m
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "ESSURLResponse.h"
#import "Foundation+Essentials.h"





@interface ESSURLResponse ()


@property NSData *data;
@property NSURL *location;

@property NSUInteger retryCount;
@property (copy) ESSURLResponseBlock handler;

@property NSError *fileError;
@property NSError *decodingError;


@end





@implementation ESSURLResponse





#pragma mark - Creating


- (instancetype)initWithSession:(NSURLSession *)session
                        request:(NSURLRequest *)request
                       response:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                       location:(NSURL *)location
                          error:(NSError *)error
                        handler:(ESSURLResponseBlock)handler {
    self = [super init];
    if (self) {
        self->_request = request;
        self->_session = session;
        self.handler = handler;
        {
            self->_statusCode = response.statusCode;
            self->_localizedStatusCodeString = [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
            self->_statusCodeError = [self.class errorForStatusCode:self.statusCode];
        }{
            self->_headers = response.allHeaderFields;
            self->_MIMEType = response.MIMEType;
            self->_encoding = [self.class stringEncodingFromEncodingName:response.textEncodingName];
        }{
            self.data = data;
            self.location = location;
            self->_loadingError = error;
            
            if (self.location.isFileURL) {
                NSError *error = nil;
                NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.location.path error:&error];
                self.fileError = error;
                self->_length = [[attributes objectForKey:NSFileSize] unsignedIntegerValue];
            }
            else {
                self->_length = self.data.length;
            }
        }
    }
    return self;
}


+ (NSError *)errorForStatusCode:(NSUInteger)statusCode {
    NSInteger errorCode = [self URLDomainErrorCodeForStatusCode:statusCode];
    if (errorCode) {
        return [NSError errorWithDomain:NSURLErrorDomain code:errorCode userInfo:nil];
    }
    else return nil;
}


+ (NSInteger)URLDomainErrorCodeForStatusCode:(NSUInteger)statusCode {
    switch (statusCode) {
        case 0 ... 399:
            return 0;
            
        case 401: // 401 Unauthorized
        case 402: // 402 Payment Required
        case 407: // 407 Proxy Authentication Required
            return NSURLErrorUserAuthenticationRequired;
            
        case 403: // 403 Forbidden
        case 404: // 404 Not Found
        case 410: // 410 Gone
            return NSURLErrorResourceUnavailable;
            
        case 405: // 405 Method Not Allowed
        case 406: // 406 Not Acceptable
        case 409: // 409 Conflict
        case 411 ... 499: // 4xx Client Error
            return NSURLErrorBadURL;
            
        case 408: // 408 Request Timeout
            return NSURLErrorTimedOut;
            
        case 500 ... 599: // 5xx Server Error
            return NSURLErrorBadServerResponse;
    }
    return 0;
}


+ (NSStringEncoding)stringEncodingFromEncodingName:(NSString *)encodingName {
    if (encodingName.length) return NSUTF8StringEncoding;
    
    CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)encodingName);
    return CFStringConvertEncodingToNSStringEncoding(encoding);
}





#pragma mark - Data


ESSLazyMake(NSString *, string) {
    if ( ! self.data.length) return nil;
    NSString *string = [[NSString alloc] initWithData:self.data encoding:self.encoding];
    if ( ! string) {
        self.decodingError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:NSFileReadUnknownStringEncodingError
                                             userInfo:nil];
    }
    return string;
}


ESSLazyMake(id, JSON) {
    if ( ! self.data.length) return nil;
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    self.decodingError = error;
    return JSON;
}


ESSLazyMake(NSString *, prettyJSONString) {
    if ( ! self.JSON) return nil;
    NSError *error = nil;
    id prettyString = [NSJSONSerialization dataWithJSONObject:self.JSON options:NSJSONWritingPrettyPrinted error:&error];
    self.decodingError = error;
    return prettyString;
}


ESSLazyMake(id, propertyList) {
    if ( ! self.data.length) return nil;
    NSError *error = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:self.data options:kNilOptions format:NULL error:&error];
    self.decodingError = error;
    return plist;
}






@end


