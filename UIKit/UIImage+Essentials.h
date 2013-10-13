//
//  UIImage+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>





@interface UIImage (Essentials)



#pragma mark - Solid Color

/// Renders image of given size whose pixels are all of given color.
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// Renders image of size 1x1 (pixel) of given color.
+ (UIImage *)imageWithColor:(UIColor *)color;



#pragma mark - Crop

/// Returns new instance that represents cropped portion of the receiver.
- (UIImage *)imageByCroppingRect:(CGRect)cropRect;



#pragma mark - Decoding

/// Returns a decoded image
- (UIImage *)imageByDecodingBitmap;


@end
