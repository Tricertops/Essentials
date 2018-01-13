//
//  UIContextualAction+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21 Sep 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "UIContextualAction+Essentials.h"



@implementation UIContextualAction (Essentials)



+ (instancetype)actionWithTitle:(NSString *)title image:(UIImage *)image style:(UIContextualActionStyle)style color:(UIColor *)color handler:(void (^)(void))handler {
    //BUG: Accessibility has a bug, when empty action titles crash the app.
    if (title.length == 0) {
        title = @" ";
    }
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:style title:title handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [self performHandlerWithoutBlockingAnimation:handler];
        completionHandler(YES);
    }];
    if (image) {
        action.image = image;
    }
    if (color) {
        action.backgroundColor = color;
    }
    return action;
}



+ (instancetype)actionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler {
    return [self actionWithTitle:title image:nil style:UIContextualActionStyleNormal color:color handler:handler];
}


+ (instancetype)actionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler {
    return [self actionWithTitle:nil image:image style:UIContextualActionStyleNormal color:color handler:handler];
}


+ (instancetype)destructiveActionWithTitle:(NSString *)title color:(UIColor *)color handler:(void (^)(void))handler {
    return [self actionWithTitle:title image:nil style:UIContextualActionStyleDestructive color:color handler:handler];
}


+ (instancetype)destructiveActionWithImage:(UIImage *)image color:(UIColor *)color handler:(void (^)(void))handler {
    return [self actionWithTitle:nil image:image style:UIContextualActionStyleDestructive color:color handler:handler];
}


+ (void)performHandlerWithoutBlockingAnimation:(void (^)(void))handler {
    [NSOperationQueue.mainQueue performSelector:@selector(addOperationWithBlock:) withObject:handler afterDelay:0.03];
}




@end


