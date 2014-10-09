//
//  NSURLRequest+Essentials.h
//  Essentials
//
//  Created by Martin Kiss on 9.10.14.
//  Copyright (c) 2014 iAdverti. All rights reserved.
//

#import <Foundation/Foundation.h>



//! Protocol that abstracts providing of request body. At leats one method should return non-nil object.
@protocol ESSURLRequestBody <NSObject>
//! Return file URL object of a file to be be uploaded. Takes precedence over -essURLRequestBodyData.
- (NSURL *)essURLRequestBodyFileURL;
//! Return memory data object to be uploaded.
- (NSData *)essURLRequestBodyData;
@end

//! Data objects can be used as URL request body, returns the receiver.
@interface NSData (ESSURLRequestBody) <ESSURLRequestBody> @end

//! Path string objects can be used to represent URL request body, returns file URL with receiver as the path.
@interface NSString (ESSURLRequestBody) <ESSURLRequestBody> @end

//! File URL objects can be used to represent URL request body, returns itself.
@interface NSURL (ESSURLRequestBody) <ESSURLRequestBody> @end





@interface NSURLRequest (Essentials)



//! Returns new URL request.
+ (instancetype)requestWithMethod:(NSString *)HTTPMethod URL:(NSURL *)URL headers:(NSDictionary *)headers body:(id<ESSURLRequestBody>)body;



@end





@interface NSMutableURLRequest (Essentials)


//! Sets .HTTPBody or .HTTPBodyStream based on the argument.
- (void)setBody:(id<ESSURLRequestBody>)body;


@end


