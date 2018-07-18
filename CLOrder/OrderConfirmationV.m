//
//  OrderConfirmationV.m
//  CLOrder
//
//  Created by Vegunta's on 07/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "OrderConfirmationV.h"
#import "AppHeader.h"
#import <MapKit/MapKit.h>
#import "CartObj.h"
#import "APIRequest.h"

@implementation OrderConfirmationV{
    NSUserDefaults *user;
    MKMapView *map;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    if ([[CartObj instance].freeItemDic objectForKey:@"ItemIdofFreeItem"]) {
        [self getFreeItem];
    }
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    self.title = @"ORDER CONFIRMATION";
    self.view.backgroundColor = [UIColor whiteColor];
    user = [NSUserDefaults standardUserDefaults];
    
}

-(void)createUI{
    
    orderListTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 325, SCREEN_WIDTH, 420+[self heightForOrderListTbl])];
    orderListTbl.scrollEnabled = YES;
    orderListTbl.delegate = self;
    orderListTbl.dataSource = self;
    
    UIScrollView *mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    mainScroll.scrollEnabled = YES;
    [self.view addSubview:mainScroll];
    mainScroll.userInteractionEnabled = YES;
    mainScroll.showsVerticalScrollIndicator = YES;
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 600+orderListTbl.frame.size.height);
    mainScroll.backgroundColor = [UIColor whiteColor];
    
    [mainScroll addSubview:orderListTbl];
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 5, 100, 60)];
    iconImg.image = [UIImage imageNamed:@"new_Logo"];
    [mainScroll addSubview:iconImg];
    
    UIImageView *sucess = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-18, 80, 35, 35)];
    sucess.image = [UIImage imageNamed:@"sucess"];
    [mainScroll addSubview:sucess];
    
    UILabel *thank=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 120, 150, 20)];
    [thank setFont:APP_FONT_REGULAR_14];
    [thank setText:@"Thank you."];
    [mainScroll addSubview:thank];
    [thank setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *yourOrder=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 140, 200, 20)];
    [yourOrder setFont:APP_FONT_REGULAR_14];
    [yourOrder setText:@"Your order has been received"];
    [thank setTextAlignment:NSTextAlignmentCenter];
    [mainScroll addSubview:yourOrder];
    
    UILabel *orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-110, 165, 220, 30)];
    [mainScroll addSubview:orderNumber];
    orderNumber.font = APP_FONT_BOLD_18;
    orderNumber.text = [NSString stringWithFormat:@"Order No: %@",[[CartObj instance].userInfo objectForKey:@"OrderId"]];
    orderNumber.textColor = DARK_GRAY;
    orderNumber.textAlignment = NSTextAlignmentCenter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm:ss a"];
    NSString *newDate = [dateFormatter stringFromDate:[NSDate date]];
    
    UILabel *orderInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH-40, 35)];
    [mainScroll addSubview:orderInfo];
    orderInfo.font = APP_FONT_BOLD_16;
    orderInfo.numberOfLines = 0;
    orderInfo.text = [NSString stringWithFormat:@"Placed on: %@", newDate];
    orderInfo.textColor = DARK_GRAY;
    orderInfo.textAlignment = NSTextAlignmentRight;
    
    UILabel *instructLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, SCREEN_WIDTH-20, 80)];
    [mainScroll addSubview:instructLbl];
    instructLbl.numberOfLines = 0;
    instructLbl.font = APP_FONT_REGULAR_14;
    instructLbl.text = [NSString stringWithFormat:@"For price adjustment or any other issue please contact %@ %@. Credit card/ PayPal transactions are shown as 'Clorder' in your statements.",[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"ClientPhone"]];
    instructLbl.textColor = [UIColor grayColor];
    
    UILabel *mapHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, orderListTbl.frame.size.height+325, SCREEN_HEIGHT-20, 25)];
    mapHeader.text = @"Restaurant Location";
    mapHeader.textColor = APP_COLOR;
    mapHeader.font = APP_FONT_BOLD_18;
    [mainScroll addSubview:mapHeader];
    
    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, orderListTbl.frame.size.height+325+25, SCREEN_WIDTH, 200)];
    [mainScroll addSubview:map];
    map.showsUserLocation = YES;
    map.delegate = self;
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    //    point.title=ord.name;
    CLLocationCoordinate2D location;
    location.latitude =  [[user objectForKey:@"clientLat"] doubleValue],
    location.longitude = [[user objectForKey:@"clientLon"] doubleValue];
    [point setCoordinate:(location)];
    [map showAnnotations:[NSArray arrayWithObject:point] animated:YES];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(SCREEN_WIDTH/2-78, orderListTbl.frame.size.height+325+225, 156, 50);
