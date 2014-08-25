//
//  UIActionSheet+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^UIActionSheetCompletionBlock)(NSInteger buttonIndex);


/// Defines classes that can be used as source fo presentation.
@protocol UIActionSheetSource @required
- (BOOL)showActionSheet:(UIActionSheet *)actionSheet;
@end
@interface UIView (UIActionSheetSource) <UIActionSheetSource> @end
@interface UIBarButtonItem (UIActionSheetSource) <UIActionSheetSource> @end
@interface UITabBar (UIActionSheetSource) <UIActionSheetSource> @end
@interface UIToolbar (UIActionSheetSource) <UIActionSheetSource> @end
@interface UIViewController (UIActionSheetSource) <UIActionSheetSource>
- (BOOL)showActionSheet:(UIActionSheet *)actionSheet from:(id<UIActionSheetSource>)source;
@end



@interface UIActionSheet (Essentials) < UIActionSheetDelegate >



#pragma mark - Show

/// Universal method to present the receiver on iPhone and iPad.
- (void)showFrom:(id<UIActionSheetSource>)source;



#pragma mark Cancellation

/// Dismisses with cancel action. Animated.
- (void)cancel;

/// Dismisses with cancel action.
- (void)cancelAnimated:(BOOL)animated;



#pragma mark - Completion Block

/// Block to be invoked automatically after the action sheet is cancelled or a button is clicked. Setting this property also sets delegate to self.
@property (nonatomic, readwrite, copy) UIActionSheetCompletionBlock completionBlock;

/// YES for completion block to be invoked after the sheet was dismissed. NO, the default, for to be invoked immediately on click.
@property (nonatomic, readwrite, assign) BOOL shouldInvokeCompletionBlockOnDismiss;


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

/// Sets completion block and shows the action sheet using universal presentation method.
- (void)showFrom:(id<UIActionSheetSource>)source completion:(UIActionSheetCompletionBlock)block;



@end


