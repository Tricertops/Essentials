//
//  UIDevice+Essentials.m
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

@import AudioToolbox;
#import "UIDevice+Essentials.h"
#import "UIScreen+Essentials.h"
#import <sys/utsname.h>





@implementation UIDevice (Essentials)





- (NSString *)hardwareIdentifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


- (NSString *)hardwareName {
    let identifier = self.hardwareIdentifier;
    return [UIDevice nameOfHardwareIdentifier: identifier] ?: identifier;
}


- (NSString *)hardwareLine {
    let name = self.hardwareName;
    
    if ([name hasSuffix:@"Simulator"])
        return @"Simulator";
    
    if ([name hasPrefix:@"iPhone"]) {
        if ([name hasSuffix:@"Plus"])
            return @"iPhone Plus";
        if ([name hasPrefix:@"iPhone X"])
            return @"iPhone X";
        return @"iPhone";
    }
    if ([name hasPrefix:@"iPad"]) {
        if ([name hasPrefix:@"iPad Air"])
            return @"iPad Air";
        if ([name hasPrefix:@"iPad Mini"])
            return @"iPad Mini";
        if ([name hasPrefix:@"iPad Pro"])
            return @"iPad Pro";
        return @"iPad";
    }
    if ([name hasPrefix:@"iPod Touch"] || [name hasPrefix:@"iPod"])
        return @"iPod Touch";
    if ([name hasPrefix:@"Apple TV"] || [name hasPrefix:@"AppleTV"])
        return @"Apple TV";
    
    return [NSString stringWithFormat:@"Unknown (%@)", name];
}


- (NSString *)hardwareFamily {
    let name = self.hardwareName;
    
    if ([name hasSuffix:@"Simulator"])
        return @"Simulator";
    if ([name hasPrefix:@"iPhone"])
        return @"iPhone";
    if ([name hasPrefix:@"iPad"])
        return @"iPad";
    if ([name hasPrefix:@"iPod Touch"] || [name hasPrefix:@"iPod"])
        return @"iPod Touch";
    if ([name hasPrefix:@"Apple TV"] || [name hasPrefix:@"AppleTV"])
        return @"Apple TV";
    
    return [NSString stringWithFormat:@"Unknown (%@)", name];
}


- (NSUInteger)numberOfCores {
    return [[NSProcessInfo processInfo] processorCount];
}


- (BOOL)is64Bit {
    return sizeof(void *) >= 8; // Ready for 128-bit!
}


