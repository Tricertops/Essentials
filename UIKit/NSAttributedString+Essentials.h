//
//  NSAttributedString+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NSAttributedString (Essentials)



#pragma mark Resizing

/// Returns a copy of the receiver whose font size is adjusted to fit into given size. Never smaller than minimum scale.
- (NSAttributedString *)attributedStringByFittingIntoSize:(CGSize)size minimumScaleFactor:(CGFloat)minimumScale;



@end
