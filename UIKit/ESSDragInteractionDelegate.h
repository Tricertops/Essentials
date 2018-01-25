//
//  ESSDragInteractionDelegate.h
//  Essentials
//
//  Created by Martin Kiss on 3 Oct 2017.
//  Copyright © 2017 Tricertops. All rights reserved.
//

#import "UIKit+Essentials.h"



//! Implements simple dragging behavior: uses items passed into init, supports multiple sessions, prefers session nearest to touch location.
@interface ESSDragInteractionDelegate : NSObject <UIDragInteractionDelegate>


- (instancetype)initWithItems:(NSArray<NSItemProvider *> *)items;
@property (readonly) NSArray<NSItemProvider *> *items;


@end


