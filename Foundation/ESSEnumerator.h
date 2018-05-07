//
//  ESSEnumerator.h
//  Essentials
//
//  Created by Martin Kiss on 2 May 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

@import Foundation;



//! Universal NSEnumerator class, customizable using blocks.
@interface ESSEnumerator<ValueType> : NSEnumerator


//! Next block is invoked with incrementing index. Cleanup block is invoked from dealloc.
- (instancetype)initWithNext:(ValueType (^)(NSUInteger index))nextBlock cleanup:(void (^)(void))cleanupBlock;


@end


