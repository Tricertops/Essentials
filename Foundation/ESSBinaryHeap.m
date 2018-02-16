//
//  ESSBinaryHeap.m
//  Essentials
//
//  Created by Martin Kiss on 13 Feb 2018.
//  Copyright © 2018 Tricertops. All rights reserved.
//

#import "ESSBinaryHeap.h"
#import "Foundation+Essentials.h"
#import "ESSHash.h"



@interface ESSBinaryHeap ()

@property (readonly) CFBinaryHeapRef underlayingHeap;

@end



#pragma mark -

@implementation ESSBinaryHeap



#pragma mark - Callbacks

static const void * ESSBinaryHeap_RetainCallback(CFAllocatorRef allocator, const void *pointer) {
    // This function requires CFAllocator argument.
    return CFRetain(pointer);
}

static void ESSBinaryHeap_ReleaseCallback(CFAllocatorRef allocator, const void *pointer) {
    // This function requires CFAllocator argument.
    CFRelease(pointer);
}

static CFComparisonResult ESSBinaryHeap_CompareCallback(const void *pointerA, const void *pointerB, void *context) {
    id objectA = (__bridge id)pointerA;
    id objectB = (__bridge id)pointerB;
    var comparator = (__bridge NSComparator)context;
    
    // NS enum is compatible with CF enum.
    return (CFComparisonResult) comparator(objectA, objectB);
}

static void ESSBinaryHeap_EnumerationCallback(const void *pointer, void *context) {
    id object = (__bridge id)pointer;
    var block = (__bridge void (^)(id))context;
    
    block(object);
}



#pragma mark - Initializers

- (instancetype)init {
    return [self initWithSelector:@selector(compare:) descending:NO];
}

- (instancetype)initWithSelector:(SEL)selector descending:(BOOL)descending {
    ESSAssert(selector != nil) else return nil;
    
    let comparator = [ESSBinaryHeap comparatorWithSelector:selector descending:descending];
    return [self initWithComparator:comparator];
}

- (instancetype)initWithSortDescriptors:(NSArray<NSSortDescriptor *> *)descriptors {
    ESSAssert(descriptors.count > 0) else return nil;
    
    let comparator = [ESSBinaryHeap comparatorWithSortDescriptors:descriptors];
    return [self initWithComparator:comparator];
}

- (instancetype)initWithComparator:(NSComparator)comparator {
    ESSAssert(comparator != nil) else return nil;
    
    self = [super init];
    if (self) {
        CFBinaryHeapCallBacks callbacks = {
            .retain = &ESSBinaryHeap_RetainCallback,
            .release = &ESSBinaryHeap_ReleaseCallback,
            .copyDescription = &CFCopyDescription,
            .compare = &ESSBinaryHeap_CompareCallback,
        };
        CFBinaryHeapCompareContext context = {
            .info = (__bridge void *)comparator,
            .retain = &CFRetain,
            .release = &CFRelease,
            .copyDescription = &CFCopyDescription,
        };
        // Even if documentation says “compareContext: Not used. Pass NULL.”, it is used.
        self->_underlayingHeap = CFBinaryHeapCreate(nil, 0, &callbacks, &context);
        self->_comparator = [comparator copy];
    }
    return self;
}

- (instancetype)initWithBinaryHeap:(ESSBinaryHeap *)other {
    ESSAssert(other != nil) else return nil;
    
    self = [super init];
    if (self) {
        self->_underlayingHeap = CFBinaryHeapCreateCopy(nil, 0, other->_underlayingHeap);
        self->_comparator = [other.comparator copy];
    }
    return self;
}

- (void)dealloc {
    CFRelease(self->_underlayingHeap);
}




#pragma mark - Accessors

- (NSUInteger)count {
    return CFBinaryHeapGetCount(self->_underlayingHeap);
}

- (BOOL)isEmpty {
    return (self.count == 0);
}

- (id)firstObject {
    return (__bridge id) CFBinaryHeapGetMinimum(self->_underlayingHeap);
}

- (BOOL)containsObjectOrderedSameAs:(id)object {
    ESSAssert(object != nil) else return NO;
    
    return CFBinaryHeapContainsValue(self->_underlayingHeap, (__bridge void *)object);
}

- (NSUInteger)countOfObjectsOrderedSameAs:(id)object {
    ESSAssert(object != nil) else return 0;
    
    return CFBinaryHeapGetCountOfValue(self->_underlayingHeap, (__bridge void *)object);
}



#pragma mark - Enumeration

- (void)enumerateUsingBlock:(void (^)(id object))block {
    // Internally, the heap creates a copy of itself and pulls first objects until it’s empty.
    CFBinaryHeapApplyFunction(self->_underlayingHeap, &ESSBinaryHeap_EnumerationCallback, (__bridge void *)block);
}

- (NSArray<id> *)allObjects {
    let count = self.count;
    var buffer = calloc(count, sizeof(id));
    
    // Internally, the heap creates a copy of itself and pulls first objects until it’s empty.
    CFBinaryHeapGetValues(self->_underlayingHeap, buffer);
    
    let array = [NSArray arrayWithObjects:(id __unsafe_unretained *)buffer count:count];
    free(buffer);
    return array;
}



#pragma mark - Mutating

- (void)addObject:(id)object {
    ESSAssert(object != nil) else return;
    
    CFBinaryHeapAddValue(self->_underlayingHeap, (__bridge void *)object);
}

- (void)addObjectsFromArray:(NSArray<id> *)array {
    foreach (object, array) {
        [self addObject:object];
    }
}

- (void)addObjectsFromSet:(NSSet<id> *)set {
    foreach (object, set) {
        [self addObject:object];
    }
}

- (id)pullFirstObject {
    id first = self.firstObject;
    [self removeFirstObject];
    return first;
}

- (void)removeFirstObject {
    CFBinaryHeapRemoveMinimumValue(self->_underlayingHeap);
}

- (void)removeAllObjects {
    CFBinaryHeapRemoveAllValues(self->_underlayingHeap);
}



#pragma mark - Other

- (NSUInteger)hash {
    return ESSHashCombine(ESSBinaryHeap.hash, ESSHash((uintptr_t) self->_underlayingHeap));
}

- (BOOL)isEqual:(ESSBinaryHeap<id> *)other {
    if (self == other) {
        return YES;
    }
    if (![other isKindOfClass:ESSBinaryHeap.class]) {
        return NO;
    }
    // CFBinaryHeap cannot reliably compare the equality of contained objects, only their ordering.
    return (self->_underlayingHeap == other->_underlayingHeap);
}

- (instancetype)copy {
    return [[self.class alloc] initWithBinaryHeap:self];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithBinaryHeap:self];
}



#pragma mark - Utilities

+ (NSComparator)comparatorWithSortDescriptors:(NSArray<NSSortDescriptor *> *)descriptors {
    ESSAssert(descriptors.count > 0) else return nil;
    
    return ^NSComparisonResult(id A, id B) {
        foreach (descriptor, descriptors) {
            let result = [descriptor compareObject:A toObject:B];
            if (result != NSOrderedSame) {
                return result;
            }
        }
        return NSOrderedSame;
    };
}

+ (NSComparator)comparatorWithSelector:(SEL)selector descending:(BOOL)descending {
    ESSAssert(selector != nil) else return nil;
    
    let descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:!descending selector:selector];
    
    return ^NSComparisonResult(id A, id B) {
        return [descriptor compareObject:A toObject:B];
    };
}



@end


