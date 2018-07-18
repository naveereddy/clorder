//
//  SelectedRestroVC.m
//  CLOrder
//
//  Created by Vegunta's on 30/05/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "SelectedRestroVC.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "AllDayMenuVC.h"
#import "DeliveryVC.h"
#import "LoginVC.h"
#import "OrderHistoryVC.h"
#import "CartObj.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "Schedular.h"
#import "SignUpView.h"

@implementation SelectedRestroVC{
    NSUserDefaults *user;
    NSInteger weekdayNumber;
    UIButton *pickupBtn;
    UIButton *deliveryBtn;
    UIButton *loginBtn;
    UIButton *registerBtn;
    UIView *dummyV;
    int currTimeInSec;
    UIButton *locationMarker;
}
@synthesize  del;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

-(void)createUI{
    user = [NSUserDefaults standardUserDefaults];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    bgImg.image = [UIImage imageNamed:APP_BG_IMG];
//    [self.view addSubview:bgImg];
//    bgImg.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-125, self.view.frame.size.height/2-185, 250, 150)];
    logoImg.image = [UIImage imageNamed:@"new_Logo"];
    [self.view addSubview:logoImg];
    logoImg.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *midleline=[[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT/2, 2, 40)];
    [midleline setBackgroundColor:APP_COLOR];
    [self.view addSubview:midleline];

    UIButton *reorderLast = [UIButton buttonWithType:UIButtonTypeCustom];
    reorderLast.frame = CGRectMake(10, SCREEN_HEIGHT/2, SCREEN_WIDTH-20, 40);
    [reorderLast setTitleColor:APP_COLOR forState:UIControlStateNormal];
    [reorderLast setImage:[UIImage imageNamed:@"reorder-subimage"] forState:UIControlStateNormal];
    [reorderLast setTitle:@"REORDER YOUR LAST ORDER" forState:UIControlStateNormal];
    reorderLast.titleLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16];
    if(self.view.frame.size.width > 375){
        reorderLast.imageEdgeInsets = UIEdgeInsetsMake(5,-75, 5, 5);
        midleline.frame =CGRectMake(80, SCREEN_HEIGHT/2, 2, 40);
    }else if(self.view.frame.size.width > 320){
        midleline.frame =CGRectMake(70, SCREEN_HEIGHT/2, 2, 40);
        reorderLast.imageEdgeInsets = UIEdgeInsetsMake(5,-65, 5, 5);
    }else{
        reorderLast.imageEdgeInsets = UIEdgeInsetsMake(5,-5, 5, 5);
    }
    reorderLast.titleEdgeInsets = UIEdgeInsetsMake(5,30,5,0);
    reorderLast.layer.borderColor=[APP_COLOR CGColor];
    reorderLast.layer.borderWidth=2;
    [reorderLast.layer setCornerRadius:2];
    [reorderLast addTarget:self action:@selector(reorderLastAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reorderLast];
    
    
    pickupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pickupBtn.frame = CGRectMake(10, self.view.frame.size.height/2+80, self.view.frame.size.width/2-20, 40);
    pickupBtn.layer.cornerRadius = 3.0;
    pickupBtn.backgroundColor = APP_COLOR;
    [pickupBtn setTitle:@"PICKUP" forState:UIControlStateNormal];
    pickupBtn.titleLabel.textColor = [UIColor whiteColor];
    pickupBtn.titleLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16];
    [pickupBtn addTarget:self action:@selector(pickupBtnAct) forControlEvents:UIControlEventTouchUpInside];
    
    deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deliveryBtn.frame = CGRectMake(self.view.frame.size.width/2+10, self.view.frame.size.height/2+80, self.view.frame.size.width/2-20, 40);
    deliveryBtn.layer.cornerRadius = 3.0;
    deliveryBtn.backgroundColor = APP_COLOR;
    [deliveryBtn setTitle:@"DELIVERY" forState:UIControlStateNormal];
    deliveryBtn.titleLabel.textColor = [UIColor whiteColor];
    deliveryBtn.titleLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16];
    [deliveryBtn addTarget:self action:@selector(deliveryBtnAct) forControlEvents:UIControlEventTouchUpInside];
    
    
    if([[user objectForKey:@"DeliveryType"] integerValue] == 4){
        [self.view addSubview:pickupBtn];
        [self.view addSubview:deliveryBtn];
    }else if([[user objectForKey:@"DeliveryType"] integerValue] == 1){
        pickupBtn.frame=CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width/4-10), self.view.frame.size.height/2+80, self.view.frame.size.width/2-20, 40);
        [self.view addSubview:pickupBtn];
    }else if([[user objectForKey:@"DeliveryType"] integerValue] == 2){
        deliveryBtn.frame=CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width/4-10), self.view.frame.size.height/2+80, self.view.frame.size.width/2-20, 40);
        [self.view addSubview:deliveryBtn];
    }else{
        [self.view addSubview:pickupBtn];
        [self.view addSubview:deliveryBtn];
    }
    registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(self.view.frame.size.width/2+10, self.view.frame.size.height/2+140, self.view.frame.size.width/2-40, 60);
    registerBtn.titleLabel.textColor = [UIColor blackColor];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [registerBtn setImage:[UIImage imageNamed:@"home-register"] forState:UIControlStateNormal];
    [registerBtn setTitle:@"REGISTER" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    if(self.view.frame.size.width > 375){
        registerBtn.imageEdgeInsets = UIEdgeInsetsMake(-30,((self.view.frame.size.width/2)-86)/2,0,0);
    }else if(self.view.frame.size.width > 320){
        registerBtn.imageEdgeInsets = UIEdgeInsetsMake(-30,((self.view.frame.size.width/2)-80)/2,0,0);
    }else{
        registerBtn.imageEdgeInsets = UIEdgeInsetsMake(-30,((self.view.frame.size.width/2)-70)/2,0,0);
    }
    registerBtn.titleEdgeInsets = UIEdgeInsetsMake(30,-((self.view.frame.size.width/2)-40-70)/2,0,0);
    [registerBtn addTarget:self action:@selector(registebtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    
    UILabel *poweredby=[[UILabel alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT-60, SCREEN_WIDTH/2-40, 30)];
    [poweredby setText:@"Powered by:"];
    [poweredby setFont:[UIFont fontWithName:@"Lora-Regular" size:14]];
    [poweredby setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:poweredby];
    
    UIImageView *clorder = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+10, SCREEN_HEIGHT-60, 130, 30)];
    [self.view addSubview:clorder];
    clorder.image = [UIImage imageNamed:@"clorder_name"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *presentVersion=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *versionLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 -50, SCREEN_HEIGHT-20, 100, 15)];
    versionLbl.text = [NSString stringWithFormat:@"V-%@", presentVersion];
    [self.view addSubview:versionLbl];
    versionLbl.font = [UIFont systemFontOfSize:10];
    versionLbl.textColor = APP_COLOR;
    versionLbl.textAlignment=NSTextAlignmentCenter;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
    [nowDateFormatter setDateFormat:@"e"];
    NSLog(@"%@",[nowDateFormatter stringFromDate:now]);
    weekdayNumber = (NSInteger)[[nowDateFormatter stringFromDate:now] integerValue]-1;
    
    loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
}
-(void)markerAction{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cartPrice"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PaymentInformation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CouponDetails"];
    [[CartObj instance].itemsForCart removeAllObjects];
    [CartObj clearInstance];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)registebtnAction{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cartPrice"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PaymentInformation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CouponDetails"];
    
    [[CartObj instance].itemsForCart removeAllObjects];
    [CartObj clearInstance];
    
    SignUpView *signUpV = [[SignUpView alloc] init];
