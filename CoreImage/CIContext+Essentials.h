//
//  CIContext+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 6.9.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>





@interface CIContext (Essentials)



#pragma mark - Creating

/// Creates a CPU-based Core Image context that uses DeviceRGB color space.
+ (instancetype)context;



#pragma mark - Processing Images

/// Returns image processed by an array of filters in temporary context.
+ (UIImage *)imageFromImage:(UIImage *)input filters:(NSArray *)filters;

/// Returns image processed by an array of filters.
- (UIImage *)imageFromImage:(UIImage *)input filters:(NSArray *)filters;



@end


