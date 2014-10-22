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





CGAffineTransform CGAffineTransformMakeScaleRotateTranslate(CGFloat scale, CGFloat rotation, UIOffset translation) {
    return CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformMakeTranslation(translation.horizontal, translation.vertical), scale, scale), rotation);
}


CGAffineTransform CGAffineTransformCombine(CGPoint translation, CGSize scale, CGFloat degrees) {
    return CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformMakeTranslation(translation.x, translation.y), scale.width, scale.height), CGRadians(degrees));
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





#pragma mark Points


CGPoint CGPointAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}


CGPoint CGPointSubtract(CGPoint a, CGPoint b) {
    return CGPointAdd(a, CGPointMultiply(b, -1));
}


CGPoint CGPointMultiply(CGPoint p, CGFloat f) {
    return CGScalePoint(p, CGSizeMake(f, f));
}


CGFloat CGPointDistanceToPoint(CGPoint a, CGPoint b) {
    return CGPointDistance(CGPointSubtract(a, b));
}


CGFloat CGPointDistance(CGPoint p) {
    return sqrt(p.x * p.x + p.y * p.y);
}





#pragma mark Sizes & Scales


CGSize const CGScaleIdentity = (CGSize){.width =  1, .height =  1};
CGSize const CGScaleFlipX    = (CGSize){.width = -1, .height =  1};
CGSize const CGScaleFlipY    = (CGSize){.width =  1, .height = -1};
CGSize const CGScaleFlipBoth = (CGSize){.width = -1, .height = -1};


CGPoint CGScalePoint(CGPoint p, CGSize s) {
    return CGPointMake(p.x * s.width, p.y * s.height);
}


CGSize CGScaleSize(CGSize a, CGSize b) {
    return CGSizeMake(a.width * b.width, a.height * a.height);
}


CGSize CGScaleInvert(CGSize s) {
    return CGSizeMake(1/s.width, 1/s.height);
}


CGFloat CGScaleMean(CGSize s) {
    return sqrtf(s.width * s.height);
}


CGSize CGSizeMultiply(CGSize s, CGFloat f) {
    return CGScaleSize(s, CGSizeMake(f, f));
}


CGSize CGSizeRotate(CGSize s, CGFloat r) {
    CGFloat sine = sin(r);
    CGFloat cosine = cos(r);
    return CGSizeMake(s.width  * cosine - s.height * sine,
                      s.height * cosine - s.width  * sine);
}


CGSize CGSizeUnrotate(CGSize rotated, CGFloat angle) {
    CGFloat sine = sin(angle);
    CGFloat cosine = cos(angle);
    CGFloat k = (cosine * cosine - sine * sine);
    CGSize unrotated = CGSizeMake(rotated.height * cosine + rotated.width  * sine,
                                  rotated.width  * cosine + rotated.height * sine);
    return CGSizeMultiply(unrotated, 1/k);
}





#pragma mark Angles


CGFloat CGDegrees(CGFloat radians) {
    return radians / M_PI * 180;
}


CGFloat CGRadians(CGFloat degrees) {
    return degrees / 180 * M_PI;
}





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






