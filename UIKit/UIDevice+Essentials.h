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

/// Returns hardware identifier. Example: iPad5,2
- (NSString *)hardwareIdentifier;

/// Returns human-readable hardware name. Example: iPad Mini 4
- (NSString *)hardwareName;

/// Returns hardware line of products. Example: iPad Mini
- (NSString *)hardwareLine;

/// Returns hardware family of products. Example: iPad
- (NSString *)hardwareFamily;

/// Returns the number of CPU cores of the device.
- (NSUInteger)numberOfCores;

/// Returns YES only if size of pointer is at least 8 bytes. This means that your app needs to be 64-bit too.
- (BOOL)is64Bit;



#pragma mark Actions

/// Vibrates the device for short time.
- (void)vibrate;



#pragma mark - Idiom

/// Return YES on when idiom is Phone.
- (BOOL)iPhone;

/// Returns YES, if the device has features of iPhone X.
- (BOOL)iPhoneX;

/// Return YES on when idiom is Pad.
- (BOOL)iPad;

/// Returns the name of current idiom. Example: "iphone".
- (NSString *)idiomName;

/// Returns string used to identify resources on for current idiom. Example: "~iphone".
- (NSString *)resourceSuffix;

/// Returns resource string by appending resource suffix.
- (NSString *)resource:(NSString *)string;



#pragma mark Class Shorthands

/// These methods call corresponding instance methods on [UIDevice currentDevice] object.

+ (BOOL)iPhone;
+ (BOOL)iPhoneX;
+ (BOOL)iPad;
+ (NSString *)idiomName;
+ (NSString *)resourceSuffix;
+ (NSString *)resource:(NSString *)string;
+ (NSUInteger)numberOfCores;
+ (BOOL)is64Bit;
+ (void)vibrate;



@end
