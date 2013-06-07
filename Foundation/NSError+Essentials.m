//
//  NSError+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSError+Essentials.h"





@implementation NSError (Essentials)





- (NSString *)underlayingLocalizedDescription {
    NSString *myDescription = self.localizedDescription;
    NSError *underlayingError = [self.userInfo objectForKey:NSUnderlyingErrorKey];
    if (underlayingError) {
        myDescription = [myDescription stringByAppendingFormat:@": %@", underlayingError.localizedDescription];
    }
    NSException *underlayingException = [self.userInfo objectForKey:@"NSUnderlyingException"];
    if (underlayingException) {
        myDescription = [myDescription stringByAppendingFormat:@": %@", underlayingException.reason];
    }
    return myDescription;
}





@end
