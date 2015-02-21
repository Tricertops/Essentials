//
//  NSCoder+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 21.2.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "NSCoder+Essentials.h"



@implementation NSCoder (Essentials)





- (void)encodeValue:(const void *)valueAddress ofObjCType:(const char *)objcType forKey:(NSString *)key {
#define expand_value(TYPE)  (*((TYPE*)valueAddress))
#define expand_object       (*((id __unsafe_unretained *)valueAddress))
#define expand_branch(TYPE) else if (strcmp(objcType, @encode(TYPE)) == 0)
#define expand_wrap(TYPE)   expand_branch(TYPE) [self encodeObject:@(expand_value(TYPE)) forKey:key];
    
    
	if (objcType == nil) return;
    expand_branch(void) return;
    expand_branch(void(*)(void)) return; // Function pointer.
    
    expand_wrap(char)
    expand_wrap(short)
    expand_wrap(int)
    expand_wrap(long)
    expand_wrap(long long)
    
    expand_wrap(unsigned char)
    expand_wrap(unsigned short)
    expand_wrap(unsigned int)
    expand_wrap(unsigned long)
    expand_wrap(unsigned long long)
    
    expand_wrap(float)
    expand_wrap(double)
    expand_wrap(_Bool)
    expand_wrap(char*) // NSString
    
    expand_branch(id) [self encodeObject:expand_object forKey:key];
    expand_branch(Class) [self encodeObject:expand_object forKey:key];
    expand_branch(SEL) [self encodeObject:NSStringFromSelector(expand_value(SEL)) forKey:key];
    
    else {
        // structures, C arrays, unions
        NSValue *objectValue = [NSValue value:valueAddress withObjCType:objcType];
        [self encodeObject:objectValue forKey:key];
    }
    
#undef expand_value
#undef expand_object
#undef expand_branch
#undef expand_wrap
}


- (BOOL)decodeValue:(void *)valueAddress ofObjCType:(const char *)objcType forKey:(NSString *)key {
#define expand_value(TYPE)  (*((TYPE*)valueAddress))
#define expand_object       (*((id __autoreleasing *)valueAddress))
#define expand_compare(OBJCTYPE)    (strcmp(objcType, OBJCTYPE) == 0)
#define expand_branch(TYPE) else if (expand_compare(@encode(TYPE)))
    
    
    if (objcType == nil) return NO;
    expand_branch(void) return NO;
    expand_branch(void(*)(void)) return NO; // Function pointer.
    
    expand_branch(id) { expand_object = [self decodeObjectForKey:key]; return YES; }
    expand_branch(Class) { expand_object = [self decodeObjectForKey:key]; return YES; }
    expand_branch(SEL) {
        NSString *string = [self decodeObjectOfClass:[NSString class] forKey:key];
        if (string == nil) {
            expand_value(SEL) = NSSelectorFromString(string);
            return YES;
        }
    }
    
    else {
        // primitive types, structures, C arrays, unions
        NSValue *objectValue = [self decodeObjectOfClass:[NSValue class] forKey:key];
        if (expand_compare(objectValue.objCType)) {
            [objectValue getValue:valueAddress];
            return YES;
        }
    }
    return NO;
    
#undef expand_value
#undef expand_object
#undef expand_branch
}







@end