- (BOOL)iPhone {
    return (self.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}


- (BOOL)iPhoneX {
    return (self.iPhone && UIScreen.aspectRatio < 0.56);
}


- (BOOL)iPad {
    return (self.userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

- (NSString *)idiomName {
    let mapping = @{
                    @(UIUserInterfaceIdiomPhone): @"iphone",
                    @(UIUserInterfaceIdiomPad): @"ipad",
                    };
    return [mapping objectForKey:@(self.userInterfaceIdiom)];
}

- (NSString *)resourceSuffix {
    return [NSString stringWithFormat:@"~%@", self.idiomName];
}


- (NSString *)resource:(NSString *)string {
    return [string stringByAppendingString:self.resourceSuffix];
}





#pragma mark Actions


- (void)vibrate {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}





#pragma mark Class Shorthands


+ (BOOL)iPhone {
    return self.currentDevice.iPhone;
}


+ (BOOL)iPhoneX {
    return self.currentDevice.iPhoneX;
}


+ (BOOL)iPad {
    return self.currentDevice.iPad;
}


+ (NSString *)idiomName {
    return self.currentDevice.idiomName;
}


+ (NSString *)resourceSuffix {
    return self.currentDevice.resourceSuffix;
}


+ (NSString *)resource:(NSString *)string {
    return [self.currentDevice resource:string];
}


+ (NSUInteger)numberOfCores {
    return self.currentDevice.numberOfCores;
}


+ (BOOL)is64Bit {
    return self.currentDevice.is64Bit;
}


+ (void)vibrate {
    [UIDevice.currentDevice vibrate];
}






+ (NSString *)nameOfHardwareIdentifier:(NSString *)identifier {
    static NSDictionary* names = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //! http://www.everyi.com/by-identifier/ipod-iphone-ipad-specs-by-model-identifier.html
        //! https://everymac.com/whatsnew/
        //! https://everymac.com/ultimate-mac-lookup/?search_keywords=Pending
        //! https://en.wikipedia.org/wiki/List_of_iOS_devices
        names = @{
                  //! Simulator
                  @"x86_64": @"Simulator",
                  @"i386": @"Simulator",
                      
                  //! iPhone
                  @"iPhone1,1": @"iPhone 1", //! 2007
                  
                  @"iPhone1,2": @"iPhone 3G", //! 2008
                  @"iPhone2,1": @"iPhone 3GS", //! 2009
                  
                  @"iPhone3,1": @"iPhone 4", //! GSM, 2010
                  @"iPhone3,2": @"iPhone 4", //! GSM, 2012
                  @"iPhone3,3": @"iPhone 4", //! CDMA, 2011
                  
                  @"iPhone4,1": @"iPhone 4S", //! 2011
                  
                  @"iPhone5,1": @"iPhone 5", //! GSM, 2012
                  @"iPhone5,2": @"iPhone 5", //! Global, 2012
                  @"iPhone5,3": @"iPhone 5C", //! GSM, 2013
                  @"iPhone5,4": @"iPhone 5C", //! Global, 2013
                  
                  @"iPhone6,1": @"iPhone 5S", //! GSM, 2013
                  @"iPhone6,2": @"iPhone 5S", //! Global, 2013
                  
                  @"iPhone7,1": @"iPhone 6 Plus", //! 2014
                  @"iPhone7,2": @"iPhone 6", //! 2014
                  
                  @"iPhone8,1": @"iPhone 6S", //! 2015
                  @"iPhone8,2": @"iPhone 6S Plus", //! 2015
                  
                  @"iPhone8,3": @"iPhone SE", //! 2016
                  @"iPhone8,4": @"iPhone SE", //! 2016
                  
                  @"iPhone9,1": @"iPhone 7", //! CDMA, 2016
                  @"iPhone9,2": @"iPhone 7 Plus", //! CDMA, 2016
                  @"iPhone9,3": @"iPhone 7", //! Global, 2016
                  @"iPhone9,4": @"iPhone 7 Plus", //! Global, 2016
                  
                  @"iPhone10,1": @"iPhone 8", //! CDMA, 2017
                  @"iPhone10,2": @"iPhone 8 Plus", //! CDMA, 2017
                  @"iPhone10,3": @"iPhone X", //! CDMA, 2017
                  @"iPhone10,4": @"iPhone 8", //! Global, 2017
                  @"iPhone10,5": @"iPhone 8 Plus", //! Global, 2017
                  @"iPhone10,6": @"iPhone X", //! Global, 2017
                  
                  @"iPhone11,2": @"iPhone XS", //! 2018
                  @"iPhone11,4": @"iPhone XS Max", //! 2018
                  @"iPhone11,6": @"iPhone XS Max", //! 2018
                  @"iPhone11,8": @"iPhone XR", //! 2018
                  
                  @"iPhone12,1": @"iPhone 11", //! 2019
                  @"iPhone12,3": @"iPhone 11 Pro", //! 2019
                  @"iPhone12,5": @"iPhone 11 Pro Max", //! 2019
                  
                  //! iPod Touch
                  @"iPod1,1": @"iPod Touch 1", //! 2007
                  @"iPod2,1": @"iPod Touch 2", //! 2008
                  @"iPod3,1": @"iPod Touch 3", //! 2009
                  @"iPod4,1": @"iPod Touch 4", //! 2010
                  @"iPod5,1": @"iPod Touch 5", //! 2012
                  @"iPod7,1": @"iPod Touch 6", //! 2015
                  @"iPod9,1": @"iPod Touch 7", //! 2019
                  
                  //! iPad
                  @"iPad1,1": @"iPad 1", //! 2010
                  @"iPad1,2": @"iPad 1", //! Cellular, 2010
                  @"iPad2,1": @"iPad 2", //! Wi-Fi, 2011
                  @"iPad2,2": @"iPad 2", //! GSM, 2011
                  @"iPad2,3": @"iPad 2", //! CDMA, 2011
                  @"iPad2,4": @"iPad 2", //! 2012
                  @"iPad3,1": @"iPad 3", //! Wi-Fi, 2012
                  @"iPad3,2": @"iPad 3", //! CDMA, 2012
                  @"iPad3,3": @"iPad 3", //! GSM, 2012
                  @"iPad3,4": @"iPad 4", //! Wi-Fi, 2012
                  @"iPad3,5": @"iPad 4", //! GSM, 2012
                  @"iPad3,6": @"iPad 4", //! Global, 2012
                  @"iPad6,11": @"iPad 5", //! Wi-Fi, 2017
                  @"iPad6,12": @"iPad 5", //! Cellular, 2017
                  @"iPad7,5": @"iPad 6", //! Wi-Fi, 2018
                  @"iPad7,6": @"iPad 6", //! Cellular, 2018
                  @"iPad7,11": @"iPad 7", //! Wi-Fi, 2019
                  @"iPad7,12": @"iPad 7", //! Cellular, 2019
                  
                  @"iPad2,5": @"iPad Mini 1", //! Wi-Fi, 2012
                  @"iPad2,6": @"iPad Mini 1", //! GSM, 2012
                  @"iPad2,7": @"iPad Mini 1", //! Global, 2012
                  @"iPad4,4": @"iPad Mini 2", //! Wi-Fi, 2013
                  @"iPad4,5": @"iPad Mini 2", //! Cellular, 2013
                  @"iPad4,6": @"iPad Mini 2", //! China, 2013
                  @"iPad4,7": @"iPad Mini 3", //! Wi-Fi, 2014
                  @"iPad4,8": @"iPad Mini 3", //! Cellular, 2014
                  @"iPad5,1": @"iPad Mini 4", //! Wi-Fi, 2015
                  @"iPad5,2": @"iPad Mini 4", //! Cellular, 2015
                  
                  @"iPad4,1": @"iPad Air 1", //! Wi-Fi, 2013
                  @"iPad4,2": @"iPad Air 1", //! Cellular, 2013
                  @"iPad4,3": @"iPad Air 1", //! China, 2013
                  @"iPad5,3": @"iPad Air 2", //! Wi-Fi, 2014
                  @"iPad5,4": @"iPad Air 2", //! Cellular, 2014
                  @"iPad11,3": @"iPad Air 3", //! Wi-Fi, 2019
                  @"iPad11,4": @"iPad Air 3", //! Cellular, 2019
                  
                  @"iPad6,7": @"iPad Pro 1", //! Wi-Fi, 12.9-inch, 2015
                  @"iPad6,8": @"iPad Pro 1", //! Cellular, 12.9-inch, 2015
                  @"iPad6,3": @"iPad Pro 1", //! Wi-Fi, 9.7-inch, 2016
                  @"iPad6,4": @"iPad Pro 1", //! Cellular, 9.7-inch, 2016
                  @"iPad7,1": @"iPad Pro 2", //! Wi-Fi, 12.9-inch, 2017
                  @"iPad7,2": @"iPad Pro 2", //! Cellular, 12.9-inch, 2017
                  @"iPad7,3": @"iPad Pro 2", //! Wi-Fi, 10.5-inch, 2017
                  @"iPad7,4": @"iPad Pro 2", //! Cellular, 10.5-inch, 2017
                  @"iPad8,1": @"iPad Pro 3", //! Wi-Fi, 11-inch, 4 GB, 2018
                  @"iPad8,2": @"iPad Pro 3", //! Wi-Fi, 11-inch, 6 GB, 2018
                  @"iPad8,3": @"iPad Pro 3", //! Cellular, 11-inch, 4 GB, 2018
                  @"iPad8,4": @"iPad Pro 3", //! Cellular, 11-inch, 6 GB, 2018
                  @"iPad8,5": @"iPad Pro 3", //! Wi-Fi, 12.9-inch, 4 GB, 2018
                  @"iPad8,6": @"iPad Pro 3", //! Wi-Fi, 12.9-inch, 6 GB, 2018
                  @"iPad8,7": @"iPad Pro 3", //! Cellular, 12.9-inch, 4 GB, 2018
                  @"iPad8,8": @"iPad Pro 3", //! Cellular, 12.9-inch, 6 GB, 2018
                  @"iPad8,9": @"iPad Pro 4", //! Wi-Fi, 11-inch, 2020
                  @"iPad8,10": @"iPad Pro 4", //! Cellular, 11-inch, 2020
                  @"iPad8,11": @"iPad Pro 4", //! Wi-Fi, 12.9-inch, 2020
                  @"iPad8,12": @"iPad Pro 4", //! Cellular, 12.9-inch, 2020
                  
                  //! Apple TV
                  @"AppleTV1,1": @"Apple TV 1", //! macOS, 2007
                  @"AppleTV2,1": @"Apple TV 2", //! iOS, 2010
                  @"AppleTV3,1": @"Apple TV 3", //! 1080p, 2012
                  @"AppleTV3,2": @"Apple TV 3", //! Rev A, 2013
                  @"AppleTV5,3": @"Apple TV 4", //! tvOS, 2015
                  @"AppleTV6,2": @"Apple TV 5", //! 4K, 2017

                  };
    });
    return names[identifier];
}





@end
