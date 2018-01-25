//
//  NSDateFormatter+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 13.2.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import "NSDateFormatter+Essentials.h"
#import "Foundation+Essentials.h"
#import "NSLocale+Essentials.h"



@implementation NSDateFormatter (Essentials)





- (NSString *)localizedFormat {
    return self.dateFormat;
}


- (void)setLocalizedFormat:(NSString *)localizedFormat {
    self.dateFormat = [NSDateFormatter dateFormatFromTemplate:localizedFormat options:kNilOptions locale:self.locale];
}





+ (NSMutableDictionary<NSString *, NSDateFormatter *> *)cachedISODateFormatters {
    static NSMutableDictionary<NSString *, NSDateFormatter *> *formatters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatters = [NSMutableDictionary new];
    });
    return formatters;
}


+ (NSDateFormatter *)ISODateFormatterWithFormat:(NSString *)format {
    if ( ! format.length) return nil;
    
    var formatter = self.cachedISODateFormatters[format];
    if ( ! formatter) {
        formatter = [NSDateFormatter new];
        formatter.locale = NSLocale.standardizedLocale;
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        formatter.dateFormat = format;
        formatter.lenient = NO;
        self.cachedISODateFormatters[format] = formatter;
    }
    return formatter;
}


+ (NSDate *)dateFromISOString:(NSString *)string {
    if ( ! string.length) return nil;
    
    //! So we have NSISO8601DateFormatter but it’s so stupid that it cannot parse arbitrary string without exact configuration. Also, some formats are beyond its capabilties at all (minute precision or sub-second precision).
    //! Here I picked most used and most practical formats and will try each of them to parse given string. Formatters are cached.
    
    static NSArray<NSString *> *supportedFormats = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        supportedFormats = @[//! All supported formats:
                             //!  • all are in UTC, no time-zone is parsed.
                             //!  • they either have no separators, all separators with T, or all separators with space.
                             //!  • order optimized for usage frequency (eh maybe).
                             //!  • week-based format doesn’t work well, because I can’t find a way to force Monday to be first (as ISO requests).
                             
                             //! Second precision.
                             @"yyyy-MM-dd'T'HH:mm:ss'Z'",
                             @"yyyy-MM-dd HH:mm:ss'Z'",
                             @"yyyyMMdd'T'HHmmss'Z'",
                             //! Day precision.
                             @"yyyy-MM-dd",
                             @"yyyyMMdd",
                             // "yyyy-DDD" collides with "yyyy-MM"
                             //! Milisecond precision.
                             @"yyyy-MM-dd'T'HH:mm:ss.S'Z'",
                             @"yyyy-MM-dd HH:mm:ss.S'Z'",
                             // Is there compact with sub-second precision?
                             //! Sub-day precision.
                             @"yyyy-MM",
                             @"yyyyMM",
                             @"yyyy",
                             //! Minute precision.
                             @"yyyy-MM-dd'T'HH:mm'Z'",
                             @"yyyy-MM-dd HH:mm'Z'",
                             // "yyyyMMdd'T'HHmm'Z'" doesn’t work properly.
                             //! Hour precision.
                             @"yyyy-MM-dd'T'HH'Z'",
                             @"yyyy-MM-dd HH'Z'",
                             // "yyyyMMdd'T'HH'Z'" doesn’t work properly.
                             ];
    });
    
    foreach (format, supportedFormats) {
        var formatter = [NSDateFormatter ISODateFormatterWithFormat:format];
        let date = [formatter dateFromString:string];
        if (date) return date;
    }
    return nil;
}


+ (NSDateFormatter *)ISODateFormatterWithPrecision:(NSCalendarUnit)unit compact:(BOOL)isCompact {
    let format = [self ISODateFormatWithPrecision:unit compact:isCompact];
    return [NSDateFormatter ISODateFormatterWithFormat:format];
}


+ (NSString *)ISODateFormatWithPrecision:(NSCalendarUnit)unit compact:(BOOL)isCompact {
    switch (unit) {
            
            //! All these formats are in UTC, if they include time.
            //! Non-compact formats use T separator.
            //! It’s not possible to produce format "yyyy-DDD", because there is no such calendar unit.
            //! Week-based formats are not available, because I can’t find a way to force Monday to be first (as ISO requests).
            
        case NSCalendarUnitYear:
            return @"yyyy";
            
        case NSCalendarUnitMonth:
            return (isCompact? @"yyyyMM" : @"yyyy-MM");
            
        case NSCalendarUnitDay:
            return (isCompact? @"yyyyMMdd" : @"yyyy-MM-dd");
            
        case NSCalendarUnitHour:
            return (isCompact? @"yyyyMMdd'T'HH'Z'" : @"yyyy-MM-dd'T'HH'Z'");
            
        case NSCalendarUnitMinute:
            return (isCompact? @"yyyyMMdd'T'HHmm'Z'" : @"yyyy-MM-dd'T'HH:mm'Z'");
            
        case NSCalendarUnitSecond:
            return (isCompact? @"yyyyMMdd'T'HHmmss'Z'" : @"yyyy-MM-dd'T'HH:mm:ss'Z'");
            
        case NSCalendarUnitNanosecond:
            return (isCompact? @"yyyyMMdd'T'HHmmssS'Z'" : @"yyyy-MM-dd'T'HH:mm:ss.S'Z'");
            
        default: break;
    }
    return nil;
}





@end


