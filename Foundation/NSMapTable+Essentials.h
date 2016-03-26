//
//  NSMapTable+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.1.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSMapTable<KeyType, ObjectType> (Essentials)


- (ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(ObjectType)object forKeyedSubscript:(KeyType)key;


@end

