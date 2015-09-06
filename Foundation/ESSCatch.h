//
//  ESSCatch.h
//  Essentials
//
//  Created by Martin Kiss on 26.3.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

@import Foundation;



//! Test condition and return its boolean value. Include formatetd message after the condition.
#define ESSCatch(condition...)  _ESSCatch(condition)
//! Creates global Catch handler. Append implementation that will be executed and optionally use variable `issue`.
#define ESSCatchHandle          _ESSCatchGenerateHandlerForFile(nil) // Implementation should follow.
//! Creates file Catch handler. Append implementation that will be executed and optionally use variable `issue`.
#define ESSCatchHandleThisFile  _ESSCatchGenerateHandlerForFile(@(__FILE__)) // Implementation should follow.
//! Pauses debugger, if Exception Breakpoint is enabled.
#define ESSPause                _ESSPause



//! Class that encapsulates all properties about the condition, place and environment.
//! Object of this class is created when ESSCatch evaluates first argument to YES.
@interface ESSCatchIssue : NSObject


//! Contents of the first argument of ESSCatch, whose value was evaluated to YES.
@property (readonly) NSString *condition;
//! Formatted message created from the other arguments of ESSCatch.
@property (readonly) NSString *message;
//! Name (with extension) of the source file in which the ESSCatch is located.
@property (readonly) NSString *file;
//! Number of the line in source file on which the ESSCatch is located.
@property (readonly) NSUInteger line;
//! Name of function/method in which the ESSCatch is located.
@property (readonly) NSString *function;

//! Date of the ESSCatch execution.
@property (readonly) NSDate *date;
//! Thread on which ESSCatch executed.
@property (readonly) NSThread *thread;
//! Call stack at the moment of ESSCatch execution.
@property (readonly) NSArray<NSString *> *callStack;
//! Operation Queue on which ESSCatch executed.
@property (readonly) NSOperationQueue *operationQueue;
//! Run Loop on which ESSCatch executed.
@property (readonly) NSRunLoop *runLoop;


@end





#pragma mark - Look No Further -





//! Function that takes an issue.
typedef void (*ESSCatchHandler)(ESSCatchIssue *issue);





@interface ESSCatchIssue ()


+ (instancetype)_c:(NSString *)condition m:(NSString *)message f:(NSString *)file l:(NSUInteger)line f:(NSString *)function;

+ (void)_addHandler:(ESSCatchHandler)h forFile:(NSString *)f;
- (NSArray<NSValue *> *)_handlers;


@end





//! Evaluates the condition and if true, creates Issue object and launches handling sequence.
#define _ESSCatch(CONDITION, MESSAGE...) \
	(BOOL)({ \
		_Bool r = (CONDITION); \
		if (__builtin_expect(r, 0)) { \
            NSString *m = [NSString stringWithFormat: @"" MESSAGE]; \
            ESSCatchIssue *i = [ESSCatchIssue _c:@#CONDITION m:m f:@(__FILE__) l:__LINE__ f:@(__PRETTY_FUNCTION__)]; \
            _ESSPause; \
            for (NSValue *wrapper in [i _handlers]) { \
                ESSCatchHandler handler = wrapper.pointerValue; \
                handler(i); \
            } \
		} \
		r; \
	})


//! Defines a function that registers another function as global or file handler.
#define _ESSCatchGenerateHandlerForFile(FILE) \
static void _ESSCatchGlobalHandler(ESSCatchIssue *issue); \
__attribute__((constructor)) static void _ESSCatchGlobalHandlerRegistrator ## __COUNTER__() { \
    [ESSCatchIssue _addHandler: &_ESSCatchGlobalHandler forFile: (FILE)];\
} \
static void _ESSCatchGlobalHandler(ESSCatchIssue *issue)
// Implementation should follow.


//! If you have Exception Breakpoint active, this macro will pause the debugger.
#define _ESSPause \
    @try{ \
        @throw [NSException exceptionWithName:@"ESSCatchException" reason:@"Pausing debugger." userInfo:nil]; \
    } \
    @catch(NSException *e) { \
    }


