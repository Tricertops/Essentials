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
#import "NSMutableDictionary+Essentials.h"
#import "NSError+Essentials.h"
#import "NSNumber+Essentials.h"
#import "NSInvocation+Essentials.h"
#import "NSOperationQueue+Essentials.h"
#import "NSTimer+Essentials.h"
#import "NSDate+Essentials.h"
#import "NSData+Essentials.h"
#import "NSUUID+Essentials.h"
#import "NSSortDescriptor+Essentials.h"
#import "NSIndexPath+Essentials.h"







#pragma mark - Assertions

/// WARNING: Any code after ESSAssert macro is conditioned by the assertion condition! If you forget to put trailing semicolon, results are unpredictable.



#if !defined(NS_BLOCK_ASSERTIONS)
    /// Use like NSAssert, but you can append code to be executed on Release.
    #define ESSAssert(CONDITION, MESSAGE, ...)\
    if ( ! (CONDITION)\
        && (( [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]\
                                                                      file:[NSString stringWithUTF8String:__FILE__]\
                                                                lineNumber:__LINE__\
                                                               description:@"Assertion failure in %s, %s:%d. Condition not satisfied: \"%s\", reason: " MESSAGE, __PRETTY_FUNCTION__, __FILE__, __LINE__, # CONDITION, ##__VA_ARGS__],\
             YES)) )
#else
    /// Use like NSAssert, but you can append code to be executed on Release.
    #define ESSAssert(CONDITION, MESSAGE, ...)\
    if ( ! (CONDITION)\
        && (( NSLog(@"*** Assertion failure in %s, %s:%d. Condition not satisfied: \"%s\", reason: " MESSAGE,\
                    __PRETTY_FUNCTION__, __FILE__, __LINE__, #CONDITION, ##__VA_ARGS__),\
             YES)) )
#endif


/// Use like NSAssert, but this one will throw exception even on Release.
#define ESSAssertException(CONDITION, MESSAGE, ...)\
    ESSAssert(CONDITION, MESSAGE, ##__VA_ARGS__)\
        @throw [NSException exceptionWithName:NSInternalInconsistencyException\
                                       reason:[NSString stringWithFormat:@"*** Assertion failure in %s, %s:%d. Condition not satisfied: \"%s\", reason: " MESSAGE, __PRETTY_FUNCTION__, __FILE__, __LINE__, #CONDITION, ##__VA_ARGS__] userInfo:nil]


/// Use like NSAssert(NO, ...), append code to be executed on Release.
#define ESSAssertFail(MESSAGE, ...)\
    ESSAssert(NO, MESSAGE, ##__VA_ARGS__)







#pragma mark - Shared Class Values


/// Use to create class method that uses dispatch_once with simple value.
#define ESSShared(TYPE, NAME, VALUE)\
+ (TYPE)NAME {\
    static TYPE NAME = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        NAME = VALUE;\
    });\
    return NAME;\
}\


/// Use to create class method `shared` that uses dispatch_once to alloc/init single instance.
#define ESSSharedInstance(CLASS)\
+ (instancetype)shared {\
    static CLASS *shared = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        shared = [[CLASS alloc] init];\
    });\
    return shared;\
}\


/// Use to create class method that uses dispatch_once with additional code. Append method body just after the macro and return object to be shared.
#define ESSSharedMake(TYPE, NAME)\
+ (TYPE)NAME {\
    static TYPE NAME = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        NAME = [self make_##NAME];\
    });\
    return NAME;\
}\
+ (TYPE)make_##NAME\







#pragma mark Properties


/// Use if you are lazy to declare read-only lazy-loaded property. Will declare selector, that forces you to use ESSLazyLoad too.
#define ESSPropertyLazy(MEMORY, TYPE, NAME)\
@property (nonatomic, readonly, MEMORY) TYPE NAME;\
- (TYPE)ess_make_##NAME;


