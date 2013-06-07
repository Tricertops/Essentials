//
//  NSInvocation+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSInvocation (Essentials)



/// Quick way of creating invocations. Arguments are used to obtain method signature and then are assigned to invocation.
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)sel;



@end
