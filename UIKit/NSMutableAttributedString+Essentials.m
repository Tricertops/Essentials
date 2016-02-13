//
//  NSMutableAttributedString+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSMutableAttributedString+Essentials.h"
#import "Foundation+Essentials.h"





@interface ESSSubrangeProxyMutableAttributedString : NSMutableAttributedString

- (instancetype)initWithTarget:(NSMutableAttributedString *)target range:(NSRange)range;
@property (readonly, weak) NSMutableAttributedString *target;
@property (readonly) NSRange range;

@end





@implementation NSMutableAttributedString (Essentials)





#pragma mark Attributes


- (NSProxy<ESSAttributable> *)subrange:(NSRange)range {
    return (id)[[ESSSubrangeProxyMutableAttributedString alloc] initWithTarget:self range:range];
}


- (void)setAttributes:(NSDictionary<NSString *,id> *)attributes {
    [self setAttributes:attributes range:self.fullRange];
}


- (void)setObject:(NSObject *)value forKeyedSubscript:(NSString *)name {
    if (value) {
        [self addAttribute:name value:value range:self.fullRange];
    }
    else {
        [self removeAttribute:name range:self.fullRange];
    }
}


- (void)updateParagraphStyleUsingBlock:(void (^)(NSMutableParagraphStyle *))block
{
    if ( ! self.length) return;
    
    NSParagraphStyle *immutable = [self attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil] ?: [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle *mutable = [immutable mutableCopy];
    block(mutable);
    self.paragraphStyle = mutable;
}


- (void)setFont:(UIFont *)font {
    self[NSFontAttributeName] = font;
}

- (void)setColor:(UIColor *)color {
    self[NSForegroundColorAttributeName] = color;
}

- (void)setShadow:(NSShadow *)shadow {
    self[NSShadowAttributeName] = shadow;
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    self[NSParagraphStyleAttributeName] = [paragraphStyle copy];
}


- (void)setAlignment:(NSTextAlignment)alignment {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.alignment = alignment;
    }];
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.firstLineHeadIndent = firstLineHeadIndent;
    }];
}

- (void)setHeadIndent:(CGFloat)headIndent {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.headIndent = headIndent;
    }];
}

- (void)setTailIndent:(CGFloat)tailIndent {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.tailIndent = tailIndent;
    }];
}

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.lineHeightMultiple = lineHeightMultiple;
    }];
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.maximumLineHeight = maximumLineHeight;
    }];
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.minimumLineHeight = minimumLineHeight;
    }];
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.lineSpacing = lineSpacing;
    }];
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.paragraphSpacing = paragraphSpacing;
    }];
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.paragraphSpacingBefore = paragraphSpacingBefore;
    }];
}

- (void)setTabStops:(NSArray<NSTextTab *> *)tabStops {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.tabStops = tabStops;
    }];
}

- (void)setDefaultTabInterval:(CGFloat)defaultTabInterval {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.defaultTabInterval = defaultTabInterval;
    }];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.lineBreakMode = lineBreakMode;
    }];
}

- (void)setHyphenationFactor:(CGFloat)hyphenationFactor {
    [self updateParagraphStyleUsingBlock:^(NSMutableParagraphStyle* paragraph) {
        paragraph.hyphenationFactor = hyphenationFactor;
    }];
}


- (void)setUsesLigatures:(BOOL)usesLigatures {
    self[NSLigatureAttributeName] = @(usesLigatures? 1 : 0);
}

- (void)setKerning:(CGFloat)kerning {
    self[NSKernAttributeName] = (kerning? @(kerning) : nil);
}

- (void)setHasStrikethrough:(BOOL)hasStrikethrough {
    self.strikethroughStyle = NSUnderlineStyleSingle;
}

- (void)setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    self[NSStrikethroughStyleAttributeName] = @(strikethroughStyle);
}

