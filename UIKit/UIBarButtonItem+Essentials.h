//
//  UIBarButtonItem+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 14.11.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIBarButtonItem (Essentials)


#pragma mark - Creating

+ (instancetype)buttonWithTitle:(NSString *)title;
+ (instancetype)doneButtonWithTitle:(NSString *)title;
+ (instancetype)buttonWithImage:(UIImage *)image;
+ (instancetype)systemButton:(UIBarButtonSystemItem)systemItem;
+ (instancetype)buttonWithView:(UIView *)view;


#pragma mark - Spaces

+ (instancetype)flexibleSpace;
+ (instancetype)spaceWithWidth:(CGFloat)width;


@end


