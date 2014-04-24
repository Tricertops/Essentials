//
//  NSUUID+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 31.1.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSUUID+Essentials.h"
#import "NSData+Essentials.h"










@implementation NSUUID (Essentials)





+ (NSUUID *)UUIDWithData:(NSData *)data {
    return [[NSUUID alloc] initWithUUIDBytes:data.bytes];
}


+ (NSUUID *)UUIDWithHexString:(NSString *)hexString {
    NSData *data = [NSData dataWithHexString:hexString];
    return [self UUIDWithData:data];
}


+ (NSUUID *)UUIDWithBase64String:(NSString *)base64String {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:kNilOptions];
    return [self UUIDWithData:data];
}





- (NSData *)UUIDData {
    uuid_t bytes;
    [self getUUIDBytes:bytes];
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}


- (NSString *)UUIDHexString {
    return [[self UUIDData] hexString];
}


- (NSString *)UUIDBase64String {
    return [[self UUIDData] base64EncodedStringWithOptions:kNilOptions];
}





@end


