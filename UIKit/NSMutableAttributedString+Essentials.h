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


@end
