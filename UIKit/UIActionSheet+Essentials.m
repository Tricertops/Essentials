//
//  UIActionSheet+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIActionSheet+Essentials.h"
#import "NSObject+Essentials.h"
#import "UIDevice+Essentials.h"





@implementation UIActionSheet (Essentials)





#pragma mark Cancellation


- (void)cancel {
    [self cancelAnimated:YES];
}


- (void)cancelAnimated:(BOOL)animated {
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:animated];
}





#pragma mark - Completion Block


- (void (^)(NSInteger))completionBlock {
    return [self associatedObjectForKey:@selector(completionBlock)];
}


- (void)setCompletionBlock:(void (^)(NSInteger))completionBlock {
    self.delegate = self;
    [self setAssociatedCopyObject:completionBlock forKey:@selector(completionBlock)];
}


- (BOOL)shouldInvokeCompletionBlockOnDismiss {
    return [[self associatedObjectForKey:_cmd] boolValue];
}


- (void)setShouldInvokeCompletionBlockOnDismiss:(BOOL)shouldInvokeCompletionBlockOnDismiss {
    [self setAssociatedStrongObject:@(shouldInvokeCompletionBlockOnDismiss) forKey:@selector(shouldInvokeCompletionBlockOnDismiss)];
}



- (void)showInView:(UIView *)view completion:(void(^)(NSInteger buttonIndex))block {
    self.completionBlock = block;
    [self showInView:view];
}

- (void)showFromToolbar:(UIToolbar *)toolbar completion:(void(^)(NSInteger buttonIndex))block {
    self.completionBlock = block;
    [self showFromToolbar:toolbar];
}

- (void)showFromTabBar:(UITabBar *)tabBar completion:(void(^)(NSInteger buttonIndex))block {
    self.completionBlock = block;
    [self showFromTabBar:tabBar];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completion:(void(^)(NSInteger buttonIndex))block {
    self.completionBlock = block;
    [self showFromRect:rect inView:view animated:animated];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completion:(void(^)(NSInteger buttonIndex))block {
    self.completionBlock = block;
    [self showFromBarButtonItem:item animated:animated];
}


- (void)showFrom:(id<UIActionSheetSource>)source completion:(void(^)(NSInteger buttonIndex))block {
    self.completionBlock = block;
    [self showFrom:source];
}


- (void)showFrom:(id<UIActionSheetSource>)source {
    [source showActionSheet:self];
}





#pragma mark - Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( ! self.shouldInvokeCompletionBlockOnDismiss) {
        if (self.completionBlock) self.completionBlock(buttonIndex);
        self.completionBlock = nil; // Release the block
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.shouldInvokeCompletionBlockOnDismiss) {
        if (self.completionBlock) self.completionBlock(buttonIndex);
        self.completionBlock = nil; // Release the block
    }
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    [self actionSheet:actionSheet clickedButtonAtIndex:actionSheet.cancelButtonIndex];
}





@end





@implementation UIView (UIActionSheetSource)

- (BOOL)showActionSheet:(UIActionSheet *)actionSheet {
    if (UIDevice.iPad) {
        [actionSheet showFromRect:self.bounds inView:self animated:YES];
    }
    else {
        [actionSheet showInView:self];
    }
    return YES;
}

@end



@implementation UIBarButtonItem (UIActionSheetSource)

- (BOOL)showActionSheet:(UIActionSheet *)actionSheet {
    if (UIDevice.iPad) {
        [actionSheet showFromBarButtonItem:self animated:YES];
        return YES;
    }
    return NO;
}

@end



@implementation UITabBar (UIActionSheetSource)

- (BOOL)showActionSheet:(UIActionSheet *)actionSheet {
    if (UIDevice.iPhone) {
        [actionSheet showFromTabBar:self];
        return YES;
    }
    return NO;
}

@end



@implementation UIToolbar (UIActionSheetSource)

- (BOOL)showActionSheet:(UIActionSheet *)actionSheet {
    if (UIDevice.iPhone) {
        [actionSheet showFromToolbar:self];
        return YES;
    }
    return NO;
}

@end



@implementation UIViewController (UIActionSheetSource)

- (BOOL)showActionSheet:(UIActionSheet *)sheet {
    BOOL didShow = ([self.tabBarController.tabBar showActionSheet:sheet]
                    ?: [self.navigationController.toolbar showActionSheet:sheet]
                    ?: [self showActionSheet:sheet]);
    if ( ! didShow) {
        [sheet showInView:self.view];
    }
    return YES;
}

- (BOOL)showActionSheet:(UIActionSheet *)sheet from:(id<UIActionSheetSource>)source {
    return [source showActionSheet:sheet] ?: [self showActionSheet:sheet];
}

@end


