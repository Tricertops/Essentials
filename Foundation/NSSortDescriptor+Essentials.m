//
//  NSSortDescriptor+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 11.4.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "NSSortDescriptor+Essentials.h"
#import "Foundation+Essentials.h"





@implementation NSSortDescriptor (Essentials)





+ (NSSortDescriptor *)randomSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:ESSKeypathClass(NSObject, self) ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        return (NSUIntegerRandom(2) ? NSOrderedAscending : NSOrderedDescending);
    }];
}





+ (NSSortDescriptor *)sortDescriptorForViewOriginX {
    return [NSSortDescriptor sortDescriptorWithKey:@"layer.frame.origin.x" ascending:YES];
}


+ (NSSortDescriptor *)sortDescriptorForViewOriginY {
    return [NSSortDescriptor sortDescriptorWithKey:@"layer.frame.origin.y" ascending:YES];
}





@end


