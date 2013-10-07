//
//  UIKit+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 27.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"







#pragma mark Rectangle


CGPoint CGRectGetCenter(CGRect rect) {
    return CGRectGetPoint(rect, 0.5, 0.5);
}


CGPoint CGRectGetPoint(CGRect rect, CGFloat relativeX, CGFloat relativeY) {
    CGPoint point;
    point.x = rect.origin.x + (rect.size.width * relativeX);
    point.y = rect.origin.y + (rect.size.height * relativeY);
    return point;
}


CGRect CGRectMakeSize(CGSize size) {
    return CGRectMakeOriginSize(CGPointZero, size);
}


CGRect CGRectMakeOrigin(CGPoint origin) {
    return CGRectMakeOriginSize(origin, CGSizeZero);
}


CGRect CGRectMakeOriginSize(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}





#pragma mark Rounding


CGFloat CGFloatRoundToScale(CGFloat value, CGFloat scale, NSRoundingMode mode) {
    double (*function)(double);
    switch (mode) {
        case NSRoundPlain:   function = &round; break;
        case NSRoundUp:      function = &ceil; break;
        case NSRoundDown:    function = &floor; break;
        case NSRoundBankers: function = &round; break;
    }
    if ( ! scale) scale = [[UIScreen mainScreen] scale];
    CGFloat result = function(value * scale) / scale;
    return result;
}


CGPoint CGPointRoundToScale(CGPoint point, CGFloat scale, NSRoundingMode mode) {
    point.x = CGFloatRoundToScale(point.x, scale, mode);
    point.y = CGFloatRoundToScale(point.y, scale, mode);
    return point;
}


CGSize CGSizeRoundToScale(CGSize size, CGFloat scale, NSRoundingMode mode) {
    size.width = CGFloatRoundToScale(size.width, scale, mode);
    size.height = CGFloatRoundToScale(size.height, scale, mode);
    return size;
}


CGRect CGRectRoundToScale(CGRect rect, CGFloat scale, NSRoundingMode mode) {
    rect.origin = CGPointRoundToScale(rect.origin, scale, mode);
    rect.size = CGSizeRoundToScale(rect.size, scale, mode);
    return rect;
}


CGFloat CGFloatRoundToScreenScale(CGFloat value) {
    return CGFloatRoundToScale(value, 0, NSRoundUp);
}


CGPoint CGPointRoundToScreenScale(CGPoint point) {
    return CGPointRoundToScale(point, 0, NSRoundUp);
}


CGSize CGSizeRoundToScreenScale(CGSize size) {
    return CGSizeRoundToScale(size, 0, NSRoundUp);
}


CGRect CGRectRoundToScreenScale(CGRect rect) {
    return CGRectRoundToScale(rect, 0, NSRoundUp);
}





#pragma mark Float


CGFloat CGFloatShareBetween(CGFloat minimum, CGFloat share, CGFloat maximum) {
    CGFloat delta = maximum - minimum;
    return (delta * share) + minimum;
}


CGFloat const UITouchMin = 44;


CGFloat const CGFloatInfinity = HUGE_VAL;





#pragma mark Edge Insets


UIEdgeInsets UIEdgeInsetsAddEdgeInsets(UIEdgeInsets a, UIEdgeInsets b) {
    UIEdgeInsets insets = {
        .top = a.top + b.top,
        .left = a.left + b.left,
        .right = a.right + b.right,
        .bottom = a.bottom + b.bottom,
    };
    return insets;
}






