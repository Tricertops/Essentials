//
//  UIButton+Essentials.m
//  MTKButtonState
//
//  Created by Martin Kiss on 20.5.17.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "UIButton+Essentials.h"





@interface ESSButtonState ()


@property (readonly, weak) UIButton *button;
@property (readonly) UIControlState controlState;


@end





@implementation ESSButtonState





- (instancetype)init {
    return [self initWithButton:nil controlState:UIControlStateNormal];
}


- (instancetype)initWithButton:(UIButton *)button controlState:(UIControlState)controlState {
    self = [super init];
    if (self) {
        self->_button = button;
        self->_controlState = controlState;
    }
    return self;
}



#pragma mark Title


- (NSString *)title {
    return [self.button titleForState:self.controlState];
}


- (void)setTitle:(NSString *)title {
    [self.button setTitle:title forState:self.controlState];
}



#pragma mark Attributed Title


- (NSAttributedString *)attributedTitle {
    return [self.button attributedTitleForState:self.controlState];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    [self.button setAttributedTitle:attributedTitle forState:self.controlState];
}



#pragma mark Title Color


- (UIColor *)titleColor {
    return [self.button titleColorForState:self.controlState];
}


- (void)setTitleColor:(UIColor *)titleColor {
    [self.button setTitleColor:titleColor forState:self.controlState];
}



#pragma mark Title Shadow Color


- (UIColor *)titleShadowColor {
    return [self.button titleShadowColorForState:self.controlState];
}


- (void)setTitleShadowColor:(UIColor *)titleShadowColor {
    [self.button setTitleShadowColor:titleShadowColor forState:self.controlState];
}



#pragma mark Image


- (UIImage *)image {
    return [self.button imageForState:self.controlState];
}


- (void)setImage:(UIImage *)image {
    [self.button setImage:image forState:self.controlState];
}



#pragma mark Background Image


- (UIImage *)backgroundImage {
    return [self.button backgroundImageForState:self.controlState];
}


- (void)setBackgroundImage:(UIImage *)backgroundImage {
    [self.button setBackgroundImage:backgroundImage forState:self.controlState];
}





@end









@implementation UIButton (Essentials)





- (ESSButtonState *)stateForControlState:(UIControlState)controlState {
    return [[ESSButtonState alloc] initWithButton:self controlState:controlState];
}


- (ESSButtonState *)normalState {
    return [self stateForControlState:UIControlStateNormal];
}


- (ESSButtonState *)disabledState {
    return [self stateForControlState:UIControlStateDisabled];
}


- (ESSButtonState *)highlightedState {
    return [self stateForControlState:UIControlStateHighlighted];
}


- (ESSButtonState *)selectedState {
    return [self stateForControlState:UIControlStateSelected];
}


- (ESSButtonState *)selectedHighlightedState {
    return [self stateForControlState:(UIControlStateSelected | UIControlStateHighlighted)];
}


- (ESSButtonState *)currentState {
    return [self stateForControlState:self.state];
}




@end
