//
//  UIColor+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIColor (Essentials)



#pragma mark - Random

/// Returns completely random color, but not too black or too white.
+ (UIColor *)randomColor;

/// Returns random tint of the receiver, but not too dark or too light.
- (UIColor *)randomize;

/// Returns random tint of the receiver. Requires numbers of discrete steps and white and black safe zones.
- (UIColor *)randomizeWithSteps:(NSUInteger)steps whiteInset:(CGFloat)white blackInset:(CGFloat)black;



@end