/// Use to create lazy-loading getter. Append implementation that assigns desired value into the property.
#define ESSLazyLoad(TYPE, GETTER)\
@synthesize GETTER = _##GETTER;\
- (TYPE)GETTER {\
    if ( ! self->_##GETTER) {\
        [self load_##GETTER];\
    }\
    return self->_##GETTER;\
}\
- (void)load_##GETTER\


/// Use to create lazy-loading getter with custom ivar. Append implementation that returns desired value.
#define ESSLazyMakeUsingIvar(TYPE, GETTER, IVAR)\
- (TYPE)GETTER {\
    if ( ! self->IVAR) {\
        self->IVAR = [self ess_make_##GETTER];\
    }\
    return self->IVAR;\
}\
- (TYPE)ess_make_##GETTER\


/// Use to create lazy-loading getter using standard _ivar. Append implementation that returns desired value.
#define ESSLazyMake(TYPE, GETTER)\
@synthesize GETTER = _##GETTER;\
ESSLazyMakeUsingIvar(TYPE, GETTER, _##GETTER)


/// Use to create accessors for associated property.
#define ESSSynthesizeStrong(TYPE, GETTER, SETTER)\
- (TYPE)GETTER {\
    return [self associatedObjectForKey:@selector(GETTER)];\
}\
- (void)SETTER:(TYPE)GETTER {\
    [self setAssociatedStrongObject:GETTER forKey:@selector(GETTER)];\
}\


/// Use to create accessors for associated property. Append implementation that assigns desired value into the property using setter.
#define ESSSynthesizeStrongLoad(TYPE, GETTER, SETTER)\
- (TYPE)GETTER {\
    TYPE GETTER = [self associatedObjectForKey:@selector(GETTER)];\
    if ( ! GETTER) {\
        [self load_##GETTER];\
        GETTER = [self associatedObjectForKey:@selector(GETTER)];\
    }\
    return GETTER;\
}\
- (void)SETTER:(TYPE)GETTER {\
    [self setAssociatedStrongObject:GETTER forKey:@selector(GETTER)];\
}\
- (void)load_##GETTER\


/// Use to create accessors for associated property. Append implementation that returns desired value.
#define ESSSynthesizeStrongMake(TYPE, GETTER, SETTER)\
- (TYPE)GETTER {\
    TYPE GETTER = [self associatedObjectForKey:@selector(GETTER)];\
    if ( ! GETTER) {\
        GETTER = [self make_##GETTER];\
        [self SETTER:GETTER];\
    }\
    return GETTER;\
}\
- (void)SETTER:(TYPE)GETTER {\
    [self setAssociatedStrongObject:GETTER forKey:@selector(GETTER)];\
}\
- (TYPE)make_##GETTER\


/// Use to create accessors for associated NSValue property. Specify primitive TYPE to be wrapped using NSValue.
#define ESSSynthesizeValue(TYPE, GETTER, SETTER)\
- (TYPE)GETTER {\
    TYPE GETTER;\
    NSValue *value = [self associatedObjectForKey:@selector(GETTER)];\
    [value getValue:&GETTER];\
    return GETTER;\
}\
- (void)SETTER:(TYPE)GETTER {\
    NSValue *value = [NSValue valueWithBytes:&GETTER objCType:@encode(TYPE)];\
    [self setAssociatedStrongObject:value forKey:@selector(GETTER)];\
}\


/// Use to create accessors for property of object type stored in User Defaults.
#define ESSSynthesizeUserDefaults(TYPE, GETTER, SETTER, KEY)\
- (TYPE)GETTER {\
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY];\
}\
- (void)SETTER:(TYPE)GETTER {\
    [[NSUserDefaults standardUserDefaults] setObject:GETTER forKey:KEY];\
}\


/// Use to create accessors for property of numeric type stored in User Defaults.
#define ESSSynthesizeNumericUserDefaults(TYPE, GETTER, SETTER, KEY)\
- (TYPE)GETTER {\
    return [[NSUserDefaults standardUserDefaults] doubleForKey:KEY];\
}\
- (void)SETTER:(TYPE)GETTER {\
    [[NSUserDefaults standardUserDefaults] setDouble:GETTER forKey:KEY];\
}\







#pragma mark String Definitions


/// Use to declare 3-part string constatnt.
#define ESSStringDeclaration(PREFIX, TYPE, NAME)        extern NSString * const   PREFIX ## TYPE ## NAME;

/// Use to define 3 part string constant. The value is joined using dots.
#define ESSStringDefinition(PREFIX, TYPE, NAME)         NSString * const   PREFIX ## TYPE ## NAME   =   @ #PREFIX "." #TYPE "." #NAME;







#pragma mark Key Path Operators


/// Don't use directly, use one of the concrete macros below.
#define keypathOperation(OPERATION, CLASS, KEYPATH)    (((void)(NO && ((void)CLASS.new.KEYPATH, NO)), "@" # OPERATION "." # KEYPATH))


/// Use to create NSString from keypath to be used as keypath operator. Example:   @keypathAverage(NSString, length)
#define keypathCount(CLASS, KEYPATH)    keypathOperation(count, CLASS, KEYPATH)
#define keypathSum(CLASS, KEYPATH)      keypathOperation(sum, CLASS, KEYPATH)
#define keypathAverage(CLASS, KEYPATH)  keypathOperation(avg, CLASS, KEYPATH)
#define keypathMin(CLASS, KEYPATH)      keypathOperation(min, CLASS, KEYPATH)
#define keypathMax(CLASS, KEYPATH)      keypathOperation(max, CLASS, KEYPATH)
#define keypathUnique(CLASS, KEYPATH)   keypathOperation(distinctUnionOfObjects, CLASS, KEYPATH)


/// Use to create string from selector. Some validation and completion included.
#define ESSSelector(SELECTOR)  NSStringFromSelector(@selector(SELECTOR))

/// Use to create string from selector. Full validation and completion included.
#define ESSKeypath(OBJECT, KEYPATH)         @(((void)(NO && ((void)OBJECT.KEYPATH, NO)), # KEYPATH))

/// Use to create string from selector if you don't have an instance by hand. Full validation and completion included.
#define ESSKeypathClass(CLASS, KEYPATH)     ESSKeypath([CLASS new], KEYPATH)


/// Unusable in current version of Clang.
#define ESSDeprecated      __attribute__((deprecated(message)))
#define ESSDeprecatedUse(selector)  ESSDeprecated("Use " # selector " instead")







#pragma mark - Numbers


/// Unsigned byte.
typedef uint8_t NSUByte;


/// Signed byte.
typedef int8_t NSByte;


/// Uses arc4random_uniform(). Pass NSUIntegerMax to use arc4random().
extern NSUInteger NSUIntegerRandom(NSUInteger count);


/// Use to make sure the VALUE is no less than MIN and no more than MAX.
#define CLAMP(MIN, VALUE, MAX) ({\
    typeof(MIN) __min = (MIN);\
    typeof(VALUE) __value = (VALUE);\
    typeof(MAX) __max = (MAX);\
    (__value > __max ? __max : (__value < __min ? __min : __value));\
})


/// Should be infinity, uses HUGE_VAL.
extern NSTimeInterval const NSTimeIntervalInfinity;







#pragma mark - Objects

/// Safely compares two objects using `==` and `-isEqual:` to really tell is those two are equal. Exception-free.
extern BOOL NSEqual(NSObject *, NSObject *);


/// Safely compares two strings using `==` and `-isEqualToString:` to really tell is those two are equal. Exception-free.
extern BOOL NSStringEqual(NSString *, NSString *);





#pragma mark - Encoding Types


#define ESST(TYPE)   @(@encode(TYPE))
#define ESSTypes(...)   ( [@[ __VA_ARGS__ ] componentsJoinedByString:@""] )




