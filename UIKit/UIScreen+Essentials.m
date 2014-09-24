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
    return (self.fixedBounds.size.height >= 568);
}


- (BOOL)retina {
    return (self.scale >= 2);
}


- (CGRect)landscapeBounds {
    CGRect portraitBounds = self.fixedBounds;
    CGRect landscapeBounds = CGRectZero;
    landscapeBounds.size.width = portraitBounds.size.height;
    landscapeBounds.size.height = portraitBounds.size.width;
    return landscapeBounds;
}


- (CGRect)fixedBounds {
    if ([self respondsToSelector:@selector(fixedCoordinateSpace)]) {
        /// iOS 8.0 and later
        return [self.fixedCoordinateSpace bounds];
    }
    else {
        /// iOS 7.1 and earlier
        return self.bounds;
    }
}


- (CGRect)rotatedBounds {
    CGRect bounds = self.bounds;
    
    if ( ! [self respondsToSelector:@selector(fixedCoordinateSpace)]) {
        /// iOS 7.1 and earlier
        BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
        if (isLandscape) {
            bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
        }
    }
    
    return bounds;
}


- (CGFloat)pixel {
    return 1.0 / self.scale;
}


- (UIInterfaceOrientation)interfaceOrientation {
    return [[UIApplication sharedApplication] statusBarOrientation];
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


+ (CGRect)fixedBounds {
    return self.mainScreen.fixedBounds;
}

+ (CGRect)rotatedBounds {
    return self.mainScreen.rotatedBounds;
}

+ (CGFloat)pixel {
    return self.mainScreen.pixel;
}

+ (UIInterfaceOrientation)interfaceOrientation {
    return self.mainScreen.interfaceOrientation;
}




@end
