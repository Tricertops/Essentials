//
//  NSInvocation+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSInvocation+Essentials.h"





@implementation NSInvocation (Essentials)





+ (instancetype)invocationWithTarget:(id)target selector:(SEL)sel {
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    NSInvocation *invocation = [self invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = sel;
    return invocation;
}





@end
