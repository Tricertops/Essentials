//
//  UIControl+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 17 Jan 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

#import "UIKit+Essentials.h"
#import "ESSEvent.h"



@interface UIControl (Essentials)


/// Add target and action for UIControlEventPrimaryActionTriggered.
- (void)addTarget:(id)target action:(SEL)action;

/// Returns ESSEvent for UIControlEventPrimaryActionTriggered.
@property (readonly) ESSEvent<__kindof UIControl *> *onAction;


@end


