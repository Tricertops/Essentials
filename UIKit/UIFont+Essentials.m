//
//  UIFont+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 14.5.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "UIFont+Essentials.h"





@implementation UIFont (Essentials)





+ (instancetype)lightSystemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}


+ (instancetype)thinSystemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
}


+ (instancetype)ultraLightSystemFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:size];
}





- (instancetype)fontWithAdjustedSizeBy:(CGFloat)increment {
    return [self fontWithSize:self.pointSize + increment];
}


- (instancetype)fontWithFeature:(UInt16)type selector:(UInt16)selector {
    NSArray<NSDictionary<NSString *, NSNumber *> *> *features = [self.fontDescriptor.fontAttributes objectForKey:UIFontDescriptorFeatureSettingsAttribute];
    NSMutableArray<NSDictionary<NSString *, NSNumber *> *> *mutableFeatures = [[NSMutableArray alloc] initWithArray:features];
    
    [mutableFeatures addObject:@{
                                 UIFontFeatureTypeIdentifierKey: @(type),
                                 UIFontFeatureSelectorIdentifierKey: @(selector),
                                 }];
    
    let descriptor = [self.fontDescriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorFeatureSettingsAttribute: mutableFeatures }];
    return [UIFont fontWithDescriptor:descriptor size:0];
}


- (instancetype)fontWithProportionalNumbers {
    return [self fontWithFeature:kNumberSpacingType selector:kProportionalNumbersSelector];
}


- (instancetype)fontWithAlternatePunctuation; {
    return [self fontWithFeature:kCharacterAlternativesType selector:1]; // Magic!
}





@end


