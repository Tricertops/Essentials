//
//  ESSCatch.m
//  Essentials
//
//  Created by Martin Kiss on 26.3.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "ESSCatch.h"
#import "Foundation+Essentials.h"





@implementation ESSCatchIssue





+ (instancetype)_c:(NSString *)condition m:(NSString *)message f:(NSString *)file l:(NSUInteger)line f:(NSString *)function {
    return [[ESSCatchIssue alloc] initWithCondition:condition message:message file:file line:line function:function];
}


- (instancetype)initWithCondition:(NSString *)condition message:(NSString *)message file:(NSString *)file line:(NSUInteger)line function:(NSString *)function {
    self = [super init];
    if (self) {
        self->_condition = [condition copy];
        self->_message = [message copy];
        self->_file = [file lastPathComponent];
        self->_line = line;
        self->_function = [function copy];
        
        self->_date = [NSDate new];
        self->_thread = [NSThread currentThread];
        self->_callStack = [NSThread callStackSymbols];
        self->_operationQueue = [NSOperationQueue currentQueue];
        self->_runLoop = [NSRunLoop currentRunLoop];
        
        [self _print];
    }
    return self;
}





ESSShared(NSMutableDictionary *, _handlers, [NSMutableDictionary new])


+ (void)_addHandler:(ESSCatchHandler)handler forFile:(NSString *)file {
    NSMutableDictionary *handlers = [self _handlers];
    id key = (file.lastPathComponent ?: @"");
    NSMutableArray *handlersForKey = handlers[key];
    if ( ! handlersForKey) {
        handlersForKey = [NSMutableArray new];
        handlers[key] = handlersForKey;
    }
    [handlersForKey addObject: [NSValue valueWithPointer: handler]];
}


- (NSArray *)_handlers {
    NSMutableArray *handlers = [NSMutableArray new];
    [handlers addObjectsFromArray: [[self.class _handlers] objectForKey:self.file] ?: @[]];
    [handlers addObjectsFromArray: [[self.class _handlers] objectForKey:nil] ?: @[]];
    return handlers;
}





- (void)_print {
    ESSWarning(@"Caught “%@” in %@: %@", self.condition, self.function, self.message);
}



   
   
@end


