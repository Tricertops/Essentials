//
//  CIFilter+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 6.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <CoreImage/CoreImage.h>


typedef CGFloat CIScalar;
typedef CGFloat CIDistance;
typedef CGFloat CIAngle;





@interface CIFilter (Essentials)



#pragma mark - Properties

/// Forwards to value for key "inputImage".
@property CIImage *inputImage;



#pragma mark - Combining

/// Sets input image of the argument to output image of the receiver.
- (void)connectToFilter:(CIFilter *)filter;

/// Connects input images with output images. Returns last filter of the input array.
+ (CIFilter *)chainFilters:(NSArray<CIFilter *> *)filters;



#pragma mark - Factory
/// Convenience constructors for many filters listed in Core Image Filter Reference.


#pragma mark Category: Geometry

/// Applies a crop to an image. (CICrop)
+ (instancetype)crop:(CGRect)extent;
/// Applies an affine transform to an image. (CIAffineTransform)
+ (instancetype)transform:(CGAffineTransform)transform;
/// Applies a scale to an image. (CIAffineTransform)
+ (instancetype)scale:(CGSize)scales;
/// Applies a rotation to an image. (CIAffineTransform)
+ (instancetype)rotate:(CIAngle)radians;
/// Applies a translation to an image. (CIAffineTransform)
+ (instancetype)move:(CGPoint)offset;
/// Rotates the source image. The image is scaled and cropped so it fits the extent of the input image. (CIStraightenFilter)
+ (instancetype)straighten:(CIAngle)radians;


#pragma mark Category: Blur

/// Spreads source pixels by an amount specified by a Gaussian distribution. (CIGaussianBlur)
+ (instancetype)blurWithRadius:(CIDistance)radius;
/// Blurs an image to simulate the effect of using a camera that moves a specified angle. (CIMotionBlur)
+ (instancetype)motionBlurWithRadius:(CIDistance)radius angle:(CIAngle)radians;
/// Simulates the effect of zooming the camera while capturing the image. (CIZoomBlur)
+ (instancetype)zoomBlurWithAmount:(CIDistance)amount center:(CIVector *)center;


#pragma mark Category: Color Adjustments

/// Modifies color values to keep them within a specified range. (CIColorClamp)
+ (instancetype)clampColorsFrom:(CIVector *)minRGBA to:(CIVector *)maxRGBA;
/// Modifies red component values to keep them within a specified range. (CIColorClamp)
+ (instancetype)clampRedFrom:(CIScalar)min to:(CIScalar)max;
/// Modifies green component values to keep them within a specified range. (CIColorClamp)
+ (instancetype)clampGreenFrom:(CIScalar)min to:(CIScalar)max;
/// Modifies blue component values to keep them within a specified range. (CIColorClamp)
+ (instancetype)clampBlueFrom:(CIScalar)min to:(CIScalar)max;
/// Modifies alpha component values to keep them within a specified range. (CIColorClamp)
+ (instancetype)clampAlphaFrom:(CIScalar)min to:(CIScalar)max;

/// Adjusts saturation, brightness, and contrast values. Parameter details below. (CIColorControls)
+ (instancetype)adjustSaturation:(CIScalar)s brightness:(CIScalar)b contrast:(CIScalar)c;
/// Adjusts saturation only. Pass 0.0 for grayscale, 1.0 for original or >1 for to increase saturation. (CIColorControls)
+ (instancetype)adjustSaturation:(CIScalar)saturation;
/// Adjusts brightness only. Parameter is added to add color components. (CIColorControls)
+ (instancetype)adjustBrightness:(CIScalar)brightness;
/// Adjusts contrast only. Pass 1.0 for original. (CIColorControls)
+ (instancetype)adjustContrast:(CIScalar)contrast;

