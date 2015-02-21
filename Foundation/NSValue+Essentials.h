//
//  NSValue+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21.2.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"





@interface NSValue (Essentials)


//! Wraps value at given address: C numbers in NSNumber, all other (including objects) in NSValue.
+ (instancetype)valueOfObjCType:(ESSObjCType)type atAddress:(const void *)address;

//! If the internal value is compatible with the contained value, copies it into the specified address.
- (BOOL)getValueOfObjCType:(ESSObjCType)type toAddress:(void *)address;


@end





@interface NSObject (ESSObjCTypes)


//! Returns object representation of value at given address.
+ (instancetype)objectOfObjCType:(ESSObjCType)type atAddress:(const void *)address;


@end




extern BOOL ESSObjCTypeEquals(ESSObjCType, ESSObjCType);
#define ESSObjCTypeIs(OBJC_TYPE, RAW_TYPE) ESSObjCTypeEquals(OBJC_TYPE, @encode(typeof(RAW_TYPE)))
extern BOOL ESSObjCTypeIsObject(ESSObjCType); //!< id/Class
extern BOOL ESSObjCTypeIsNumber(ESSObjCType); //!< (unsigned) char/short/int/long/long long, float/double, _Bool
extern BOOL ESSObjCTypeIsString(ESSObjCType); //!< char*, SEL
extern BOOL ESSObjCTypeIsValue(ESSObjCType); //!< struct, array, union, pointer
extern BOOL ESSObjCTypeIsOther(ESSObjCType); //!< void, void(*)(void)



//! Macro for casting pointer to given type. For id, add __autoreleasing or __unsafe_unretained.
#define ESSObjCTypeCast(TYPE, VALUE_ADDRESS)  (*((TYPE*)VALUE_ADDRESS))



