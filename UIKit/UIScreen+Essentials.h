//
//  UIScreen+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"





@interface UIScreen (Essentials)



#pragma mark - Dimensions

//! Ratio of width to height in portrait.
- (CGFloat)aspectRatio;

/// Return whether the receiver has scale of 2 (or more).
- (BOOL)retina;

/// Returns bounds NOT adjusted for current interface orientation, works for iOS 8 and later.
- (CGRect)fixedBounds;

/// Returns bounds adjusted for current interface orientation, works for iOS 7 and earlier.
- (CGRect)rotatedBounds;

/// Returns a value that indicates how many points represent an actual screen pixel (i.e. 0.5 @2x devices).
- (CGFloat)pixel;

/// Returns orientation of the screen.
- (UIInterfaceOrientation)interfaceOrientation;

/// Renders all windows of this screen including status bar area. Status bar itself cannot be drawn without hacks, but drawing block allows you to add any custom content, including fake status bars.
- (UIImage *)takeScreenshotWithDrawing:(void (^)(void))drawingBlock;


#pragma mark - Class Shorthands

/// These methods call appropriate instance methods on [UIScreen mainScreen] object.

+ (CGFloat)aspectRatio;
+ (BOOL)retina;
+ (CGRect)fixedBounds;
+ (CGRect)rotatedBounds;
+ (CGFloat)scale;
+ (CGFloat)pixel;
+ (UIInterfaceOrientation)interfaceOrientation;
+ (CGFloat)width;


@end




/// Returns fraction of main screen’s width. Bigger screens get bigger values.
extern CGFloat UIScreenFraction(CGFloat);


