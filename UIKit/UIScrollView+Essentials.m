//
//  UIScrollView+Essentials.m
//  Essentials
//
//  Created by Juraj Homola on 26.6.2013.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIScrollView+Essentials.h"

@implementation UIScrollView (Essentials)




#pragma mark - Structs Adjustments

- (void)adjustContentInset:(void (^)(UIEdgeInsets *))block {
    UIEdgeInsets contentInset = self.contentInset;
    block(&contentInset);
    self.contentInset = contentInset;
}


- (void)adjustScrollIndicatorInsets:(void (^)(UIEdgeInsets *))block {
    UIEdgeInsets scrollIndicatorInsets = self.scrollIndicatorInsets;
    block(&scrollIndicatorInsets);
    self.scrollIndicatorInsets = scrollIndicatorInsets;
}




@end
