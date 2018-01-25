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
    if (data.length != sizeof(uuid_t)) return nil;
    return [[NSUUID alloc] initWithUUIDBytes:data.bytes];
}


+ (NSUUID *)UUIDWithHexString:(NSString *)hexString {
    let data = [NSData dataWithHexadecimalString:hexString];
    return [self UUIDWithData:data];
}


+ (NSUUID *)UUIDWithBase64String:(NSString *)base64String {
    let data = [[NSData alloc] initWithBase64EncodedString:base64String options:kNilOptions];
    return [self UUIDWithData:data];
}





- (NSData *)UUIDData {
    uuid_t bytes;
    [self getUUIDBytes:bytes];
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}


- (NSString *)UUIDHexString {
    return [[self UUIDData] hexadecimalString];
}


- (NSString *)UUIDBase64String {
    return [[self UUIDData] base64EncodedStringWithOptions:kNilOptions];
}





@end


