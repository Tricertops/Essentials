//
//  UIKit+Essentials.h
//  Essentials
//
//  Created by Juraj Homola on 18.6.2013.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIAlertView+Essentials.h"
#import "UIActionSheet+Essentials.h"
#import "UIColor+Essentials.h"
#import "UIDevice+Essentials.h"
#import "UIImage+Essentials.h"
#import "UIScreen+Essentials.h"
#import "UIView+Essentials.h"
#import "UIScrollView+Essentials.h"
#import "NSShadow+Essentials.h"
#import "NSAttributedString+Essentials.h"
#import "NSMutableAttributedString+Essentials.h"



#pragma mark Rectangle

extern CGPoint CGRectGetCenter(CGRect);
extern CGPoint CGRectGetPoint(CGRect rect, CGFloat relativeX, CGFloat relativeY);

extern CGRect CGRectMakeSize(CGSize);
extern CGRect CGRectMakeOrigin(CGPoint);
extern CGRect CGRectMakeOriginSize(CGPoint, CGSize);



#pragma mark Rounding

extern CGFloat CGFloatRoundToScale(CGFloat value, CGFloat scale, NSRoundingMode mode);
extern CGPoint CGPointRoundToScale(CGPoint point, CGFloat scale, NSRoundingMode mode);
extern CGSize CGSizeRoundToScale(CGSize size, CGFloat scale, NSRoundingMode mode);
extern CGRect CGRectRoundToScale(CGRect rect, CGFloat scale, NSRoundingMode mode);

extern CGFloat CGFloatRoundToScreenScale(CGFloat);
extern CGPoint CGPointRoundToScreenScale(CGPoint);
extern CGSize CGSizeRoundToScreenScale(CGSize);
extern CGRect CGRectRoundToScreenScale(CGRect);



#pragma mark Edge Insets

extern UIEdgeInsets UIEdgeInsetsAddEdgeInsets(UIEdgeInsets, UIEdgeInsets);



#pragma mark Autoresizing

enum {
    UIViewAutoresizingFlexibleMargins = (UIViewAutoresizingFlexibleTopMargin
                                         | UIViewAutoresizingFlexibleBottomMargin
                                         | UIViewAutoresizingFlexibleLeftMargin
                                         | UIViewAutoresizingFlexibleRightMargin),
    UIViewAutoresizingFlexibleSize = (UIViewAutoresizingFlexibleWidth
                                      | UIViewAutoresizingFlexibleHeight),
};
