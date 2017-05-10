//
//  ESSLog.m
//  Essentials
//
//  Created by Martin Kiss on 18.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "ESSLog.h"
#import "NSString+Essentials.h"





#pragma mark - Private


static ESSLogLevel ESSLogLevelLimit = ESSLogLevelDebug;


static void _ESSLogPrivate(ESSLogLevel level, NSString *message) {
    if (level < ESSLogLevelLimit) return;
    
    NSString *threadInfo = [NSThread isMainThread]? @"" : @"BACKGROUND ";
    asl_log(nil, nil, ASL_LEVEL_DEBUG - level, "%s%s", threadInfo.UTF8String, message.UTF8String);
}


static NSString * ESSLogLevelName(ESSLogLevel level) {
    if (level <= ESSLogLevelDebug) return @"Debug";
    else if (level <= ESSLogLevelNotice) return @"Notice"; // Includes Info level.
    else if (level <= ESSLogLevelWarning) return @"Warning";
    else if (level <= ESSLogLevelError) return @"Error";
    else return @"Critical"; // Includes Alert and Emergency levels.
}





#pragma mark - Levels


void ESSDebug(NSString *format, ...) {
    NSString *message = NSStringFromFormat(format);
    _ESSLogPrivate(ESSLogLevelDebug, message);
}


void ESSNotice(NSString *format, ...) {
    NSString *message = NSStringFromFormat(format);
    _ESSLogPrivate(ESSLogLevelNotice, ESSString(@"╸%@╺", message));
}


void ESSWarning(NSString *format, ...) {
    NSString *message = NSStringFromFormat(format);
    _ESSLogPrivate(ESSLogLevelWarning, ESSString(@"◆ Warning: %@ ◆", message));
}


void ESSError(NSString *format, ...) {
    NSString *message = NSStringFromFormat(format);
    _ESSLogPrivate(ESSLogLevelError, ESSString(@">> Error: %@ <<", message));
}


void ESSCritical(NSString *format, ...) {
    NSString *message = NSStringFromFormat(format);
    _ESSLogPrivate(ESSLogLevelCritical, ESSString(@"*** Critical: %@ ***", message));
}


void ESSLog(ESSLogLevel level, NSString *format, ...) {
    NSString *message = NSStringFromFormat(format);
    if (level <= ESSLogLevelDebug) ESSDebug(@"%@", message);
    else if (level <= ESSLogLevelNotice) ESSNotice(@"%@", message); // Includes Info level.
    else if (level <= ESSLogLevelWarning) ESSWarning(@"%@", message);
    else if (level <= ESSLogLevelError) ESSError(@"%@", message);
    else ESSCritical(@"%@", message); // Includes Alert and Emergency levels.
}





#pragma mark - Limiting


ESSLogLevel ESSLogGetLevel(void) {
    return ESSLogLevelLimit;
}


ESSLogLevel ESSLogSetLevel(ESSLogLevel level) {
    NSString *message = ESSString(@"Logging level set to: %@", ESSLogLevelName(level));
    BOOL canLogBefore = (level >= ESSLogLevelLimit);
    if (canLogBefore) {
        _ESSLogPrivate(ESSLogLevelDebug, message);
    }
    ESSLogLevel previous = ESSLogLevelLimit;
    ESSLogLevelLimit = level;
    if ( ! canLogBefore) {
        _ESSLogPrivate(ESSLogLevelDebug, message);
    }
    return previous;
}



