//
//  ESSHash.h
//  Essentials
//
//  Created by Martin Kiss on 2 Feb 2017.
//  Copyright © 2017 PixelCut. All rights reserved.
//

#import "Foundation+Essentials.h"


//! Example usage:
//  ESSHashCombine( ESSHash(42), ESSHash(3.14), ESSHash(self) )



extern NSUInteger ESSHash(int)           ESSOverloaded;
extern NSUInteger ESSHash(unsigned int)  ESSOverloaded;
extern NSUInteger ESSHash(long)          ESSOverloaded;
extern NSUInteger ESSHash(unsigned long) ESSOverloaded;
extern NSUInteger ESSHash(double)        ESSOverloaded;
extern NSUInteger ESSHash(id _Nonnull)   ESSOverloaded;


//! Combines two hashes together. Mutates referenced hash value.
extern void ESSHashAggregate(NSUInteger* _Nonnull aggregateRef, NSUInteger hash);


//! Convenience macro for combining variable number of hashes together.
#define ESSHashCombine(hashes...) \
    ( (NSUInteger) ({ \
        NSUInteger __hashes[] = { hashes }; \
        NSUInteger __count = sizeof(__hashes) / sizeof(NSUInteger); \
        _ESSHashCombine(__hashes, __count); \
    }) )

extern NSUInteger _ESSHashCombine(NSUInteger* _Nonnull hashes, NSUInteger count);


