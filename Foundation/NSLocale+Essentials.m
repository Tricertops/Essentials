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





@implementation NSLocale (Essentials)





#pragma mark - Identifier Accessors


- (NSString *)identifier {
    return self.localeIdentifier;
}


- (NSDictionary *)components {
    return [NSLocale componentsFromLocaleIdentifier:self.identifier];
}





#pragma mark - Language Accessors


- (NSString *)languageCode {
    return [self objectForKey:NSLocaleLanguageCode];
}


- (NSString *)countryCode {
    return [self objectForKey:NSLocaleCountryCode];
}


- (NSString *)variantCode {
    return [self objectForKey:NSLocaleVariantCode];
}





#pragma mark - Writing Accessors


- (NSString *)scriptCode {
    return [self objectForKey:NSLocaleScriptCode];
}


- (NSCharacterSet *)exemplarCharacterSet {
    return [self objectForKey:NSLocaleExemplarCharacterSet];
}


- (NSString *)collationIdentifier {
    return [self objectForKey:NSLocaleCollationIdentifier];
}


- (NSString *)collatorIdentifier {
    return [self objectForKey:NSLocaleCollatorIdentifier];
}





#pragma mark - Calendar Accessors


- (NSCalendar *)calendar {
    return [self objectForKey:NSLocaleCalendar];
}





#pragma mark - Measurement Acessors


- (BOOL)usesMetricSystem {
    return [[self objectForKey:NSLocaleUsesMetricSystem] boolValue];
}


- (NSString *)measurementSystem {
    return [self objectForKey:NSLocaleMeasurementSystem];
}





#pragma mark - Numbers Accessors


- (NSString *)decimalSeparator {
    return [self objectForKey:NSLocaleDecimalSeparator];
}


- (NSString *)groupingSeparator {
    return [self objectForKey:NSLocaleGroupingSeparator];
}





#pragma mark - Currency Accessors


- (NSString *)currencySymbol {
    return [self objectForKey:NSLocaleCurrencySymbol];
}


- (NSString *)currencyCode {
    return [self objectForKey:NSLocaleCurrencyCode];
}





#pragma mark - Quotation Accessors


- (NSString *)quotationBeginDelimiter {
    return [self objectForKey:NSLocaleQuotationBeginDelimiterKey];
}


- (NSString *)quotationEndDelimiter {
    return [self objectForKey:NSLocaleQuotationEndDelimiterKey];
}


- (NSString *)alternateQuotationBeginDelimiter {
    return [self objectForKey:NSLocaleAlternateQuotationBeginDelimiterKey];
}


- (NSString *)alternateQuotationEndDelimiter {
    return [self objectForKey:NSLocaleAlternateQuotationEndDelimiterKey];
}





#pragma mark - Creating


+ (instancetype)localeWithComponents:(NSDictionary *)components {
    NSString *identifier = [NSLocale localeIdentifierFromComponents:components];
    return [NSLocale localeWithLocaleIdentifier:identifier];
}


- (NSLocale *)localeWithComponentKeys:(NSArray *)keys {
    NSDictionary *components = [keys dictionaryByMappingToValues:^id(NSString *key) {
        return [self objectForKey:key];
    }];
    return [NSLocale localeWithComponents:components];
}


- (NSLocale *)localeWithComponents:(NSDictionary *)components {
    NSDictionary *combinedComponents = [self.components dictionaryByAddingValuesFromDictionary:components];
    return [NSLocale localeWithComponents:combinedComponents];
}





@end


