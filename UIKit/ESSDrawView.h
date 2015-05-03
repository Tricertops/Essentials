//
//  ESSDrawView.h
//  Essentials
//
//  Created by Martin Kiss on 3.5.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIView (ESSDrawView)


//! Creates new view with given block invoked from drawRect:
+ (UIView *)viewWithDrawRect: (void (^)(UIView *view, CGRect rect))drawRect;


@end


