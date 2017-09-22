//
//  UISwipeActionsConfiguration+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21 Sep 2017.
//  Copyright © 2017 iAdverti. All rights reserved.
//

#import "UISwipeActionsConfiguration+Essentials.h"



@implementation UISwipeActionsConfiguration (Essentials)


+ (instancetype)configurationWithActions:(NSArray<UIContextualAction *> *)actions performsFirstActionWithFullSwipe:(BOOL)performsFirstActionWithFullSwipe {
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:actions];
    configuration.performsFirstActionWithFullSwipe = performsFirstActionWithFullSwipe;
    return configuration;
}


@end


