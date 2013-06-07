//
//  UIActionSheet+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIActionSheet+Essentials.h"
#import "NSObject+Essentials.h"





@implementation UIActionSheet (Essentials)





#pragma mark - Completion Block


- (void (^)(NSInteger))completionBlock {
    return [self associatedObject:@selector(completionBlock)];
}


- (void)setCompletionBlock:(void (^)(NSInteger))completionBlock {
    self.delegate = self;
    [self associateCopyObject:completionBlock forKey:@selector(completionBlock)];
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





#pragma mark - Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.completionBlock) self.completionBlock(buttonIndex);
    self.completionBlock = nil; // Release the block
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    [self actionSheet:actionSheet clickedButtonAtIndex:actionSheet.cancelButtonIndex];
}





@end
