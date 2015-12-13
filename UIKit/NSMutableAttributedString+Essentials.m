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


- (void)applySuperscriptWithScale:(CGFloat)scale inRange:(NSRange)range {
    UIFont *existingFont = [self attribute:NSFontAttributeName atIndex:range.location effectiveRange:nil];
    ESSAssert(existingFont, @"Attributed string must have defined font in given range.") else return;
    
    UIFont *superscriptFont = [existingFont fontWithSize:existingFont.pointSize * scale];
    
    [self addAttribute:NSFontAttributeName
                 value:superscriptFont
                 range:range];
    
    [self addAttribute:NSBaselineOffsetAttributeName
                 value:@(existingFont.capHeight - superscriptFont.capHeight)
                 range:range];
}


- (void)applySuperscriptInRange:(NSRange)range {
    [self applySuperscriptWithScale:0.6 inRange:range];
}


- (void)applySuperscriptForRegisteredSigns {
    [self.string enumerateOccurencesOfString:@"®"
                                     options:kNilOptions
                                  usingBlock:^(NSString *match, NSRange range, BOOL *stop) {
                                      [self applySuperscriptInRange:range];
                                  }];
}





#pragma mark Subscript


- (void)applySubscriptWithScale:(CGFloat)scale inRange:(NSRange)range {
    UIFont *existingFont = [self attribute:NSFontAttributeName atIndex:range.location effectiveRange:nil];
    ESSAssert(existingFont, @"Attributed string must have defined font in given range.") else return;
    
    UIFont *subscriptFont = [existingFont fontWithSize:existingFont.pointSize * scale];
    
    [self addAttribute:NSFontAttributeName
                 value:subscriptFont
                 range:range];
    
    [self addAttribute:NSBaselineOffsetAttributeName
                 value:@(existingFont.descender - subscriptFont.descender)
                 range:range];
}


- (void)applySubscriptInRange:(NSRange)range {
    [self applySubscriptWithScale:0.6 inRange:range];
}





@end










@implementation NSString (Essentials_NSMutableAttributedString)



- (NSMutableAttributedString *)attributedStringWithFont:(UIFont *)font {
    return [[NSMutableAttributedString alloc] initWithString:self attributes:@{ NSFontAttributeName: font }];
}



@end


