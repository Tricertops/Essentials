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

+ (CGFloat)width {
    return self.mainScreen.fixedBounds.size.width;
}




@end





CGFloat UIScreenFraction(CGFloat fraction) {
    return CGFloatRoundToScreenScale(UIScreen.fixedBounds.size.width * fraction);
}


