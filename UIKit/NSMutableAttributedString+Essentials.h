//
//  NSMutableAttributedString+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+Essentials.h"





@interface NSMutableAttributedString (Essentials)



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



/// Returns new mutable attributed string created from the receiver and given attributes.
- (NSMutableAttributedString *)mutableAttributed:(NSDictionary<NSString *, id> *)attributes;



@end


