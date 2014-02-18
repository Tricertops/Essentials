//
//  NSMutableAttributedString+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NSMutableAttributedString (Essentials)



#pragma mark Resizing

/// Reduces font size to fit into given size. Never smaller than minimum scale, returns the receiver.
- (NSAttributedString *)fitIntoSize:(CGSize)size minimumScaleFactor:(CGFloat)scale;



#pragma mark Enumerating

/// Enumerates paragraph styles in the receiver allowing you to modify it.
- (void)enumerateParagraphStyles:(void(^)(NSMutableParagraphStyle *paragraphStyle))block;


#pragma mark Superscript

/// Modifies attributes of the receiver in given range to make superscript effect just like in Pages.app
- (void)applySuperscriptInRange:(NSRange)range;

/// Uses superscript in all REGISTERED SIGN characters (®).
- (void)applySuperscriptForRegisteredSigns;




@end
