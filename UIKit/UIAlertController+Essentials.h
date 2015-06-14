//
//  UIAlertController+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 5.6.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIAlertController (Essentials)



#pragma mark - Creation

//! Creates alert controller with Alert style.
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;
//! Creates alert controller with Action Sheet style.
+ (instancetype)sheetWithTitle:(NSString *)title message:(NSString *)message;

//! Creates alert controller that presents an error.
+ (instancetype)alertWithError:(NSError *)error;
//! Creates alert controller that presents an error with custom title and button.
+ (instancetype)alertWithError:(NSError *)error title:(NSString *)title button:(NSString*)button;


#pragma mark - Properties

@property (readonly) BOOL isAlert; //!< Whether the style is Alert.
@property (readonly) BOOL isSheet; //!< Whether the style is Action Sheet.


#pragma mark - Actions

//! Adds and returns new Cancel action with title and no handler.
- (UIAlertAction *)addCancel:(NSString *)title;
//! Adds and returns new Cancel action with title and handler.
- (UIAlertAction *)addCancel:(NSString *)title handler:(void (^)(void))handler;
//! Adds and returns new Default action with title and handler.
- (UIAlertAction *)addAction:(NSString *)title handler:(void (^)(void))handler;
//! Adds and returns new Destructive action with title and handler.
- (UIAlertAction *)addDestructive:(NSString *)title handler:(void (^)(void))handler;


#pragma mark - Presentation

//! Presents the receiver on topmost view controller.
- (void)present;
//! Presents the receiver on given view controller.
- (void)presentFrom:(UIViewController *)viewController;

//! Presents the receiver on given view controller. Optionally in a popover (only sheets) from given bar button item.
- (void)presentFrom:(UIViewController *)viewController asPopover:(BOOL)popover fromBarButtonItem:(UIBarButtonItem *)item;
//! Presents the receiver on given view controller. Optionally in a popover (only sheets) from given view.
- (void)presentFrom:(UIViewController *)viewController asPopover:(BOOL)popover fromView:(UIView *)view;
//! Presents the receiver on given view controller. Optionally in a popover (only sheets) from given rect of a view.
- (void)presentFrom:(UIViewController *)viewController asPopover:(BOOL)popover fromView:(UIView *)view rect:(CGRect)rect;

//! Dismisses the receiver.
- (void)dismiss;



@end


