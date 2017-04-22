//
//  ESSFastEnumeration.h
//  Essentials
//
//  Created by Martin Kiss on 22 Apr 2017.
//  Copyright © 2017 iAdverti. All rights reserved.
//



@protocol ESSFastEnumeration <NSFastEnumeration>
- (id)ess_enumeratedType;
@end


// Usage:  foreach (s, strings) { ... }
#define foreach(element, collection) for (typeof((collection).ess_enumeratedType) element in (collection))


@interface NSArray<ElementType> (ESSFastEnumeration) <ESSFastEnumeration>

- (ElementType)ess_enumeratedType;

@end



@interface NSSet<ElementType> (ESSFastEnumeration) <ESSFastEnumeration>

- (ElementType)ess_enumeratedType;

@end



@interface NSOrderedSet<ElementType> (ESSFastEnumeration) <ESSFastEnumeration>

- (ElementType)ess_enumeratedType;

@end



@interface NSPointerArray (ESSFastEnumeration) <ESSFastEnumeration>

- (void *)ess_enumeratedType;

@end



@interface NSHashTable<ElementType> (ESSFastEnumeration) <ESSFastEnumeration>

- (ElementType)ess_enumeratedType;

@end



@interface NSDictionary<KeyType, ValueType> (ESSFastEnumeration) <ESSFastEnumeration>

- (KeyType)ess_enumeratedType;

@end



@interface NSMapTable<KeyType, ValueType> (ESSFastEnumeration) <ESSFastEnumeration>

- (KeyType)ess_enumeratedType;

@end



@interface NSEnumerator<ElementType> (ESSFastEnumeration) <ESSFastEnumeration>

- (ElementType)ess_enumeratedType;

@end


