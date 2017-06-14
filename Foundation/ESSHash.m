//
//  ESSHash.m
//  Essentials
//
//  Created by Martin Kiss on 2 Feb 2017.
//  Copyright © 2017 PixelCut. All rights reserved.
//

#import "ESSHash.h"





// Inspired by CoreFoundation http://www.opensource.apple.com/source/CF/CF-550/ForFoundationOnly.h


static NSUInteger const ESSHashFactor = 2654435761U;


NSUInteger ESSHash(long value) ESSOverloaded {
    return ESSHashFactor * (unsigned long)value;
}

NSUInteger ESSHash(unsigned long value) ESSOverloaded {
    return ESSHashFactor * value;
}

NSUInteger ESSHash(double value) ESSOverloaded {
    double absolute = ABS(value);
    double integral = round(absolute);
    double fragment = absolute - integral;
    NSUInteger integralHash = ESSHashFactor * fmod(integral, NSUIntegerMax);
    NSUInteger fragmentHash = fragment * NSUIntegerMax;
    return integralHash + fragmentHash;
}

NSUInteger ESSHash(id object) ESSOverloaded {
    return [object hash];
}





void ESSHashAggregate(NSUInteger* _Nonnull aggregateRef, NSUInteger hash)
{
    ESSAssert(aggregateRef) else return;
    
    // Inspired by C++ library Boost http://www.boost.org/doc/libs/1_37_0/doc/html/hash/reference.html#boost.hash_combine
    NSUInteger aggregate = *aggregateRef;
    *aggregateRef = aggregate ^ (hash + ESSHashFactor + (aggregate << 6) + (aggregate >> 2));
}


NSUInteger _ESSHashCombine(NSUInteger* _Nonnull hashes, NSUInteger count)
{
    ESSAssert(hashes) else return 0;
    ESSAssert(count) else return 0;
    
    NSUInteger aggregate = 0;
    forcount(index, count) {
        ESSHashAggregate(&aggregate, hashes[index]);
    }
    return aggregate;
}




