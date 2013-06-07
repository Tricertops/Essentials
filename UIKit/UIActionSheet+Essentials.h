//
//  UIActionSheet+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^UIActionSheetCompletionBlock)(NSInteger buttonIndex);





@interface UIActionSheet (Essentials) < UIActionSheetDelegate >



#pragma mark - Completion Block

/// Block to be invoked automatically after the action sheet is cancelled or a button is clicked. Setting this property also sets delegate to self.
@property (nonatomic, readwrite, copy) UIActionSheetCompletionBlock completionBlock;

/// Sets completion block and shows the action sheet in given view.
- (void)showInView:(UIView *)view completion:(UIActionSheetCompletionBlock)block;

/// Sets completion block and shows the action sheet from given toolbar.
- (void)showFromToolbar:(UIToolbar *)toolbar completion:(UIActionSheetCompletionBlock)block;

/// Sets completion block and shows the action sheet from given tab bar.
- (void)showFromTabBar:(UITabBar *)tabBar completion:(UIActionSheetCompletionBlock)block;

/// Sets completion block and shows the action sheet in given rect of view.
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completion:(UIActionSheetCompletionBlock)block;

/// Sets completion block and shows the action sheet from given bar button item.
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completion:(UIActionSheetCompletionBlock)block;



@end
