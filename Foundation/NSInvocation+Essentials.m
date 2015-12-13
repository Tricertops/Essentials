//
//  NSInvocation+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSInvocation+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSInvocation (Essentials)





+ (instancetype)invocationWithTarget:(id)target selector:(SEL)sel {
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    NSInvocation *invocation = [self invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = sel;
    return invocation;
}


- (id)objectArgumentAtIndex:(NSInteger)index {
    index += 2; // move beyond `self` and `_cmd`
    __unsafe_unretained id argument = nil;
    const char *argumentType = [self.methodSignature getArgumentTypeAtIndex:index];
    ESSAssert(strcmp(argumentType, @encode(id)) == 0,
              @"Incorrect argument type '%s' of method '-%@'", argumentType, NSStringFromSelector(self.selector))
    else return nil;
    [self getArgument:&argument atIndex:index];
    id arcArgument = argument;
    return arcArgument;
}


- (void)setObjectArgument:(id)arcObject atIndex:(NSInteger)index {
    index += 2; // move beyond `self` and `_cmd`
    __unsafe_unretained id object = arcObject;
    const char *argumentType = [self.methodSignature getArgumentTypeAtIndex:index];
    ESSAssert(strcmp(argumentType, @encode(id)) == 0,
              @"Incorrect argument type '%s' of method '-%@'", argumentType, NSStringFromSelector(self.selector))
    else return;
    [self setArgument:&object atIndex:index];
}


- (NSInteger)integerArgumentAtIndex:(NSInteger)index {
    index += 2; // move beyond `self` and `_cmd`
    NSInteger integer;
    const char *argumentType = [self.methodSignature getArgumentTypeAtIndex:index];
    ESSAssert(strcmp(argumentType, @encode(NSInteger)) == 0,
              @"Incorrect argument type '%s' in method '-%@'", argumentType, NSStringFromSelector(self.selector))
    else return NSNotFound;
    [self getArgument:&integer atIndex:index];
    return integer;
}


- (void)setIntegerArgument:(NSInteger)integer atIndex:(NSInteger)index {
    index += 2; // move beyond `self` and `_cmd`
    const char *argumentType = [self.methodSignature getArgumentTypeAtIndex:index];
    ESSAssert(strcmp(argumentType, @encode(NSInteger)) == 0,
              @"Incorrect argument type '%s' in method '-%@'", argumentType, NSStringFromSelector(self.selector))
    else return;
    [self setArgument:&integer atIndex:index];
}


- (id)objectReturnValue {
    __unsafe_unretained id returnValue = nil;
    const char *returnType = [self.methodSignature methodReturnType];
    ESSAssert(strcmp(returnType, @encode(id)) == 0,
              @"Incorrect return type '%s' of method '-%@'", returnType, NSStringFromSelector(self.selector))
    else return nil;
    [self getReturnValue:&returnValue];
    id arcReturnValue = returnValue;
    return arcReturnValue;
}


- (void)setObjectReturnValue:(id)arcObject {
    __unsafe_unretained id object = arcObject;
    const char *returnType = [self.methodSignature methodReturnType];
    ESSAssert(strcmp(returnType, @encode(id)) == 0,
              @"Incorrect return type '%s' of method '-%@'", returnType, NSStringFromSelector(self.selector))
    else return;
    [self setReturnValue:&object];
}


- (NSInteger)integerReturnValue {
    NSInteger returnValue;
    const char *returnType = [self.methodSignature methodReturnType];
    ESSAssert(strcmp(returnType, @encode(NSInteger)) == 0,
              @"Incorrect return type '%s' of method '-%@'", returnType, NSStringFromSelector(self.selector))
    else return NSNotFound;
    [self getReturnValue:&returnValue];
    return returnValue;
}


- (void)setIntegerReturnValue:(NSInteger)integer {
    const char *returnType = [self.methodSignature methodReturnType];
    ESSAssert(strcmp(returnType, @encode(NSInteger)) == 0,
              @"Incorrect return type '%s' of method '-%@'", returnType, NSStringFromSelector(self.selector))
    else return;
    [self setReturnValue:&integer];
}


@end
