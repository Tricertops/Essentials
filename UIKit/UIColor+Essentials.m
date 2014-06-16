//
//  UIColor+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIColor+Essentials.h"





@implementation UIColor (Essentials)





#pragma mark - Random


+ (UIColor *)randomColor {
    // https://gist.github.com/kylefox/1689973
    CGFloat hue = ( arc4random_uniform(256) / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [self colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


- (UIColor *)randomize {
    return [self randomizeWithSteps:12 whiteInset:0.2 blackInset:0.2];
}


- (UIColor *)randomizeWithSteps:(NSUInteger)steps whiteInset:(CGFloat)whiteInset blackInset:(CGFloat)blackInset {
    // get RGB
    CGFloat red = -1;
    CGFloat green = -1;
    CGFloat blue = -1;
    CGFloat alpha = -1;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red < 0 && green < 0 && blue < 0) {
        // in case of grayscale color
        CGFloat white = -1;
        [self getWhite:&white alpha:&alpha];
        red = blue = green = (white);
    }
    
    NSUInteger randomStep = arc4random() % steps;
    CGFloat stepSize = (1 - whiteInset - blackInset) / steps;
    CGFloat random = blackInset + stepSize * randomStep;
    
    UIColor *randomizedColor = nil;
    if (random <= 0.5) {
        randomizedColor = [UIColor colorWithRed:(red*random*2)
                                          green:(green*random*2)
                                           blue:(blue*random*2)
                                          alpha:alpha];
    }
    else {
        CGFloat redInverted = 1-red;
        CGFloat greenInverted = 1-green;
        CGFloat blueInverted = 1-blue;
        randomizedColor = [UIColor colorWithRed:red+(redInverted*(random-0.5)*2)
                                          green:green+(greenInverted*(random-0.5)*2)
                                           blue:blue+(blueInverted*(random-0.5)*2)
                                          alpha:alpha];
    }
    return randomizedColor;
}





#pragma mark - Components



- (CGFloat)redComponent {
    CGFloat red;
    
    BOOL hasRGBColorSpace = [self getRed:&red green:NULL blue:NULL alpha:NULL];
    if (hasRGBColorSpace) return red;
    
    BOOL hasGrayscaleColorSpace = [self getWhite:&red alpha:NULL];
    if (hasGrayscaleColorSpace) return red;
    
    return 0;
}


- (CGFloat)greenComponent {
    CGFloat green;
    
    BOOL hasRGBColorSpace = [self getRed:NULL green:&green blue:NULL alpha:NULL];
    if (hasRGBColorSpace) return green;
    
    BOOL hasGrayscaleColorSpace = [self getWhite:&green alpha:NULL];
    if (hasGrayscaleColorSpace) return green;
    
    return 0;
}


- (CGFloat)blueComponent {
    CGFloat blue;
    
    BOOL hasRGBColorSpace = [self getRed:NULL green:NULL blue:&blue alpha:NULL];
    if (hasRGBColorSpace) return blue;
    
    BOOL hasGrayscaleColorSpace = [self getWhite:&blue alpha:NULL];
    if (hasGrayscaleColorSpace) return blue;
    
    return 0;
}


- (CGFloat)alphaComponent {
    return CGColorGetAlpha(self.CGColor);
}


- (UIColor *)invertedColor {
    CGFloat red, green, blue, alpha;
    BOOL hasRGBColorSpace = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    if (hasRGBColorSpace) return [UIColor colorWithRed:1 - red
                                                 green:1 - green
                                                  blue:1 - blue
                                                 alpha:alpha];
    CGFloat white;
    BOOL hasGrayscaleColorSpace = [self getWhite:&white alpha:&alpha];
    if (hasGrayscaleColorSpace) return [UIColor colorWithWhite:1- white
                                                         alpha:alpha];
    return nil;
}





#pragma mark - Combining


+ (UIColor *)averageColor:(NSArray *)colors {
    if ( ! colors.count) return nil;
    if (colors.count == 1) return colors.firstObject;
    
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    for (UIColor *color in colors) {
        red += [color redComponent];
        green += [color greenComponent];
        blue += [color blueComponent];
        alpha += [color alphaComponent];
    }
    
    return [UIColor colorWithRed:red / colors.count
                           green:green / colors.count
                            blue:blue / colors.count
                           alpha:alpha / colors.count];
}


- (UIColor *)blendedColorOn:(UIColor *)other {
    return [self blendedColorOn:other alpha:1];
}


- (UIColor *)blendedColorOn:(UIColor *)other alpha:(CGFloat)additionalAlpha {
    //TODO: Does this really work in all cases?!
    CGFloat alpha = additionalAlpha * self.alphaComponent;
    
    if (alpha >= 1) return self;
    if (alpha <= 0) return other;
        
    return [UIColor colorWithRed:self.redComponent * alpha + other.redComponent * (1 - alpha)
                           green:self.greenComponent * alpha + other.greenComponent * (1 - alpha)
                            blue:self.blueComponent * alpha + other.blueComponent * (1 - alpha)
                           alpha:1 - (1 - alpha) * (1 - other.alphaComponent)];
}





#pragma mark Brightness


- (CGFloat)luminance {
    CGFloat luminance = 0;
    [self getWhite:&luminance alpha:NULL];
    return luminance;
}


- (UIColor *)colorWithLuminance:(CGFloat)newLuminance {
    if (newLuminance <= 0) return [UIColor blackColor];
    if (newLuminance >= 1) return [UIColor whiteColor];
    
    CGFloat oldLuminance = self.luminance;
    if (oldLuminance == newLuminance) return self;
    
    CGFloat red, green, blue;
    BOOL hasRGBColorSpace = [self getRed:&red green:&green blue:&blue alpha:NULL];
    if ( ! hasRGBColorSpace) return self;
    
    
    CGFloat delta = (newLuminance - oldLuminance);
    return [UIColor colorWithRed:CLAMP(0, red + delta, 1)
                           green:CLAMP(0, green + delta, 1)
                            blue:CLAMP(0, blue + delta, 1)
                           alpha:1];
}





@end





UIColor * UIColorByteRGBA(NSUByte r, NSUByte g, NSUByte b, CGFloat a) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}



UIColor * UIColorByteRGB(NSUByte r, NSUByte g, NSUByte b) {
    return UIColorByteRGBA(r, g, b, 1);
}

