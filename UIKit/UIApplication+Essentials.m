//
//  UIApplication+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 28.4.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIApplication+Essentials.h"
#import "UIViewController+Essentials.h"





@implementation UIApplication (Essentials)





+ (instancetype)shared {
    return [self sharedApplication];
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self.keyWindow.rootViewController.deepestPresentedViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
}


- (UIWindow *)legacyKeyWindow {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return self.keyWindow;
#pragma clang diagnostic pop
}

- (CGRect)legacyStatusBarFrame {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return self.statusBarFrame;
#pragma clang diagnostic pop
}





@end


