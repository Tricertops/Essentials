//
//  NSAttributedString+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 20.8.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import "NSAttributedString+Essentials.h"
#import "NSMutableAttributedString+Essentials.h"



@implementation NSAttributedString (Essentials)





#pragma mark Resizing


- (NSAttributedString *)attributedStringByFittingIntoSize:(CGSize)size minimumScaleFactor:(CGFloat)scale {
    return [[self mutableCopy] fitIntoSize:size minimumScaleFactor:scale];
}





@end

