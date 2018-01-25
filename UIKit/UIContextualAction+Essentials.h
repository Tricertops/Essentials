//
//  UIContextualAction+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21 Sep 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "UIKit+Essentials.h"



@interface UIContextualAction (Essentials)


/// Convenience constructor for Normal style with title and custom color. Uses simplified handler.
+ (instancetype)actionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler;

/// Convenience constructor for Normal style with image and custom color. Uses simplified handler.
+ (instancetype)actionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler;

/// Convenience constructor for Destructive style with title and custom color. Uses simplified handler.
+ (instancetype)destructiveActionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler;

/// Convenience constructor for Destructive style with image and custom color. Uses simplified handler.
+ (instancetype)destructiveActionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler;


@end


