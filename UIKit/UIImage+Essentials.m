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



+ (CGFloat)rotationForOrientation:(UIImageOrientation)orientation {
    switch (orientation) {
        case UIImageOrientationUp:      return 0;
        case UIImageOrientationLeft:    return M_PI_2;  //  90
        case UIImageOrientationDown:    return M_PI;    // 180
        case UIImageOrientationRight:   return -M_PI_2; // -90
            
        case UIImageOrientationUpMirrored:      return 0;
        case UIImageOrientationLeftMirrored:    return -M_PI_2; // -90
        case UIImageOrientationDownMirrored:    return M_PI;    // 180
        case UIImageOrientationRightMirrored:   return M_PI_2;  //  90
    }
    return 0;
}


+ (CGPoint)relativeTranslationForOrientation:(UIImageOrientation)orientation {
    switch (orientation) {
        case UIImageOrientationUp:      return CGPointZero;
        case UIImageOrientationLeft:    return CGPointMake(0, 1);
        case UIImageOrientationDown:    return CGPointMake(1, 1);
        case UIImageOrientationRight:   return CGPointMake(1, 0);
            
        case UIImageOrientationUpMirrored:      return CGPointMake(1, 0);
        case UIImageOrientationLeftMirrored:    return CGPointZero;
        case UIImageOrientationDownMirrored:    return CGPointMake(0, 1);
        case UIImageOrientationRightMirrored:   return CGPointMake(1, 1);
    }
    return CGPointZero;
}


+ (BOOL)mirroringForOrientation:(UIImageOrientation)orientation {
    switch (orientation) {
        case UIImageOrientationUp:     
        case UIImageOrientationLeft:   
        case UIImageOrientationDown:   
        case UIImageOrientationRight:
            return NO;
        case UIImageOrientationUpMirrored:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationDownMirrored:
        case UIImageOrientationRightMirrored:
            return YES;
    }
}


+ (CGAffineTransform)transformForOrientation:(UIImageOrientation)orientation size:(CGSize)size scale:(CGFloat)scale {
    CGFloat rotation = [self rotationForOrientation:orientation];
    CGPoint relativeTranslation = [self relativeTranslationForOrientation:orientation];
    BOOL mirroring = [self mirroringForOrientation:orientation];
    if (scale == 0) {
        scale = [[UIScreen mainScreen] scale];
    }
    
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformScale(t, scale * (mirroring? -1 : 1), scale);
    t = CGAffineTransformRotate(t, rotation);
    t = CGAffineTransformTranslate(t, relativeTranslation.x * -size.width * scale,
                                      relativeTranslation.y * -size.height * scale);
    return t;
}


- (CGAffineTransform)transform {
    return [UIImage transformForOrientation:self.imageOrientation size:self.size scale:self.scale];
}


- (UIImage *)imageByCroppingRect:(CGRect)cropRect {
    CGRect transformedCropRect = CGRectApplyAffineTransform(cropRect, [self transform]);
    
    /// http://iosdevelopertips.com/graphics/how-to-crop-an-image-take-two.html
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, transformedCropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}





#pragma mark - Decoding 


- (UIImage *)imageByDecodingBitmap {
    return [self imageByDecodingBitmapWithDrawing:nil];
}


- (UIImage *)imageByDecodingBitmapWithDrawing:(void (^)(CGRect rect, BOOL *mask))drawBlock {
    if (self.images) return self; // Do not decode animated images
    
    CGRect rect = (CGRect){.origin = CGPointZero, .size = self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1]; // Draw the receiver.
    BOOL mask = NO;
    if (drawBlock) drawBlock(rect, &mask); // Perform custom drawing on the image.
    if (mask) {
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1]; // Apply masking of the receiver.
    }
    
    UIImage *decodedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	return decodedImage;
}





@end
