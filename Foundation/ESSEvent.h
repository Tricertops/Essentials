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

//! Create new Event with initial value, which is not sent, yet.
- (instancetype)initWithValue:(ValueType)value;
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
//! Registers special handler that forwards events to other Event mediator. Owner is used as observer object.
- (void)chainEvent:(__weak ESSEvent<ValueType> *)event owner:(__weak id)owner;
//! Registers special handler that uses Key-Value Coding to set property on given object. Target is used as observer object.
- (void)bindTo:(__weak id)target property:(NSString *)keyPath;
//! Removes all handlers registered for given observer
- (void)removeObserver:(__weak id)observer;


@end



#define ESSEventInitialize(name, optionalValue...) \
    ESSLazyMake(ESSEvent *, name) { \
        return [[ESSEvent alloc] initWithValue:@[optionalValue].firstObject]; \
    }


