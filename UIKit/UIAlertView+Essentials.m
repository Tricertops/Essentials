//
//  UIAlertView+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIAlertView+Essentials.h"
#import "NSObject+Essentials.h"





@implementation UIAlertView (Essentials)





#pragma mark - Completion Block


- (UIAlertViewCompletionBlock)completionBlock {
    return [self associatedObjectForKey:@selector(completionBlock)];
}


- (void)setCompletionBlock:(UIAlertViewCompletionBlock)completionBlock {
    self.delegate = self;
    [self setAssociatedCopyObject:completionBlock forKey:@selector(completionBlock)];
}


- (BOOL)shouldInvokeCompletionBlockOnDismiss {
    return [[self associatedObjectForKey:@selector(shouldInvokeCompletionBlockOnDismiss)] boolValue];
}


- (void)setShouldInvokeCompletionBlockOnDismiss:(BOOL)shouldInvokeCompletionBlockOnDismiss {
    [self setAssociatedStrongObject:@(shouldInvokeCompletionBlockOnDismiss) forKey:@selector(shouldInvokeCompletionBlockOnDismiss)];
}


- (void)showWithCompletion:(UIAlertViewCompletionBlock)block {
    self.completionBlock = block;
    [self show];
}





#pragma mark - Delegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( ! self.shouldInvokeCompletionBlockOnDismiss) {
        if (self.completionBlock) self.completionBlock(buttonIndex);
        self.completionBlock = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.shouldInvokeCompletionBlockOnDismiss) {
        if (self.completionBlock) self.completionBlock(buttonIndex);
        self.completionBlock = nil;
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    if (self.shouldInvokeCompletionBlockOnDismiss) {
        [self alertView:alertView didDismissWithButtonIndex:alertView.cancelButtonIndex];
    }
    else {
        [self alertView:alertView clickedButtonAtIndex:alertView.cancelButtonIndex];
    }
}





#pragma mark - Text Fields


- (UITextField *)textField {
    switch (self.alertViewStyle) {
        case UIAlertViewStyleDefault:               return nil;
        case UIAlertViewStylePlainTextInput:        return [self textFieldAtIndex:0];
        case UIAlertViewStyleSecureTextInput:       return nil;
        case UIAlertViewStyleLoginAndPasswordInput: return [self textFieldAtIndex:0];
    }
}


- (UITextField *)secureTextField {
    switch (self.alertViewStyle) {
        case UIAlertViewStyleDefault:               return nil;
        case UIAlertViewStylePlainTextInput:        return nil;
        case UIAlertViewStyleSecureTextInput:       return [self textFieldAtIndex:0];
        case UIAlertViewStyleLoginAndPasswordInput: return [self textFieldAtIndex:1];
    }
}





@end
