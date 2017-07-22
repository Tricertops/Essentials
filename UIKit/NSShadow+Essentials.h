//
//  NSShadow+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 14.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface NSShadow (Essentials)




#pragma mark Creation

/// Creates new instance that represents no shadow.
+ (instancetype)invisibleShadow;

/// Creates new instance with given values. Color is premultiplied by alpha.
+ (instancetype)shadowWithOffset:(UIOffset)offset color:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius;

/// Creates new instance with only vertical offset, black color of given alpha, and with blur radius.
+ (instancetype)shadowWithVerticalOffset:(CGFloat)offset alpha: (CGFloat)alpha radius:(CGFloat)radius;



#pragma mark Accessors

/// Converted accessor for .shadowOffset (CGSize)
@property IBInspectable UIOffset offset;

/// Typed accessor for .shadowColor (id)
@property IBInspectable UIColor *color;

/// Accessor for alpha channel of the color.
@property IBInspectable CGFloat alpha;

/// Alias for .shadowBlurRadius
@property IBInspectable CGFloat radius;



#pragma mark Visibility

/// Returns whether the shadow would be visible if drawn.
@property (readonly) BOOL isVisible;




@end
