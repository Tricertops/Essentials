//
//  UIViewController+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 8.3.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"





@interface UIViewController (Essentials)


//! Returns UINavigationController containing the receiver as the root. Inherits some properties.
- (UINavigationController *)wrappedInNavigationController;

//! Traverses presented View Controllers and returns the deepest one.
- (UIViewController *)deepestPresentedViewController;

//! Dismisses the receiver by unqinding its presentation.
- (IBAction)dismiss;

//! Adds child view controller to the receiver (with proper method sequence).
- (void)addChildInstantly:(UIViewController *)childViewController;

//! Removes view from superview and the receiver from its parent (with proper method sequence).
- (void)removeFromParentInstantly;


@end


