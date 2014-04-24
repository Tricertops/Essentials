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
- (BOOL)tall;

/// Return whether the receiver has scale of 2 (or more).
- (BOOL)retina;

/// Returns landscape bounds of the screen.
- (CGRect)landscapeBounds;

/// Returns a value that indicates how many points represent an actual screen pixel. (i.e. 0.5 @2x devices)
- (CGFloat)pixel;


#pragma mark - Class Shorthands

/// These methods call appropriate instance methods on [UIScreen mainScreen] object.

+ (BOOL)tall;
+ (BOOL)retina;
+ (CGRect)landscapeBounds;
+ (CGFloat)pixel;


@end
