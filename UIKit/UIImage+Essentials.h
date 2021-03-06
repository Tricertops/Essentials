//
//  UIImage+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"
@import simd;





@interface UIImage (Essentials) <NSCopying>



/// Initializes new instance from contents of given file URL.
+ (instancetype)imageFromURL:(NSURL *)fileURL;



#pragma mark - NSCopying

/// Returns self.
- (instancetype)copyWithZone:(NSZone *)zone;



#pragma mark - Solid Color

/// Renders image of given size whose pixels are all of given color.
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// Renders image of size 1x1 (pixel) of given color.
+ (UIImage *)imageWithColor:(UIColor *)color;



#pragma mark - System Images

+ (instancetype)system:(NSString *)systemName API_AVAILABLE(ios(13));
+ (instancetype)smallSystem:(NSString *)systemName API_AVAILABLE(ios(13));
+ (instancetype)mediumSystem:(NSString *)systemName API_AVAILABLE(ios(13));
+ (instancetype)largeSystem:(NSString *)systemName API_AVAILABLE(ios(13));
+ (instancetype)system:(NSString *)systemName font:(UIFont *)font API_AVAILABLE(ios(13));
+ (instancetype)smallSystem:(NSString *)systemName font:(UIFont *)font API_AVAILABLE(ios(13));
+ (instancetype)mediumSystem:(NSString *)systemName font:(UIFont *)font API_AVAILABLE(ios(13));
+ (instancetype)largeSystem:(NSString *)systemName font:(UIFont *)font API_AVAILABLE(ios(13));

    

#pragma mark - Coordinates

/// A rectangle with zero origin that specifies the extent of the image in points.
@property (readonly) CGRect pointExtent;

/// A rectangle with zero origin that specifies the extent of the image in pixels.
@property (readonly) CGRect pixelExtent;

/// A size of the image in points.
@property (readonly) CGSize pointSize;

/// A size of the image in pixels.
@property (readonly) CGSize pixelSize;

/// Calculates affine transform that converts coordinates from receiver's logical to native space. Used for crop rectanges.
- (CGAffineTransform)transform;

/// Generalized version of the above method.
+ (CGAffineTransform)transformForOrientation:(UIImageOrientation)orientation size:(CGSize)size scale:(CGFloat)scale;



#pragma mark - Crop & Resize

/// Returns new instance that represents cropped portion of the receiver. Transforms the crop rect to match image orientation.
- (UIImage *)imageByCroppingRect:(CGRect)cropRect;

/// Returns new instance that doesn’t exceed given dimensions.
- (UIImage *)resizedImageToSize:(CGSize)size;



#pragma  mark - Drawing

/// Returns new image draw using instructions in provided block.
+ (instancetype)drawWithSize:(CGSize)size block:(void(^)(void))block;

/// Returns new image draw using instructions in provided block with given opaqueness and scale.
+ (instancetype)drawWithSize:(CGSize)size opaque:(BOOL)opaque scale:(CGFloat)scale block:(void(^)(void))block;



#pragma mark - Bitmap Processing

/// Returns number of pixels in the receiver.
- (NSUInteger)numberOfPixels;

/// Extracts bitmap from the receiver, passes it to the block and then returns new image from that bitmap.
- (UIImage *)imageByProcessingBitmap:(void(^)(NSMutableData *bitmap))block;

/// Extracts samples from the receiver, passes it to the block and then returns new image from that bitmap. Block gets number of samples, the sample values (4× the count, RGBA) and a temporary buffer that can be used for calculations.
- (UIImage *)imageByProcessingSamples:(void(^)(NSUInteger count, float *samples, float *quarter))block;

/// Returns new image created by processing receiver's samples using given block.
- (UIImage *)imageByEnumeratingPixels:(simd_float4(^)(simd_float4 color))block;

/// Returns image with inverted red, green and blue and preserved alpha.
- (UIImage *)invertedImage;

/// Returns colors that are contained in the image mapped to their share. Only colors with share more than 2.5%
- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogram;

/// Returns colors that are contained in the image mapped to their share. Only colors with more than the minimum threshold.
- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogramWithThreshold:(CGFloat)minimum;

/// Returns colors that are contained in the image mapped to their share. Colors are grouped by their -naturalName and only with more than 1%
- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogramGroupedByNaturalNames;

/// Returns colors that are contained in the image mapped to their share. Colors are grouped by their -naturalName and only with more than minimum threshold.
- (NSDictionary<UIColor *, NSNumber *> *)createColorHistogramGroupedByNaturalNamesWithThreshold:(CGFloat)minimum;



#pragma mark - Decoding

/// Returns a decoded image.
- (UIImage *)imageByDecodingBitmap;

/// Returns a decoded image with applied drawings in the block. You can optionally set out parameter to YES, if you want your drawing to be masked by the image, so they will not get out of its real shape.
- (UIImage *)imageByDecodingBitmapWithDrawing:(void (^)(CGRect rect, BOOL *mask))drawBlock;

/// Returns a decoded image of given size with applied drawings in the block. You can optionally set out parameter to YES, if you want your drawing to be masked by the image, so they will not get out of its real shape.
- (UIImage *)imageByDecodingBitmapWithSize:(CGSize)size drawing:(void (^)(CGRect rect, BOOL *mask))drawBlock;

/// Returns new image that is tinted just like iOS 7 is doing. It takes the tint color and masks it with the receiver's alpha channel.
- (UIImage *)imageByTintingToColor:(UIColor *)tintColor;



#pragma mark - Rendering Modes

/// Shortcut for -imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate
- (UIImage *)templateImage;

/// Shortcut for -imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal
- (UIImage *)originalImage;



#pragma mark - Adjustment

/// Returns a image that has a circle drawn around it, with appropriate size
- (UIImage *)imageWrappedInCircleWithSize:(CGSize)circleSize lineWidth:(CGFloat)lineWidth circleColor:(UIColor *)circleColor;



#pragma mark - Data Encoding

/// Encodes receiver into PNG format.
@property (readonly) NSData *PNGData;

/// Encodes receiver into JPEG format with quality 0.9.
@property (readonly) NSData *JPEGData;

/// Encodes receiver into JPEG format with arbitrary quality in range 0…1.
- (NSData *)JPEGDataWithQuality:(CGFloat)quality;


@end
