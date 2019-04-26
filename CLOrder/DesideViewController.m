//
//  DesideViewController.m
//  CLOrder
//
//  Created by Naveen Thukkani on 03/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "DesideViewController.h"
#import "APIRequest.h"
#import "APIRequester.h"
#import "AppHeader.h"
#import "MultiLocationVC.h"
#import "SelectedRestroVC.h"

@interface DesideViewController ()

@end

@implementation DesideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([ORDER_ONLINE isEqualToString:@"YES"]){
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MultiLocationVC *mul =[storyboard instantiateViewControllerWithIdentifier:@"orderOnlineMain"];
        UINavigationController *con=[[UINavigationController alloc] initWithRootViewController:mul];
        [con.navigationBar setBackgroundColor:[UIColor clearColor]];
        [con.navigationBar setBarTintColor:APP_COLOR];
        [self presentViewController:con animated:YES completion:nil];
    }else{
        [self fetchChildClientSettings];
    }
}
-(void)fetchChildClientSettings{
    [APIRequest fetchChildClientSettings:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
        }else{
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if([[resObj objectForKey:@"isSuccess"] boolValue]){
                NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
                for (NSDictionary *personObject in ((NSArray *)[resObj objectForKey:@"ChildLocations"])) {
                    NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:personObject];
                    [archiveArray addObject:personEncodedObject];
                }
                [[NSUserDefaults standardUserDefaults] setObject:archiveArray forKey:@"Locations"];

                if([((NSArray *)[resObj objectForKey:@"ChildLocations"]) count] > 1){
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MultiLocationVC *mul =[storyboard instantiateViewControllerWithIdentifier:@"MultiLocation"];
                    mul.locationsList=[resObj objectForKey:@"ChildLocations"];
                    UINavigationController *con=[[UINavigationController alloc] initWithRootViewController:mul];
                    [self presentViewController:con animated:YES completion:nil];
                }else{
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SelectedRestroVC *select =[storyboard instantiateViewControllerWithIdentifier:@"SelectedRes"];
                    UINavigationController *con=[[UINavigationController alloc] initWithRootViewController:select];
                    [self presentViewController:con animated:YES completion:nil];
                    [self fetchClientSettings];
                }
            }
        }
    }];
}
-(void) fetchClientSettings{
    [APIRequest fetchClientSettings:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
        }else{
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
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
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"PaymentSetting"] forKey:@"PaymentSetting"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ShippingOptionId"] forKey:@"ShippingOptionId"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"TimeZone"] forKey:@"TimeZone"];
                [[NSUserDefaults standardUserDefaults] setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"DeliveryType"] forKey:@"DeliveryType"];
                NSLog(@"address %@,%@",[resObj objectForKey:@"DeliveryAddresses"],[resObj objectForKey:@"clientId"]);
                if([[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ShippingOptionId"] integerValue] == 2){
                    if(![[resObj objectForKey:@"DeliveryAddresses"] isKindOfClass:[NSNull class]]){
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DeliveryAddresses"];
                        NSMutableArray *addressAarry=[[NSMutableArray alloc] initWithCapacity:0];
                        for(NSDictionary *obj in [resObj objectForKey:@"DeliveryAddresses"]){
                            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
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
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
