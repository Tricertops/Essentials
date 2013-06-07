//
//  UIAlertView+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef void(^UIAlertViewCompletionBlock)(NSInteger buttonIndex);





@interface UIAlertView (Essentials) < UIAlertViewDelegate >



#pragma mark Completion Block

/// Block to be invoked automatically after the alert view is cancelled or a button is clicked. Setting this property also sets delegate to self.
@property (nonatomic, readwrite, copy) UIAlertViewCompletionBlock completionBlock;

/// Sets completion block and show the alerti view.
- (void)showWithCompletion:(UIAlertViewCompletionBlock)block;



#pragma mark - Text Fields

/// Returns text field WITHOUT secure entry enabled. Returns nil in case of Default or SecureTextInput alert style.
- (UITextField *)textField;

/// Returns text field WITH secure entry enabled. Returns nil in case of Default or PlainTextInput alert style.
- (UITextField *)secureTextField;



@end
