//
//  NSLocale+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 8.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSLocale (Essentials)




#pragma mark - Identifier Accessors

//! Alias for .localeIdentifier
@property (readonly) NSString *identifier;

//! Returns all component defined in the receiver.
@property (readonly) NSDictionary *components;



#pragma mark - Language Accessors

//! String for key NSLocaleLanguageCode.
@property (readonly) NSString *languageCode;
//! String for key NSLocaleCountryCode.
@property (readonly) NSString *countryCode;
//! String for key NSLocaleVariantCode.
@property (readonly) NSString *variantCode;


#pragma mark - Writing Accessors

//! String for key NSLocaleScriptCode.
@property (readonly) NSString *scriptCode;
//! Character set for key NSLocaleExemplarCharacterSet.
@property (readonly) NSCharacterSet *exemplarCharacterSet;
//! String for key NSLocaleCollationIdentifier.
@property (readonly) NSString *collationIdentifier;
//! String for key NSLocaleCollatorIdentifier.
@property (readonly) NSString *collatorIdentifier;


#pragma mark - Calendar Accessors

//! Calendar for key NSLocaleCalendar.
@property (readonly) NSCalendar *calendar;


#pragma mark - Measurement Acessors

//! Boolean for key NSLocaleUsesMetricSystem.
@property (readonly) BOOL usesMetricSystem;
//! String for key NSLocaleMeasurementSystem, “Metric” or “U.S.”
@property (readonly) NSString *measurementSystem;


#pragma mark - Numbers Accessors

//! String for key NSLocaleDecimalSeparator.
@property (readonly) NSString *decimalSeparator;
//! String for key NSLocaleGroupingSeparator.
@property (readonly) NSString *groupingSeparator;


#pragma mark - Currency Accessors

//! String for key NSLocaleCurrencySymbol.
@property (readonly) NSString *currencySymbol;
//! String for key NSLocaleCurrencyCode.
@property (readonly) NSString *currencyCode;


#pragma mark - Quotation Accessors

//! String for key NSLocaleQuotationBeginDelimiter.
@property (readonly) NSString *quotationBeginDelimiter;
//! String for key NSLocaleQuotationEndDelimiter.
@property (readonly) NSString *quotationEndDelimiter;
//! String for key NSLocaleAlternateQuotationBeginDelimiter.
@property (readonly) NSString *alternateQuotationBeginDelimiter;
//! String for key NSLocaleAlternateQuotationEndDelimiter.
@property (readonly) NSString *alternateQuotationEndDelimiter;





@end


