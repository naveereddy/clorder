//
//  OrderOnlineMainVC.m
//  CLOrder
//
//  Created by Naveen Thukkani on 06/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "OrderOnlineMainVC.h"
#import "AppHeader.h"
#import "GoogleSearchView.h"

@interface OrderOnlineMainVC ()

@end

@implementation OrderOnlineMainVC
@synthesize bottomView,searchField,currentLocationButton,myGeocoder;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), 44), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:blank forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:APP_COLOR];
    
    self.title=@"Order Food Online";
    searchField.delegate = self;
    [searchField.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-70 height:40]];
    
    [bottomView.layer setShadowOpacity:1.0];
    [bottomView.layer setShadowRadius:5.0];
    [bottomView.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    
    CGFloat space=(SCREEN_WIDTH-200-30)/3;
    int itemspace =0;
    
    UIButton *facebookButton=[[UIButton alloc] initWithFrame:CGRectMake((15+itemspace*50+itemspace*space), 5, 50, 50)];
    [facebookButton setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(faceBookAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:facebookButton];
    
    itemspace=itemspace+1;
    
    UIButton *twitter=[[UIButton alloc] initWithFrame:CGRectMake((15+itemspace*50+itemspace*space),5,50,50)];
    [twitter setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
    [twitter addTarget:self action:@selector(twitterAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:twitter];
    
    itemspace=itemspace+1;

    UIButton *gmailButton=[[UIButton alloc] initWithFrame:CGRectMake((15+itemspace*50+itemspace*space),5,50,50)];
    [gmailButton setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
    [gmailButton addTarget:self action:@selector(gmailAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:gmailButton];
    
    itemspace=itemspace+1;

    UIButton *instagram=[[UIButton alloc] initWithFrame:CGRectMake((15+itemspace*50+itemspace*space), 5 , 50 , 50)];
    [instagram setImage:[UIImage imageNamed:@"instagram"] forState:UIControlStateNormal];
    [instagram addTarget:self action:@selector(instagramAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:instagram];
        
}
-(CALayer *)bottomborderAdding:(CGFloat)width height:(CGFloat)height{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [[UIColor grayColor] CGColor];
    border.frame = CGRectMake(0, height-1, width, 1);
    return border;
}
-(void)faceBookAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/orderfoodonlinenow"] options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
-(void)gmailAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/orderfoodonlinenow"] options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
-(void)instagramAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/OrderFoodOnline/"] options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
-(void)twitterAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Orderfoodonlin1?lang=en"] options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
-(void)addressSelection:(NSString *)address locationDetails:(CLLocationCoordinate2D )location{
    searchField.text=address;
    _locationsObjects.latitude=location.latitude;
    _locationsObjects.longitude=location.longitude;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    GoogleSearchView *search = [[GoogleSearchView alloc] init];
    search.objects=self;
    search.fromOrderOnline=YES;
    [self.navigationController pushViewController:search animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)currentLocationAction:(id)sender {
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
             searchField.text=[addressString stringByReplacingOccurrencesOfString:undesired withString:desired];
            _locationsObjects.latitude=location.latitude;
            _locationsObjects.longitude=location.longitude;
        }
    }];
}
- (IBAction)findRestuarentsAction:(id)sender {
    if(![searchField.text isEqualToString:@""]){
        RestuarentListVC *vc=[[RestuarentListVC alloc] init];
        vc.address=searchField.text;
        vc.locationsObjects=_locationsObjects;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        UIAlertView *view=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", @"Please enter your Address"] delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
        [view show];
    }
}
@end
