//
//  NSData+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 4.12.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSData+Essentials.h"





@implementation NSData (Essentials)





- (NSString *)stringUsingUTF8Encoding {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}




+ (NSData *)dataWithHexString:(NSString *)hexString {
    NSArray *ignoringSymbols = @[@"-", @"\n", @" "];
    for (NSString *symbol in ignoringSymbols) {
        hexString = [hexString stringByReplacingOccurrencesOfString:symbol withString:@""];
    }
    
    const char *hex = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = strlen(hex);
    NSMutableData *data = [NSMutableData dataWithCapacity:length];
    
    char byteHex[3] = { '\0', '\0', '\0'};
    for (NSUInteger index = 0; index < length/2; index++) {
        byteHex[0] = hex[2 * index];
        byteHex[1] = hex[2 * index + 1];
        
        unsigned char byte = strtol(byteHex, NULL, 16);
        [data appendBytes:&byte length:1];
    }
    
    return data;
}


- (NSString *)hexString {
    const unsigned char *data = [self bytes];
    NSUInteger length  = self.length;
    NSMutableString *hex  = [NSMutableString stringWithCapacity:(length * 2)];
    
    for (int index = 0; index < length; index++) {
        [hex appendFormat:@"%02x", (unsigned char)data[index]];
    }
    
    return hex;
}





@end


