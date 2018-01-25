//
//  UIBezierPath+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 10.1.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIBezierPath+Essentials.h"
#import "UIKit+Essentials.h"



@implementation UIBezierPath (Essentials)



- (CGRect)pathBounds {
    return CGPathGetPathBoundingBox(self.CGPath);
}

- (CGRect)controlBounds {
    return CGPathGetBoundingBox(self.CGPath);
}



#pragma mark - Constructors


+ (instancetype)lineFrom:(CGPoint)start to:(CGPoint)end {
    UIBezierPath *line = [self new];
    [line moveToPoint:start];
    [line addLineToPoint:end];
    return line;
}


+ (instancetype)lineFrom:(CGPoint)start by:(CGPoint)delta {
    UIBezierPath *line = [self new];
    [line moveToPoint:start];
    [line addLineToPoint:CGPointAdd(start, delta)];
    return line;
}


+ (instancetype)rectangle:(CGRect)rect {
    return [self bezierPathWithRect:rect];
}


+ (instancetype)rectangle:(CGRect)rect corners:(CGFloat)radius {
    return [self bezierPathWithRoundedRect:rect cornerRadius:radius];
}


+ (instancetype)oval:(CGRect)rect {
    return [self bezierPathWithOvalInRect:rect];
}


+ (instancetype)circleAround:(CGPoint)center radius:(CGFloat)radius {
    return [self bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
}


+ (instancetype)combinedPathFromPaths:(NSArray<UIBezierPath *> *)paths {
    UIBezierPath *path = [self new];
    foreach (subpath, paths) {
        [path appendPath:subpath];
    }
    return path;
}





#pragma mark - Moves


- (void)moveTo:(CGPoint)point {
    [self moveToPoint:point];
}


- (void)moveXTo:(CGFloat)x {
    [self moveToPoint:CGPointMake(x, self.currentPoint.y)];
}


- (void)moveYTo:(CGFloat)y {
    [self moveToPoint:CGPointMake(self.currentPoint.x, y)];
}


- (void)moveBy:(CGPoint)point {
    [self moveToPoint:CGPointAdd(self.currentPoint, point)];
}


- (void)moveXBy:(CGFloat)x {
    [self moveToPoint:CGPointAdd(self.currentPoint, CGPointMake(x, 0))];
}


- (void)moveYBy:(CGFloat)y {
    [self moveToPoint:CGPointAdd(self.currentPoint, CGPointMake(0, y))];
}





#pragma mark - Lines


- (void)lineTo:(CGPoint)point {
    [self addLineToPoint:point];
}


- (void)lineToX:(CGFloat)x {
    [self addLineToPoint:CGPointMake(x, self.currentPoint.y)];
}


- (void)lineToY:(CGFloat)y {
    [self addLineToPoint:CGPointMake(self.currentPoint.x, y)];
}


- (void)lineBy:(CGPoint)point {
    [self addLineToPoint:CGPointAdd(self.currentPoint, point)];
}


- (void)lineByX:(CGFloat)x {
    [self addLineToPoint:CGPointAdd(self.currentPoint, CGPointMake(x, 0))];
}


- (void)lineByY:(CGFloat)y {
    [self addLineToPoint:CGPointAdd(self.currentPoint, CGPointMake(0, y))];
}





#pragma mark - Transform


- (void)rotateBy:(CGFloat)radians clockwise:(BOOL)clockwise {
    /// In iOS, a positive value specifies counterclockwise rotation and a negative value specifies clockwise rotation.
    if (clockwise) radians *= -1;
    [self applyTransform:CGAffineTransformMakeRotation(radians)];
}


- (void)scaleBy:(CGSize)scale {
    [self applyTransform:CGAffineTransformMakeScale(scale.width, scale.height)];
}


- (void)translateBy:(CGPoint)offset {
    [self applyTransform:CGAffineTransformMakeTranslation(offset.x, offset.y)];
}





#pragma mark - Stroking & Filling


- (void)stroke:(UIColor *)color {
    [self stroke:color width:self.lineWidth];
}


- (void)stroke:(UIColor *)color width:(CGFloat)width {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGFloat previousWidth = self.lineWidth;
    self.lineWidth = width;
    [color setStroke];
    [self stroke];
    self.lineWidth = previousWidth;
    CGContextRestoreGState(context);
}


- (void)fill:(UIColor *)color {
    [self fill:color evenOdd:self.usesEvenOddFillRule];
}


- (void)fill:(UIColor *)color evenOdd:(BOOL)evenOdd {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    BOOL previousEvenOdd = self.usesEvenOddFillRule;
    self.usesEvenOddFillRule = evenOdd;
    [color setFill];
    [self fill];
    self.usesEvenOddFillRule = previousEvenOdd;
    CGContextRestoreGState(context);
}





@end