//    [mapBtn setTitle:@"OPEN MAP" forState:UIControlStateNormal];
//    [mapBtn setBackgroundColor:APP_COLOR];
    [mapBtn setImage:[UIImage imageNamed:@"open_map"] forState:UIControlStateNormal];
    [mapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(mapBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:mapBtn];
//    mapBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(SCREEN_WIDTH/2-78, SCREEN_HEIGHT-50, 156, 50);
//    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [doneBtn setBackgroundColor:APP_COLOR];
    [doneBtn setImage:[UIImage imageNamed:@"done_map"] forState:UIControlStateNormal];
    [doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [doneBtn addTarget:self action:@selector(doneBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
//    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    
    [self CurrentLocationIdentifier];

}
-(void)getFreeItem{
    [APIRequest getModifiersForItem:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId",
                                     [[CartObj instance].freeItemDic objectForKey:@"ItemIdofFreeItem"], @"ItemID",
                                     nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            [self getFreeItem];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //            [alert show];
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error] mutableCopy];
            NSLog(@"Response :\n %@",resObj);
            
            [[CartObj instance].freeItemDic setObject:resObj forKey:@"Modifiers"];
            [[CartObj instance].freeItemDic setObject:[NSNumber numberWithInt:0] forKey:@"Price"];
            [[CartObj instance].freeItemDic setObject:[resObj objectForKey:@"ItemName"] forKey:@"Title"];
            [[CartObj instance].freeItemDic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
            [[CartObj instance].itemsForCart addObject:[CartObj instance].freeItemDic];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self requestTax];
                [orderListTbl reloadData];
            });
            
        }
    }];
    
}


