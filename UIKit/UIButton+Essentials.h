//
//  UIButton+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 20.5.17.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ESSButtonState : NSObject

@property NSString *title;
@property NSAttributedString *attributedTitle;
@property UIColor *titleColor;
@property UIColor *titleShadowColor;
@property UIImage *image;
@property UIImage *backgroundImage;

@end



@interface UIButton (Essentials)

@property (readonly) ESSButtonState *normalState;
@property (readonly) ESSButtonState *disabledState;
@property (readonly) ESSButtonState *highlightedState;
@property (readonly) ESSButtonState *selectedState;
@property (readonly) ESSButtonState *selectedHighlightedState;

- (ESSButtonState *)stateForControlState:(UIControlState)controlState;

@property (readonly) ESSButtonState *currentState;

- (void)addTarget:(id)target action:(SEL)action;

@end


