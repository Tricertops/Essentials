//
//  ESSDrawView.m
//  Essentials
//
//  Created by Martin Kiss on 3.5.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "ESSDrawView.h"





@implementation ESSDrawView





- (void)setDrawRectBlock:(void (^)(UIView *, CGRect))drawRectBlock {
    self->_drawRectBlock = drawRectBlock;
    
    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect {
    if (self.drawRectBlock) self.drawRectBlock(self, rect);
}





@end





@implementation UIView (ESSDrawView)



+ (UIView *)viewWithDrawRect:(void (^)(UIView *, CGRect))drawRect {
    ESSDrawView *view = [ESSDrawView new];
    view.drawRectBlock = drawRect;
    return view;
}



@end


