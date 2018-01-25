//
//  NSValue+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21.2.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "NSValue+Essentials.h"





@implementation NSNumber (ESSObjCTypes)





+ (instancetype)valueOfObjCType:(ESSObjCType)type atAddress:(const void *)address {
    return [self numberOfObjCType:type atAddress:address];
}


+ (instancetype)numberOfObjCType:(ESSObjCType)type atAddress:(const void *)address {
    //! If NULL is passed as address, zero NSNumber is returned. Can be used to check numeric types.
#define check_and_return(TYPE) if (ESSObjCTypeIs(type, TYPE)) return (address ? @(ESSObjCTypeCast(TYPE, address)) : @0)
    
    check_and_return(char);
    check_and_return(short);
    check_and_return(int);
    check_and_return(long);
    check_and_return(long long);
    
    check_and_return(unsigned char);
    check_and_return(unsigned short);
    check_and_return(unsigned int);
    check_and_return(unsigned long);
    check_and_return(unsigned long long);
    
    check_and_return(float);
    check_and_return(double);
    
    check_and_return(bool);
    
    return nil;
#undef check_and_return
}


- (BOOL)getValueOfObjCType:(ESSObjCType)type toAddress:(void *)address {
    return [self getNumberOfObjCType:type toAddress:address];
}


- (BOOL)getNumberOfObjCType:(ESSObjCType)type toAddress:(void *)address {
    if (address == NULL) return NO;
    
#define check_and_assign_and_return(TYPE, METHOD) \
if (ESSObjCTypeIs(type, TYPE)) { \
    ESSObjCTypeCast(TYPE, address) = self.METHOD; \
    return YES; \
}

    check_and_assign_and_return(char, charValue);
    check_and_assign_and_return(short, shortValue);
    check_and_assign_and_return(int, intValue);
    check_and_assign_and_return(long, longValue);
    check_and_assign_and_return(long long, longLongValue);
    
    check_and_assign_and_return(unsigned char, unsignedCharValue);
    check_and_assign_and_return(unsigned short, unsignedShortValue);
    check_and_assign_and_return(unsigned int, unsignedIntValue);
    check_and_assign_and_return(unsigned long, unsignedLongValue);
    check_and_assign_and_return(unsigned long long, unsignedLongLongValue);
    
    check_and_assign_and_return(float, floatValue);
    check_and_assign_and_return(double, doubleValue);
    
    check_and_assign_and_return(bool, boolValue);
    
    return NO;
#undef check_and_assign_and_return
    
}



@end





@implementation NSValue (Essentials)




+ (instancetype)valueOfObjCType:(ESSObjCType)type atAddress:(const void *)address {
    if (address == NULL) return nil;
    
    //! Check NSNumber first.
    let number = [NSNumber numberOfObjCType:type atAddress:address];
    if (number) return number;
    
    return [NSValue valueWithBytes:address objCType:type]; //TODO: Handle unsupported types?
}


- (BOOL)getValueOfObjCType:(ESSObjCType)type toAddress:(void *)address {
    if (address == NULL) return NO;
    
    //! NSNumber overrides this method.
    //TODO: There could be NSValue with wrapped numeric value.
    if ( ! ESSObjCTypeEquals(type, self.objCType)) return NO;
    [self getValue:address];
    return YES;
}





@end





@implementation NSObject (ESSObjCTypes)





+ (instancetype)objectOfObjCType:(ESSObjCType)type atAddress:(const void *)address {
    if (ESSObjCTypeIsObject(type)) return ESSObjCTypeCast(id __autoreleasing, address);
    if (ESSObjCTypeIsNumber(type)) return [NSNumber numberOfObjCType:type atAddress:address];
    if (ESSObjCTypeIsString(type)) return @(ESSObjCTypeCast(char*, address));
    if (ESSObjCTypeIsValue(type)) return [NSValue valueOfObjCType:type atAddress:address];
    return nil;
}




@end





BOOL ESSObjCTypeEquals(ESSObjCType A, ESSObjCType B) {
    return (A == B || (A && strcmp(A, B) == 0));
}





#define check_and_return(TYPE) if (type[0] == @encode(TYPE)[0]) return YES


BOOL ESSObjCTypeIsObject(ESSObjCType type) {
    check_and_return(id);
    check_and_return(Class);
    return NO;
}


BOOL ESSObjCTypeIsNumber(ESSObjCType type) {
    return [NSNumber numberOfObjCType:type atAddress:NULL] != nil;
}


BOOL ESSObjCTypeIsString(ESSObjCType type) {
    check_and_return(char*);
    check_and_return(SEL);
    return NO;
}


BOOL ESSObjCTypeIsValue(ESSObjCType type) {
    check_and_return(struct {});
    check_and_return(union {});
    check_and_return(int[]);
    check_and_return(void*);
    return NO;
}


BOOL ESSObjCTypeIsOther(ESSObjCType type) {
    if (ESSObjCTypeIsObject(type)) return NO;
    if (ESSObjCTypeIsNumber(type)) return NO;
    if (ESSObjCTypeIsString(type)) return NO;
    if (ESSObjCTypeIsValue(type)) return NO;
    return YES;
}


#undef check_and_return


