//
//  NSMutableAttributedString+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSMutableAttributedString+Essentials.h"



@implementation NSMutableAttributedString (Essentials)





#pragma mark Resizing


- (NSAttributedString *)fitIntoSize:(CGSize)size minimumScaleFactor:(CGFloat)scale {
    NSStringDrawingContext *drawingSettings = [[NSStringDrawingContext alloc] init];
    drawingSettings.minimumScaleFactor = scale;
    [self boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       context:drawingSettings];
    
    if (drawingSettings.actualScaleFactor != 1) {        
        [self enumerateAttribute:NSFontAttributeName
                         inRange:NSMakeRange(0, self.length)
                         options:kNilOptions
                      usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
                          [self addAttribute:NSFontAttributeName
                                       value:[font fontWithSize:(font.pointSize * drawingSettings.actualScaleFactor)]
                                       range:range];
                      }];
    }
    
    return self;
}





#pragma mark Enumerating


- (void)enumerateParagraphStyles:(void(^)(NSMutableParagraphStyle *paragraphStyle))block {
    [self enumerateAttribute:NSParagraphStyleAttributeName
                     inRange:NSMakeRange(0, self.length)
                     options:kNilOptions
                  usingBlock:^(NSParagraphStyle *paragraphStyle, NSRange range, BOOL *stop) {
                      NSMutableParagraphStyle *mutableParagraphStyle = [paragraphStyle mutableCopy];
                      block(mutableParagraphStyle);
                      [self addAttribute:NSParagraphStyleAttributeName
                                   value:[mutableParagraphStyle copy]
                                   range:range];
                  }];
}





@end
