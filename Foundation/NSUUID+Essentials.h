//
//  NSUUID+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 31.1.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/NSUUID.h>
#import <Foundation/NSData.h>





@interface NSUUID (Essentials)



+ (NSUUID *)UUIDWithData:(NSData *)data;
+ (NSUUID *)UUIDWithBase64String:(NSString *)base64String;


- (NSData *)UUIDData;
- (NSString *)UUIDBase64String;



@end


