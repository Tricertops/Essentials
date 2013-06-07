//
//  UIAlertView+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface UIAlertView (Essentials) < UIAlertViewDelegate >



#pragma mark Completion Block

/// Block to be invoked automatically after the alert view is cancelled or a button is clicked. Setting this property also sets delegate to self.
@property (nonatomic, readwrite, copy) void (^completionBlock)(NSInteger buttonIndex);

/// Sets completion block and show the alerti view.
- (void)showWithCompletion:(void(^)(NSInteger buttonIndex))block;



#pragma mark - Text Fields

/// Returns text field WITHOUT secure entry enabled. Returns nil in case of Default or SecureTextInput alert style.
- (UITextField *)textField;

/// Returns text field WITH secure entry enabled. Returns nil in case of Default or PlainTextInput alert style.
- (UITextField *)secureTextField;



@end
