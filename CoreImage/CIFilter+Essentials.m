//
//  CIFilter+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 6.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "CIFilter+Essentials.h"





@implementation CIFilter (Essentials)





#pragma mark - Properties


- (CIImage *)inputImage {
    return [self valueForKey:kCIInputImageKey];
}


- (void)setInputImage:(CIImage *)inputImage {
    return [self setValue:inputImage forKey:kCIInputImageKey];
}





#pragma mark - Combining


- (void)connectToFilter:(CIFilter *)filter {
    filter.inputImage = self.outputImage;
}


+ (CIFilter *)chainFilters:(NSArray<CIFilter *> *)filters {
    CIFilter *previousFilter = nil;
    CIFilter *currentFilter = nil;
    
    for (currentFilter in filters) {
        if (previousFilter) {
            [previousFilter connectToFilter:currentFilter];
            currentFilter = [currentFilter filterByCroppingInfiniteExtent];
        }
        previousFilter = currentFilter;
    }
    
    return previousFilter;
}


/// In case the filter produces image with infinite extent, crop the output to input.
- (CIFilter *)filterByCroppingInfiniteExtent {
    if ( ! self.inputImage) {
         return self;
    }
    if (CGRectIsInfinite(self.inputImage.extent)) {
        return self; /// Input is already infinite.
    }
    if ( ! CGRectIsInfinite(self.outputImage.extent)) {
        return self;
    }
    /// Input is not infinite, but output is infinite.
    CIFilter *crop = [CIFilter crop:self.inputImage.extent];
    [self connectToFilter:crop];
    return crop;
}





#pragma mark - Factory


#pragma mark Category: Geometry


+ (instancetype)crop:(CGRect)extent {
    return [CIFilter filterWithName:@"CICrop"
                      keysAndValues:
            @"inputRectangle",
            [CIVector vectorWithX:extent.origin.x
                                Y:extent.origin.y
                                Z:extent.size.width
                                W:extent.size.height],
            nil];
}


+ (instancetype)transform:(CGAffineTransform)transform {
    return [CIFilter filterWithName:@"CIAffineTransform"
                      keysAndValues:
            kCIInputTransformKey, [NSValue valueWithBytes:&transform objCType:@encode(typeof(transform))],
            nil];
}


+ (instancetype)scale:(CGSize)scales {
    return [self transform:CGAffineTransformMakeScale(scales.width, scales.height)];
}


+ (instancetype)rotate:(CIAngle)radians {
    return [self transform:CGAffineTransformMakeRotation(radians)];
}


+ (instancetype)move:(CGPoint)offset {
    return [self transform:CGAffineTransformMakeTranslation(offset.x, offset.y)];
}


+ (instancetype)straighten:(CIAngle)radians {
    return [CIFilter filterWithName:@"CIStraightenFilter"
                      keysAndValues:
            kCIInputAngleKey, @(radians),
            nil];
}


#pragma mark Category: Blur


+ (instancetype)blurWithRadius:(CIDistance)radius {
    return [CIFilter filterWithName:@"CIGaussianBlur"
                      keysAndValues:
            kCIInputRadiusKey, @(radius),
            nil];
}


+ (instancetype)motionBlurWithRadius:(CIDistance)radius angle:(CIAngle)radians {
    return [CIFilter filterWithName:@"CIMotionBlur"
                      keysAndValues:
            kCIInputRadiusKey, @(radius),
            kCIInputAngleKey, @(radians),
            nil];
}


+ (instancetype)zoomBlurWithAmount:(CIDistance)amount center:(CIVector *)center {
    return [CIFilter filterWithName:@"CIZoomBlur"
                      keysAndValues:
            @"inputAmount", @(amount),
            kCIInputCenterKey, center ?: [CIVector vectorWithX:0 Y:0],
            nil];
}


#pragma mark Category: Color Adjustments


+ (instancetype)clampColorsFrom:(CIVector *)minRGBA to:(CIVector *)maxRGBA {
    return [CIFilter filterWithName:@"CIColorClamp"
                      keysAndValues:
            @"inputMinComponents", minRGBA,
            @"inputMaxComponents", maxRGBA,
            nil];
}

