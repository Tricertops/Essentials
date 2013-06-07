//
//  UIDevice+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface UIDevice (Essentials)




#pragma mark Hardware

/// Returns hardware model identifier. Example: iPhone5,2
- (NSString *)modelVersion;



#pragma mark - Idiom

/// Return YES on when idiom is Phone.
- (BOOL)iPhone;

/// Return YES on when idiom is Pad.
- (BOOL)iPad;

/// Returns the name of current idiom. Example: "iphone".
- (NSString *)idiomName;

/// Returns string used to identify resources on for current idiom. Example: "~iphone".
- (NSString *)resourceSuffix;

/// Returns resource string by appending resource suffix.
- (NSString *)resource:(NSString *)string;



#pragma mark Class Shorthands

+ (NSString *)modelVersion;
+ (BOOL)iPhone;
+ (BOOL)iPad;
+ (NSString *)idiomName;
+ (NSString *)resourceSuffix;
+ (NSString *)resource:(NSString *)string;



@end