//    signUpV.emailId = email.text;
//    signUpV.password = password.text;
    [self.navigationController pushViewController:signUpV animated:YES];
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), 44), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:blank forBarMetrics:UIBarMetricsDefault];

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:0] forKey:@"AddMore"];
    
    loginBtn.frame = CGRectMake(20, self.view.frame.size.height/2+140,(self.view.frame.size.width/2)-40, 60);
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
//    [loginBtn.layer setBorderWidth:1];
//    [loginBtn.layer setBorderColor:[APP_COLOR CGColor]];
    [loginBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
            [loginBtn setTitle:@"LOGOUT" forState:UIControlStateNormal];
            [user setObject:[NSNumber numberWithInt:0] forKey:@"popIndex"];
        }else{
            [loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
            [user setObject:[NSNumber numberWithInt:1] forKey:@"popIndex"];
        }

    [loginBtn setImage:[UIImage imageNamed:@"home-login"] forState:UIControlStateNormal];
    if(self.view.frame.size.width > 375){
        loginBtn.imageEdgeInsets = UIEdgeInsetsMake(-30,((self.view.frame.size.width/2)-135)/2,0, 0);
    }else if(self.view.frame.size.width > 320){
        loginBtn.imageEdgeInsets = UIEdgeInsetsMake(-30,((self.view.frame.size.width/2)-100)/2,0, 0);
    }else{
        loginBtn.imageEdgeInsets = UIEdgeInsetsMake(-30,((self.view.frame.size.width/2)-70)/2,0, 0);
    }
    loginBtn.titleEdgeInsets = UIEdgeInsetsMake(30,-((self.view.frame.size.width/2)-40-65)/2,0,0);
    [loginBtn addTarget:self action:@selector(logInBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    NSMutableArray *locationsary=[NSMutableArray arrayWithCapacity:0];
    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:@"Locations"]) {
        NSDictionary *dic=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [locationsary addObject:dic];
    }
    if([locationsary count] > 1){
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        locationMarker=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 30, 50, 50)];
        [locationMarker setImage:[UIImage imageNamed:@"loaction_marker"] forState:UIControlStateNormal];
        [locationMarker addTarget:self action:@selector(markerAction) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:locationMarker];
        [window bringSubviewToFront:locationMarker];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setBackgroundColor:APP_COLOR];
    [locationMarker removeFromSuperview];
}
- (void)logInBtnAct {
    [user setObject:[NSNumber numberWithInt:0] forKey:@"OrderType"];
    if ([[user objectForKey:@"userInfo"] objectForKey:@"UserId"] > 0) {
        
        [loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
        
        [user removeObjectForKey:@"userInfo"];
        [user removeObjectForKey:@"cartPrice"];
        [user removeObjectForKey:@"PaymentInformation"];
        [user removeObjectForKey:@"subTotalPrice"];
        [user removeObjectForKey:@"cart"];
        [user removeObjectForKey:@"CouponDetails"];
        [user removeObjectForKey:@"TipIndex"];
        
        [[CartObj instance].itemsForCart removeAllObjects];
        [CartObj clearInstance];
        
        [[GIDSignIn sharedInstance] signOut];
        [[FBSDKLoginManager new] logOut];
        
    }else{
        [self pushLoginScreen];
    }
}


-(void) fetchClientSettings{
    [APIRequest fetchClientSettings:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            [user removeObjectForKey: @"BusinessHours"];
            [user removeObjectForKey: @"MinDelivery"];
            [user removeObjectForKey: @"clientLat"];
            [user removeObjectForKey: @"clientLon"];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
            if ([[resObj objectForKey:@"isSuccess"] boolValue] &&
                ![[resObj objectForKey:@"ClientSettings"] isKindOfClass:[NSNull class]] &&
                [[[resObj objectForKey:@"ClientSettings"] objectForKey:@"BusinessHours"] count]) {
                
                [NSTimeZone setDefaultTimeZone:[resObj objectForKey:@"TimeZone"]];
                
                [user setObject:[NSMutableArray arrayWithArray:[[[resObj objectForKey:@"ClientSettings"] objectForKey:@"BusinessHours"] mutableCopy]] forKey:@"BusinessHours"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"DelTimeOffset"] forKey:@"DelTimeOffset"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"PickupTimeOffset"] forKey:@"PickupTimeOffset"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"MinDelivery"] forKey:@"MinDelivery"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"maxCashValue"] forKey:@"maxCashValue"];

                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"clientLat"] forKey:@"clientLat"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"clientLon"] forKey:@"clientLon"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ClientName"] forKey:@"ClientName"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"PhoneNumber"] forKey:@"ClientPhone"];
                [user setObject:[NSNumber numberWithBool:[[resObj objectForKey:@"isRestOpen"] boolValue]] forKey:@"isRestOpen"];
                [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ShippingOptionId"] forKey:@"ShippingOptionId"];
                NSLog(@"address %@,%@",[resObj objectForKey:@"DeliveryAddresses"],[resObj objectForKey:@"clientId"]);
                if([[[resObj objectForKey:@"ClientSettings"] objectForKey:@"ShippingOptionId"] integerValue] == 2){
                    if([resObj objectForKey:@"DeliveryAddresses"]){
                        
                    }else{
                        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
                        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
                        NSError *error = nil;
                        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                        NSLog(@"%@", jsonDict);
                   }
                }
                if ([resObj objectForKey:@"EnableTip"] && [[resObj objectForKey:@"EnableTip"] boolValue]) {
                    [user setObject:[[resObj objectForKey:@"ClientSettings"] objectForKey:@"DefaultTip"] forKey:@"DefaultTip"];
                    
                }else{
                    [user removeObjectForKey:@"DefaultTip"];
                }
                
            }
            if (pickupBtn.selected) {
                [self pickupBtnAct];
            }
            if (deliveryBtn.selected) {
                [self deliveryBtnAct];
            }
        }
    }];
}

