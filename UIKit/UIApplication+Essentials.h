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
+ (nonnull instancetype)shared;


//! Presents given view controlelr modally on the currently displayed deepest VC.
- (void)presentViewController:(nonnull UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^ _Nullable)(void))completion;


//! Returns a key window across all connected scenes. Replacement for .keyWindow property.
@property (readonly, nullable) UIWindow *legacyKeyWindow;
//! Replacement for .statusBarFrame property.
@property (readonly) CGRect legacyStatusBarFrame;


@end


