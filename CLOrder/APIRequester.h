//
//  APIRequester.h
//  CLOrder
//
//  Created by Vegunta's on 16/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define REST_URL_DEV
//#define REST_URL @"http://devapi.clorder.com"
#define REST_URL @"https://api.clorder.com"
typedef void (^RequestCallback)(NSMutableData *buffer);

@interface APIRequester : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableString *requestURL;
@property (nonatomic, strong) RequestCallback requestCallback;
@property (nonatomic, strong) id delegate;
@property (nonatomic, assign) SEL callback;
@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSDictionary *requestBody;
@property (nonatomic, assign) BOOL syncInProgress;
- (BOOL)initializeRequest:(NSDictionary *)requestObj;

@end
