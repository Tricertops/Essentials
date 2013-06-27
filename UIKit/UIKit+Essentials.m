//
//  UIKit+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 27.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"





#pragma mark Rectangle


extern CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


extern CGRect CGRectMakeSize(CGSize size) {
    return CGRectMakeOriginSize(CGPointZero, size);
}


extern CGRect CGRectMakeOrigin(CGPoint origin) {
    return CGRectMakeOriginSize(origin, CGSizeZero);
}


extern CGRect CGRectMakeOriginSize(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}





#pragma mark Rounding


extern CGFloat CGFloatRoundToScale(CGFloat value, CGFloat scale, NSRoundingMode mode) {
    CGFloat (*function)(CGFloat);
    switch (mode) {
        case NSRoundPlain:   function = &roundf; break;
        case NSRoundUp:      function = &ceilf; break;
        case NSRoundDown:    function = &floorf; break;
        case NSRoundBankers: function = &roundf; break;
    }
    if ( ! scale) scale = [[UIScreen mainScreen] scale];
    CGFloat result = function(value * scale) / scale;
    return result;
}


extern CGPoint CGPointRoundToScale(CGPoint point, CGFloat scale, NSRoundingMode mode) {
    point.x = CGFloatRoundToScale(point.x, scale, mode);
    point.y = CGFloatRoundToScale(point.y, scale, mode);
    return point;
}


extern CGSize CGSizeRoundToScale(CGSize size, CGFloat scale, NSRoundingMode mode) {
    size.width = CGFloatRoundToScale(size.width, scale, mode);
    size.height = CGFloatRoundToScale(size.height, scale, mode);
    return size;
}


extern CGRect CGRectRoundToScale(CGRect rect, CGFloat scale, NSRoundingMode mode) {
    rect.origin = CGPointRoundToScale(rect.origin, scale, mode);
    rect.size = CGSizeRoundToScale(rect.size, scale, mode);
    return rect;
}




extern CGFloat CGFloatRoundToScreenScale(CGFloat value) {
    return CGFloatRoundToScale(value, 0, NSRoundUp);
}


extern CGPoint CGPointRoundToScreenScale(CGPoint point) {
    return CGPointRoundToScale(point, 0, NSRoundUp);
}


extern CGSize CGSizeRoundToScreenScale(CGSize size) {
    return CGSizeRoundToScale(size, 0, NSRoundUp);
}


extern CGRect CGRectRoundToScreenScale(CGRect rect) {
    return CGRectRoundToScale(rect, 0, NSRoundUp);
}


