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
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
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





@end
