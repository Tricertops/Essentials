//
//  UIApplication+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 28.4.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"



@interface UIApplication (Essentials)



//! Like +sharedApplication, but shorter.
+ (instancetype)shared;


//! Presents given view controlelr modally on the currently displayed deepest VC.
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;



@end


