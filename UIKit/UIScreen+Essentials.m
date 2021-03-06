//
//  UIScreen+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIScreen+Essentials.h"
#import "UIKit+Essentials.h"
#import "UIImage+Essentials.h"





@implementation UIScreen (Essentials)




#pragma mark - Dimensions


- (CGFloat)aspectRatio {
    CGRect bounds = self.fixedBounds;
    return  bounds.size.width / bounds.size.height;
}


- (BOOL)retina {
    return (self.scale >= 2);
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


- (UIImage *)takeScreenshotWithDrawing:(void (^)(void))drawingBlock {
    let app = UIApplication.sharedApplication;
    
    return [UIImage drawWithSize:self.bounds.size opaque:YES scale:self.scale block:^{
        foreach (window, app.windows) {
            if (window.screen == self && !window.isHidden) {
                [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
            }
        }
        if (drawingBlock) drawingBlock();
    }];
}




#pragma mark - Class Shorthands


+ (CGFloat)aspectRatio {
    return self.mainScreen.aspectRatio;
}


+ (BOOL)retina {
    return self.mainScreen.retina;
}


+ (CGRect)fixedBounds {
    return self.mainScreen.fixedBounds;
}

+ (CGRect)rotatedBounds {
    return self.mainScreen.rotatedBounds;
}

+ (CGFloat)scale {
    return self.mainScreen.scale;
}

+ (CGFloat)pixel {
    return self.mainScreen.pixel;
}

+ (UIInterfaceOrientation)interfaceOrientation {
    return self.mainScreen.interfaceOrientation;
}

+ (CGFloat)width {
    return self.mainScreen.fixedBounds.size.width;
}




@end





CGFloat UIScreenFraction(CGFloat fraction) {
    return CGFloatRoundToScreenScale(UIScreen.fixedBounds.size.width * fraction);
}


