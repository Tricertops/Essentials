//
//  UIViewController+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 8.3.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIViewController+Essentials.h"





@implementation UIViewController (Essentials)





- (UINavigationController *)wrappedInNavigationController {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    navigationController.modalTransitionStyle = self.modalTransitionStyle;
    navigationController.modalPresentationStyle = self.modalPresentationStyle;
    navigationController.toolbarHidden = (self.toolbarItems.count == 0);
    return navigationController;
}





- (UIViewController *)deepestPresentedViewController {
    return self.presentedViewController.deepestPresentedViewController ?: self;
}





- (void)dismiss {
    BOOL canPop = (self.navigationController && self.navigationController.viewControllers.firstObject != self);
    if (canPop) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}





@end


