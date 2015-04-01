//
//  NSCoder+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21.2.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "NSCoder+Essentials.h"
#import "NSValue+Essentials.h"





@implementation NSCoder (Essentials)





- (void)encodeValue:(const void *)address ofObjCType:(ESSObjCType)type forKey:(NSString *)key {
    ESSAssert(address, @"No address.") return;
    ESSAssert(type, @"No type.") return;
    
    NSObject *object = [NSObject objectOfObjCType:type atAddress:address];
    if (object) [self encodeObject:object forKey:key];
}


- (BOOL)decodeValue:(void *)address ofObjCType:(ESSObjCType)type forKey:(NSString *)key {
    ESSAssert(address, @"No address.") return NO;
    ESSAssert(type, @"No type.") return NO;
    
    if (ESSObjCTypeIsObject(type)) {
        ESSObjCTypeCast(id __autoreleasing, address) = [self decodeObjectForKey:key];
        return YES;
    }
    if (ESSObjCTypeIsString(type)) {
        NSString *string = [self decodeObjectOfClass:[NSString class] forKey:key];
        ESSObjCTypeCast(const char*, address) = string.UTF8String;
        return YES;
    }
    if (ESSObjCTypeIsValue(type)) {
        NSValue *value = [self decodeObjectOfClass:[NSValue class] forKey:key];
        if (ESSObjCTypeEquals(type, value.objCType)) {
            [value getValue:address];
            return YES;
        }
    }
    
    return NO;
}





@end


