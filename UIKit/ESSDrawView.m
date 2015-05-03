//
//  ESSDrawView.m
//  Essentials
//
//  Created by Martin Kiss on 3.5.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "ESSDrawView.h"





@interface ESSDrawView : UIView


@property (readonly) void (^drawRectBlock)(UIView *, CGRect);


@end





@implementation ESSDrawView





- (instancetype)initWithDrawRectBlock:(void (^)(UIView *view, CGRect rect))drawRect {
    self = [super initWithFrame: CGRectZero];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.opaque = NO;
        self->_drawRectBlock = drawRect;
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    if (self.drawRectBlock) self.drawRectBlock(self, rect);
}





@end





@implementation UIView (ESSDrawView)



+ (UIView *)viewWithDrawRect:(void (^)(UIView *, CGRect))drawRect {
    return [[ESSDrawView alloc] initWithDrawRectBlock: drawRect];
}



@end