/// Multiplies source color values and adds a bias factor to each color component.
+ (instancetype)transformRed:(CIVector *)rRGBA green:(CIVector *)gRGBA blue:(CIVector *)bRGBA alpha:(CIVector *)aRGBA bias:(CIVector *)biasRGBA;
/// Multiplies source color values and adds a bias factor to red color component.
+ (instancetype)transformRed:(CIVector *)RGBA bias:(CIScalar)bias;
/// Multiplies source color values and adds a bias factor to green color component.
+ (instancetype)transformGreen:(CIVector *)RGBA bias:(CIScalar)bias;
/// Multiplies source color values and adds a bias factor to blue color component.
+ (instancetype)transformBlue:(CIVector *)RGBA bias:(CIScalar)bias;
/// Multiplies source color values and adds a bias factor to alpha color component.
+ (instancetype)transformAlpha:(CIVector *)RGBA bias:(CIScalar)bias;

/// Adjusts the exposure setting for an image similar to the way you control exposure for a camera when you change the F-stop. (CIExposureAdjust)
+ (instancetype)adjustExposure:(CIScalar)EV;

/// Adjusts midtone brightness. (CIGammaAdjust)
+ (instancetype)adjustGamma:(CIScalar)power;

/// Changes the overall hue, or tint, of the source pixels. (CIHueAdjust)
+ (instancetype)adjustHue:(CIAngle)angle;

/// Adjusts the saturation of an image while keeping pleasing skin tones. (CIVibrance)
+ (instancetype)adjustVibrance:(CIScalar)amount;

/// Adjusts the reference white point for an image and maps all colors in the source using the new reference. (CIWhitePointAdjust)
+ (instancetype)adjustWhitePoint:(CIColor *)color;


#pragma mark Category: Color Effects

/// Inverts the colors in an image. (CIColorInvert)
+ (instancetype)invertColors;

/// Desaturates colors in the image (CIColorControls with “saturation” 0.0)
+ (instancetype)grayscaleColors;

/// Remaps colors so they fall within shades of a single color. (CIColorMonochrome)
+ (instancetype)monochromeColor:(CIColor *)color intensity:(CIScalar)intensity;

/// Remaps red, green, and blue color components to the number of brightness values you specify for each color component. (CIColorPosterize)
+ (instancetype)posterizeWithLevels:(CIScalar)levels;

/// Maps luminance to a color ramp of two colors. (CIFalseColor)
+ (instancetype)falseColor:(CIColor *)color0 toColor:(CIColor *)color1;

/// Maps the colors of an image to various shades of brown. (CISepiaTone)
+ (instancetype)sepiaWithIntensity:(CIScalar)intensity;

/// Reduces the brightness of an image at the periphery. (CIVignette)
+ (instancetype)vignetteWithRadius:(CIDistance)radius intensity:(CIScalar)intensity;


#pragma mark Category: Photo Effects
/// These 8 filters are used in iOS 7 Camera app and they apply a preconfigured set of effects.

/// Imitate vintage photography film with exaggerated color. (CIPhotoEffectChrome)
+ (instancetype)photoEffectChrome;

/// Imitate vintage photography film with diminished color. (CIPhotoEffectFade)
+ (instancetype)photoEffectFade;

/// Imitate vintage photography film with distorted colors. (CIPhotoEffectInstant)
+ (instancetype)photoEffectInstant;

/// Imitate black-and-white photography film with low contrast. (CIPhotoEffectMono)
+ (instancetype)photoEffectMono;

/// Imitate black-and-white photography film with exaggerated contrast. (CIPhotoEffectNoir)
+ (instancetype)photoEffectNoir;

/// Imitate vintage photography film with emphasized cool colors. (CIPhotoEffectProcess)
+ (instancetype)photoEffectProcess;

/// Imitate black-and-white photography film without significantly altering contrast. (CIPhotoEffectTonal)
+ (instancetype)photoEffectTonal;

/// Imitate vintage photography film with emphasized warm colors. (CIPhotoEffectTransfer)
+ (instancetype)photoEffectTransfer;





@end