+ (instancetype)clampRedFrom:(CIScalar)min to:(CIScalar)max {
    return [self clampColorsFrom:[CIVector vectorWithX:min Y:0 Z:0 W:0]
                              to:[CIVector vectorWithX:max Y:1 Z:1 W:1]];
}

+ (instancetype)clampGreenFrom:(CIScalar)min to:(CIScalar)max {
    return [self clampColorsFrom:[CIVector vectorWithX:0 Y:min Z:0 W:0]
                              to:[CIVector vectorWithX:1 Y:max Z:1 W:1]];
}

+ (instancetype)clampBlueFrom:(CIScalar)min to:(CIScalar)max {
    return [self clampColorsFrom:[CIVector vectorWithX:0 Y:0 Z:min W:0]
                              to:[CIVector vectorWithX:1 Y:1 Z:max W:1]];
}

+ (instancetype)clampAlphaFrom:(CIScalar)min to:(CIScalar)max {
    return [self clampColorsFrom:[CIVector vectorWithX:0 Y:0 Z:0 W:min]
                              to:[CIVector vectorWithX:1 Y:1 Z:1 W:max]];
}


+ (instancetype)adjustSaturation:(CIScalar)s brightness:(CIScalar)b contrast:(CIScalar)c {
    return [CIFilter filterWithName:@"CIColorControls"
                      keysAndValues:
            kCIInputSaturationKey, @(s),
            kCIInputBrightnessKey, @(b),
            kCIInputContrastKey, @(c),
            nil];
}


+ (instancetype)adjustSaturation:(CIScalar)saturation {
    return [CIFilter filterWithName:@"CIColorControls"
                      keysAndValues:
            kCIInputSaturationKey, @(saturation),
            nil];
}


+ (instancetype)adjustBrightness:(CIScalar)brightness {
    return [CIFilter filterWithName:@"CIColorControls"
                      keysAndValues:
            kCIInputBrightnessKey, @(brightness),
            nil];
}


+ (instancetype)adjustContrast:(CIScalar)contrast {
    return [CIFilter filterWithName:@"CIColorControls"
                      keysAndValues:
            kCIInputContrastKey, @(contrast),
            nil];
}


+ (instancetype)transformRed:(CIVector *)rRGBA green:(CIVector *)gRGBA blue:(CIVector *)bRGBA alpha:(CIVector *)aRGBA bias:(CIVector *)biasRGBA {
    return [CIFilter filterWithName:@"CIColorMatrix"
                      keysAndValues:
            @"inputRVector", rRGBA ?: [CIVector vectorWithX:1 Y:0 Z:0 W:0],
            @"inputGVector", gRGBA ?: [CIVector vectorWithX:0 Y:1 Z:0 W:0],
            @"inputBVector", bRGBA ?: [CIVector vectorWithX:0 Y:0 Z:1 W:0],
            @"inputAVector", aRGBA ?: [CIVector vectorWithX:0 Y:0 Z:0 W:1],
            @"inputBiasVector", biasRGBA ?: [CIVector vectorWithX:0 Y:0 Z:0 W:0],
            nil];
}

+ (instancetype)transformRed:(CIVector *)RGBA bias:(CIScalar)bias {
    return [self transformRed:RGBA green:nil blue:nil alpha:nil bias:[CIVector vectorWithX:bias Y:0 Z:0 W:0]];
}

+ (instancetype)transformGreen:(CIVector *)RGBA bias:(CIScalar)bias {
    return [self transformRed:nil green:RGBA blue:nil alpha:nil bias:[CIVector vectorWithX:0 Y:bias Z:0 W:0]];
}

+ (instancetype)transformBlue:(CIVector *)RGBA bias:(CIScalar)bias {
    return [self transformRed:nil green:nil blue:RGBA alpha:nil bias:[CIVector vectorWithX:0 Y:0 Z:bias W:0]];
}