-(void)CurrentLocationIdentifier{
    //---- For getting current gps location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //------
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
//        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}

-(void)mapBtnAct{

//    this uses an address for the destination.  can use lat/long, too with %f,%f format
//    NSString* address = @"106 N 7th St, Richmond, VA 23219";
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?daddr=%f,%f",//&daddr=%f,%f
                      [[user objectForKey:@"clientLat"] doubleValue], [[user objectForKey:@"clientLon"] doubleValue]];//map.userLocation.location.coordinate.latitude, map.userLocation.location.coordinate.longitude
    NSLog(@"%@", url);
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
}
-(void)doneBtnAct{
    [user removeObjectForKey:@"cartPrice"];
    [user removeObjectForKey:@"subTotalPrice"];
    [user removeObjectForKey:@"cart"];
    [user removeObjectForKey:@"CouponDetails"];
    [user removeObjectForKey:@"TipIndex"];
    [user removeObjectForKey:@"DefaultTip"];
    [user removeObjectForKey:@"OrderDate"];
    [user removeObjectForKey:@"OrderTime"];
    
    [[CartObj instance].itemsForCart removeAllObjects];
    [CartObj clearInstance];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
-(void) leftBarAct{
//    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)heightForOrderListTbl{
    CGFloat height =  30;
    for (int i = 0; i < [[CartObj instance].itemsForCart count]; i++) {
        height = height+[self heightForRow:[NSIndexPath indexPathForRow:(i+1) inSection:0]];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 125.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, 1)];
    [header addSubview:topLine];
    topLine.backgroundColor = [UIColor whiteColor];
    
    UILabel *orderTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2-15, 20)];
    [header addSubview:orderTimeLbl];
    orderTimeLbl.textAlignment = NSTextAlignmentCenter;
    orderTimeLbl.text = @"Order Time";
    orderTimeLbl.font = APP_FONT_BOLD_18;
    
    UILabel *pickupLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 5, SCREEN_WIDTH/2-15, 20)];
    [header addSubview:pickupLbl];
    pickupLbl.textAlignment = NSTextAlignmentCenter;
    pickupLbl.font = APP_FONT_BOLD_18;
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"OrderType"] intValue] == 1) {
        pickupLbl.text = @"PickUp";
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"OrderType"] intValue] == 2){
        pickupLbl.text = @"Delivery";
    }
    

    NSLog(@"%@", [CartObj instance].userInfo);
    
    
    NSDateFormatter *dateForma = [[NSDateFormatter alloc] init];
    [dateForma setTimeStyle:NSDateFormatterFullStyle];
    [dateForma setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateForma setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    
    NSDate *date = [[NSDate alloc] init];
    dateForma.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    date = [dateForma dateFromString:[NSString stringWithFormat:@"%@",[[CartObj instance].userInfo objectForKey:@"OrderDate"]]];
    dateForma.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    // Convert to new Date Format
    [dateForma setDateFormat:@"dd-MMM-yyyy hh:mm a"];
    NSString *newDate = [dateForma stringFromDate:date];
    
    
    UILabel *orderTimeDtlLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH/2-15, 35)];
    [header addSubview:orderTimeDtlLbl];
    orderTimeDtlLbl.textAlignment = NSTextAlignmentCenter;
    orderTimeDtlLbl.numberOfLines = 0;
    
    orderTimeDtlLbl.text = [[[CartObj instance].userInfo objectForKey:@"isFutureOrder"] boolValue]?[NSString stringWithFormat:@"%@(Future)", newDate]: @"ASAP";//[NSString stringWithFormat:@"%@", newDate];
    
    orderTimeDtlLbl.font = APP_FONT_BOLD_14;
    
    
    UILabel *pickupDtlLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 30, SCREEN_WIDTH/2-15, 20)];
    [header addSubview:pickupDtlLbl];
    pickupDtlLbl.textAlignment = NSTextAlignmentCenter;
    pickupDtlLbl.text = @"--";
    
    UILabel *midLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    [header addSubview:midLine];
    midLine.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 62, SCREEN_WIDTH/2-15, 20)];
    [header addSubview:nameLbl];
    nameLbl.textAlignment = NSTextAlignmentCenter;
    nameLbl.text = [NSString stringWithFormat:@"%@", [[CartObj instance].userInfo objectForKey:@"FullName"]];
    nameLbl.font = APP_FONT_REGULAR_18;
    
    UILabel *instuctionLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 62, SCREEN_WIDTH/2-15, 20)];
    [header addSubview:instuctionLbl];
    instuctionLbl.textAlignment = NSTextAlignmentCenter;
    instuctionLbl.text = @"Instructions";
    instuctionLbl.font = APP_FONT_REGULAR_14;
    
    
    UILabel *mobileLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH/2-15, 20)];
    [header addSubview:mobileLbl];
    mobileLbl.textAlignment = NSTextAlignmentCenter;
    mobileLbl.text = [NSString stringWithFormat:@"%@", [[[CartObj instance].userInfo objectForKey:@"UserAddress"] objectForKey:@"PhoneNumber"]];
    mobileLbl.font = APP_FONT_REGULAR_18;
    
    
    UITextField *instructionTxt = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 90, SCREEN_WIDTH/2-15, 20)];
    [header addSubview:instructionTxt];
    instructionTxt.textAlignment = NSTextAlignmentLeft;
    instructionTxt.placeholder = @"Instructions goes here..";
    instructionTxt.text = [NSString stringWithFormat:@"%@", [[CartObj instance].spclNote length]?[CartObj instance].spclNote:@""];
    instructionTxt.font = APP_FONT_REGULAR_14;
    instructionTxt.userInteractionEnabled = false;
    
    UILabel *deviderLine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 65, 1, 50)];
    [header addSubview:deviderLine];
    deviderLine.backgroundColor = [UIColor whiteColor];
    
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 117, SCREEN_WIDTH, 1)];
    [header addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor whiteColor];
    
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 180.0;
}

