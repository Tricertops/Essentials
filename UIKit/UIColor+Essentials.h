//
//  UIColor+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foundation+Essentials.h"





@interface UIColor (Essentials)



#pragma mark - Random

/// Returns completely random color, but not too black or too white.
+ (UIColor *)randomColor;

/// Returns random tint of the receiver, but not too dark or too light.
- (UIColor *)randomize;

/// Returns random tint of the receiver. Requires numbers of discrete steps and white and black safe zones.
- (UIColor *)randomizeWithSteps:(NSUInteger)steps whiteInset:(CGFloat)white blackInset:(CGFloat)black;



#pragma mark - Components

/// Red component of RGB or grayscale color.
- (CGFloat)redComponent;

/// Green component of RGB or grayscale color.
- (CGFloat)greenComponent;

/// Blue component of RGB or grayscale color.
- (CGFloat)blueComponent;

/// Alpha component of the receiver.
- (CGFloat)alphaComponent;



#pragma mark - Brightness

/// Luminance of the receiver. Value of the receiver in grayscale.
- (CGFloat)luminance;

/// Return new color with the same hue as the receiver, but different luminance.
- (UIColor *)colorWithLuminance:(CGFloat)luminance;



@end





#pragma mark - Functions

/// Convenience function for creating RGBA colors using byte values.
extern inline UIColor * UIColorByteRGBA(NSUByte r, NSUByte g, NSUByte b, CGFloat a);

/// Convenience function for creating RGB colors using byte values with alpha 1.
extern inline UIColor * UIColorByteRGB(NSUByte r, NSUByte g, NSUByte b);