+ (instancetype)transformAlpha:(CIVector *)RGBA bias:(CIScalar)bias {
    return [self transformRed:nil green:nil blue:nil alpha:RGBA bias:[CIVector vectorWithX:0 Y:0 Z:0 W:bias]];
}


+ (instancetype)adjustExposure:(CIScalar)EV {
    return [CIFilter filterWithName:@"CIExposureAdjust"
                      keysAndValues:
            kCIInputEVKey, @(EV),
            nil];
}


+ (instancetype)adjustGamma:(CIScalar)power {
    return [CIFilter filterWithName:@"CIGammaAdjust"
                      keysAndValues:
            @"inputPower", @(power),
            nil];
}


+ (instancetype)adjustHue:(CIAngle)angle {
    return [CIFilter filterWithName:@"CIHueAdjust"
                      keysAndValues:
            kCIInputAngleKey, @(angle),
            nil];
}


+ (instancetype)adjustVibrance:(CIScalar)amount {
    return [CIFilter filterWithName:@"CIVibrance"
                      keysAndValues:
            @"inputAmount", @(amount),
            nil];
}


+ (instancetype)adjustWhitePoint:(CIColor *)color {
    return [CIFilter filterWithName:@"CIWhitePointAdjust"
                      keysAndValues:
            kCIInputColorKey, color,
            nil];
}


#pragma mark Category: Color Effects


+ (instancetype)invertColors {
    return [CIFilter filterWithName:@"CIColorInvert"];
}


+ (instancetype)grayscaleColors {
    return [CIFilter adjustSaturation: 0];
}


+ (instancetype)monochromeColor:(CIColor *)color intensity:(CIScalar)intensity {
    return [CIFilter filterWithName:@"CIColorMonochrome"
                      keysAndValues:
            kCIInputColorKey, color,
            kCIInputIntensityKey, @(intensity),
            nil];
}


+ (instancetype)posterizeWithLevels:(CIScalar)levels {
    return [CIFilter filterWithName:@"CIColorPosterize"
                      keysAndValues:
            @"inputLevels", @(levels),
            nil];
}


+ (instancetype)falseColor:(CIColor *)color0 toColor:(CIColor *)color1 {
    return [CIFilter filterWithName:@"CIFalseColor"
                      keysAndValues:
            @"inputColor0", color0,
            @"inputColor1", color1,
            nil];
}


+ (instancetype)maskToAlpha {
    return [CIFilter filterWithName:@"CIMaskToAlpha"];
}


+ (instancetype)sepiaWithIntensity:(CIScalar)intensity {
    return [CIFilter filterWithName:@"CISepiaTone"
                      keysAndValues:
            kCIInputIntensityKey, @(intensity),
            nil];
}


+ (instancetype)vignetteWithRadius:(CIDistance)radius intensity:(CIScalar)intensity {
    return [CIFilter filterWithName:@"CIVignette"
                      keysAndValues:
            kCIInputRadiusKey, @(radius),
            kCIInputIntensityKey, @(intensity),
            nil];
}


#pragma mark Category: Photo Effects


+ (instancetype)photoEffectChrome {
    return [CIFilter filterWithName:@"CIPhotoEffectChrome"];
}


+ (instancetype)photoEffectFade {
    return [CIFilter filterWithName:@"CIPhotoEffectFade"];
}


+ (instancetype)photoEffectInstant {
    return [CIFilter filterWithName:@"CIPhotoEffectInstant"];
}


+ (instancetype)photoEffectMono {
    return [CIFilter filterWithName:@"CIPhotoEffectMono"];
}


+ (instancetype)photoEffectNoir {
    return [CIFilter filterWithName:@"CIPhotoEffectNoir"];
}


+ (instancetype)photoEffectProcess {
    return [CIFilter filterWithName:@"CIPhotoEffectProcess"];
}


+ (instancetype)photoEffectTonal {
    return [CIFilter filterWithName:@"CIPhotoEffectTonal"];
}


+ (instancetype)photoEffectTransfer {
    return [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
}





@end