- (void)reorderLastAct {
    [user setObject:[NSNumber numberWithInt:3] forKey:@"OrderType"];
    if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
        OrderHistoryVC *nextView = [[OrderHistoryVC alloc] init];
        [self.navigationController pushViewController:nextView animated:YES];
    }else{
        [self pushLoginScreen];
    }
}

-(BOOL)checkRestroClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Closed"] boolValue]) {
            open = NO;
            break;
        }else{
            open = YES;
        }
    }
    return open;
}

-(BOOL)checkDeliveryClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"DeliveryClosed"] boolValue]) {
            open = NO;
            break;
        }else{
            open = YES;
        }
    }
    return open;
}

-(BOOL)checkPickUpClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber){
            if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Closed"] boolValue]) {
                open = NO;
                break;
            }else{
                open = YES;
            }
        }else{
            open = YES;
        }
    }
    return open;
}
-(void)pickupBtnAct{
    if(![CartObj checkPickupDelivery:YES])
        return;
    if ([[user objectForKey:@"BusinessHours"] count] <=0) {
        pickupBtn.selected = YES;
        deliveryBtn.selected = NO;
        [self fetchClientSettings];
    }else{
        if ([[user objectForKey:@"isRestOpen"] boolValue] && [self checkPickUpClosed]) {
            [self goForPickUp];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed for pickup today" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: @"Continue", nil];
            [alert setTag:100];
            [alert show];
        }
    }
   
}
-(void)scheduleOrder{
    dummyV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:dummyV];
    dummyV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [user removeObjectForKey:@"OrderDate"];
    [[CartObj instance].userInfo removeObjectForKey:@"OrderDate"];
    [[CartObj instance].userInfo removeObjectForKey:@"OrderTime"];
    [[CartObj instance].userInfo removeObjectForKey:@"timeArr"];
    [user removeObjectForKey:@"TodayClosed"];
    Schedular *scheduleV = [[Schedular alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT/2-170, SCREEN_WIDTH-40, 340) forController:self];
    [self.view addSubview:scheduleV];
    scheduleV.backgroundColor = [UIColor whiteColor];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 100) {
            [self goForPickUp];
        }
        if (alertView.tag == 200) {
            [self goForDelivery];
        }
    }
}

