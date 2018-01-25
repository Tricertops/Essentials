//
//  ESSDrawView.h
//  Essentials
//
//  Created by Martin Kiss on 3.5.15.
//  Copyright (c) 2015 iAdverti. All rights reserved.
//

#import "UIKit+Essentials.h"



@interface ESSDrawView : UIView

/// Set or get drawing block currently used by the receiver.
@property (nonatomic) void (^drawRectBlock)(UIView *view, CGRect rect);

@end



@interface UIView (ESSDrawView)

/// Creates new view with given block invoked from drawRect:
+ (ESSDrawView *)viewWithDrawRect: (void (^)(UIView *view, CGRect rect))drawRect;

@end


