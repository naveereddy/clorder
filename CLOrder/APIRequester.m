//
//  APIRequester.m
//  CLOrder
//
//  Created by Vegunta's on 16/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "APIRequester.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Reachability.h"


@interface APIRequester() {
    NSMutableData *responseData;
}
@end

@implementation APIRequester

@synthesize requestURL, requestCallback, delegate, callback, headers, requestBody, syncInProgress;

- (BOOL)initializeRequest:(NSDictionary *)requestObj {
    
    NSString *remoteHostName = @"www.apple.com";
    
    Reachability *hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    hostReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [hostReachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network connection not available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            return 0;
        }
        case ReachableViaWWAN:
        {
            
            
        }
        case ReachableViaWiFi:
        {
        }
    }
    requestBody = requestObj;
    NSLog(@"Request URL : %@",requestURL);
    NSLog(@"Request Obj : %@",requestObj);
    if([requestURL containsString:@"FetchClientChildLocations"]){
        
    }else if (!syncInProgress){
        [AppDelegate loaderShow:YES];
    }
    //    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    //    payload[@"DeviceID"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //    payload[@"AMIDRequest"] = xmlRequest;
    //    NSData *payloadData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    responseData = [[NSMutableData alloc] init];
    NSData *payloadData;
    if (!requestObj) {
        [request setHTTPMethod:@"GET"];
    }else{
        payloadData = [NSJSONSerialization dataWithJSONObject:requestObj options:0 error:nil];//[xmlRequest dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:payloadData];
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [headers.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [request setValue:headers[obj] forHTTPHeaderField:obj];
    }];
    //    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[payloadData length]] forHTTPHeaderField:@"Content-Length"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [connection start];
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (requestCallback) {
        requestCallback(responseData);
    } else {
        [delegate performSelector:callback withObject:responseData];
    }
    if([requestURL containsString:@"FetchClientChildLocations"]){
        
    }else if(!syncInProgress){
        [AppDelegate loaderShow:NO];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (!syncInProgress){
        
    }
    
    if (requestCallback) {
        requestCallback(nil);
    } else {
        [delegate performSelector:callback withObject:nil];
    }
    if([requestURL containsString:@"FetchClientChildLocations"]){
        
    }else if(!syncInProgress){
        [AppDelegate loaderShow:NO];
    }
}

@end
