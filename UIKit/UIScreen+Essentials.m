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
    return [self.fixedCoordinateSpace bounds];
}


- (CGRect)rotatedBounds {
    return self.bounds;
}


- (CGFloat)pixel {
    return 1.0 / self.scale;
}


- (UIImage *)takeScreenshotWithDrawing:(void (^)(void))drawingBlock {
    let app = UIApplication.sharedApplication;
    let scene = (UIWindowScene *)app.connectedScenes.anyObject;
    
    return [UIImage drawWithSize:self.bounds.size opaque:YES scale:self.scale block:^{
        foreach (window, scene.windows) {
            if (window.screen == self && !window.isHidden) {
                [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
            }
        }
        if (drawingBlock) drawingBlock();
    }];
}




#pragma mark - Class Shorthands


+ (CGFloat)aspectRatio {
    return self.deprecatedMainScreen.aspectRatio;
}


+ (BOOL)retina {
    return self.deprecatedMainScreen.retina;
}


+ (CGRect)fixedBounds {
    return self.deprecatedMainScreen.fixedBounds;
}

+ (CGRect)rotatedBounds {
    return self.deprecatedMainScreen.rotatedBounds;
}

+ (CGFloat)scale {
    return self.deprecatedMainScreen.scale;
}

+ (CGFloat)pixel {
    return self.deprecatedMainScreen.pixel;
}

+ (CGFloat)width {
    return self.deprecatedMainScreen.fixedBounds.size.width;
}

+ (UIScreen*)deprecatedMainScreen {
    return self.mainScreen;
}




@end





CGFloat UIScreenFraction(CGFloat fraction) {
    return CGFloatRoundToScreenScale(UIScreen.fixedBounds.size.width * fraction);
}


