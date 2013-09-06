//
//  Foundation+Essentials.h
//  Essentials
//
//  Created by Juraj Homola on 18.6.2013.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSObject+Essentials.h"
#import "NSString+Essentials.h"
#import "NSArray+Essentials.h"
#import "NSMutableArray+Essentials.h"
#import "NSDictionary+Essentials.h"
#import "NSError+Essentials.h"
#import "NSNumber+Essentials.h"
#import "NSInvocation+Essentials.h"
#import "NSOperationQueue+Essentials.h"





#pragma mark - Assertions

/// WARNING: Any code after ESSAssert macro is conditioned by the assertion condition! If you forget to put trailing semicolon, results are unpredictable.


#if !defined(NS_BLOCK_ASSERTIONS)

#define ESSAssert(CONDITION, MESSAGE, ...)\
if ( ! (CONDITION) && (( [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] file:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__ description:MESSAGE, ##__VA_ARGS__], YES)) )

#else

#define ESSAssert(CONDITION, MESSAGE, ...)\
if ( ! (CONDITION) && (( NSLog(@"*** Assertion failure in %s, %s:%d, Condition not satisfied: %s, reason: '" MESSAGE "'", __PRETTY_FUNCTION__, __FILE__, __LINE__, #CONDITION, ##__VA_ARGS__), YES)) )

#endif

#define ESSAssertReturn(CONDITION, MESSAGE, ...)        ESSAssert(CONDITION, MESSAGE, ##__VA_ARGS__) return
#define ESSAssertReturnNil(CONDITION, MESSAGE, ...)     ESSAssert(CONDITION, MESSAGE, ##__VA_ARGS__) return nil
#define ESSAssertException(CONDITION, MESSAGE, ...)     ESSAssert(CONDITION, MESSAGE, ##__VA_ARGS__) @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"*** Assertion failure in %s, %s:%d, Condition not satisfied: %s, reason: '" MESSAGE "'", __PRETTY_FUNCTION__, __FILE__, __LINE__, #CONDITION, ##__VA_ARGS__] userInfo:nil]





#pragma mark - Shared Values


#define ESSShared(TYPE, NAME, VALUE)\
+ (TYPE)NAME {\
    static TYPE NAME = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        NAME = VALUE;\
    });\
    return NAME;\
}\


#define ESSStringDefinition(PREFIX, TYPE, NAME)\
NSString * const   PREFIX ## TYPE ## NAME   =   @ #PREFIX "." #TYPE "." #NAME;





#pragma mark Key Path Operators


#define keypathOperation(OPERATION, CLASS, KEYPATH)    (((void)(NO && ((void)CLASS.new.KEYPATH, NO)), "@" # OPERATION "." # KEYPATH))

#define keypathCount(CLASS, KEYPATH)    keypathOperation(count, CLASS, KEYPATH)
#define keypathSum(CLASS, KEYPATH)      keypathOperation(sum, CLASS, KEYPATH)
#define keypathAverage(CLASS, KEYPATH)  keypathOperation(avg, CLASS, KEYPATH)
#define keypathMin(CLASS, KEYPATH)      keypathOperation(min, CLASS, KEYPATH)
#define keypathMax(CLASS, KEYPATH)      keypathOperation(max, CLASS, KEYPATH)
#define keypathUnique(CLASS, KEYPATH)   keypathOperation(distinctUnionOfObjects, CLASS, KEYPATH)





#pragma mark - Random


extern NSUInteger NSUIntegerRandom(NSUInteger count);




#pragma mark - Clamping

#define CLAMP(MIN, VALUE, MAX) ({\
    typeof(MIN) __min = (MIN);\
    typeof(VALUE) __value = (VALUE);\
    typeof(MAX) __max = (MAX);\
    (__value > __max ? __max : (__value < __min ? __min : __value));\
})




#pragma mark - Types


typedef uint8_t NSUByte;
typedef unsigned char NSByte;


