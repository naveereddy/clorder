    //
//  AppDelegate.m
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "AppDelegate.h"
#import "AppHeader.h"
#import <MapKit/MapKit.h>
#import "CartObj.h"
#import "LocationContact.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "APIRequest.h"
#import "DeliveryAddress.h"


static NSString * const kClientId = @"679446363010-t393n7nhk3shrq5mvd6jev39dldmh4sm.apps.googleusercontent.com";

@interface AppDelegate ()

@end

@implementation AppDelegate

+(void)loaderShow:(BOOL)val{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static Loader * lod;
    
    if (lod == nil) {
        lod = [[Loader alloc] init];
    }
    if (val) {
        lod.retainCountVal ++;
        [appDel.window addSubview:lod];
    }else{
        lod.retainCountVal --;
        if (lod.retainCountVal <= 0) {
            lod.retainCountVal = 0;
            [lod removeFromSuperview];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:@"AVHn_BDAMoZIsKAAo7GjwI0M-7e1Gnc2XacJhYL4a5tvPeBuXbCqBC2AWGO3", PayPalEnvironmentSandbox:@"AT6cGxBwRvDtcg5ZovY3buRT28DbZP7MBRaHEON8YZvUUd1FSz6ZHNQ1ejvc"}];
//    @"AT6cGxBwRvDtcg5ZovY3buRT28DbZP7MBRaHEON8YZvUUd1FSz6ZHNQ1ejvc"
//    @"AiHdWrSoknctBzRntL9-oGotJkMvADGAVcX3y06XfaRtRllojh88rDlA" //Sandeep account sandbox
//    @"AbpsMFPwYRRkGEt2XSRpUa2wKnLzrH569zYOo0ZqoCJjUqFAJgSuYkIaIRM2hDBnbBKfcLrIHin4zFDj" //Sandeep account Live
    [GIDSignIn sharedInstance].clientID = kClientId;
    [GIDSignIn sharedInstance].delegate = self;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Lora-Regular" size:18],NSFontAttributeName,nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = APP_COLOR;
    }
    [self.window setTintColor:APP_COLOR];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[CartObj instance].itemsForCart removeAllObjects];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:@"cart"]) {
//        NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:data]);
        [[CartObj instance].itemsForCart addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self fetchClientSettings];
    [[CartObj instance].itemsForCart removeAllObjects];
    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:@"cart"]) {
//        NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:data]);
        [[CartObj instance].itemsForCart addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[CartObj instance].itemsForCart removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"BusinessHours"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"MinDelivery"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"clientLat"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"clientLon"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) fetchClientSettings{
    [APIRequest fetchClientSettings:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
//            NSDate *now = [NSDate date];
//            NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
//            NSArray *daysOfWeek = @[@"",@"Su",@"M",@"T",@"W",@"Th",@"F",@"S"];
//            [nowDateFormatter setDateFormat:@"e"];
//            weekdayNumber = (NSInteger)[[nowDateFormatter stringFromDate:now] integerValue];
//            NSLog(@"Day of Week: %@",[daysOfWeek objectAtIndex:weekdayNumber]);
            
            if ([[resObj objectForKey:@"isSuccess"] boolValue] &&
                ![[resObj objectForKey:@"ClientSettings"] isKindOfClass:[NSNull class]] &&
                [[[resObj objectForKey:@"ClientSettings"] objectForKey:@"BusinessHours"] count]) {
                
                [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
                NSLog(@"%@", [NSDate date]);
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray arrayWithArray:[[[resObj objectForKey:@"ClientSettings"] objectForKey:@"BusinessHours"] mutableCopy]] forKey:@"BusinessHours"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"DelTimeOffset"] forKey:@"DelTimeOffset"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"PickupTimeOffset"] forKey:@"PickupTimeOffset"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"MinDelivery"] forKey:@"MinDelivery"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"maxCashValue"] forKey:@"maxCashValue"];

                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"clientLat"] forKey:@"clientLat"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"clientLon"] forKey:@"clientLon"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[[resObj objectForKey:@"isRestOpen"] boolValue]] forKey:@"isRestOpen"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ClientName"] forKey:@"ClientName"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"PhoneNumber"] forKey:@"ClientPhone"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ShippingOptionId"] forKey:@"ShippingOptionId"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"DeliveryType"] forKey:@"DeliveryType"];
                NSLog(@"address %@,%@",[resObj objectForKey:@"DeliveryAddresses"],[resObj objectForKey:@"clientId"]);
                if([[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ShippingOptionId"] integerValue] == 2){
                    if(![[resObj objectForKey:@"DeliveryAddresses"] isKindOfClass:[NSNull class]]){
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DeliveryAddresses"];
                        NSMutableArray *addressAarry=[[NSMutableArray alloc] initWithCapacity:0];
                        for(NSDictionary *obj in [resObj objectForKey:@"DeliveryAddresses"]){
                            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
//                            DeliveryAddress *devly=[[DeliveryAddress alloc] init];
//                            devly.Address1=[[obj objectForKey:@"Address1"] isKindOfClass:[NSNull class]] ? @"":[obj objectForKey:@"Address1"];
//                            devly.Address2=[[obj objectForKey:@"Address2"] isKindOfClass:[NSNull class]] ? @"":[obj objectForKey:@"Address2"];
//                            devly.City=[[obj objectForKey:@"City"] isKindOfClass:[NSNull class]]? @"":[obj objectForKey:@"City"];
//                            devly.ZipPostalCode=[[obj objectForKey:@"ZipPostalCode"] isKindOfClass:[NSNull class]]? @"":[obj objectForKey:@"ZipPostalCode"];
                          [dic setObject:[[obj objectForKey:@"Address1"] isKindOfClass:[NSNull class]] ? @"":[obj objectForKey:@"Address1"] forKey:@"Address1"];
                          [dic setObject:[[obj objectForKey:@"Address2"] isKindOfClass:[NSNull class]] ? @"":[obj objectForKey:@"Address2"] forKey:@"Address2"];
                          [dic setObject:[[obj objectForKey:@"City"] isKindOfClass:[NSNull class]]? @"":[obj objectForKey:@"City"] forKey:@"City"];
                          [dic setObject:[[obj objectForKey:@"ZipPostalCode"] isKindOfClass:[NSNull class]]? @"":[obj objectForKey:@"ZipPostalCode"] forKey:@"ZipPostalCode"];
                          [addressAarry addObject:dic];
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:addressAarry forKey:@"DeliveryAddresses"];
                    }else{
                        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
                        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
                        NSError *error = nil;
                        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DeliveryAddresses"];
                        [[NSUserDefaults standardUserDefaults] setObject:[jsonDict objectForKey:@"DeliveryAddresses"] forKey:@"DeliveryAddresses"];
                    }
                }
                if ([resObj objectForKey:@"EnableTip"] && [[resObj objectForKey:@"EnableTip"] boolValue]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"DefaultTip"] forKey:@"DefaultTip"];

                }else{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DefaultTip"];
                }
                NSLog(@"%@\n%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"TipIndex"],[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultTip"]);

            }
        }
    }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    if ([url.absoluteString rangeOfString:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"]]].location != NSNotFound)
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }else{
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }

}


//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary *)options {
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//
//    
//}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
}


- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


@end