-(void)removeDummyView:(UIButton *)sender{
    [sender.superview removeFromSuperview];
    [dummyV removeFromSuperview];
}


- (void)orderScheduledForToday:(UIButton *)sender {
    
    BOOL proceed = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderDate"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    NSLog(@"%@", [[CartObj instance].userInfo objectForKey:@"timeArr"]);
    [formatter setDateFormat:@"hh:mm a"];
    [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderTime"];

    NSLog(@"%@\n%@", [user  objectForKey:@"OrderDate"], [user objectForKey:@"OrderTime"]);
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    proceed = [self canPlaceOrderForNow];

    if (!proceed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed at the moment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else{
        [dummyV removeFromSuperview];
        [sender.superview removeFromSuperview];
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
            DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
            [self.navigationController pushViewController:deliveryV animated:YES];
        }else{
            [self pushLoginScreen];
        }
    }

}

-(BOOL)canPlaceOrderForNow{
    bool canPlace = NO;
    int currTime = [self timeInSeconds:[user objectForKey:@"OrderTime"]];
    
    
    for (NSDictionary *businessTimings in [user objectForKey:@"BusinessHours"]) {
        if ([[businessTimings objectForKey:@"Day"] intValue] == weekdayNumber) {
            
            if ([[user objectForKey:@"OrderType"] intValue] == 1) {
            
                int breakFastStart  = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastStartTime"]];
                int breakFastEnd    = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastEndTime"]];
                
                int lunchStart      = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchStartTime"]];
                int lunchEnd        = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchEndTime"]];
                
                int dinnerStart     = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerStartTime"]];
                int dinnerEnd       = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerEndTime"]];
                
                if (breakFastStart != breakFastEnd) {
                    breakFastEnd = breakFastEnd? breakFastEnd :(lunchStart? lunchStart:(lunchEnd? lunchEnd:(dinnerStart?dinnerStart:dinnerEnd)));
                }
                
                if (lunchStart != lunchEnd) {
                    lunchEnd = lunchEnd? lunchEnd : (dinnerStart? dinnerStart: dinnerEnd);
                    
                    lunchStart = lunchStart? lunchStart: (breakFastEnd? breakFastEnd: breakFastStart);
                }
                if (dinnerStart != dinnerEnd) {
                    dinnerStart = dinnerStart? dinnerStart : ([self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchEndTime"]]? [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchEndTime"]]: (lunchStart? lunchStart: (breakFastEnd? breakFastEnd: breakFastStart)));
                }
                
                if (breakFastStart < breakFastEnd) {
                    NSLog(@"%d ... %d", (breakFastStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60), (breakFastEnd?breakFastEnd:(lunchEnd?lunchEnd:dinnerEnd)));
                    if (currTime >= (breakFastStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60) &&
                        (currTime <= (breakFastEnd?breakFastEnd:(lunchEnd?lunchEnd:dinnerEnd)))) {
                        
                        canPlace = YES;
                        break;
                    }
                }
                
                if(lunchStart < lunchEnd){
                    if (currTime >= (lunchStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60) &&
                        (currTime <= (lunchEnd?lunchEnd:dinnerEnd))) {
//                        NSLog(@"%d",(lunchEnd?lunchEnd:dinnerEnd) );
                        canPlace = YES;
                        break;
                    }
                }
                
                if(dinnerStart < dinnerEnd){
                    if (currTime >= (dinnerStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60) && currTime <= dinnerEnd) {
                        canPlace = YES;
                        break;
                    }
                }
            
            }
            
            
            if ([[user objectForKey:@"OrderType"] intValue] == 2) {
                
                int breakFastDelStart  = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastDeliveryStartTime"]];
                int breakFastDelEnd    = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastDeliveryEndTime"]];
                
                int lunchDelStart      = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryStartTime"]];
                int lunchDelEnd        = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryEndTime"]];
                
                int dinnerDelStart     = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerDeliveryStartTime"]];
                int dinnerDelEnd       = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerDeliveryEndTime"]];
                
                if (breakFastDelStart != breakFastDelEnd) {
                    breakFastDelEnd = breakFastDelEnd? breakFastDelEnd :(lunchDelStart? lunchDelStart:(lunchDelEnd? lunchDelEnd
                                                                                                       : (dinnerDelStart? dinnerDelStart:dinnerDelEnd)));
                }
                if (lunchDelStart != lunchDelEnd) {
                    lunchDelEnd = lunchDelEnd? lunchDelEnd : (dinnerDelStart? dinnerDelStart: dinnerDelEnd);
                    lunchDelStart = lunchDelStart? lunchDelStart: (breakFastDelEnd? breakFastDelEnd: breakFastDelStart);
                }
                if (dinnerDelStart != dinnerDelEnd) {
                    
                    dinnerDelStart = dinnerDelStart? dinnerDelStart : ([self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryEndTime"]]? [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryEndTime"]]: (lunchDelStart? lunchDelStart: (breakFastDelEnd? breakFastDelEnd: breakFastDelStart)));
                }
                
                
                if (breakFastDelStart < breakFastDelEnd) {
                    
                    if (currTime >= (breakFastDelStart + [[user objectForKey:@"DelTimeOffset"] intValue]*60) &&
                        (currTime <= (breakFastDelEnd? breakFastDelEnd:(lunchDelEnd?lunchDelEnd:dinnerDelEnd) ))) {
                        
                        canPlace = YES;
                        break;
                    }
                }
                
                if(lunchDelStart < lunchDelEnd){
                    if (currTime >= (lunchDelStart + [[user objectForKey:@"DelTimeOffset"] intValue]*60) &&
                        (currTime <= (lunchDelEnd? lunchDelEnd:dinnerDelEnd ))) {
                        
                        canPlace = YES;
                        break;
                    }
                }
                
                if(dinnerDelStart < dinnerDelEnd){
                    if (currTime >= (dinnerDelStart + [[user objectForKey:@"DelTimeOffset"] intValue]*60) && currTime <= dinnerDelEnd) {
                        canPlace = YES;
                        break;
                    }
                }
                
            }
            
            break;
            
        }
    }
    
    return canPlace;
}

