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
#import "UITableView+Essentials.h"
#import "UIFont+Essentials.h"





#pragma mark Rectangle


/// Returns center of the rectangle.
extern CGPoint CGRectGetCenter(CGRect);


/// Returns any point in rectangle using relative point.
extern CGPoint CGRectGetPoint(CGRect rect, CGFloat relativeX, CGFloat relativeY);


/// Make rectangle using size. Zero origin.
extern CGRect CGRectMakeSize(CGSize);


/// Make rectangle using origin. Zero size.
extern CGRect CGRectMakeOrigin(CGPoint);


/// Make rectangle using origin and size.
extern CGRect CGRectMakeOriginSize(CGPoint, CGSize);





#pragma mark Affine Transform


extern CGAffineTransform CGAffineTransformMakeScaleRotateTranslate(CGFloat scale, CGFloat rotation, UIOffset translation) __deprecated;
extern CGAffineTransform CGAffineTransformCombine(CGPoint translation, CGSize scale, CGFloat degrees);





#pragma mark Rounding


/// Round values to givun scale (pass 0 for screen scale) using given rounsing mode. NSRoundBankers is not supported, and uses NSRoundPlain
extern CGFloat CGFloatRoundToScale(CGFloat value, CGFloat scale, NSRoundingMode mode);
extern CGPoint CGPointRoundToScale(CGPoint point, CGFloat scale, NSRoundingMode mode);
extern CGSize CGSizeRoundToScale(CGSize size, CGFloat scale, NSRoundingMode mode);
extern CGRect CGRectRoundToScale(CGRect rect, CGFloat scale, NSRoundingMode mode);


/// Reound values to screen scale using NSRoundUp.
extern CGFloat CGFloatRoundToScreenScale(CGFloat);
extern CGPoint CGPointRoundToScreenScale(CGPoint);
extern CGSize CGSizeRoundToScreenScale(CGSize);
extern CGRect CGRectRoundToScreenScale(CGRect);





#pragma mark Floats


/// Returns value between edge-points in given share.
extern CGFloat CGFloatShareBetween(CGFloat minimum, CGFloat share, CGFloat maximum);


/// Minimal touch size for UIKit components: 44 points.
extern CGFloat const UITouchMin;


/// Should be infinity, uses HUGE_VAL.
extern CGFloat const CGFloatInfinity;





#pragma mark Points


/// Returns new point as a sum of the arguments.
extern CGPoint CGPointAdd(CGPoint, CGPoint);

/// Returns new point as a difference of the arguments.
extern CGPoint CGPointSubtract(CGPoint, CGPoint);

/// Returns new point as a fraction of the argument.
extern CGPoint CGPointMultiply(CGPoint, CGFloat);

/// Calculates distance between points.
extern CGFloat CGPointDistanceToPoint(CGPoint, CGPoint);

/// Calculates distance from this point to zero.
extern CGFloat CGPointDistance(CGPoint);





#pragma mark Sizes & Scales


/// Scale of {1, 1}
extern CGSize const CGScaleIdentity;
/// Scale of {-1, 1}
extern CGSize const CGScaleFlipX;
/// Scale of {1, -1}
extern CGSize const CGScaleFlipY;
/// Scale of {-1, -1}
extern CGSize const CGScaleFlipBoth;

/// Returns new point multiplied by the size.
extern CGPoint CGScalePoint(CGPoint, CGSize);

/// Multiplies two sizes.
extern CGSize CGScaleSize(CGSize, CGSize);

/// Returns new inverted scale.
extern CGSize CGScaleInvert(CGSize);

/// Returns scalar as a geometric average of both scales.
extern CGFloat CGScaleMean(CGSize);

/// Multiplies the size by given number.
extern CGSize CGSizeMultiply(CGSize, CGFloat);

/// Calculates enclosing size of rotated size.
extern CGSize CGSizeRotate(CGSize, CGFloat);

/// Calculates original size that was rotated. Inverse of CGSizeRotate().
extern CGSize CGSizeUnrotate(CGSize, CGFloat);





#pragma mark Angles

/// Converts radiands to degrees.
extern CGFloat CGDegrees(CGFloat radians);

/// Converts degrees to radiands.
extern CGFloat CGRadians(CGFloat degrees);





#pragma mark Edge Insets


/// Use to sum up two edge insets.
extern UIEdgeInsets UIEdgeInsetsAddEdgeInsets(UIEdgeInsets, UIEdgeInsets);





#pragma mark Autoresizing

enum : NSUInteger {
    
    /// Combination of all four margins.
    UIViewAutoresizingFlexibleMargins = (UIViewAutoresizingFlexibleTopMargin
                                         | UIViewAutoresizingFlexibleBottomMargin
                                         | UIViewAutoresizingFlexibleLeftMargin
                                         | UIViewAutoresizingFlexibleRightMargin),
    
    
    /// Combination of both dimensions.
    UIViewAutoresizingFlexibleSize = (UIViewAutoresizingFlexibleWidth
                                      | UIViewAutoresizingFlexibleHeight),
    
    
    /// Combination of all autoresizing values.
    UIViewAutoresizingFlexibleAll = (UIViewAutoresizingFlexibleSize
                                     | UIViewAutoresizingFlexibleMargins),
    
};






