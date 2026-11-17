//
//  NSLocale+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 8.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSLocale+Essentials.h"
#import "NSArray+Essentials.h"
#import "NSDictionary+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSLocale (Essentials)





#pragma mark - Identifier Accessors


- (NSString *)identifier {
    return self.localeIdentifier;
}


- (NSDictionary<NSString *, id> *)components {
    return [NSLocale componentsFromLocaleIdentifier:self.identifier];
}





#pragma mark - Language Accessors


- (NSString *)languageName {
    return [self languageNameInLocale:nil];
}


- (NSString *)languageNameInLocale:(NSLocale *)localeOrNil {
    let locale = localeOrNil ?: NSLocale.standardizedLocale;
    return [locale displayNameForKey:NSLocaleLanguageCode value:[self objectForKey:NSLocaleLanguageCode]];
}


- (NSString *)countryName {
    return [self countryNameInLocale:nil];
}


- (NSString *)countryNameInLocale:(NSLocale *)localeOrNil {
    let locale = localeOrNil ?: NSLocale.standardizedLocale;
    return [locale displayNameForKey:NSLocaleCountryCode value:[self objectForKey:NSLocaleCountryCode]];
}





#pragma mark - Calendar Accessors


- (NSCalendar *)calendar {
    return [self objectForKey:NSLocaleCalendar];
}





#pragma mark - Measurement Acessors


- (NSString *)measurementSystem {
    return [self objectForKey:NSLocaleMeasurementSystem];
}





#pragma mark - Currency Accessors


- (NSString *)currencyName {
    return [self currencyNameInLocale:nil];
}


- (NSString *)currencyNameInLocale:(NSLocale *)localeOrNil {
    let locale = localeOrNil ?: NSLocale.standardizedLocale;
    return [locale displayNameForKey:NSLocaleCurrencyCode value:[self objectForKey:NSLocaleCurrencyCode]];
}





#pragma mark - Creating


ESSSharedMake(NSLocale *, standardizedLocale) {
    return [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
}


+ (instancetype)localeWithComponents:(NSDictionary<NSString *, id> *)components {
    let identifier = [NSLocale localeIdentifierFromComponents:components];
    return [NSLocale localeWithLocaleIdentifier:identifier];
}


- (NSLocale *)localeWithComponentKeys:(NSArray<NSString *> *)keys {
    let components = [keys dictionaryByMappingToValues:^id(NSString *key) {
        return [self objectForKey:key];
    }];
    return [NSLocale localeWithComponents:components];
}


- (NSLocale *)localeWithComponents:(NSDictionary<NSString *, id> *)components {
    let combinedComponents = [self.components dictionaryByAddingValuesFromDictionary:components];
    return [NSLocale localeWithComponents:combinedComponents];
}


- (NSLocale *)localeWithLanguage:(NSString *)language {
    return [self localeWithComponents:@{ NSLocaleLanguageCode: language }];
}


- (NSLocale *)localeWithCountry:(NSString *)country {
    return [self localeWithComponents:@{ NSLocaleCountryCode: country }];
}





@end


