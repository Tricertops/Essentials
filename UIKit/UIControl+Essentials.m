//
//  UIControl+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 17 Jan 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

#import "UIControl+Essentials.h"
#import "NSObject+Essentials.h"



@implementation UIControl (Essentials)





- (void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventPrimaryActionTriggered];
}



- (ESSEvent<UIControl *> *)onAction {
    ESSEvent *event = [self associatedObjectForKey:_cmd];
    if (!event) {
        event = [[ESSEvent alloc] initWithOwner:self initialValue:self];
        [self addTarget:event action:@selector(notify)];
        [self setAssociatedStrongObject:event forKey:_cmd];
    }
    return event;
}





@end


