//
//  Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 7.6.13.
//  Copyright (c) 2013 iAdverti. All rights reserved.
//

@import Foundation;

FOUNDATION_EXPORT double EssentialsVersionNumber;
FOUNDATION_EXPORT const unsigned char EssentialsVersionString[];


#import "Foundation+Essentials.h"
#import "NSObject+Essentials.h"
#import "NSString+Essentials.h"
#import "NSArray+Essentials.h"
#import "NSMutableArray+Essentials.h"
#import "NSDictionary+Essentials.h"
#import "NSMutableDictionary+Essentials.h"
#import "NSError+Essentials.h"
#import "NSNumber+Essentials.h"
#import "NSInvocation+Essentials.h"
#import "NSOperationQueue+Essentials.h"
#import "NSTimer+Essentials.h"
#import "NSDate+Essentials.h"
#import "NSData+Essentials.h"
#import "NSUUID+Essentials.h"
#import "NSSortDescriptor+Essentials.h"
#import "NSIndexPath+Essentials.h"
#import "NSLocale+Essentials.h"
#import "NSURLRequest+Essentials.h"
#import "NSURLSession+Essentials.h"
#import "ESSURLResponse.h"
#import "ESSProxy.h"
#import "ESSLog.h"
#import "NSCoder+Essentials.h"
#import "ESSCatch.h"
#import "NSBundle+Essentials.h"
#import "NSMutableSet+Essentials.h"
#import "NSMapTable+Essentials.h"
#import "NSDateFormatter+Essentials.h"
#import "NSCharacterSet+Essentials.h"
#import "ESSEvent.h"
#import "JSON.h"
#import "NSFileManager+Essentials.h"
#import "ESSHash.h"
#import "NSValue+Essentials.h"
#import "ESSBinaryHeap.h"
#import "ESSEnumerator.h"

#import "Typed.h"
#import "jDateFormat.h"

#if TARGET_OS_IPHONE
    #import "UIKit+Essentials.h"
    #import "UIAlertController+Essentials.h"
    #import "UIColor+Essentials.h"
    #import "UIDevice+Essentials.h"
    #import "UIImage+Essentials.h"
    #import "UIScreen+Essentials.h"
    #import "UIView+Essentials.h"
    #import "UIScrollView+Essentials.h"
    #import "NSShadow+Essentials.h"
    #import "NSAttributedString+Essentials.h"
    #import "NSMutableAttributedString+Essentials.h"
    #import "UITableView+Essentials.h"
    #import "UIFont+Essentials.h"
    #import "UIBarButtonItem+Essentials.h"
    #import "UIBezierPath+Essentials.h"
    #import "UIViewController+Essentials.h"
    #import "UIApplication+Essentials.h"
    #import "ESSDrawView.h"
    #import "UIButton+Essentials.h"
    #import "UIControl+Essentials.h"
    #import "UISwipeActionsConfiguration+Essentials.h"
    #import "UIContextualAction+Essentials.h"
    #import "ESSDragInteractionDelegate.h"
#endif

#import "CoreImage+Essentials.h"
#import "CIContext+Essentials.h"
#import "CIFilter+Essentials.h"
