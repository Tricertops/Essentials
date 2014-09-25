//
//  NSShadow+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 14.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSShadow+Essentials.h"





@implementation NSShadow (Essentials)





+ (instancetype)invisibleShadow {
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = nil;
    return shadow;
}


+ (instancetype)shadowWithOffset:(UIOffset)offset color:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(offset.horizontal, offset.vertical);
    CGFloat finalAlpha = CGColorGetAlpha(color.CGColor) * alpha;
    shadow.shadowColor = [color colorWithAlphaComponent:finalAlpha];
    shadow.shadowBlurRadius = radius;
    return shadow;
}



@end
