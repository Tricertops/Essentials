//
//  UIControl+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 17 Jan 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

#import "UIControl+Essentials.h"



@implementation UIControl (Essentials)





- (void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventPrimaryActionTriggered];
}





@end


