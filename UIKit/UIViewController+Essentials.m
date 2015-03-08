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
    return navigationController;
}





@end


