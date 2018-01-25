//
//  UIFont+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 14.5.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"
#import <CoreText/SFNTLayoutTypes.h>





@interface UIFont (Essentials)



+ (instancetype)lightSystemFontOfSize:(CGFloat)size;
+ (instancetype)thinSystemFontOfSize:(CGFloat)size;
+ (instancetype)ultraLightSystemFontOfSize:(CGFloat)size;

- (instancetype)fontWithAdjustedSizeBy:(CGFloat)increment;
- (instancetype)fontWithFeature:(UInt16)type selector:(UInt16)selector;
- (instancetype)fontWithProportionalNumbers;
- (instancetype)fontWithAlternatePunctuation;



@end


