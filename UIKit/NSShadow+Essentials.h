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


@end
