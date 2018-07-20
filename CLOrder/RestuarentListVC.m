//
//  RestuarentListVC.m
//  CLOrder
//
//  Created by Naveen Thukkani on 06/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "RestuarentListVC.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "APIRequester.h"
#import "ListOfRestuarents.h"
#import "CardcellForRes.h"
#import "MapViewVC.h"
#import "MultiLocationVC.h"
#import "SelectedRestroVC.h"
#import "AppDelegate.h"
#import "GoogleSearchView.h"

@interface RestuarentListVC (){
    UITableView *locationListTbl;
    UITextField *searchField;
    UIButton *filterBtn;
    UIView *fiterViews;
    UITextField *addressText;
    UITextField *distanceText;
    UITextField *cusinesText;
    UITextField *priceText;
    UIView *noResView;
    UIPickerView *distancePicker,*pricePicker,*cuisinePicker;
    NSArray *distanceArry, *priceArray;
    NSMutableArray *cuisineArray;
    HCSStarRatingView *starRatingView;
    BOOL delivery;
    BOOL searchTextFieldActive;
    NSMutableArray *searchArrayforLocation;
}

@end

@implementation RestuarentListVC
@synthesize myGeocoder;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundColor:APP_COLOR];
    [self.navigationController.navigationBar setBarTintColor:APP_COLOR];
    
    self.title=@"Order Food Online";
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    distanceArry =[[NSArray alloc] initWithObjects:@"5",@"10",@"15",@"20", nil];
    priceArray=[[NSArray alloc] initWithObjects:@"No Price",@"$10",@"$100",@"$1000", nil];
    cuisineArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setImage:[UIImage imageNamed:@"map_location"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(rightBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems= [NSArray arrayWithObject:rightBarItem];
    
    locationsArray=[[NSMutableArray alloc] initWithCapacity:0];
    searchArrayforLocation=[[NSMutableArray alloc] initWithCapacity:0];
    searchField=[[UITextField alloc] initWithFrame:CGRectMake(10, 71, SCREEN_WIDTH-60, 40)];
    [searchField.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-60 height:40]];
    [searchField setPlaceholder:@"Search By Restaurant"];
    [searchField setDelegate:self];
    searchField.textColor = [UIColor  blackColor];
    searchField.textAlignment = NSTextAlignmentLeft;
    [searchField setFont:APP_FONT_REGULAR_16];
    
    filterBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 76, 30, 30)];
    [filterBtn setImage:[UIImage imageNamed:@"filter"] forState: UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterAction) forControlEvents:UIControlEventTouchUpInside];
    
    locationListTbl=[[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
    locationListTbl.delegate=self;
    locationListTbl.dataSource=self;
    locationListTbl.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [locationListTbl setSeparatorColor:[UIColor clearColor]];
    [locationListTbl setBackgroundColor:[UIColor whiteColor]];
    [self searchingLocationList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
}
-(void)filterAction{
    
    fiterViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    fiterViews.backgroundColor = TRANSPARENT_GRAY;
    [self.view addSubview:fiterViews];
    [self.view bringSubviewToFront:fiterViews];

    UIView *dummyV = [[UIView alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH-40, SCREEN_HEIGHT-100)];
    [fiterViews addSubview:dummyV];
    dummyV.backgroundColor = [UIColor whiteColor];
    
    UILabel *headLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dummyV.frame.size.width, 40)];
    headLbl.textColor = [UIColor whiteColor];
    headLbl.backgroundColor = APP_COLOR;
    headLbl.text = @"FILTERS";
    headLbl.textAlignment = NSTextAlignmentCenter;
    [headLbl setFont:APP_FONT_REGULAR_16];
    [dummyV addSubview:headLbl];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(dummyV.frame.size.width-30, 10, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"closebutton_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [dummyV addSubview:closeBtn];
    
    UIButton *setModifierBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setModifierBtn.frame = CGRectMake(dummyV.frame.size.width/2-75, dummyV.frame.size.height-50, 150, 40);
    [setModifierBtn setBackgroundColor:APP_COLOR];
    [setModifierBtn.titleLabel setFont:APP_FONT_REGULAR_16];
    [setModifierBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [setModifierBtn addTarget:self action:@selector(filtersSubmitAct) forControlEvents:UIControlEventTouchUpInside];
    [dummyV addSubview:setModifierBtn];
    
    UIScrollView *sView=[[UIScrollView alloc] init];
    sView.frame=CGRectMake(0, 40, dummyV.frame.size.width, dummyV.frame.size.height-90);
    sView.contentSize=CGSizeMake(dummyV.frame.size.width,440);
    [dummyV addSubview:sView];
    
    UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, dummyV.frame.size.width-20, 20)];
    [addressLabel setText:@"Address"];
    [addressLabel setFont:APP_FONT_REGULAR_16];
    [sView addSubview:addressLabel];
    
    addressText=[[UITextField alloc] initWithFrame:CGRectMake(10, 40, dummyV.frame.size.width-60, 40)];
    [addressText.layer addSublayer:[self bottomborderAdding:addressText.frame.size.width height:40]];
    [addressText setPlaceholder:@"Enter Your Address"];
    [addressText setDelegate:self];
    [addressText setText:_address];
    addressText.textColor = [UIColor  blackColor];
    addressText.textAlignment = NSTextAlignmentLeft;
    [addressText setFont:APP_FONT_REGULAR_16];
    [sView addSubview:addressText];
    
    UIButton *currentLocation=[[UIButton alloc] initWithFrame:CGRectMake(dummyV.frame.size.width-45, 45, 30, 30)];
    [currentLocation setImage:[UIImage imageNamed:@"gps"] forState:UIControlStateNormal];
    [currentLocation addTarget:self action:@selector(currentLocation) forControlEvents:UIControlEventTouchUpInside];
    [sView addSubview:currentLocation];
    
    UILabel *distanceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,100, dummyV.frame.size.width-20, 20)];
    [distanceLabel setText:@"Distance(Miles:)"];
    [distanceLabel setFont:APP_FONT_REGULAR_16];
    [sView addSubview:distanceLabel];
    
    distanceText=[[UITextField alloc] initWithFrame:CGRectMake(10, 120, dummyV.frame.size.width-20, 40)];
    [distanceText.layer addSublayer:[self bottomborderAdding:distanceText.frame.size.width height:40]];
    [distanceText setPlaceholder:@"Enter Distance"];
    [distanceText setDelegate:self];
    [distanceText setText:@"5"];
    distanceText.textColor = [UIColor  blackColor];
    distanceText.textAlignment = NSTextAlignmentLeft;
    [distanceText setFont:APP_FONT_REGULAR_16];
    [sView addSubview:distanceText];
    
    distancePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-220, self.view.frame.size.width-40, 220)];
    distanceText.inputView = distancePicker;
    distancePicker.delegate=self;
    distancePicker.dataSource=self;
    
    UILabel *cuisneLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,180, dummyV.frame.size.width-20, 20)];
    [cuisneLabel setText:@"Cuisines"];
    [cuisneLabel setFont:APP_FONT_REGULAR_16];
    [sView addSubview:cuisneLabel];
    
    cusinesText=[[UITextField alloc] initWithFrame:CGRectMake(10, 200, dummyV.frame.size.width-20, 40)];
    [cusinesText.layer addSublayer:[self bottomborderAdding:cusinesText.frame.size.width height:40]];
    [cusinesText setPlaceholder:@"Enter Cuisines"];
    [cusinesText setDelegate:self];
    if([cuisineArray count]){
        [cusinesText setText:[NSString stringWithFormat:@"%@ (%@)",[[cuisineArray objectAtIndex:0] objectForKey:@"Cname"],[[cuisineArray objectAtIndex:0] objectForKey:@"Count"]]];
    }else{
        [cusinesText setText:@""];
    }
    cusinesText.textColor = [UIColor  blackColor];
    cusinesText.textAlignment = NSTextAlignmentLeft;
    [cusinesText setFont:APP_FONT_REGULAR_16];
    [sView addSubview:cusinesText];
    
    cuisinePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-220, self.view.frame.size.width-40, 220)];
    cusinesText.inputView = cuisinePicker;
    cuisinePicker.delegate=self;
    cuisinePicker.dataSource=self;
    
    UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,260, dummyV.frame.size.width-20, 20)];
    [priceLabel setText:@"Price"];
    [priceLabel setFont:APP_FONT_REGULAR_16];
    [sView addSubview:priceLabel];
    
    priceText=[[UITextField alloc] initWithFrame:CGRectMake(10, 280, dummyV.frame.size.width-20, 40)];
    [priceText.layer addSublayer:[self bottomborderAdding:priceText.frame.size.width height:40]];
    [priceText setPlaceholder:@"Enter Price"];
    [priceText setText:@"No Price"];
    [priceText setDelegate:self];
    priceText.textColor = [UIColor  blackColor];
    priceText.textAlignment = NSTextAlignmentLeft;
    [priceText setFont:APP_FONT_REGULAR_16];
    [sView addSubview:priceText];
    
    pricePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-220, self.view.frame.size.width-40, 220)];
    priceText.inputView = pricePicker;
    pricePicker.delegate=self;
    pricePicker.dataSource=self;
    
    UIToolbar *optionPickerTool=[[UIToolbar alloc]init];
    optionPickerTool.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(addressFieldDoneAction)];
    [optionPickerTool setItems:[[NSArray alloc] initWithObjects:button1, nil]];
    distanceText.inputAccessoryView=optionPickerTool;
    priceText.inputAccessoryView=optionPickerTool;
    cusinesText.inputAccessoryView=optionPickerTool;

    UILabel *rateLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,340, dummyV.frame.size.width-20, 20)];
    [rateLabel setText:@"RATE ME"];
    [rateLabel setFont:APP_FONT_REGULAR_16];
    [sView addSubview:rateLabel];
    
    starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(10, 360, 160, 35)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = APP_COLOR;
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [sView addSubview:starRatingView];
    
    UIButton *chekboxbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chekboxbtn.frame = CGRectMake(10,410,160, 25);
    chekboxbtn.titleLabel.font = APP_FONT_REGULAR_14;
    chekboxbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    chekboxbtn.titleLabel.numberOfLines = 0;
    [chekboxbtn setTitle:@"Delivery Available" forState:UIControlStateNormal];
    [chekboxbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chekboxbtn addTarget:self action:@selector(checkBoxBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [chekboxbtn setImage:[UIImage imageNamed:@"checkboxUnchecked"] forState:UIControlStateNormal];
    [chekboxbtn setImage:[UIImage imageNamed:@"checkboxChecked"] forState:UIControlStateSelected];
    [sView addSubview:chekboxbtn];

}
-(CALayer *)bottomborderAdding:(CGFloat)width height:(CGFloat)height{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [[UIColor grayColor] CGColor];
    border.frame = CGRectMake(0, height-1, width, 1);
    return border;
}
-(void)addressFieldDoneAction{
    [distanceText resignFirstResponder];
    [priceText resignFirstResponder];
    [cusinesText resignFirstResponder];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == distancePicker){
        return distanceArry.count;
    }else if (pickerView == pricePicker){
        return priceArray.count;
    }else if (pickerView == cuisinePicker){
        return cuisineArray.count;
    }
    return 0;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == distancePicker){
        return [distanceArry objectAtIndex:row];
    }else if (pickerView == pricePicker){
        return [priceArray objectAtIndex:row];
    }else if (pickerView == cuisinePicker){
        return [NSString stringWithFormat:@"%@ (%@)",[[cuisineArray objectAtIndex:row] objectForKey:@"Cname"],[[cuisineArray objectAtIndex:row] objectForKey:@"Count"]];
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == distancePicker){
       distanceText.text= [distanceArry objectAtIndex:row];
    }else if (pickerView == pricePicker){
       priceText.text= [priceArray objectAtIndex:row];
    }else if (pickerView == cuisinePicker){
       cusinesText.text=  [NSString stringWithFormat:@"%@ (%@)",[[cuisineArray objectAtIndex:row] objectForKey:@"Cname"],[[cuisineArray objectAtIndex:row] objectForKey:@"Count"]];
    }
}
-(void)checkBoxBtnAct:(UIButton *)sender{
    sender.selected = !sender.selected;
    delivery=sender.selected;
}
-(void)didChangeValue:(HCSStarRatingView *)view{
    NSLog(@"Star Rating value %f",view.value);
}
-(void)closeBtnAct{
    [fiterViews removeFromSuperview];
}
-(void)filtersSubmitAct{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[NSNull null] forKey:@"ExclusiveStartKey"];
    [dic setObject:[NSNumber numberWithFloat:_locationsObjects.latitude] forKey:@"Latitude"];
    [dic setObject:[NSNumber numberWithFloat:_locationsObjects.longitude] forKey:@"Longitude"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    [dic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"Date"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    [formatter setDateFormat:@"hh:mm a"];
    [dic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"Time"];
    [dic setObject:distanceText.text forKey:@"Distance"];
    if([priceText.text isEqualToString:@"No Price"]){
        [dic setObject:[NSNumber numberWithInt:0] forKey:@"PriceForTwo"];
    }else{
        [dic setObject:[priceText.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"PriceForTwo"];
    }
    if([cusinesText.text isEqualToString:@"All"]){
      [dic setObject:@"All" forKey:@"Cuisine"];
    }else{
     NSArray *arry=[cusinesText.text componentsSeparatedByString:@"("];
        [dic setObject:[arry objectAtIndex:0] forKey:@"Cuisine"];
    }
    [dic setObject:[NSNull null] forKey:@"Parking"];
    [dic setObject:[NSNull null] forKey:@"TakeOut"];
    [dic setObject:[NSNull null] forKey:@"Buffet"];
    [dic setObject:[NSNull null] forKey:@"KidsFriendly"];
    [dic setObject:[NSNull null] forKey:@"OutdoorSeating"];
    [dic setObject:[NSNumber numberWithInt:starRatingView.value] forKey:@"Rating"];
    [dic setObject:[NSNumber numberWithInt:delivery] forKey:@"DeliveryAvail"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"OpenNow"];
    NSDictionary *itemDic=[[NSDictionary alloc] initWithObjectsAndKeys:dic,@"Items", nil];
    
    [self gettingRestaurantlist:itemDic];
    [fiterViews removeFromSuperview];
}
-(void)currentLocation{
    [AppDelegate loaderShow:YES];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [AppDelegate loaderShow:NO];
    [locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    NSLog(@"User Scanned loaction : %f, %f",location.coordinate.latitude,location.coordinate.longitude);
    [self convertingIntoAdress:location.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [AppDelegate loaderShow:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn-on Location Services"
                                                    message:@"To enable turn on your Location Services in settings."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert setTag:6668];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (alertView.tag==6668 && (buttonIndex == 0)) {
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            // code here
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:"]];
        }else
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    }
}
-(void)convertingIntoAdress:(CLLocationCoordinate2D)location
{
    [AppDelegate loaderShow:YES];
    CLLocation *locations = [[CLLocation alloc]
                             initWithLatitude:location.latitude longitude:location.longitude];
    myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder reverseGeocodeLocation:locations completionHandler:^(NSArray *placemarks, NSError *error) {
        [AppDelegate loaderShow:NO];
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString  *addressString = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                        [placemark subThoroughfare],
                                        [placemark thoroughfare],
                                        [placemark locality],
                                        [placemark administrativeArea]];
            NSString *undesired = @"(null)";
            NSString *desired   = @"\n";
             addressText.text=[addressString stringByReplacingOccurrencesOfString:undesired withString:desired];
            _locationsObjects.latitude=location.latitude;
            _locationsObjects.longitude=location.longitude;
        }
    }];
}
-(void)rightBarAct{
    MapViewVC *map=[[MapViewVC alloc] init];
    map.locationsArray=locationsArray;
    map.regionLocation=_locationsObjects;
    [self.navigationController pushViewController:map animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
     return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == addressText){
        [textField resignFirstResponder];
        GoogleSearchView *search = [[GoogleSearchView alloc] init];
        search.objects=self;
        search.fromOrderOnline=YES;
        [self.navigationController pushViewController:search animated:YES];
    }else if(textField == searchField){
        searchTextFieldActive=YES;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == searchField){
       NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(searchStr.length > 0){
            [self searchActionAutomatically:searchStr];
        }else{
            [locationsArray removeAllObjects];
            for(int i=0; i<searchArrayforLocation.count; i++){
                [locationsArray addObject:[searchArrayforLocation objectAtIndex:i]];
            }
            [locationListTbl reloadData];
        }
    }
    return YES;
}
-(void)searchActionAutomatically:(NSString *)str{
    if(locationsArray.count > 0){
        BOOL rangFound=0;
        NSMutableArray *displayItemArry=[[NSMutableArray alloc]init];
        for (int i=0; i<searchArrayforLocation.count; i++) {
            NSString *searchLocation = ((ListOfRestuarents *)[searchArrayforLocation objectAtIndex:i]).Title;
            NSRange rangePhone = [searchLocation rangeOfString:str options:NSCaseInsensitiveSearch];
            if (rangePhone.location != NSNotFound)
            {
                rangFound=1;
                [displayItemArry addObject:[searchArrayforLocation objectAtIndex:i]];
            }
        }
        [locationsArray removeAllObjects];
        locationsArray=[displayItemArry mutableCopy];
        [locationListTbl reloadData];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == searchField){
        searchTextFieldActive=NO;
    }
}
-(void)addressSelection:(NSString *)address locationDetails:(CLLocationCoordinate2D )location{
     addressText.text=address;
    _address=address;
    _locationsObjects.latitude=location.latitude;
    _locationsObjects.longitude=location.longitude;
}
-(void)searchingLocationList{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[NSNull null] forKey:@"ExclusiveStartKey"];
    [dic setObject:[NSNumber numberWithFloat:_locationsObjects.latitude] forKey:@"Latitude"];
    [dic setObject:[NSNumber numberWithFloat:_locationsObjects.longitude] forKey:@"Longitude"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    [dic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"Date"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    [formatter setDateFormat:@"hh:mm a"];
    [dic setObject:[formatter stringFromDate:[NSDate date]] forKey:@"Time"];
    [dic setObject:@"5" forKey:@"Distance"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"PriceForTwo"];
    [dic setObject:[NSNull null] forKey:@"Cuisine"];
    [dic setObject:[NSNull null] forKey:@"Parking"];
    [dic setObject:[NSNull null] forKey:@"TakeOut"];
    [dic setObject:[NSNull null] forKey:@"Buffet"];
    [dic setObject:[NSNull null] forKey:@"KidsFriendly"];
    [dic setObject:[NSNull null] forKey:@"OutdoorSeating"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"Rating"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"DeliveryAvail"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"OpenNow"];
    NSDictionary *itemDic=[[NSDictionary alloc] initWithObjectsAndKeys:dic,@"Items", nil];
    
    [self gettingRestaurantlist:itemDic];
}
-(void)addingAllViews{
    [self.view addSubview:locationListTbl];
    [self.view addSubview:searchField];
    [self.view addSubview:filterBtn];

}
-(void)gettingRestaurantlist:(NSDictionary *)items{
    [APIRequest searchLocationlist:items completion:^(NSMutableData *buffer) {
        [locationsArray removeAllObjects];
        [noResView removeFromSuperview];
        [cuisineArray removeAllObjects];
        if(!buffer){
            
        }else{
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            NSArray *arry;
            ![resObj isKindOfClass:[NSNull class]] && !([(NSArray *)resObj count]==1 && [[(NSArray *)resObj objectAtIndex:0] objectForKey:@"Cuisines"] != nil)?arry=(NSArray *)resObj:@"";
            if(arry && [arry count]){
                for(int i=0; i<arry.count-1; i++){
                    ListOfRestuarents *res=[[ListOfRestuarents alloc] init];
                    res.Title=[[arry objectAtIndex:i] objectForKey:@"Title"];
                    res.Address=[[arry objectAtIndex:i] objectForKey:@"Address"];
                    res.ImageUrl=[[arry objectAtIndex:i] objectForKey:@"ImageUrl"];
                    res.Distance=[[arry objectAtIndex:i] objectForKey:@"Distance"];
                    res.LunchDelivery=[[arry objectAtIndex:i] objectForKey:@"LunchDelivery"];
                    res.CuisineName=[[arry objectAtIndex:i] objectForKey:@"CuisineName"];
                    res.CuisineId=[[arry objectAtIndex:i] objectForKey:@"CuisineId"];
                    res.DinnerDelivery=[[arry objectAtIndex:i] objectForKey:@"DinnerDelivery"];
                    res.Lunch=[[arry objectAtIndex:i] objectForKey:@"Lunch"];
                    res.Dinner=[[arry objectAtIndex:i] objectForKey:@"Dinner"];
                    res.Timing=[[[arry objectAtIndex:i] objectForKey:@"Timing"] mutableCopy];
                    res.Lat=[[[arry objectAtIndex:i] objectForKey:@"Lat"] doubleValue];
                    res.Long=[[[arry objectAtIndex:i] objectForKey:@"Long"] doubleValue];
                    res.RestaurantID=[NSString stringWithFormat:@"%ld",[[[arry objectAtIndex:i] objectForKey:@"RestaurantID"] integerValue]];
                    [locationsArray addObject:res];
                    [searchArrayforLocation addObject:res];
                }
                NSInteger allCount=0;
                for(int i=0 ; i< ((NSArray *)[[arry objectAtIndex:arry.count-1] objectForKey:@"Cuisines"]).count ; i++){
                    [cuisineArray addObject:[[[arry objectAtIndex:arry.count-1] objectForKey:@"Cuisines"] objectAtIndex:i]];
                    allCount=allCount+[[[[[arry objectAtIndex:arry.count-1] objectForKey:@"Cuisines"] objectAtIndex:i] objectForKey:@"Count"] integerValue];
                }
                NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"All",@"Cname",[NSNumber numberWithInteger:allCount],@"Count", nil];
                [cuisineArray count] > 0?[cuisineArray insertObject:dic atIndex:0]:@"";
                [self addingAllViews];
            }else{
                NSLog(@"We don't have restuarents around you");
                [locationListTbl reloadData];
                [self norestuarantsView];
            }
        }
    }];
}
-(void)norestuarantsView{
    noResView=[[UIView alloc] initWithFrame:CGRectMake(0, 64+50,SCREEN_WIDTH, SCREEN_HEIGHT-(64+50))];
    [noResView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:noResView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT-64+50)/2-20, SCREEN_WIDTH-20, 40)];
    [label setFont:APP_FONT_BOLD_18];
    [label setText:@"No Restuarants in your Area"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [noResView addSubview:label];
    
    [self.view addSubview:searchField];
    [self.view addSubview:filterBtn];

}
-(void)leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return locationsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 340;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CardcellForRes *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[CardcellForRes alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image.tag=indexPath.row;
    cell.CuisineName.text=((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).CuisineName;
    cell.title.text=((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Title;
    cell.address.text=((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Address;
    if([((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Lunch isEqualToString:@"Open"] || [((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Dinner isEqualToString:@"Open"]){
        cell.deliveystatusLabel.text=@"Open";
    }else{
        cell.deliveystatusLabel.text=@"Currently Not Available-Order In Advance";
    }
    [cell.cousineImageView setImage:[UIImage imageNamed:@"fork"]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[NSDate date]];
    NSString *endOfDay,*startOfDay;
    startOfDay=[[[((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Timing objectAtIndex:adjustedWeekdayOrdinal-1] objectForKey:@"Lunch"] objectForKey:@"start"];
    endOfDay=[[[((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Timing objectAtIndex:adjustedWeekdayOrdinal-1] objectForKey:@"Dinner"] objectForKey:@"end"];
    if([cell.deliveystatusLabel.text isEqualToString:@"Open"]){
        cell.openorclosetime.text=[NSString stringWithFormat:@"Closes At %@",endOfDay];
    }else{
        cell.openorclosetime.text=[NSString stringWithFormat:@"Opens At %@",startOfDay];
    }
    
    NSString *string=[NSString stringWithFormat:@"Distance(Miles):%.2f",[((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Distance doubleValue]];
    NSMutableAttributedString *distance=[[NSMutableAttributedString alloc] initWithString:string];
    NSRange dista=[string rangeOfString:@"Distance(Miles):"];
    NSRange distanceValue=[string rangeOfString:[NSString stringWithFormat:@"%.2f",[((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).Distance doubleValue]]];
    [distance addAttribute:NSForegroundColorAttributeName value:DARK_GRAY range:dista];
    [distance addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:distanceValue];
    cell.distance.attributedText=distance;
    
    NSString *restuarentStatus;
    if([((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).LunchDelivery isEqualToString:@"Available"] || [((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).DinnerDelivery isEqualToString:@"Available"]){
        restuarentStatus=@"Available";
    }else{
        restuarentStatus=@"Not Available";
    }
    NSString *dev=[NSString stringWithFormat:@"Delivery:%@",restuarentStatus];
    NSMutableAttributedString *delivery=[[NSMutableAttributedString alloc] initWithString:dev];
    NSRange delive=[dev rangeOfString:@"Delivery:"];
    NSRange delivevalue=[dev rangeOfString:restuarentStatus];
    [delivery addAttribute:NSForegroundColorAttributeName value:DARK_GRAY range:delive];
    [delivery addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:delivevalue];
    cell.Delivery.attributedText=delivery;

    if(((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).imageData && indexPath.row == cell.image.tag){
        cell.image.image=[UIImage imageWithData:((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).imageData];
    }else{
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSString *path =((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).ImageUrl;
            NSData *dta = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            UIImage *image = [UIImage imageWithData:dta];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (indexPath.row == cell.image.tag){
                    if(dta){
                        cell.image.image=image;
                        NSLog(@"indexPath %ld and Arraycount %lu",(long)indexPath.row,locationsArray.count);
                        if(locationsArray.count > indexPath.row)
                            ((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).imageData=dta;
                    }else{
                        cell.image.image=[UIImage imageNamed:@"menu-placeholder"];
                    }
                }
            });
        });
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:((ListOfRestuarents *)[locationsArray objectAtIndex:indexPath.row]).RestaurantID forKey:@"MainClientId"];
    [self fetchChildClientSettings];
}
-(void)fetchChildClientSettings{
    [AppDelegate loaderShow:YES];
    [APIRequest fetchChildClientSettings:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID,@"clientId", nil] completion:^(NSMutableData *buffer) {
        [AppDelegate loaderShow:NO];
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
                    mul.fromOrderOnline=YES;
                    [self.navigationController pushViewController:mul animated:NO];
                }else{
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SelectedRestroVC *select =[storyboard instantiateViewControllerWithIdentifier:@"SelectedRes"];
                    [self.navigationController pushViewController:select animated:NO];
                    [self fetchClientSettings];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"%@", [resObj objectForKey:@"status"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];

            }
        }
    }];
}
-(void) fetchClientSettings{
    [APIRequest fetchClientSettings:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID,@"clientId", nil] completion:^(NSMutableData *buffer) {
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
                UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SelectedRestroVC *select =[storyboard instantiateViewControllerWithIdentifier:@"SelectedRes"];
                [self.navigationController pushViewController:select animated:NO];
            }
        }
    }];
}
-(void)keyboardWasShown:(NSNotification *)notification{
    if(!searchTextFieldActive){
        CGRect frm = self.view.frame;
        frm.origin.y = (frm.origin.y<0)?frm.origin.y:-40;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = frm;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    if(!searchTextFieldActive){
        CGRect frm = self.view.frame;
        frm.origin.y = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = frm;
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
