//
//  UIAlertController+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 5.6.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIAlertController+Essentials.h"
#import "UIApplication+Essentials.h"
#import "UIViewController+Essentials.h"





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
    
    let messageComponents = NSMutableArray(
        error.localizedDescription ?: @"",
        error.localizedFailureReason ?: @"",
        error.localizedRecoverySuggestion ?: @"",
        error.helpAnchor ?: @"",
    );
    [messageComponents removeObject:@""];
    let message = [messageComponents componentsJoinedByString:@"\n\n"];
    
    var alert = [UIAlertController alertWithTitle:title message:message];
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
    let fallback = (style == UIAlertActionStyleCancel? @"Cancel" : @"");
    var action = [UIAlertAction actionWithTitle:title ?: fallback
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


- (void)presentFrom:(UIViewController *)viewController {
    [viewController.deepestPresentedViewController presentViewController:self animated:YES completion:nil];
}


- (void)presentFrom:(UIViewController *)viewController asPopover:(BOOL)popover fromBarButtonItem:(UIBarButtonItem *)barButton {
    if (popover && self.isSheet) {
        self.popoverPresentationController.barButtonItem = barButton;
    }
    [self presentFrom:viewController];
}


- (void)presentFrom:(UIViewController *)viewController asPopover:(BOOL)popover fromView:(UIView *)view {
    [self presentFrom:viewController asPopover:popover fromView:view rect:view.bounds];
}


- (void)presentFrom:(UIViewController *)viewController asPopover:(BOOL)popover fromView:(UIView *)view rect:(CGRect)rect {
    if (popover && self.isSheet && view) {
        self.popoverPresentationController.sourceView = view;
        self.popoverPresentationController.sourceRect = rect;
    }
    [self presentFrom:viewController];
}


- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}





@end


