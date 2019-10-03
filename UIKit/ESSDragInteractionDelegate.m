//
//  ESSDragInteractionDelegate.m
//  Essentials
//
//  Created by Martin Kiss on 3 Oct 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "ESSDragInteractionDelegate.h"
#import "UIKit+Essentials.h"



@implementation ESSDragInteractionDelegate



- (instancetype)initWithItems:(NSArray<NSItemProvider *> *)items {
    self = [super init];
    if (self) {
        self->_items = [items copy];
    }
    return self;
}



- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session {
    var dragItems = [NSMutableArray<UIDragItem *> new];
    
    foreach (item, self.items) {
        var dragItem = [[UIDragItem alloc] initWithItemProvider:item];
        [dragItems addObject:dragItem];
    }
    return dragItems;
}


- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForAddingToSession:(id<UIDragSession>)session withTouchAtPoint:(CGPoint)point {
    return [self dragInteraction:interaction itemsForBeginningSession:session];
}


- (id<UIDragSession>)dragInteraction:(UIDragInteraction *)interaction sessionForAddingItems:(NSArray<id<UIDragSession>> *)sessions withTouchAtPoint:(CGPoint)touchLocation {
    CGFloat nearestDistance = INFINITY;
    id<UIDragSession> nearestSession = nil;
    var view = interaction.view;
    
    foreach (session, sessions) {
        CGPoint sessionLocation = [session locationInView:view];
        CGFloat distance = CGPointDistanceToPoint(touchLocation, sessionLocation);
        
        if (nearestDistance > distance) {
            nearestDistance = distance;
            nearestSession = session;
        }
    }
    
    return nearestSession;
}



@end


