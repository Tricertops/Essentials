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


- (void (^)(NSInteger))completionBlock {
    return [self associatedObject:@selector(completionBlock)];
}


- (void)setCompletionBlock:(void (^)(NSInteger))completionBlock {
    self.delegate = self;
    [self associateCopyObject:completionBlock forKey:@selector(completionBlock)];
}


- (void)showWithCompletion:(void(^)(NSInteger buttonIndex))block {
    self.completionBlock = block;
    [self show];
}





#pragma mark - Delegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.completionBlock) self.completionBlock(buttonIndex);
    self.completionBlock = nil;
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    if (self.completionBlock) self.completionBlock(self.cancelButtonIndex);
    self.completionBlock = nil;
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
