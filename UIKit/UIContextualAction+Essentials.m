//
//  UIContextualAction+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21 Sep 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "UIContextualAction+Essentials.h"



@implementation UIContextualAction (Essentials)



+ (instancetype)actionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler {
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:title handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self performHandlerWithoutBlockingAnimation:handler];
        completionHandler(YES);
    }];
    if (color) {
        action.backgroundColor = color;
    }
    return action;
}



+ (instancetype)actionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler {
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self performHandlerWithoutBlockingAnimation:handler];
        completionHandler(YES);
    }];
    action.image = image;
    if (color) {
        action.backgroundColor = color;
    }
    return action;
}



+ (instancetype)descructiveActionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler {
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:title handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self performHandlerWithoutBlockingAnimation:handler];
        completionHandler(YES);
    }];
    if (color) {
        action.backgroundColor = color;
    }
    return action;
}



+ (instancetype)descructiveActionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler {
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self performHandlerWithoutBlockingAnimation:handler];
        completionHandler(YES);
    }];
    action.image = image;
    if (color) {
        action.backgroundColor = color;
    }
    return action;
}


+ (void)performHandlerWithoutBlockingAnimation:(void (^)(void))handler {
    [NSOperationQueue.mainQueue performSelector:@selector(addOperationWithBlock:) withObject:handler afterDelay:0.03];
}




@end


