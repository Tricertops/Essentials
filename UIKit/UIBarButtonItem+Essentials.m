//
//  UIBarButtonItem+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 14.11.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "UIBarButtonItem+Essentials.h"





@implementation UIBarButtonItem (Essentials)





#pragma mark - Creating


+ (instancetype)buttonWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
}


+ (instancetype)doneButtonWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:nil action:nil];
}


+ (instancetype)buttonWithImage:(UIImage *)image {
    return [[self alloc] initWithImage:image style:UIBarButtonItemStylePlain target:nil action:nil];
}


+ (instancetype)systemButton:(UIBarButtonSystemItem)systemItem {
    return [[self alloc] initWithBarButtonSystemItem:systemItem target:nil action:nil];
}


+ (instancetype)buttonWithView:(UIView *)view {
    return [[self alloc] initWithCustomView:view];
}





#pragma mark - Spaces


+ (instancetype)flexibleSpace {
    return [self systemButton:UIBarButtonSystemItemFlexibleSpace];
}


+ (instancetype)spaceWithWidth:(CGFloat)width {
    var space = [self systemButton:UIBarButtonSystemItemFlexibleSpace];
    space.width = width;
    return space;
}





#pragma mark - Action


- (void)setTarget:(id)target action:(SEL)selector {
    self.target = target;
    self.action = selector;
}





@end


