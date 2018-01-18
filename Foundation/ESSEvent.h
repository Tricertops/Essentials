//
//  ESSEvent.h
//  Essentials
//
//  Created by Martin Kiss on 10.2.16.
//  Copyright © 2016 Martin Kiss. All rights reserved.
//

#import <Foundation/Foundation.h>



//! Object that manages observers and sends them values when requested.
@interface ESSEvent<ValueType> : NSObject


#pragma mark - Object Maintaining the Event

//! Macro for automatic implementation of Event getter with lazy initialization.
#define ESSEventInitialize(name, optionalValue...) \
    _ESSEventInitialize(name, optionalValue)

//! Create new Event with owner and initial value, which is not sent, yet.
- (instancetype)initWithOwner:(__weak id)owner initialValue:(ValueType)value;
//! Object responsible for owning strong reference to this Event.
@property (readonly, weak) id owner;
//! Invokes all registered handlers with the last value.
- (void)notify;
//! Invokes all registered handlers with the given value.
- (void)sendValue:(ValueType)value;
//! Removes all handlers of all observers.
- (void)removeAllObservers;

//! Whether the event is in a process of notifying its observers.
@property (readonly) BOOL isNotifying;
//! Whether the receiver is inside suspended block.
@property (readonly) BOOL isSuspended;
//! Cause the receiver to not invoke any handlers until resumed.
- (void)suspend;
//! Resumes the receiver after calling suspend. Optionally send last value to observers.
- (void)resumeAndNotify:(BOOL)alsoResend;


#pragma mark - Objects Listening to the Event

//! Contains last sent value.
@property (readonly, weak) ValueType lastValue;
//! Registers handler for given observer. Handler is invoked with the observer and sender to avoid retain-cycles.
- (void)addObserver:(__weak id)observer handler:(void (^)(id observer, ValueType value))handler;
//! Registers special handler that invokes selector on the observer. Selector may accept one argument – the sender.
- (void)addObserver:(__weak id)observer selector:(SEL)selector;
//! Registers special handler that forwards events to other Event object of the same ValueType.
- (void)chainTo:(__weak ESSEvent<ValueType> *)event;
//! Registers special handler that sends custom value to other Event object.
- (void)replaceValue:(id)value chainTo:(__weak ESSEvent *)event;
//! Registers special handler that discards value and notifies the other Event object.
- (void)ignoreValueAndChainTo:(__weak ESSEvent *)event;
//! Removes all handlers registered for given observer
- (void)removeObserver:(__weak id)observer;


@end



#define _ESSEventInitialize(name, optionalValue...) \
    ESSLazyMake(ESSEvent *, name) { \
        return [[ESSEvent alloc] initWithOwner:self initialValue:@[optionalValue].firstObject]; \
    }


