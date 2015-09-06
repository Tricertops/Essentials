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
            
            NSDateFormatter *formatter = [self.class HTTPDateFormatter];
            NSString *lastModified = [self.headers objectForKey:@"Last-Modified"];
            self->_lastModified = [formatter dateFromString:lastModified];
        }{
            self.data = data;
            self.location = location;
            self->_loadingError = error;
            
            if (self.location.isFileURL) {
                NSError *error = nil;
                NSDictionary<NSString *, id> *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.location.path error:&error];
                self.fileError = error;
                self->_length = [[attributes objectForKey:NSFileSize] unsignedIntegerValue];
            }
            else {
                self->_length = self.data.length;
            }
            
            self->_shouldRetry = [self.class isErrorWorthRetrying:self.loadingError ?: self.statusCodeError];
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
    if ( ! encodingName.length) return NSUTF8StringEncoding;
    
    CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)encodingName);
    return CFStringConvertEncodingToNSStringEncoding(encoding);
}


+ (BOOL)isErrorWorthRetrying:(NSError *)error {
    if ( ! error) return NO;
    if ( ! NSEqual(error.domain, NSURLErrorDomain)) return NO;
    
    switch (error.code) {
        case NSURLErrorTimedOut:
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorCallIsActive:
            return YES;
            
        default: return NO;
    }
}


ESSSharedMake(NSDateFormatter *, HTTPDateFormatter) {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [NSLocale standardizedLocale];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
    return formatter;
}





#pragma mark - Data


ESSLazyMake(NSString *, string) {
    NSData *data = self.data;
    if ( ! data.length) return nil;
    NSString *string = [[NSString alloc] initWithData:data encoding:self.encoding];
    if ( ! string) {
        self.decodingError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:NSFileReadUnknownStringEncodingError
                                             userInfo:nil];
    }
    return string;
}


ESSLazyLoad(NSDictionary *, JSON) {
    [self loadJSON];
}


ESSLazyLoad(NSArray<id> *, JSONArray) {
    [self loadJSON];
}


- (void)loadJSON {
    NSData *data = self.data;
    if ( ! data.length) return;
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    self->_JSON = [NSDictionary cast:JSON];
    self->_JSONArray = [NSArray cast:JSON];
    self.decodingError = error;
}


ESSLazyMake(NSString *, prettyJSONString) {
    id JSON = self.JSON ?: self.JSONArray;
    if ( ! JSON) return nil;
    NSError *error = nil;
    id prettyString = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&error];
    self.decodingError = error;
    return [[NSString alloc] initWithData:prettyString encoding:NSUTF8StringEncoding];
}


ESSLazyLoad(NSDictionary *, propertyList) {
    [self loadPropertyList];
}


ESSLazyLoad(NSArray<id> *, propertyListArray) {
    [self loadPropertyList];
}


- (void)loadPropertyList {
    NSData *data = self.data;
    if ( ! data.length) return;
    NSError *error = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:data options:kNilOptions format:NULL error:&error];
    self->_propertyList = [NSDictionary cast:plist];
    self->_propertyListArray = [NSArray cast:plist];
    self.decodingError = error;
}





#pragma mark - File


- (BOOL)loadLocationURLToData {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:self.location options:NSDataReadingMappedIfSafe error:&error];
    self.data = data;
    self.fileError = error;
    return (data != nil);
}


- (BOOL)moveTo:(NSURL *)URL {
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] moveItemAtURL:self.location toURL:URL error:&error];
    if (success) self.location = URL;
    self.fileError = error;
    return success;
}


- (BOOL)moveToCaches {
    NSArray<NSURL *> *cachesDirs = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *cacheURL = [cachesDirs firstObject];
    cacheURL = [cacheURL URLByAppendingPathComponent:NSStringFromClass(self.class) isDirectory:YES];
    cacheURL = [cacheURL URLByAppendingPathComponent:self.location.lastPathComponent];
    return [self moveTo:cacheURL];
}





#pragma mark - Errors


- (NSError *)error {
    return self.loadingError ?: self.statusCodeError ?: self.fileError ?: self.decodingError;
}





#pragma  mark - Retrying


- (BOOL)retryAfter:(NSTimeInterval)delay {
    NSURLSession *session = self.session;
    NSURLRequest *request = self.request;
    ESSURLResponseBlock handler = self.handler;
    BOOL isFileDownload = (self.location != nil);
    BOOL canRetry = (session != nil && request != nil && handler != nil);
    NSUInteger retryCount = self.retryCount;
    
    if (canRetry) {
        [session.delegateQueue delay:delay asynchronous:^{
            [session performRequest:request toFile:isFileDownload completionHandler:^(ESSURLResponse *response) {
                // Reuse the same handler and invoke it.
                response.retryCount = retryCount + 1;
                response.handler = handler;
                handler(response);
            }];
        }];
    }
    return canRetry;
}


- (BOOL)retryIfNeededAfter:(NSTimeInterval)delay count:(NSUInteger)count {
    if (self.shouldRetry && self.retryCount < count) {
        return [self retryAfter:delay];
    }
    return NO;
}





#pragma mark - Cleanup


- (void)invalidate {
    self->_request = nil;
    self->_session = nil;
    
    self->_statusCode = 0;
    self->_localizedStatusCodeString = nil;
    
    self->_headers = nil;
    self->_length = 0;
    self->_MIMEType = nil;
    self->_encoding = 0;
    
    self.data = nil;
    self->_string = nil;
    self->_JSON = nil;
    self->_prettyJSONString = nil;
    self->_propertyList = nil;
    
    self.location = nil;
    
    self->_loadingError = nil;
    self->_statusCodeError = nil;
    self.fileError = nil;
    self.decodingError = nil;
    
    self->_shouldRetry = NO;
    self->_retryCount = NSUIntegerMax; // Acts like repeated infite times.
}





@end


