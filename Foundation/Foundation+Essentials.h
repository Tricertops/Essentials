//
//  Foundation+Essentials.h
//  Essentials
//
//  Created by Juraj Homola on 18.6.2013.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

@import ObjectiveC;
@import Foundation;

#import "ESSLog.h"
#import "Typed.h"


#define ESSOverloaded   __attribute__((overloadable))

#define SDK_iOS11  __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#define SDK_iOS10  __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000





#pragma mark - Assertions

#ifndef ESS_I_have_read_and_agree_to_the_ESSAssert_changes
    #error ESSAssert has changed sematics.
    //! ESSAssert macros have changed semantics, so their fallback code should start with `else` keyword.
    //! Example usage: ESSAssert(condition) else return;
    //! Message is now optional.
    //! ESSAssertFail() has been renamed to ESSFail().
    //! ESSAssertException() is has been removed.
#endif


//! Enable assert when Foundation assert are enabled.
#if DEBUG
    #define ESS_DEBUG_ASSERT_ENABLED   1
#else
    #define ESS_DEBUG_ASSERT_ENABLED   0
#endif


#define ESSAssert(requirement, format...) \
    if (({ \
            BOOL __ok = !!(requirement); \
            if ( ! __ok) _ESSHandleAssertion(requirement, format); \
            __ok; \
        })) ESSNothing(); \
    // else ...

#if ESS_DEBUG_ASSERT_ENABLED
    //! Logs the assertion failure and stops execution.
    #define ESSDebugAssert(requirement, format...)   ESSAssert(requirement, format)
#else
    //! Do nothing.
    #define ESSDebugAssert(requirement, format...)   ESSAssert(YES)
#endif


#define ESSFail(format...)   _ESSHandleAssertion(NO, @"Failed: " format)

#define _ESSHandleAssertion(requirement, format...) \
    ((void)({ \
        let __function = @(__PRETTY_FUNCTION__); \
        let __assertion = @#requirement; \
        var __message = [NSString stringWithFormat: @"" format]; \
        if (__message.length == 0 && __assertion.length > 0) \
            __message = [NSString stringWithFormat: @"Assertion failure: %@", __assertion]; \
        ESSError(@"%@: %@", __function, __message); \
        if (ESS_DEBUG_ASSERT_ENABLED) {\
            [NSAssertionHandler.currentHandler \
                handleFailureInFunction: __function \
                file: @(__FILE__) \
                lineNumber: __LINE__ \
                description: @"%@", __message]; \
        } \
    }))



//! Use to avoid “empty if/while body”.
inline static void ESSNothing(void) {}





#pragma mark - Shared Class Values


/// Use to create local static variable. Includes type inferrence
#define ESSStatic(NAME_ASSIGN, VALUE...)\
static typeof(VALUE) NAME_ASSIGN (typeof(VALUE))0;\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        NAME_ASSIGN (VALUE);\
    });\
}


/// Use to create class method that uses dispatch_once with simple value.
#define ESSShared(TYPE, NAME, VALUE...)\
+ (TYPE)NAME {\
    static TYPE NAME = (TYPE)0;\
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
        shared = [CLASS.self new];\
    });\
    return shared;\
}\


/// Use to create class method that uses dispatch_once with additional code. Append method body just after the macro and return object to be shared.
#define ESSSharedMake(TYPE, NAME)\
+ (TYPE)NAME {\
    static TYPE NAME = (TYPE)0;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        NAME = [self make_##NAME];\
    });\
    return NAME;\
}\
+ (TYPE)make_##NAME\

/// Use to create global cache accessible via a class method.
#define ESSSharedCache(NAME)    ESSSharedMake(NSCache *, NAME) { return [NSCache new]; }


