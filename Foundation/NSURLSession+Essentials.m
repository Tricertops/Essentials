//
//  NSURLSession+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSURLSession+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSURLSession (Essentials)





#pragma mark - Creating & Shared


ESSSharedMake(NSURLSession *, mainQueueSession) {
    return [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                         delegate:nil
                                    delegateQueue:[NSOperationQueue mainQueue]];
}


+ (instancetype)defaultSessionOnQueue:(NSOperationQueue *)queue {
    if (queue == [NSOperationQueue mainQueue]) {
        return [self mainQueueSession];
    }
    else {
        return [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                             delegate:nil
                                        delegateQueue:queue];
    }
}





@end


