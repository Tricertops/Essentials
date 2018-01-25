//
//  NSBundle+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 18.10.15.
//  Copyright © 2015 iAdverti. All rights reserved.
//

#import "Foundation+Essentials.h"



@interface NSBundle (Essentials)


//! Value from Info.plist for CFBundleVersion key.
@property (readonly) NSString *version;

//! Value from Info.plist for CFBundleShortVersionString key.
@property (readonly) NSString *shortVersionString;


@end


