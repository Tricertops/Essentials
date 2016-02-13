//
//  NSDateFormatter+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 13.2.16.
//  Copyright © 2016 iAdverti. All rights reserved.
//

#import "NSDateFormatter+Essentials.h"



@implementation NSDateFormatter (Essentials)





- (NSString *)localizedFormat {
    return self.dateFormat;
}


- (void)setLocalizedFormat:(NSString *)localizedFormat {
    self.dateFormat = [NSDateFormatter dateFormatFromTemplate:localizedFormat options:kNilOptions locale:self.locale];
}





@end


