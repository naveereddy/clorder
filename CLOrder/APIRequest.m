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
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/RegisterClorderUser",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)loginUser:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/LoginUser",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientSettings:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchClientSettings",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)fetchChildClientSettings:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/clordermobile/FetchClientChildLocations",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientMenu:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchClientMenu",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}


+ (void)fetchClientItems:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchClientItems",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientCategories:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchClientCategories",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)getModifiersForItem:(NSDictionary *)dict completion:(RequestCallback)cb {
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/GetModifiersForItem",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)getRestaurentPromotions:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/GetRestaurentPromotions",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)getRestaurentHours:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/GetRestaurentHours",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchMenuWithCategories:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchMenuWithCategories",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchClientOrderHistory:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchClientOrderHistory",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)getOrderdetails:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/GetOrderdetails",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)getOrderDetailsForReorder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/GetOrderDetailsForReorder",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)placeOrder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/PlaceOrder",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)confirmOrderPostPayment:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/ConfirmOrderPostPayment",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)confirmPaypalOrder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/ConfirmOrderPostPayment",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchDeliveryFees:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchDeliveryFees",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchTaxForOrder:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchTaxForOrder",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)updateClorderUser:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/UpdateClorderUser",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)fetchDiscount:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchDiscount",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}

+ (void)clorderGoogleSignup:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/ClorderGoogleSignup",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)fetchRestTimeSlots:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderMobile/FetchRestTimeSlots",REST_URL];
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
+ (void)gettingLatLong:(NSDictionary *)dict url:(NSString *)url completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@",url];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)forgotPasswordApi:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderUserAdmin/ResetUserPassword",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)changePasswordApi:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"%@/ClorderUserAdmin/ChangeUserPassword",REST_URL];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
+ (void)searchLocationlist:(NSDictionary *)dict completion:(RequestCallback)cb{
    APIRequester *connection = [[APIRequester alloc] init];
    connection.requestURL = [NSMutableString stringWithFormat:@"https://xnabrco3j1.execute-api.us-east-2.amazonaws.com/prod/api/"];
    connection.requestCallback = ^(NSMutableData *data){
        cb(data);
    };
    //    connection.headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Content-Type",@"application/json",nil];
    if (![connection initializeRequest:dict])
        cb(nil);
}
@end
