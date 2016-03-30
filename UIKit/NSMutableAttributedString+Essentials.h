//
//  NSMutableAttributedString+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foundation+Essentials.h"
#import "NSAttributedString+Essentials.h"



@protocol ESSAttributable <NSObject>

ESSWriteOnlyProperty(ESSPassthrough(NSDictionary<NSString *, id> *), attributes);

/// Adds the attribute to the full range of string. Nil value removes the attribute.
- (void)setObject:(NSObject *)attributeValue forKeyedSubscript:(NSString *)attributeName;

/// Invokes block for paragraph style of the receiver.
- (void)updateParagraphStyleUsingBlock:(void (^)(NSMutableParagraphStyle *))block;

ESSWriteOnlyProperty(UIFont *, font); /// Default: System 12pt
ESSWriteOnlyProperty(NSString *, fontName); /// Setting replaces all fonts in string, preserving size.
ESSWriteOnlyProperty(CGFloat, fontSize); /// Setting replaces all fonts in string, preserving point size.
ESSWriteOnlyProperty(UIColor *, color); /// Default: Black
ESSWriteOnlyProperty(NSShadow *, shadow);
ESSWriteOnlyProperty(NSParagraphStyle *, paragraphStyle); /// Default: +defaultParagraphStyle

ESSWriteOnlyProperty(NSTextAlignment, alignment); /// Default: Natural
ESSWriteOnlyProperty(CGFloat, firstLineHeadIndent);
ESSWriteOnlyProperty(CGFloat, headIndent);
ESSWriteOnlyProperty(CGFloat, tailIndent);
ESSWriteOnlyProperty(CGFloat, lineHeightMultiple);
ESSWriteOnlyProperty(CGFloat, maximumLineHeight);
ESSWriteOnlyProperty(CGFloat, minimumLineHeight);
ESSWriteOnlyProperty(CGFloat, lineSpacing);
ESSWriteOnlyProperty(CGFloat, paragraphSpacing);
ESSWriteOnlyProperty(CGFloat, paragraphSpacingBefore);
ESSWriteOnlyProperty(NSArray <NSTextTab *> *, tabStops);
ESSWriteOnlyProperty(CGFloat, defaultTabInterval);
ESSWriteOnlyProperty(NSLineBreakMode, lineBreakMode); /// Default: Word Wrapping
ESSWriteOnlyProperty(CGFloat, hyphenationFactor);

ESSWriteOnlyProperty(BOOL, usesLigatures); /// Default: YES (default ligatures)
ESSWriteOnlyProperty(CGFloat, kerning); /// Zero uses default kerning.
ESSWriteOnlyProperty(BOOL, hasStrikethrough);
ESSWriteOnlyProperty(NSUnderlineStyle, strikethroughStyle);
ESSWriteOnlyProperty(BOOL, hasUnderline);
ESSWriteOnlyProperty(NSUnderlineStyle, underlineStyle);
ESSWriteOnlyProperty(CGFloat, strokeWidth); /// Preserves fill.
ESSWriteOnlyProperty(CGFloat, baselineOffset);
ESSWriteOnlyProperty(CGFloat, obliqueness);
ESSWriteOnlyProperty(CGFloat, expansion);

ESSWriteOnlyProperty(UIColor *, backgroundColor);
ESSWriteOnlyProperty(UIColor *, strokeColor); /// If different than text color.
ESSWriteOnlyProperty(UIColor *, underlineColor); /// If different than text color.
ESSWriteOnlyProperty(UIColor *, strikethroughColor); /// If different than text color.

ESSWriteOnlyProperty(BOOL, hasLetterpressEffect);
ESSWriteOnlyProperty(NSTextAttachment *, attachment);
ESSWriteOnlyProperty(NSURL *, link);

@end





@interface NSMutableAttributedString (Essentials) <ESSAttributable>



/// Returns proxy that can receive attribute settings and forwards them to the receiver for given range.
- (NSProxy<ESSAttributable> *)subrange:(NSRange)range;



#pragma mark Appending

/// Appends compatible string to the end.
- (void)append: (NSObject<ESSAttributedString> *)string;



#pragma mark Resizing

/// Reduces font size to fit into given size. Never smaller than minimum scale, returns the receiver.
- (NSAttributedString *)fitIntoSize:(CGSize)size minimumScaleFactor:(CGFloat)scale;



#pragma mark Enumerating

/// Enumerates paragraph styles in the receiver allowing you to modify it.
- (void)enumerateParagraphStyles:(void(^)(NSMutableParagraphStyle *paragraphStyle))block;


#pragma mark Superscript

/// Modifies attributes of the receiver in given range to make superscript effect with given scale that aligns ascenders.
- (void)applySuperscriptWithScale:(CGFloat)scale inRange:(NSRange)range;

/// Modifies attributes of the receiver in given range to make superscript effect with scale of 0.6
- (void)applySuperscriptInRange:(NSRange)range;

/// Uses superscript in all REGISTERED SIGN characters (®).
- (void)applySuperscriptForRegisteredSigns;


#pragma mark Subscript

/// Modifies attributes of the receiver in given range to make subscript effect with given scale that aligns descenders.
- (void)applySubscriptWithScale:(CGFloat)scale inRange:(NSRange)range;

/// Modifies attributes of the receiver in given range to make subscript effect with scale of 0.6
- (void)applySubscriptInRange:(NSRange)range;




@end










@interface NSString (Essentials_NSMutableAttributedString)



/// Allow you to set attributes of the string using block. Pass nil for no attributes.
- (NSMutableAttributedString *)attributed:(void (^)(NSMutableAttributedString *string))block;



@end


