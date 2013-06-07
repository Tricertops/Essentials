//
//  UIScreen+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIScreen+Essentials.h"





@implementation UIScreen (Essentials)




#pragma mark - Dimensions


- (BOOL)tall {
    return (self.bounds.size.height >= 568);
}


- (BOOL)retina {
    return (self.scale >= 2);
}





#pragma mark - Class Shorthands


+ (BOOL)tall {
    return self.mainScreen.tall;
}


+ (BOOL)retina {
    return self.mainScreen.retina;
}





@end