-(nullable UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UILabel *underLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [footer addSubview:underLine];
    underLine.backgroundColor = [UIColor whiteColor];
    
    UILabel *footerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-75-100-20, 60)];
    [footer addSubview:footerTitle];
    footerTitle.numberOfLines = 0;
    footerTitle.textAlignment = NSTextAlignmentCenter;
    if ([[user objectForKey:@"PaymentType"] intValue] == 1) {
        footerTitle.text = @"Cash Payment";
    }else if([[user objectForKey:@"PaymentType"] intValue] == 2){
        footerTitle.text = @"Card Payment";
    }else if([[user objectForKey:@"PaymentType"] intValue] == 4){
        footerTitle.text = @"PayPal Prepaid";
    }
    
    footerTitle.textColor = APP_COLOR;
    footerTitle.font = APP_FONT_BOLD_18;
    
    UILabel *subTotalLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75-100, 5, 100, 20)];
    [footer addSubview:subTotalLbl];
    subTotalLbl.textAlignment = NSTextAlignmentLeft;
    subTotalLbl.text = @"SUBTOTAL";
    subTotalLbl.font = APP_FONT_REGULAR_16;
    
    UILabel *subTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 5, 65, 20)];
    [footer addSubview:subTotalPrice];
    subTotalPrice.textAlignment = NSTextAlignmentRight;
    subTotalPrice.text = [NSString stringWithFormat:@"$%@",[user objectForKey:@"subTotalPrice"] ];
    subTotalPrice.font = APP_FONT_REGULAR_16;
    
    UILabel *taxLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75-100, 30, 100, 20)];
    [footer addSubview:taxLbl];
    taxLbl.textAlignment = NSTextAlignmentLeft;
    taxLbl.text = @"TAX";
    taxLbl.font = APP_FONT_REGULAR_16;
    
    UILabel *taxPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 30, 65, 20)];
    [footer addSubview:taxPrice];
    taxPrice.textAlignment = NSTextAlignmentRight;
    taxPrice.text = [NSString stringWithFormat:@"$%@", [user objectForKey:@"TaxCost"]];
    taxPrice.font = APP_FONT_REGULAR_16;
    
    UILabel *discountLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75-100, 55, 100, 20)];
    [footer addSubview:discountLbl];
    discountLbl.textAlignment = NSTextAlignmentLeft;
    discountLbl.text = @"DISCOUNT";
    discountLbl.font = APP_FONT_REGULAR_16;
    
    UILabel *discountPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 55, 65, 20)];
    [footer addSubview:discountPrice];
    discountPrice.textAlignment = NSTextAlignmentRight;
    discountPrice.text = [NSString stringWithFormat:@"-$%@", [user objectForKey:@"DiscountAmount"]?[user objectForKey:@"DiscountAmount"]:@"0"];
    discountPrice.font = APP_FONT_REGULAR_16;
    
    UILabel *deliveryLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75-100, 80, 100, 20)];
    [footer addSubview:deliveryLbl];
    deliveryLbl.textAlignment = NSTextAlignmentLeft;
    deliveryLbl.text = @"DELIVERY";
    deliveryLbl.font = APP_FONT_REGULAR_16;
    
    UILabel *deliveryPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 80, 65, 20)];
    [footer addSubview:deliveryPrice];
    deliveryPrice.textAlignment = NSTextAlignmentRight;
    deliveryPrice.text = [NSString stringWithFormat:@"$%@", [user objectForKey:@"ShippingCost"]];
    deliveryPrice.font = APP_FONT_REGULAR_16;
    
    UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75-100, 105, 100, 20)];
    [footer addSubview:tipLbl];
    tipLbl.textAlignment = NSTextAlignmentLeft;
    tipLbl.text = @"TIP";
    tipLbl.font = APP_FONT_REGULAR_16;
    
    UILabel *tipPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 105, 65, 20)];
    [footer addSubview:tipPrice];
    tipPrice.textAlignment = NSTextAlignmentRight;
    tipPrice.text = [NSString stringWithFormat:@"$%@", [user objectForKey:@"TipAmount"]?[user objectForKey:@"TipAmount"]:@"0"];
    tipPrice.font = [UIFont systemFontOfSize:16.0];
    
    UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75-100, 130, 100, 20)];
    [footer addSubview:totalLbl];
    totalLbl.textAlignment = NSTextAlignmentLeft;
    totalLbl.text = @"TOTAL";
    totalLbl.font = APP_FONT_BOLD_16;
    
    UILabel *totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 130, 65, 20)];
    [footer addSubview:totalPrice];
    totalPrice.textAlignment = NSTextAlignmentRight;
    totalPrice.text = [NSString stringWithFormat:@"$%@", [user objectForKey:@"cartPrice"]];
    totalPrice.font = APP_FONT_BOLD_16;
    
    UILabel *noteLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 40, 25)];
    [footer addSubview:noteLbl];
    noteLbl.text = @"Note: ";
    noteLbl.textColor = [UIColor grayColor];
    noteLbl.font = APP_FONT_BOLD_10;
    
    UILabel *noteTxtLbl = [[UILabel alloc] initWithFrame:CGRectMake(55, 148, SCREEN_WIDTH-65, 50)];
    [footer addSubview:noteTxtLbl];
    noteTxtLbl.numberOfLines = 0;
    noteTxtLbl.textColor = [UIColor grayColor];
    noteTxtLbl.text = @"Order changes and cancellations are accepted only if request is made within a resonable time as accepted by the business";
    noteTxtLbl.font = APP_FONT_REGULAR_10;
    
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[CartObj instance].itemsForCart count]+2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UILabel *qtyLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 20)];
    [cell addSubview:qtyLbl];
    qtyLbl.textAlignment = NSTextAlignmentCenter;
    qtyLbl.font = APP_FONT_REGULAR_16;
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-60, 0, 60, 20)];
    [cell addSubview:priceLbl];
    priceLbl.textAlignment = NSTextAlignmentRight;
    priceLbl.font = APP_FONT_REGULAR_16;
    
    UILabel *itemLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-35-qtyLbl.frame.size.width-priceLbl.frame.size.width, 20)];
    [cell addSubview:itemLbl];
