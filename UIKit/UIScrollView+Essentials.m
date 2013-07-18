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





#pragma mark Content Progress


- (CGPoint)contentProgress {
    CGRect viewport = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    CGSize boundsSize = viewport.size;
    CGPoint contentOffset = viewport.origin;
    CGSize contentSize = self.contentSize;
    
    CGSize scrollableSize = {
        .width = contentSize.width - boundsSize.width,
        .height = contentSize.height - boundsSize.height,
    };
    
    CGPoint contentProgress = {
        .x = (scrollableSize.width > 0? contentOffset.x / scrollableSize.width : 0),
        .y = (scrollableSize.height > 0? contentOffset.y / scrollableSize.height : 0),
    };
    return contentProgress;
}


- (void)setContentProgress:(CGPoint)contentProgress {
    CGRect viewport = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    CGSize boundsSize = viewport.size;
    CGSize contentSize = self.contentSize;
    
    CGPoint contentOffset = {
        .x = (contentSize.width - boundsSize.width) * contentProgress.x - self.contentInset.left,
        .y = (contentSize.height - boundsSize.height) * contentProgress.y - self.contentInset.top,
    };
    self.contentOffset = contentOffset;
}


+ (NSSet *)keyPathsForValuesAffectingContentProgress {
    return [NSSet setWithObjects:@"contentSize", @"frame", @"contentOffset", @"contentInset", nil];
}





@end
