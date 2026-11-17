//
//  NSLocale+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 8.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"





@interface NSLocale (Essentials)




#pragma mark - Identifier Accessors

//! Alias for .localeIdentifier
@property (readonly) NSString *identifier;

//! Returns all component defined in the receiver.
@property (readonly) NSDictionary<NSString *, id> *components;



#pragma mark - Language Accessors

//! Language name for standardized locale.
@property (readonly) NSString *languageName;
//! Name of language in given locale. Pass nil for standardized locale.
- (NSString *)languageNameInLocale:(NSLocale *)localeOrNil;

//! Country name for standardized locale.
@property (readonly) NSString *countryName;
//! Name of country in given locale. Pass nil for standardized locale.
- (NSString *)countryNameInLocale:(NSLocale *)localeOrNil;


#pragma mark - Calendar Accessors

//! Calendar for key NSLocaleCalendar.
@property (readonly) NSCalendar *calendar;


#pragma mark - Measurement Acessors

//! String for key NSLocaleMeasurementSystem, “Metric”, “U.S.” or “U.K.”
@property (readonly) NSString *measurementSystem;


#pragma mark - Currency Accessors

//! Currency name for standardized locale.
@property (readonly) NSString *currencyName;
//! Name of currency in given locale. Pass nil for standardized locale.
- (NSString *)currencyNameInLocale:(NSLocale *)localeOrNil;



#pragma mark - Creating

//! Returns locale with identifier “en_US_POSIX”.
+ (instancetype)standardizedLocale;

//! Returns new locale with given components.
+ (instancetype)localeWithComponents:(NSDictionary<NSString *, id> *)components;

//! Returns new locale that has components from the receiver only for given keys.
- (NSLocale *)localeWithComponentKeys:(NSArray<NSString *> *)keys;

//! Returns new locale with overridden components.
- (NSLocale *)localeWithComponents:(NSDictionary<NSString *, id> *)components;

//! Returns new locale with all components from the receiver except language.
- (NSLocale *)localeWithLanguage:(NSString *)language;

//! Returns new locale with all components from the receiver except country.
- (NSLocale *)localeWithCountry:(NSString *)country;





@end


