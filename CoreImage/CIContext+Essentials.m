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
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CIContext *context = [CIContext contextWithOptions:
                          @{
                            kCIContextWorkingColorSpace: (__bridge id)colorSpace,
                            kCIContextOutputColorSpace: (__bridge id)colorSpace,
                            }];
    CGColorSpaceRelease(colorSpace);
    return context;
}





#pragma mark - Processing Images


+ (UIImage *)imageFromImage:(UIImage *)inputUI filters:(NSArray *)filters {
    return [[CIContext context] imageFromImage:inputUI filters:filters];
}


- (UIImage *)imageFromImage:(UIImage *)inputUI filters:(NSArray *)filters {
    if ( ! inputUI) return nil;
    if ( ! filters.count) return inputUI;
    
    CIImage *inputCI = [CIImage imageWithCGImage:inputUI.CGImage];
    
    [filters.firstObject setValue:inputCI forKey:kCIInputImageKey];
    CIFilter *finalFilter = [CIFilter chainFilters:filters];
    
    CGImageRef outputCG = [self createCGImage:finalFilter.outputImage fromRect:inputCI.extent];
    UIImage *outputUI = [UIImage imageWithCGImage:outputCG scale:inputUI.scale orientation:inputUI.imageOrientation];
    CGImageRelease(outputCG);
    
    return [outputUI imageWithRenderingMode:inputUI.renderingMode];
}





@end


