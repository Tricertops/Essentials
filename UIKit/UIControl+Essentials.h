//
//  UIControl+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 17 Jan 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIControl (Essentials)


/// Add target and action for UIControlEventPrimaryActionTriggered
- (void)addTarget:(id)target action:(SEL)action;


@end


