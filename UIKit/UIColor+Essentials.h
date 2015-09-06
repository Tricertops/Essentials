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

/// Returns new color that has one minus component of the receiver.
- (UIColor *)invertedColor;



#pragma mark - Combining

/// Returns average color from those provided.
+ (UIColor *)averageColor:(NSArray<UIColor *> *)colors;

/// Returns new color that is a result from blending receiver onto argument.
- (UIColor *)blendedColorOn:(UIColor *)other;

/// Returns new color that is a result from blending receiver onto argument with additional alpha applied on the receiver.
- (UIColor *)blendedColorOn:(UIColor *)other alpha:(CGFloat)additionalAlpha;


//TODO: - (UIColor *)blendedColorOn:(UIColor *)other mode:(CGBlendMode)mode alpha:(CGFloat;



#pragma mark - Brightness

/// Luminance of the receiver. Value of the receiver in grayscale.
- (CGFloat)luminance;

/// Return new color with the same hue as the receiver, but different luminance.
- (UIColor *)colorWithLuminance:(CGFloat)luminance;



#pragma mark - Description

/// Returns natural name of the color, like purple, blue, orange, and so on
@property (readonly) NSString *naturalName;



#pragma mark - Color Spaces

/// Device Gray color space.
+ (CGColorSpaceRef)deviceGrayColorSpace;

/// Device RGB color space.
+ (CGColorSpaceRef)deviceRGBColorSpace;

/// Device CMYK color space.
+ (CGColorSpaceRef)deviceCMYKColorSpace;



#pragma mark - Gradients

//! Creates gradient with two colors.
+ (CGGradientRef)gradientFromColor:(UIColor *)color toColor:(UIColor *)color;

//! Creates gradient with two colors. First is derived from the receiver at given alpha, second is the receiver.
- (CGGradientRef)gradientFromAlpha:(CGFloat)alpha;

//! Creates gradient with two colors. First is the receiver, second is derived from the receiver at given alpha.
- (CGGradientRef)gradientToAlpha:(CGFloat)alpha;

//! Creates gradient from a single color with multiple levels of alpha.
- (CGGradientRef)gradientWithAlphaStops:(NSArray<NSNumber *> *)alphaStops locations:(NSArray<NSNumber *> *)locations;

//! Creates gradient from a multiple colors.
+ (CGGradientRef)gradientWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;





@end





#pragma mark - Functions

/// Convenience function for creating RGBA colors using byte values.
extern UIColor * UIColorByteRGBA(NSUByte r, NSUByte g, NSUByte b, CGFloat a);

/// Convenience function for creating RGB colors using byte values with alpha 1.
extern UIColor * UIColorByteRGB(NSUByte r, NSUByte g, NSUByte b);


