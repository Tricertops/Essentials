//
//  UIAlertController+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 5.6.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIAlertController+Essentials.h"
#import "UIApplication+Essentials.h"





@implementation UIAlertController (Essentials)





#pragma mark - Creation


+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
}


+ (instancetype)sheetWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}


+ (instancetype)alertWithError:(NSError *)error {
    return [self alertWithError:error title:nil button:nil];
}


+ (instancetype)alertWithError:(NSError *)error title:(NSString *)title button:(NSString*)button {
    title = title ?: error.localizedFailureReason ?: @"Error";
    
	NSMutableArray *messageComponents = @[
	    error.localizedDescription ?: @"",
	    error.localizedFailureReason ?: @"",
	    error.localizedRecoverySuggestion ?: @"",
	    error.helpAnchor ?: @"",
	].mutableCopy;
    [messageComponents removeObject:@""];
    NSString *message = [messageComponents componentsJoinedByString:@"\n\n"];
    
    UIAlertController *alert = [UIAlertController alertWithTitle:title message:message];
    [alert addCancel:(button ?: @"Dismiss")];
    
    [error.localizedRecoveryOptions enumerateObjectsUsingBlock:^(NSString *recoveryOption, NSUInteger index, BOOL *stop) {
        [alert addAction:recoveryOption handler:^{
            [error.recoveryAttempter attemptRecoveryFromError:error optionIndex:index];
        }];
    }];
    return alert;
}





#pragma mark - Properties


- (BOOL)isAlert {
    return (self.preferredStyle == UIAlertControllerStyleAlert);
}


- (BOOL)isSheet {
        return (self.preferredStyle == UIAlertControllerStyleActionSheet);
}





#pragma mark - Actions


- (UIAlertAction *)addCancel:(NSString *)title {
    return [self addCancel:title handler:nil];
}


- (UIAlertAction *)addCancel:(NSString *)title handler:(void (^)(void))handler {
    return [self addActionWithTitle:title style:UIAlertActionStyleCancel handler:handler];
}


- (UIAlertAction *)addAction:(NSString *)title handler:(void (^)(void))handler {
    return [self addActionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
}


- (UIAlertAction *)addDestructive:(NSString *)title handler:(void (^)(void))handler {
    return [self addActionWithTitle:title style:UIAlertActionStyleDestructive handler:handler];
}


- (UIAlertAction *)addActionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(void))handler {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:style
                                                   handler:^(UIAlertAction *action) {
                                                       if (handler) handler();
                                                   }];
    [self addAction:action];
    return action;
}





#pragma mark - Presentation


- (void)present {
    [[UIApplication shared] presentViewController:self animated:YES completion:nil];
}


- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)barButton {
    self.popoverPresentationController.barButtonItem = barButton;
    [self present];
}


- (void)presentPopoverFromView:(UIView *)view {
    [self presentPopoverFromView:view rect:view.bounds];
}


- (void)presentPopoverFromView:(UIView *)view rect:(CGRect)rect {
    self.popoverPresentationController.sourceView = view;
    self.popoverPresentationController.sourceRect = rect;
    [self present];
}


- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}





@end


