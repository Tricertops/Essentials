//
//  NSDateFormatter+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 13.2.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



@interface NSDateFormatter (Essentials)



//! Get: returns dateFormat. Set: creates best format from template in receiver’s locale.
@property NSString *localizedFormat;


//! Parses ISO 8601 string using many formats like: '2017-05-07' or '2017-05-07T11:35:14Z'
+ (NSDate *)dateFromISOString:(NSString *)string;

//! Returns date formatter configured to produce ISO 8601 strings with given precision, optionally with separators.
+ (NSDateFormatter *)ISODateFormatterWithPrecision:(NSCalendarUnit)unit compact:(BOOL)isCompact;

//! Returns date formatter without locale and with given dateFormat. No validation on the format is performed. This method caches the formatters.
+ (NSDateFormatter *)ISODateFormatterWithFormat:(NSString *)format;



@end


