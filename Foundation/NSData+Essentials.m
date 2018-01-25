//
//  NSData+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 4.12.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSData+Essentials.h"





@implementation NSData (Essentials)





- (NSString *)UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}




+ (NSData *)dataWithHexadecimalString:(NSString *)hexString {
    NSArray<NSString *> *ignoringSymbols = @[@"-", @"\n", @" "];
    foreach (symbol, ignoringSymbols) {
        hexString = [hexString stringByReplacingOccurrencesOfString:symbol withString:@""];
    }
    
    const char *hex = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = strlen(hex);
    NSMutableData *data = [NSMutableData dataWithCapacity:length];
    
    char byteHex[3] = { '\0', '\0', '\0'};
    forcount (index, length / 2) {
        byteHex[0] = hex[2 * index];
        byteHex[1] = hex[2 * index + 1];
        
        unsigned char byte = strtol(byteHex, NULL, 16);
        [data appendBytes:&byte length:1];
    }
    
    return data;
}


- (NSString *)hexadecimalString {
    const unsigned char *data = [self bytes];
    NSMutableString *hex = [NSMutableString stringWithCapacity:(self.length * 2)];
    
    forcount (index, self.length) {
        [hex appendFormat:@"%02x", (unsigned char)data[index]];
    }
    
    return hex;
}





- (NSString *)formattedLength {
    return [NSByteCountFormatter stringFromByteCount:self.length countStyle:NSByteCountFormatterCountStyleMemory];
}





@end


