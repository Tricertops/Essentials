//
//  UIContextualAction+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21 Sep 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIContextualAction (Essentials)


/// Convenience constructor for Normal style with title and custom color. Uses simplified handler.
+ (instancetype)actionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler;

/// Convenience constructor for Normal style with image and custom color. Uses simplified handler.
+ (instancetype)actionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler;

/// Convenience constructor for Descructive style with title and custom color. Uses simplified handler.
+ (instancetype)descructiveActionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler;

/// Convenience constructor for Descructive style with image and custom color. Uses simplified handler.
+ (instancetype)descructiveActionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler;


@end


