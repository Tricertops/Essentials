//
//  UIBezierPath+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 10.1.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIBezierPath (Essentials)



#pragma mark - Constructors

+ (instancetype)lineFrom:(CGPoint)start to:(CGPoint)end;
+ (instancetype)lineFrom:(CGPoint)start by:(CGPoint)delta;
+ (instancetype)rectangle:(CGRect)rect;
+ (instancetype)rectangle:(CGRect)rect corners:(CGFloat)radius;
+ (instancetype)oval:(CGRect)rect;
+ (instancetype)circleAround:(CGPoint)center radius:(CGFloat)radius;

+ (instancetype)combinedPathFromPaths:(NSArray*)paths;


#pragma mark - Moves

- (void)moveTo:(CGPoint)point;
- (void)moveXTo:(CGFloat)x;
- (void)moveYTo:(CGFloat)y;
- (void)moveBy:(CGPoint)point;
- (void)moveXBy:(CGFloat)x;
- (void)moveYBy:(CGFloat)y;


#pragma mark - Lines

- (void)lineTo:(CGPoint)point;
- (void)lineToX:(CGFloat)x;
- (void)lineToY:(CGFloat)y;
- (void)lineBy:(CGPoint)point;
- (void)lineByX:(CGFloat)x;
- (void)lineByY:(CGFloat)y;


#pragma mark - Stroking & Filling

- (void)stroke:(UIColor *)color;
- (void)stroke:(UIColor *)color width:(CGFloat)width;
- (void)fill:(UIColor *)color;
- (void)fill:(UIColor *)color evenOdd:(BOOL)evenOdd;



@end


