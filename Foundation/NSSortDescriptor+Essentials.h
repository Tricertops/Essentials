//
//  NSSortDescriptor+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 11.4.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



typedef enum : BOOL {
    ESSSortDescending = NO,
    ESSSortAscending = YES,
} ESSSort;



@interface NSSortDescriptor (Essentials)


+ (instancetype)sortAscending:(BOOL)ascending;
+ (instancetype)sortAscending:(BOOL)ascending selector:(SEL)selector;

+ (instancetype)randomSortDescriptor;

+ (instancetype)sortDescriptorForViewOriginX;
+ (instancetype)sortDescriptorForViewOriginY;

+ (NSComparator)comparatorForSortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

+ (instancetype)sortDescriptorAscending:(BOOL)ascending accessor:(id(^)(id))accessor;


@end


#define ESSSort(Class, keyPath, ascend) \
(NSSortDescriptor *)({ \
    if (NO) { \
        Class *object = nil; \
        (void)object.keyPath; \
    } \
    [NSSortDescriptor sortDescriptorWithKey:@#keyPath ascending:ESSSort##ascend]; \
})


#define ESSSortUsing(Class, keyPath, ascend, compareSelector) \
(NSSortDescriptor *)({ \
    if (NO) { \
        Class *object = nil; \
        (void)object.keyPath; \
    } \
    SEL selector = NSSelectorFromString(@#compareSelector); \
    [NSSortDescriptor sortDescriptorWithKey:@#keyPath ascending:ESSSort##ascend selector:selector]; \
})


#define ESSSortAccess(Class, expression, ascend) \
(NSSortDescriptor *)({ \
    [NSSortDescriptor sortDescriptorAscending:ESSSort##ascend accessor:^(Class *x){ return (expression); }]; \
})