//    itemLbl.numberOfLines = 0;
    itemLbl.textAlignment = NSTextAlignmentLeft;
    itemLbl.font = APP_FONT_REGULAR_16;
    
    if (0 == indexPath.row) {
        qtyLbl.text = @"Qty";
        priceLbl.text = @"Price";
        itemLbl.text = @"Item";
        qtyLbl.font = APP_FONT_BOLD_16;
        priceLbl.font = APP_FONT_BOLD_16;
        itemLbl.font = APP_FONT_BOLD_16;
        
    }else if(indexPath.row == [[CartObj instance].itemsForCart count]+1){
        qtyLbl.text = @"";
        priceLbl.text = @"";
        
        UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        [cell addSubview:topLine];
        topLine.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, SCREEN_WIDTH, 1)];
        [cell addSubview:bottomLine];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        
        itemLbl.text = @"END OF ORDER";
        [itemLbl setFont:APP_FONT_REGULAR_16];
        itemLbl.frame = CGRectMake(0, 1, SCREEN_WIDTH, 18);
        itemLbl.textAlignment = NSTextAlignmentCenter;
        
    }else{
        itemLbl.frame = CGRectMake(50, 0, SCREEN_WIDTH-35-qtyLbl.frame.size.width-priceLbl.frame.size.width, 20);
//        [itemLbl sizeToFit];
        qtyLbl.text = [NSString stringWithFormat:@"%@x",[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Quantity"]];
        itemLbl.text = [NSString stringWithFormat:@"%@", [[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Title"]];
     
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH-35-qtyLbl.frame.size.width-priceLbl.frame.size.width, [self heightForRow:indexPath])];
        [cell.contentView addSubview:desc];
        desc.text = [NSString stringWithFormat:@"%@",[self getDescStr:indexPath]];
        desc.numberOfLines = 0;
        desc.font = APP_FONT_REGULAR_14;
        
        CGFloat itemPrice = [[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Price"] doubleValue];
        
        if ([[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]) {
            for (int i = 0; i < [[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]; i++) {
                
                if ([[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] count]) {
                    for (int j = 0; j < [[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] count]; j++) {
                        
                        if ([[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Default"] integerValue]) {
                            
                            if (![[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] isKindOfClass:[NSNull class]]) {
                                
                                itemPrice = itemPrice +[[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] doubleValue] ;
                            }
                        }
                    }
                }
                
            }
        }
        
        priceLbl.text = [NSString stringWithFormat:@"$%.2f", itemPrice * [qtyLbl.text intValue]];
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [orderListTbl deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 || indexPath.row == [[CartObj instance].itemsForCart count]+1) {
        return 25.0;
    }
    return [self heightForRow:indexPath]+10;

}

-(CGFloat)heightForRow:(NSIndexPath *)indexPath{
    NSMutableString *selectionStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", [self getDescStr:indexPath]]];
    
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",selectionStr] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :APP_FONT_REGULAR_14} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/14; i++){
        gap++;
    }
    return labelHeight.size.height+gap*4;
}

-(NSMutableString *)getDescStr:(NSIndexPath *)indexPath{
    NSMutableString *selectionStr = [NSMutableString stringWithString:@""] ;
    
    if( [[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]){
        for (int i = 0; i < [[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]; i++) {
            NSMutableString *tempTitleStr = [NSMutableString stringWithString:@""];
            
            if ([[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]) {
                NSMutableString *tempModifierStr = [NSMutableString stringWithString:@""];
                
                for (int j = 0; j < [[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]; j++) {
                    
                    
                    if (([[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Default"] intValue] ==1) &&
                        (![[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Title"] isKindOfClass:[NSNull class]])) {
                        
                        [tempModifierStr appendString:[NSString stringWithFormat:@" %@,",[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Title"]]];
                        
                    }
                }
                if ([tempModifierStr length] > 0) {
                    tempTitleStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@ %@",[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row-1] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Name"], tempModifierStr]];
                    tempTitleStr = [NSMutableString stringWithString: [tempTitleStr substringToIndex:[tempTitleStr length]-1]];
                }
                
            }
            if ([tempTitleStr length] > 0) {
                [selectionStr appendString:[NSString stringWithFormat:@"%@\n", tempTitleStr]];
            }
            
        }
        
    }
    return selectionStr;
}
@end
