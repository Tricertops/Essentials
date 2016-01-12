//
//  NSAttributedString+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ESSAttributedString
- (NSAttributedString *)ess_attributedString;
@end





@interface NSAttributedString (Essentials) <ESSAttributedString>



#pragma mark - Range

/// Range covering all characters of the receiver.
@property (readonly) NSRange fullRange;



#pragma mark Resizing

/// Returns a copy of the receiver whose font size is adjusted to fit into given size. Never smaller than minimum scale.
- (NSAttributedString *)attributedStringByFittingIntoSize:(CGSize)size minimumScaleFactor:(CGFloat)minimumScale;



@end





@interface NSString (NSAttributedString_Essentials) <ESSAttributedString>


/// Returns new attributed string created from the receiver and given attributes.
- (NSAttributedString *)attributed:(NSDictionary<NSString *, NSObject *> *)attributes;

/// Returns new attributed string created from the receiver with given font and color.
- (NSAttributedString *)withFont:(UIFont *)font color:(UIColor *)color;


@end