- (void)setHasUnderline:(BOOL)hasUnderline {
    self.underlineStyle = NSUnderlineStyleSingle;
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle {
    self[NSUnderlineStyleAttributeName] = @(underlineStyle);
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    /// Negative stroke width preserves fill.
    self[NSStrokeWidthAttributeName] = @(-ABS(strokeWidth));
}

- (void)setBaselineOffset:(CGFloat)baselineOffset {
    self[NSBaselineOffsetAttributeName] = @(baselineOffset);
}

- (void)setExpansion:(CGFloat)expansion {
    self[NSExpansionAttributeName] = @(expansion);
}

- (void)setObliqueness:(CGFloat)obliqueness {
    self[NSObliquenessAttributeName] = @(obliqueness);
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self[NSBackgroundColorAttributeName] = backgroundColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    self[NSStrokeColorAttributeName] = strokeColor;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    self[NSUnderlineColorAttributeName] = underlineColor;
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor {
    self[NSStrikethroughColorAttributeName] = strikethroughColor;
}


- (void)setHasLetterpressEffect:(BOOL)hasLetterpressEffect {
    self[NSTextEffectAttributeName] = (hasLetterpressEffect? NSTextEffectLetterpressStyle : nil);
}

- (void)setAttachment:(NSTextAttachment *)attachment {
    self[NSAttachmentAttributeName] = attachment;
}

- (void)setLink:(NSURL *)link {
    self[NSLinkAttributeName] = link;
}






#pragma mark Appending


- (void)append: (NSObject<ESSAttributedString> *)string {
    NSAttributedString *attributedString = string.ess_attributedString;
    if ( ! attributedString) return;
    
    [self appendAttributedString:attributedString];
}





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



- (NSMutableAttributedString *)attributed:(void (^)(NSMutableAttributedString *))block {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    if (block) block(string);
    return string;
}


@end










@implementation ESSSubrangeProxyMutableAttributedString



- (instancetype)initWithTarget:(NSMutableAttributedString *)target range:(NSRange)range {
    self = [super init]; /// Cannot instantiate super. Foundation is hacking against us.
    if (self) {
        self->_target = target;
        self->_range = range;
    }
    return self;
}


- (NSAttributedString *)targetSubstring {
    return [self.target attributedSubstringFromRange:self.range];
}


- (void)convertToTarget:(NSRangePointer)range {
    if ( ! range) return;
    
    ESSAssert(range->location < self.length)
    else range->location = self.length;
    
    ESSAssert(range->location + range->length <= self.length)
    else range->length = self.length - range->location;
    
    range->location += self.range.location;
}

- (void)convertFromTarget:(NSRangePointer)range {
    if ( ! range) return;
    
    range->location -= self.range.location;
    range->length = MIN(range->length, self.length);
}


/// This proxy doesn’t support partial editing.


- (NSString *)string {
    return [self.target.string substringWithRange:self.range];
}


- (NSUInteger)length {
    return self.range.length;
}


- (NSDictionary<NSString *,id> *)attributesAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)effectiveRange {
    NSDictionary<NSString *,id> *attributes = [self.target attributesAtIndex:index - self.range.location
                                                              effectiveRange:effectiveRange];
    [self convertFromTarget:effectiveRange];
    return attributes;
}


- (NSDictionary<NSString *,id> *)attributesAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)effectiveRange inRange:(NSRange)rangeLimit {
    [self convertToTarget:&rangeLimit];
    NSDictionary<NSString *,id> *attributes = [super attributesAtIndex:index - self.range.location
                                                 longestEffectiveRange:effectiveRange
                                                               inRange:rangeLimit];
    [self convertFromTarget:effectiveRange];
    return attributes;
}


- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index effectiveRange:(NSRangePointer)effectiveRange {
    id attributes = [self.target attribute:attributeName
                                   atIndex:index - self.range.location
                            effectiveRange:effectiveRange];
    [self convertFromTarget:effectiveRange];
    return attributes;
}


- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)effectiveRange inRange:(NSRange)rangeLimit {
    [self convertToTarget:&rangeLimit];
    id attributes = [self.target attribute:attributeName
                                   atIndex:index - self.range.location
                     longestEffectiveRange:effectiveRange
                                   inRange:rangeLimit];
    [self convertFromTarget:effectiveRange];
    return attributes;
}


- (NSUInteger)hash {
    return self.targetSubstring.hash;
}


- (BOOL)isEqual:(id)other {
    return [self.targetSubstring isEqual:other];
}


- (BOOL)isEqualToAttributedString:(NSAttributedString *)other {
    return [self.targetSubstring isEqualToAttributedString:other];
}


- (NSAttributedString *)attributedSubstringFromRange:(NSRange)range {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    return self.targetSubstring;
}


- (void)enumerateAttribute:(NSString *)attributeName inRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)options usingBlock:(void (^)(id, NSRange, BOOL *))block {
    [self convertToTarget:&enumerationRange];
    [self.target enumerateAttribute:attributeName
                            inRange:enumerationRange
                            options:options
                         usingBlock:^(id value, NSRange range, BOOL *stop) {
                             [self convertFromTarget:&range];
                             block(value, range, stop);
                         }];
}


- (void)enumerateAttributesInRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)options usingBlock:(void (^)(NSDictionary<NSString *,id> *, NSRange, BOOL *))block {
    [self convertToTarget:&enumerationRange];
    [self.target enumerateAttributesInRange:enumerationRange
                                    options:options
                                 usingBlock:^(NSDictionary<NSString *,id> * attributes, NSRange range, BOOL *stop) {
                                     [self convertFromTarget:&range];
                                     block(attributes, range, stop);
                                 }];
}


- (NSMutableString *)mutableString {
    ESSFail();
    return [self.string mutableCopy];
}


- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    [self.target replaceCharactersInRange:self.range withString:string];
    self->_range.length = string.length;
}

- (void)deleteCharactersInRange:(NSRange)range {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    [self.target deleteCharactersInRange:self.range];
    self->_range.length = 0;
}

- (void)setAttributes:(NSDictionary<NSString *,id> *)attributes range:(NSRange)range {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    [self.target setAttributes:attributes range:self.range];
}

- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    [self.target addAttribute:name value:value range:self.range];
}

- (void)addAttributes:(NSDictionary<NSString *,id> *)attributes range:(NSRange)range {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    [self.target addAttributes:attributes range:self.range];
}

- (void)removeAttribute:(NSString *)name range:(NSRange)range {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    [self.target removeAttribute:name range:self.range];
}

- (void)appendAttributedString:(NSAttributedString *)attributed {
    [self insertAttributedString:attributed atIndex:self.length];
}

- (void)insertAttributedString:(NSAttributedString *)attributed atIndex:(NSUInteger)index {
    ESSAssert(index == self.length);
    [self.target insertAttributedString:attributed atIndex:NSRangeFollowingIndex(self.range)];
    self->_range.length += attributed.length;
}

- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attributed {
    ESSAssert(NSRangeEqual(range, self.fullRange));
    [self.target replaceCharactersInRange:self.range withAttributedString:attributed];
    self->_range.length = attributed.length;
}

- (void)setAttributedString:(NSAttributedString *)attributed {
    [self.target replaceCharactersInRange:self.range withAttributedString:attributed];
    self->_range.length = attributed.length;
}





@end


