//
//  UIImage+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

@import Accelerate;
#import "UIImage+Essentials.h"
#import "Foundation+Essentials.h"
#import "UIKit+Essentials.h"
#import "UIColor+Essentials.h"





@implementation UIImage (Essentials)





+ (instancetype)imageFromURL:(NSURL *)URL {
    ESSAssert(URL.isFileURL) else return nil;
    
    return [UIImage imageWithContentsOfFile:URL.path];
}





#pragma mark - NSCopying


- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}





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





#pragma mark - Coordinates


- (CGRect)pointExtent {
    return CGRectMakeSize(self.pointSize);
}


- (CGRect)pixelExtent {
    return CGRectMakeSize(self.pixelSize);
}


- (CGSize)pointSize {
    return self.size;
}


- (CGSize)pixelSize {
    return CGSizeMultiply(self.pointSize, self.scale);
}





#pragma mark - Crop & Resize



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


- (UIImage *)resizedImageToSize:(CGSize)size {
    CGRect rect = CGRectFitIntoRect(CGRectMakeSize(self.size), CGRectMakeSize(size));
    return [UIImage drawWithSize:rect.size opaque:NO scale:self.scale block:^{
        [self drawInRect:rect];
    }];
}





#pragma  mark - Drawing


+ (instancetype)drawWithSize:(CGSize)size block:(void(^)(void))block {
    return [self drawWithSize:size opaque:NO scale:0 block:block];
}


+ (instancetype)drawWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale block:(void(^)(void))block {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    block();
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}





#pragma mark - Processing Bitmap


- (NSUInteger)numberOfPixels {
    NSUInteger width = self.size.width * self.scale;
    NSUInteger height = self.size.height * self.scale;
    return (width * height);
}


- (UIImage *)imageByProcessingBitmap:(void(^)(NSMutableData *bitmap))block {
    NSUInteger width = self.size.width * self.scale;
    NSUInteger height = self.size.height * self.scale;
    
    NSMutableData *bitmap = [NSMutableData dataWithLength:width * height * 4];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(bitmap.mutableBytes, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    block(bitmap);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *processedImage = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:UIImageOrientationUp];
    
    CGImageRelease(cgImage);
    CGContextRelease(context);
    
    return [processedImage imageWithRenderingMode:self.renderingMode];
}


- (UIImage *)imageByProcessingSamples:(void(^)(NSUInteger count, float *samples, float *quarter))block {
    return [self imageByProcessingBitmap:^(NSMutableData *bitmap) {
        NSUInteger valueCount = bitmap.length;
        NSUInteger sampleCount = valueCount/4;
        
        static const float zero = 0;
        static const float one = 1;
        static const float byte = UINT8_MAX;
        
        float *samples = malloc(sizeof(float) * valueCount);
        float *quarter = malloc(sizeof(float) * sampleCount);
        
        vDSP_vfltu8((unsigned char *)bitmap.bytes, 1, samples, 1, valueCount); // Convert to float
        vDSP_vsdiv(samples, 1, &byte, samples, 1, valueCount); // Map to [0 1]
        
        block(sampleCount, samples, quarter);
        
        vDSP_vclip(samples, 1, &zero, &one, samples, 1, valueCount); // Clip to [0 1]
        vDSP_vsmul(samples, 1, &byte, samples, 1, valueCount); // Map to [0 255]
        vDSP_vfixu8(samples, 1, (unsigned char *)bitmap.mutableBytes, 1, valueCount); // Convert to uint8_t
        free(quarter);
        free(samples);
    }];
}


- (UIImage *)imageByEnumeratingPixels:(GLKVector4(^)(GLKVector4 color))block {
    static float const multiplier = 255;
    
    return [self imageByProcessingBitmap:^(NSMutableData *bitmap) {
        NSUByte *bytes = bitmap.mutableBytes;
        NSUInteger count = bitmap.length;
        
        for (NSUInteger index = 0; index < count; index += 4) {
            GLKVector4 color = GLKVector4Make(bytes[index +0] / multiplier,
                                              bytes[index +1] / multiplier,
                                              bytes[index +2] / multiplier,
                                              bytes[index +3] / multiplier);
            color = block(color);
            bytes[index +0] = color.r * multiplier;
            bytes[index +1] = color.g * multiplier;
            bytes[index +2] = color.b * multiplier;
            bytes[index +3] = color.a * multiplier;
        }
    }];
}


- (UIImage *)invertedImage {
    return [self imageByEnumeratingPixels:^GLKVector4(GLKVector4 color) {
        return GLKVector4Make(1 - color.r,
                              1 - color.g,
                              1 - color.b,
                              color.a);
    }];
}


- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogram {
    return [self createColorHistogramWithThreshold:0.025];
}


- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogramWithThreshold:(CGFloat)minimum {
    NSUInteger numberOfPixels = self.numberOfPixels;
    if (numberOfPixels > UINT32_MAX) return nil;
    NSMutableDictionary<UIColor *, NSNumber *> *dictionary = [NSMutableDictionary new];
    
    [self imageByProcessingBitmap:^(NSMutableData *bitmap) {
        uint32_t colors = 1 << 16; // 65536 distinct colors
        uint32_t *histogram = calloc(colors, sizeof(uint32_t)); // 4 bytes to store count
        
        uint64_t count = bitmap.length;
        const uint8_t *bytes = bitmap.bytes;
        for (uint64_t index = 0; index < count; index += 4) {
            //  RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA
            uint8_t r = bytes[index +0];
            uint8_t g = bytes[index +1];
            uint8_t b = bytes[index +2];
            uint8_t a = bytes[index +3];
            //TODO: Handle premultiplied values :(
            uint16_t color = 0;
            color |= (r >> 4) << 0;
            color |= (g >> 4) << 4;
            color |= (b >> 4) << 8;
            color |= (a >> 4) << 12;
            //  RRRRGGGGBBBBAAAA
            histogram[color] ++;
        }
        
        for (uint32_t index = 0; index < colors; index++) {
            uint16_t color = index;
            CGFloat share = histogram[color] * 1.0 / numberOfPixels;
            if (share <= minimum) continue;
            
            //  RRRRGGGGBBBBAAAA
            uint8_t r = (color & 0x000F) >> 0;
            uint8_t g = (color & 0x00F0) >> 4;
            uint8_t b = (color & 0x0F00) >> 8;
            uint8_t a = (color & 0xF000) >> 12;
            //  0000RRRR
            //  0000GGGG
            //  0000BBBB
            //  0000AAAA
            
            UIColor *ui = [UIColor colorWithRed:(r * 1.0 / 0xF)
                                          green:(g * 1.0 / 0xF)
                                           blue:(b * 1.0 / 0xF)
                                          alpha:(a * 1.0 / 0xF)];
            [dictionary setObject:@(share) forKey:ui];
        }
        free(histogram);
    }];
    return dictionary;
}


- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogramGroupedByNaturalNames {
    return [self createColorHistogramGroupedByNaturalNamesWithThreshold:0.01];
}


- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogramGroupedByNaturalNamesWithThreshold:(CGFloat)minimum {
    NSDictionary<UIColor *, NSNumber *> *colorsToShare = [self createColorHistogramWithThreshold:0]; // all
    NSMutableDictionary<NSString *, NSNumber *> *namesToShare = [NSMutableDictionary new];
    NSMutableDictionary<UIColor *, NSString *> *colorsToName = [NSMutableDictionary new];
    [colorsToShare enumerateKeysAndObjectsUsingBlock:^(UIColor *color, NSNumber *colorShare, BOOL *stop) {
        //! Build  color->name  mapping
        NSString *name = [color naturalName];
        colorsToName[color] = name;
        //! Sum shares for color named the same into  name->share  mapping
        CGFloat nameShare = [namesToShare[name] doubleValue];
        namesToShare[name] = @(nameShare + [colorShare doubleValue]);
    }];
    //! Exclude color names with too little share
    NSSet<NSString *> *significantNames = [namesToShare keysOfEntriesPassingTest:^BOOL(NSString *name, NSNumber *nameShare, BOOL *stop) {
        return [nameShare doubleValue] > minimum;
    }];
    NSMutableDictionary<UIColor *, NSNumber *> *significantColorsToShare = [NSMutableDictionary new];
    for (NSString *name in significantNames) {
        //! For every significant color name, find the color with the largest share
        NSArray<UIColor *> *namedColors = [[colorsToName allKeysForObject:name] sortedArrayUsingComparator:
                                           ^NSComparisonResult(UIColor *colorA, UIColor *colorB) {
                                               return [colorsToShare[colorA] compare:colorsToShare[colorB]];
                                           }];
        UIColor *significantColor = namedColors.lastObject;
        //! Build final  color->share  mapping, where colors are coalesced by their names
        significantColorsToShare[significantColor] = namesToShare[name];
    }
    return significantColorsToShare;
}






#pragma mark - Decoding 


- (UIImage *)imageByDecodingBitmap {
    return [self imageByDecodingBitmapWithDrawing:nil];
}


- (UIImage *)imageByDecodingBitmapWithDrawing:(void (^)(CGRect rect, BOOL *mask))drawBlock {
    return [self imageByDecodingBitmapWithSize:self.size drawing:drawBlock];
}


- (UIImage *)imageByDecodingBitmapWithSize:(CGSize)size drawing:(void (^)(CGRect rect, BOOL *mask))drawBlock {
    if (self.images) return self; // Do not decode animated images
    
    CGRect rect = (CGRect){.origin = CGPointZero, .size = size};
    
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
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


- (UIImage *)imageByTintingToColor:(UIColor *)tintColor {
    return [[self imageByDecodingBitmapWithDrawing:^(CGRect rect, BOOL *mask) {
        [tintColor setFill];
        CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
        *mask = YES;
    }] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; // Why would you tint, if you wanted template image, huh?
}





#pragma mark - Rendering Modes


- (UIImage *)templateImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}


- (UIImage *)originalImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}





#pragma mark – Adjustments


- (UIImage *)imageWrappedInCircleWithSize:(CGSize)circleSize lineWidth:(CGFloat)lineWidth circleColor:(UIColor *)circleColor {
    UIImageRenderingMode originalRenderingMode = self.renderingMode;
    CGFloat circleWidth = circleSize.width;
    CGFloat circleHeight = circleSize.height;
    
    UIGraphicsBeginImageContextWithOptions(circleSize, NO, [[UIScreen mainScreen] scale]);
    
    [self drawInRect:CGRectMake(ceil(circleWidth/2-self.size.width/2), ceil(circleHeight/2-self.size.height/2), self.size.width, self.size.height)];
    [circleColor setStroke];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleWidth, circleHeight)];
    [path addClip]; //Stroke the inside
    path.lineWidth = lineWidth*2;
    [path stroke];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [resultImage imageWithRenderingMode:originalRenderingMode];
}





#pragma mark - Data Encoding

- (NSData *)PNGData {
    return UIImagePNGRepresentation(self);
}


- (NSData *)JPEGData {
    return [self JPEGDataWithQuality:0.9];
}


- (NSData *)JPEGDataWithQuality:(CGFloat)quality {
    return UIImageJPEGRepresentation(self, quality);
}





@end




