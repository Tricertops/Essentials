//
//  NSShadow+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 14.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSShadow+Essentials.h"





@implementation NSShadow (Essentials)





#pragma mark Creation


+ (instancetype)invisibleShadow {
    var shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = nil;
    return shadow;
}


+ (instancetype)shadowWithOffset:(UIOffset)offset color:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius {
    var shadow = [NSShadow new];
    shadow.offset = offset;
    shadow.color = color;
    shadow.alpha *= alpha;
    shadow.radius = radius;
    return shadow;
}


+ (instancetype)shadowWithVerticalOffset:(CGFloat)offset alpha: (CGFloat)alpha radius:(CGFloat)radius {
    var shadow = [NSShadow new];
    shadow.offset = UIOffsetMake(0, offset);
    shadow.color = UIColor.blackColor;
    shadow.alpha = alpha;
    shadow.radius = radius;
    return shadow;
}





#pragma mark Accessors


- (UIOffset)offset {
    return UIOffsetMake(self.shadowOffset.width, self.shadowOffset.height);
}


- (void)setOffset:(UIOffset)offset {
    self.shadowOffset = CGSizeMake(offset.horizontal, offset.vertical);
}


- (UIColor *)color {
    return self.shadowColor;
}


- (void)setColor:(UIColor *)color {
    self.shadowColor = color;
}


- (CGFloat)alpha {
    return CGColorGetAlpha(self.color.CGColor);
}


- (void)setAlpha:(CGFloat)alpha {
    self.color = [self.color colorWithAlphaComponent:alpha];
}


- (CGFloat)radius {
    return self.shadowBlurRadius;
}


- (void)setRadius:(CGFloat)radius {
    self.shadowBlurRadius = radius;
}





#pragma mark Visibility


- (BOOL)isVisible {
    if ( ! self.color) return NO;
    if (self.alpha <= 0) return NO;
    if (self.offset.horizontal == 0 && self.offset.vertical == 0 && self.radius == 0) return NO;
    return YES;
}



@end
