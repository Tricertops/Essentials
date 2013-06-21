//
//  NSNumber+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSNumber (Essentials)



/// Invokes given block N times, where N is receiver's unsignedIntegerValue.
- (void)times:(void(^)(void))block;

/// Invokes given block N times with iteration indexes, where N is receiver's unsignedIntegerValue.
- (void)timesIndex:(void(^)(NSUInteger index))block;



@end
