//
//  ESSLog.h
//  Essentials
//
//  Created by Martin Kiss on 18.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <asl.h>



#pragma mark - Levels

/// Macro for converting levels from ASL to ESS.
#define ESSLogLevelFromASL(level)   (ASL_LEVEL_DEBUG - (level))

/// These levels are same to compare as numbers. Debug is the lowest, Critical is the highest.
typedef enum : NSUInteger {
    /// Use for trivial events with verbose messages.
    ESSLogLevelDebug = ESSLogLevelFromASL(ASL_LEVEL_DEBUG), // 0
    /// Use for important events under normal conditions.
    ESSLogLevelNotice = ESSLogLevelFromASL(ASL_LEVEL_NOTICE), // 2
    /// Use for important events under abnormal conditions.
    ESSLogLevelWarning = ESSLogLevelFromASL(ASL_LEVEL_WARNING), // 3
    /// Use for recoverable errors that don’t affect stability.
    ESSLogLevelError = ESSLogLevelFromASL(ASL_LEVEL_ERR), // 4
    /// Use for unrecoverable errors that affect stability.
    ESSLogLevelCritical = ESSLogLevelFromASL(ASL_LEVEL_CRIT), // 5
} ESSLogLevel;


/// Logs trivial event with verbose messages.
void ESSDebug(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/// Logs important event under normal conditions.
void ESSNotice(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/// Logs important event under abnormal conditions.
void ESSWarning(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/// Logs recoverable error that doesn’t affect stability.
void ESSError(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

/// Logs unrecoverable error that affects stability.
void ESSCritical(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);


/// Logs a message with given level.
void ESSLog(ESSLogLevel level, NSString *format, ...) NS_FORMAT_FUNCTION(2, 3);




#pragma mark - Limiting

/// Supresses logs with lower level. Returns previous level, so it can be reverted.
ESSLogLevel ESSLogSetLevel(ESSLogLevel);

/// Returns current logging level. The default is ESSLogLevelDebug.
ESSLogLevel ESSLogGetLevel(void);


