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


- (CGRect)landscapeBounds {
    CGRect portraitBounds = self.bounds;
    CGRect landscapeBounds = CGRectZero;
    landscapeBounds.size.width = portraitBounds.size.height;
    landscapeBounds.size.height = portraitBounds.size.width;
    return landscapeBounds;
}


- (CGFloat)pixel {
    return 1.0 / self.scale;
}




#pragma mark - Class Shorthands


+ (BOOL)tall {
    return self.mainScreen.tall;
}


+ (BOOL)retina {
    return self.mainScreen.retina;
}


+ (CGRect)landscapeBounds {
    return self.mainScreen.landscapeBounds;
}

+ (CGFloat)pixel {
    return self.mainScreen.pixel;
}




@end