-(int)longTimeFormatInSeconds:(NSString *)timeStr{
    
    NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
    
    if (timeArr.count == 3) {
        return (([[timeArr objectAtIndex:0] intValue]*60*60) +
                ([[timeArr objectAtIndex:1] intValue]*60) +
                ([[timeArr objectAtIndex:2] intValue]));
    }else
        return 0;
}

-(int)timeInSeconds:(NSString *)timeStr{
    NSArray *arr = [timeStr componentsSeparatedByString:@" "];
    int addOffset = 0;
    if (!timeStr.length)
        return 0;
    if ([[arr objectAtIndex:1] isEqualToString:@"PM"]) {
        addOffset = 12*60*60;
    }
    
    
    NSArray *arr2 = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
    
    if ([[arr2 objectAtIndex:0] isEqualToString:@"12"] && [[arr objectAtIndex:1] isEqualToString:@"PM"]) {
        addOffset=0;
    }
    if ([[arr2 objectAtIndex:0] isEqualToString:@"12"] && [[arr objectAtIndex:1] isEqualToString:@"AM"]){
        return [[arr2 objectAtIndex:1] intValue]*60+addOffset;
    }else{
        return [[arr2 objectAtIndex:0] intValue]*60*60+[[arr2 objectAtIndex:1] intValue]*60+addOffset;
    }
}

