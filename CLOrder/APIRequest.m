//
//  APIRequest.m
//  CLOrder
//
//  Created by Vegunta's on 16/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "APIRequest.h"
#import <UIKit/UIKit.h>

@implementation APIRequest


+ (void)registerClorderUser:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/RegisterClorderUser",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)loginUser:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/LoginUser",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientSettings:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchClientSettings",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientMenu:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchClientMenu",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}


+ (void)fetchClientItems:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchClientItems",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientCategories:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchClientCategories",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)getModifiersForItem:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/GetModifiersForItem",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)getRestaurentPromotions:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/GetRestaurentPromotions",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)getRestaurentHours:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/GetRestaurentHours",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchMenuWithCategories:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchMenuWithCategories",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientOrderHistory:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchClientOrderHistory",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)getOrderdetails:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/GetOrderdetails",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)getOrderDetailsForReorder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/GetOrderDetailsForReorder",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)placeOrder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/PlaceOrder",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)confirmPaypalOrder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ConfirmPaypalOrder",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchDeliveryFees:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchDeliveryFees",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchTaxForOrder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchTaxForOrder",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)updateClorderUser:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/UpdateClorderUser",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchDiscount:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchDiscount",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)clorderGoogleSignup:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderGoogleSignup",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)fetchRestTimeSlots:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/FetchRestTimeSlots",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)googleAutoComplteApi:(NSDictionary *)dict url:(NSString *)url completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@",url];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
@end
