//
//  MultiLocationVC.m
//  CLOrder
//
//  Created by Naveen Thukkani on 03/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "MultiLocationVC.h"
#import "AppHeader.h"
#import "APIRequester.h"
#import "APIRequest.h"
#import "LocationsList.h"
#import "SelectedRestroVC.h"
@interface MultiLocationVC ()
{
    UITableView *mulLocation;
    UIBarButtonItem *leftBarItem;
}
@end

@implementation MultiLocationVC
@synthesize locationsList,locationsObjects,fromOrderOnline;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:APP_COLOR];
    self.title=@"All Locations";
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];

    
    mapVu=[[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,200)];
    mapVu.delegate=self;
    [self.view addSubview:mapVu];
    
    mulLocation=[[UITableView alloc] initWithFrame:CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT-200-64) style:UITableViewStylePlain];
    mulLocation.delegate=self;
    mulLocation.dataSource=self;
    [self.view addSubview:mulLocation];
    mulLocation.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [mulLocation setSeparatorColor:[UIColor clearColor]];
    
    for (int i=0;i<locationsList.count; i++) {
        locationsObjects.latitude=[[[locationsList objectAtIndex:i] objectForKey:@"ClientLatititude"] doubleValue];
        locationsObjects.longitude=[[[locationsList objectAtIndex:i] objectForKey:@"ClientLongitude"] doubleValue];
        if(locationsObjects.latitude == 0 || locationsObjects.longitude == 0){
            NSString *encode = [[[locationsList objectAtIndex:i] objectForKey:@"ClientAddress"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
            [self gettingLatLong:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@",encode,GOOGLE_API_KEY] index:i];
        }else{
            [self createMapviewWithLocation:locationsObjects mapView:mapVu title:[[locationsList objectAtIndex:i] objectForKey:@"ClientName"] index:i];
        }
    }
    locationsObjects.latitude=[[[locationsList objectAtIndex:locationsList.count-1] objectForKey:@"ClientLatititude"] doubleValue];
    locationsObjects.longitude=[[[locationsList objectAtIndex:locationsList.count-1] objectForKey:@"ClientLongitude"] doubleValue];
    [self setCenter:locationsObjects forMap:mapVu];
}
-(void)leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if(fromOrderOnline){
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return locationsList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationsList *cell = [[LocationsList alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    cell.textLabel.font = APP_FONT_BOLD_18;
    [cell.textLabel setTextColor:DARK_GRAY];
    cell.detailTextLabel.font = APP_FONT_REGULAR_16;
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    cell.detailTextLabel.numberOfLines=0;
    cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    cell.textLabel.text=[[locationsList objectAtIndex:indexPath.row] objectForKey:@"ClientName"];
    cell.detailTextLabel.text=[[locationsList objectAtIndex:indexPath.row] objectForKey:@"ClientAddress"];
    cell.imageView.image=[UIImage imageNamed:@"loaction_marker"];
    
    UILabel *numberLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 20)];
    [numberLabel setFont:APP_FONT_REGULAR_12];
    [cell.imageView addSubview:numberLabel];
    [numberLabel setTextAlignment:NSTextAlignmentCenter];
    [numberLabel setTextColor:[UIColor whiteColor]];
    [cell bringSubviewToFront:numberLabel];
    [numberLabel setText:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [mulLocation deselectRowAtIndexPath:indexPath animated:YES];
    [self fetchClientSettings:[[locationsList objectAtIndex:indexPath.row] objectForKey:@"ClientId"]];
    [[NSUserDefaults standardUserDefaults] setObject:[[locationsList objectAtIndex:indexPath.row] objectForKey:@"ClientId"] forKey:@"MainClientId"];
}
-(void) fetchClientSettings:(NSString *)clientID{
    [APIRequest fetchClientSettings:[NSDictionary dictionaryWithObjectsAndKeys:clientID,@"clientId", nil] completion:^(NSMutableData *buffer) {
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
                [self.navigationController pushViewController:select animated:YES];
            }
        }
    }];
}
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationView";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapVu dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil){
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout=YES;
    annotationView.image = [UIImage imageNamed:@"loaction_marker"];
    
    NSInteger indexValue = 0;
    for (int i=0; i<locationsList.count; i++) {
        if([[[locationsList objectAtIndex:i] objectForKey:@"ClientAddress"] isEqualToString:annotation.subtitle]){
            indexValue=i+1;
        }
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 30, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"%ld",(long)indexValue];
    label.font=APP_FONT_REGULAR_12;
    label. textAlignment = NSTextAlignmentCenter;
    [annotationView addSubview:label];
    [annotationView bringSubviewToFront:label];
    
    return annotationView;
}
- (void)createMapviewWithLocation:(CLLocationCoordinate2D)location mapView:(MKMapView *)mapView title:(NSString *)title index:(int)index {
     MKPointAnnotation *mapAnnotation = [[MKPointAnnotation alloc] init];
     mapAnnotation.title=title;
     mapAnnotation.subtitle=[[locationsList objectAtIndex:index] objectForKey:@"ClientAddress"];
    [mapAnnotation setCoordinate:location];
    [mapView addAnnotation:mapAnnotation];
}
- (void)setCenter:(CLLocationCoordinate2D)location forMap:(MKMapView *)mapView{
    float mapSpanY= 0.09;
    float mapSpanX = mapSpanY * mapView.frame.size.width / mapView.frame.size.height;
    MKCoordinateSpan span = MKCoordinateSpanMake(mapSpanX, mapSpanY);
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(location.latitude, location.longitude), span);
    [mapView setRegion:region animated:YES];
}
-(void)gettingLatLong:(NSString *)string index:(int)index{
    [APIRequest gettingLatLong:nil url:string completion:^(NSMutableData *buffer) {
        if(!buffer){
            
        }else{
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if(![[resObj objectForKey:@"status"]  isEqualToString:@"ZERO_RESULTS"])
            {
                locationsObjects.latitude=[[[[[[resObj objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                locationsObjects.longitude=[[[[[[resObj objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                [self createMapviewWithLocation:locationsObjects mapView:mapVu title:[[locationsList objectAtIndex:index] objectForKey:@"ClientName"] index:index];
            }
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