- (void)orderScheduled:(UIButton *)sender {
    
    if ([[CartObj instance].userInfo objectForKey:@"OrderDate"] && ![[[CartObj instance].userInfo objectForKey:@"OrderTime"] isEqualToString:@"Closed"]) {
        [user setObject:[[CartObj instance].userInfo objectForKey:@"OrderDate"] forKey:@"OrderDate"];
        [user setObject:[[CartObj instance].userInfo objectForKey:@"OrderTime"] forKey:@"OrderTime"];
        NSLog(@"%@\n%@", [[CartObj instance].userInfo objectForKey:@"OrderTime"], [[CartObj instance].userInfo objectForKey:@"OrderDate"]);
        [dummyV removeFromSuperview];
        [sender.superview removeFromSuperview];
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
            DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
            [self.navigationController pushViewController:deliveryV animated:YES];
        }else{
            [self pushLoginScreen];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed at the moment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }

}

-(void)goForPickUp{
    [user setObject:[NSNumber numberWithInt:1] forKey:@"OrderType"];
    [self scheduleOrder];


}

-(void)goForDelivery{
    [user setObject:[NSNumber numberWithInt:2] forKey:@"OrderType"];
    [self scheduleOrder];
}


-(void)deliveryBtnAct{
    if(![CartObj checkPickupDelivery:NO])
        return;
    if ([[user objectForKey:@"BusinessHours"] count] <=0) {
        deliveryBtn.selected = YES;
        pickupBtn.selected = NO;
        [self fetchClientSettings];
    }else{
        if ([[user objectForKey:@"isRestOpen"] boolValue] && [self checkPickUpClosed] && [self checkDeliveryClosed]){
            [self goForDelivery];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed for delivery today" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: @"Continue", nil];//@
            [alert setTag:200];
            [alert show];
        }
    }
}

-(void) pushLoginScreen{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *nextView = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
