//
//  CIContext+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 6.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "CIContext+Essentials.h"
#import "CIFilter+Essentials.h"
#import "NSArray+Essentials.h"





@implementation CIContext (Essentials)





#pragma mark - Creating


+ (instancetype)context {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    CIContext *context = [CIContext contextWithOptions:
                          @{
                            kCIContextWorkingColorSpace: (__bridge id)colorSpace,
                            kCIContextOutputColorSpace: (__bridge id)colorSpace,
                            }];
    CGColorSpaceRelease(colorSpace);
    return context;
}





#pragma mark - Processing Images


+ (UIImage *)imageFromImage:(UIImage *)inputUI filters:(NSArray<CIFilter *> *)filters {
    return [[CIContext context] imageFromImage:inputUI filters:filters];
}


- (UIImage *)imageFromImage:(UIImage *)inputUI filters:(NSArray<CIFilter *> *)filters {
    if ( ! inputUI) return nil;
    if ( ! filters.count) return inputUI;
    
    CIImage *inputCI = [CIImage imageWithCGImage:inputUI.CGImage];
    
    [filters.firstObject setValue:inputCI forKey:kCIInputImageKey];
    CIFilter *finalFilter = [CIFilter chainFilters:filters];
    
    CIImage *outputCI = finalFilter.outputImage;
    CGRect extent = outputCI.extent;
    if (CGRectIsInfinite(extent)) {
        NSLog(@"%s: Output image is infinite, crop it.", __PRETTY_FUNCTION__);
        extent = inputCI.extent;
    }
    CGImageRef outputCG = [self createCGImage:outputCI fromRect:extent];
    UIImage *outputUI = [UIImage imageWithCGImage:outputCG scale:inputUI.scale orientation:inputUI.imageOrientation];
    CGImageRelease(outputCG);
    
    return [outputUI imageWithRenderingMode:inputUI.renderingMode];
}





@end





@implementation UIImage (CoreImage)



- (instancetype)imageByRemovingWhite {
    return [CIContext imageFromImage:self filters:@[
        [CIFilter invertColors],
        [CIFilter maskToAlpha],
        [CIFilter invertColors],
    ]];
}



@end




