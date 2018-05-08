//
//  ESSEnumerator.m
//  Essentials
//
//  Created by Martin Kiss on 2 May 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

#import "ESSEnumerator.h"
#import "Foundation+Essentials.h"



@interface ESSEnumerator ()

@property (readonly) id (^nextBlock)(NSUInteger);
@property (readonly) void (^cleanupBlock)(void);

@property NSUInteger nextIndex;

@end



@implementation ESSEnumerator


- (instancetype)initWithNext:(id (^)(NSUInteger))nextBlock cleanup:(void (^)(void))cleanupBlock {
    self = [self init];
    
    self->_nextBlock = nextBlock;
    self->_cleanupBlock = cleanupBlock;
    
    if (!self.nextBlock) {
        [self cleanup];
    }
    
    return self;
}

- (void)dealloc {
    [self cleanup];
}

- (id)nextObject {
    if (!self.nextBlock) return nil;
    
    let index = self.nextIndex;
    id object = self.nextBlock(index);
    self.nextIndex = index + 1;
    
    if (!object) {
        [self cleanup];
    }
    return object;
}

- (void)cleanup {
    if (self.cleanupBlock) self.cleanupBlock();
    
    self->_cleanupBlock = nil;
    self->_nextBlock = nil;
}


@end


