//
//  NSSortDescriptor+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 11.4.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface NSSortDescriptor (Essentials)



+ (NSSortDescriptor *)randomSortDescriptor;

+ (NSSortDescriptor *)sortDescriptorForViewOriginX;
+ (NSSortDescriptor *)sortDescriptorForViewOriginY;



@end