/// Use to run code once the UIApplication did finish launching.
#define ESSInitializeOnAppLaunch \
+ (void)load { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        [NSNotificationCenter.defaultCenter addObserver:self \
                                               selector:@selector(ess_applicationDidFinishLaunchingNotification:) \
                                                   name:UIApplicationDidFinishLaunchingNotification \
                                                 object:nil]; \
    }); \
} \
+ (void)ess_applicationDidFinishLaunchingNotification:(NSNotification *)notification { \
     [self ess_application:[UIApplication cast:notification.object] didFinishLaunchingWithOptions:notification.userInfo]; \
} \
+ (void)ess_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<NSString *, id> *)launchOptions






#pragma mark Properties


/// Create property with not accessible getter.
#define ESSWriteOnlyProperty(type, name) \
    @property type name; \
    - (type)name __unavailable; \


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
    let value = [NSValue valueWithBytes:&GETTER objCType:@encode(TYPE)];\
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


typedef uint8_t NSByte;


/// Uses arc4random_uniform(). Pass NSUIntegerMax to use arc4random().
extern NSUInteger NSUIntegerRandom(NSUInteger count);


/// Use to make sure the VALUE is no less than MIN and no more than MAX.
#define CLAMP(MIN, VALUE, MAX) ({\
    typeof(MIN) __min = (MIN);\
    typeof(VALUE) __value = (VALUE);\
    typeof(MAX) __max = (MAX);\
    (__value > __max ? __max : (__value < __min ? __min : __value));\
})


typedef double NSFloat;


/// Infinity.
extern NSTimeInterval const NSTimeIntervalInfinity;


/// Generates random time between min and max with given step.
extern NSTimeInterval NSTimeIntervalRandom(NSTimeInterval minimum, NSTimeInterval granularity, NSTimeInterval maximum);


/// Signed index allows referencing from the tail. -1 means last index, -2 the one before.
extern NSUInteger ESSIndexFromSignedIndex(NSInteger signedIndex, NSUInteger count);





#pragma mark - Range

/// Location is NSNotFound and length is zero.
extern NSRange const NSRangeNotFound;

/// Make NSRange using location and length.
extern NSRange NSRangeMake(NSUInteger, NSUInteger);

/// Make NSRange using start index and end index (included).
extern NSRange NSRangeMakeFromTo(NSUInteger, NSUInteger);

/// Location is not NSNotFound.
extern BOOL NSRangeIsFound(NSRange);

/// Last included index, or NSNotFound for empty ranges.
extern NSUInteger NSRangeLastIndex(NSRange);

/// First index after this range.
extern NSUInteger NSRangeFollowingIndex(NSRange);

/// Index is included in range.
extern BOOL NSRangeContainsIndex(NSRange, NSUInteger);

/// All indexes of second and in the first range.
extern BOOL NSRangeContainsRange(NSRange, NSRange);

/// Both values must be equal.
extern BOOL NSRangeEqual(NSRange, NSRange);

/// Return range that contains both ranges.
extern NSRange NSRangeUnion(NSRange, NSRange);

/// Whether at least one index is in both.
extern BOOL NSRangeIntersects(NSRange, NSRange);

/// Return range with all indexes included in both.
extern NSRange NSRangeIntersection(NSRange, NSRange);





#pragma mark - Objects

/// Safely compares two objects using `==` and `-isEqual:` to really tell is those two are equal. Exception-free.
extern BOOL NSEqual(NSObject *, NSObject *);


/// Safely compares two strings using `==` and `-isEqualToString:` to really tell is those two are equal. Exception-free.
extern BOOL NSStringEqual(NSString *, NSString *);





#pragma mark - Encoding Types


#define ESST(TYPE)   @(@encode(TYPE))
#define ESSTypes(...)   ( [@[ __VA_ARGS__ ] componentsJoinedByString:@""] )
typedef const char * ESSObjCType;




#pragma mark - Branch Prediction

#define ESSUnlikely(x)   __builtin_expect(!!(x), NO)
#define ESSLikely(x)     __builtin_expect(!!(x), YES)





#pragma mark - Attributes


#define ESSPassthrough(content...)  content




#define THIS_IS_NOT_MACRO




#define forcount(index, count, by...) \
    for (NSInteger __count = (count), index = 0; index < __count; index += (by + 0) ?: 1)

#define forever \
    while (INFINITY)



