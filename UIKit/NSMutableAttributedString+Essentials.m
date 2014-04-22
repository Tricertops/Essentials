//
//  NSMutableAttributedString+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSMutableAttributedString+Essentials.h"
#import "Foundation+Essentials.h"





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
                      NSMutableParagraphStyle *mutableParagraphStyle = [(paragraphStyle ?: [NSParagraphStyle defaultParagraphStyle]) mutableCopy];
                      block(mutableParagraphStyle);
                      [self addAttribute:NSParagraphStyleAttributeName
                                   value:[mutableParagraphStyle copy]
                                   range:range];
                  }];
}




#pragma mark Superscript


- (void)applySuperscriptInRange:(NSRange)range {
    // Values taken empirically from Pages 5.1
    
    UIFont *existingFont = [self attribute:NSFontAttributeName atIndex:range.location effectiveRange:nil];
    ESSAssert(existingFont, @"Attributed string must have defined font in given range.") return;
    
    [self addAttribute:NSFontAttributeName
                 value:[existingFont fontWithSize:existingFont.pointSize / 1.5]
                 range:range];
    
    [self addAttribute:NSBaselineOffsetAttributeName
                 value:@(existingFont.pointSize * 0.26)
                 range:range];
}


- (void)applySuperscriptForRegisteredSigns {
    [self.string enumerateOccurencesOfString:@"®"
                                     options:kNilOptions
                                  usingBlock:^(NSString *match, NSRange range, BOOL *stop) {
                                      [self applySuperscriptInRange:range];
                                  }];
}





@end










@implementation NSString (Essentials_NSMutableAttributedString)



- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font {
    return [[NSMutableAttributedString alloc] initWithString:self attributes:@{ NSFontAttributeName: font }];
}



@end


