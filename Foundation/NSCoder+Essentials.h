//
//  NSCoder+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 21.2.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"





@interface NSCoder (Essentials)


- (void)encodeValue:(const void *)valueAddress ofObjCType:(const char *)objcType forKey:(NSString *)key;
- (BOOL)decodeValue:(void *)valueAddress ofObjCType:(const char *)objcType forKey:(NSString *)key;


@end





#define ESSEncode(IVAR) ESSEncodeCustom(self->IVAR, encoder, @#IVAR)
#define ESSEncodeCustom(VALUE, ENCODER, KEY) \
(void)({ \
    var value = (VALUE); \
    [(ENCODER) encodeValue:&value ofObjCType:@encode(typeof(value)) forKey:(KEY)]; \
})

#define ESSEncodeConditional(IVAR) ESSEncodeConditionalCustom(self->IVAR, encoder, @#IVAR)
#define ESSEncodeConditionalCustom(OBJECT, ENCODER, KEY) \
(void)({ \
    [(ENCODER) encodeConditionalObject:(OBJECT) forKey:(KEY)]; \
})


#define ESSDecode(IVAR) ESSDecodeCustom(self->IVAR, decoder, IVAR, @#IVAR)
#define ESSDecodeCustom(STORAGE, DECODER, TYPE, KEY) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-repeated-use-of-weak\"") \
(void)({ \
    typeof(TYPE) value; \
    BOOL ok = [(DECODER) decodeValue:&value ofObjCType:@encode(typeof(TYPE)) forKey:(KEY)]; \
    if (ok) (STORAGE) = value; \
}) \
_Pragma("clang diagnostic pop") \


