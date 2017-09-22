//
//  UISwipeActionsConfiguration+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21 Sep 2017.
//  Copyright © 2017 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UISwipeActionsConfiguration (Essentials)


/// Convenience constructor with extra argument.
+ (instancetype)configurationWithActions:(NSArray<UIContextualAction *> *)actions performsFirstActionWithFullSwipe:(BOOL)performsFirstActionWithFullSwipe;


@end


