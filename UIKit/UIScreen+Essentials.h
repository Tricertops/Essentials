//
//  UIScreen+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIScreen (Essentials)



#pragma mark - Dimensions

/// Returns whether the receiver has more than 568 points in height. Intended to be used for 4" display detection, usefull only on iPhone.
- (BOOL)tall __deprecated_msg("Obsolete with iPhone 6 (and Plus)");

/// Return whether the receiver has scale of 2 (or more).
- (BOOL)retina;

/// Returns landscape bounds of the screen.
- (CGRect)landscapeBounds __deprecated_msg("Obsolete with iOS 8, use -rotatedBounds");

/// Returns bounds NOT adjusted for current interface orientation, works for iOS 8 and later.
- (CGRect)fixedBounds;

/// Returns bounds adjusted for current interface orientation, works for iOS 7 and earlier.
- (CGRect)rotatedBounds;

/// Returns a value that indicates how many points represent an actual screen pixel (i.e. 0.5 @2x devices).
- (CGFloat)pixel;

/// Returns orientation of the screen.
- (UIInterfaceOrientation)interfaceOrientation;


#pragma mark - Class Shorthands

/// These methods call appropriate instance methods on [UIScreen mainScreen] object.

+ (BOOL)tall __deprecated_msg("Obsolete with iPhone 6 (and Plus)");
+ (BOOL)retina;
+ (CGRect)landscapeBounds __deprecated_msg("Obsolete with iOS 8, use -rotatedBounds");
+ (CGRect)fixedBounds;
+ (CGRect)rotatedBounds;
+ (CGFloat)scale;
+ (CGFloat)pixel;
+ (UIInterfaceOrientation)interfaceOrientation;
+ (CGFloat)width;


@end




/// Returns fraction of main screen’s width. Bigger screens get bigger values.
extern CGFloat UIScreenFraction(CGFloat);


