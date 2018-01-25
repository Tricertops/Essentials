//
//  NSCharacterSet+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 26.3.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import "NSCharacterSet+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSCharacterSet (Essentials)





#pragma mark - Constructing


+ (instancetype)characterSetFrom:(unichar)firstCharacter to:(unichar)lastCharacter {
    return [self characterSetWithRange:NSRangeMakeFromTo(firstCharacter, lastCharacter)];
}


+ (instancetype)characterSetByMerging:(NSArray<NSCharacterSet *> *)characterSets {
    var unionCharSet = [NSMutableCharacterSet new];
    foreach (charSet, characterSets) {
        [unionCharSet formUnionWithCharacterSet:charSet];
    }
    return unionCharSet;
}


- (instancetype)characterSetByUnionWithSet:(NSCharacterSet *)characterSet {
    return [NSMutableCharacterSet characterSetByMerging:@[self, characterSet]];
}


- (instancetype)characterSetByIntersectionWithSet:(NSCharacterSet *)characterSet {
    var intersectionCharSet = [self mutableCopy];
    [intersectionCharSet formUnionWithCharacterSet:characterSet];
    return intersectionCharSet;
}





#pragma mark - Common Character Sets


ESSShared(NSCharacterSet *,
          ASCIICharacterSet,
          [NSCharacterSet characterSetFrom:0 to:127])

ESSShared(NSCharacterSet *,
          printableASCIICharacterSet,
          [NSCharacterSet characterSetFrom:'!' to:'~'])

ESSShared(NSCharacterSet *,
          alphanumericASCIICharacterSet,
          [NSCharacterSet characterSetByMerging:
           @[
             [NSCharacterSet characterSetFrom:'0' to:'9'],
             [NSCharacterSet characterSetFrom:'A' to:'Z'],
             [NSCharacterSet characterSetFrom:'a' to:'z'],
             ]])

ESSShared(NSCharacterSet *,
          punctuationASCIICharacterSet,
          [NSCharacterSet characterSetByMerging:
           @[
             [NSCharacterSet characterSetFrom:'!' to:'/'],
             [NSCharacterSet characterSetFrom:':' to:'@'],
             [NSCharacterSet characterSetFrom:'[' to:'`'],
             [NSCharacterSet characterSetFrom:'{' to:'~'],
             ]])

ESSShared(NSCharacterSet *,
          lowercaseHexadecimalCharacterSet,
          [NSCharacterSet characterSetByMerging:
           @[
             [NSCharacterSet characterSetFrom:'0' to:'9'],
             [NSCharacterSet characterSetFrom:'a' to:'f'],
             ]])

ESSShared(NSCharacterSet *,
          uppercaseHexadecimalCharacterSet,
          [NSCharacterSet characterSetByMerging:
           @[
             [NSCharacterSet characterSetFrom:'0' to:'9'],
             [NSCharacterSet characterSetFrom:'A' to:'F'],
             ]])

ESSShared(NSCharacterSet *,
          hexadecimalCharacterSet,
          [NSCharacterSet characterSetByMerging:
           @[
             [NSCharacterSet characterSetFrom:'0' to:'9'],
             [NSCharacterSet characterSetFrom:'A' to:'F'],
             [NSCharacterSet characterSetFrom:'a' to:'f'],
             ]])





@end


