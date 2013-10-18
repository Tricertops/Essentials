//
//  UIImage+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIImage+Essentials.h"





@implementation UIImage (Essentials)





#pragma mark - Solid Color


+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, size.width, size.height);
    layer.backgroundColor = [color CGColor];
    
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}





#pragma mark - Crop


- (UIImage *)imageByCroppingRect:(CGRect)cropRect {
    /// http://iosdevelopertips.com/graphics/how-to-crop-an-image-take-two.html
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}





#pragma mark - Decoding 


- (UIImage *)imageByDecodingBitmap {
    return [self imageByDecodingBitmapWithDrawing:nil];
}


- (UIImage *)imageByDecodingBitmapWithDrawing:(void (^)(CGRect rect))drawBlock {
    if (self.images) return self; // Do not decode animated images
    
    CGRect rect = (CGRect){.origin = CGPointZero, .size = self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1]; // Draw the receiver.
    if (drawBlock) drawBlock(rect); // Perform custom drawing on the image.
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1]; // Apply masking of the receiver.
    
    UIImage *decodedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	return decodedImage;
}





@end
