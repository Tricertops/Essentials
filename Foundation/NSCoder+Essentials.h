//
//  NSCoder+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21.2.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSCoder (Essentials)


- (void)encodeValue:(const void *)valueAddress ofObjCType:(const char *)objcType forKey:(NSString *)key;
- (BOOL)decodeValue:(void *)valueAddress ofObjCType:(const char *)objcType forKey:(NSString *)key;


@end



#define ESSEncode(ivar) \
(void)({ \
    typeof(self->ivar) value = self->ivar; \
    [encoder encodeValue:&value ofObjCType:@encode(typeof(value)) forKey:@#ivar]; \
})

#define ESSEncodeConditional(ivar) \
(void)({ \
    [encoder encodeConditionalObject:self->ivar forKey:@#ivar]; \
})


#define ESSDecode(ivar) \
(void)({ \
    typeof(self->ivar) value; \
    BOOL ok = [decoder decodeValue:&value ofObjCType:@encode(typeof(value)) forKey:@#ivar]; \
    if (ok) self->ivar = value; \
})


