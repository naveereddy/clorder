//
//  LocationContact.m
//  CLOrder
//
//  Created by Vegunta's on 06/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "LocationContact.h"
#import "AppHeader.h"
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@implementation LocationContact

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    mapView.showsUserLocation = YES;
    if ([mapView respondsToSelector:@selector(showsTraffic)])
        mapView.showsTraffic = YES;
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.title=@"Sample";
    CLLocationCoordinate2D location;
    location.latitude = 42.119152;
    location.longitude = -87.988242;
    
    
    // this uses an address for the destination.  can use lat/long, too with %f,%f format
    NSString* address = @"Arlington Heights, IL 60004";
    NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",
                     location.latitude, location.longitude,
                     [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
    
    NSMutableArray *anns = [[NSMutableArray alloc] init];
    [point setCoordinate:(location)];
    [anns addObject:point];
    [mapView showAnnotations:anns animated:YES];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    headerImg.backgroundColor = TRANSPARENT_GRAY;
    [mapView addSubview:headerImg];
    
    UISearchBar *searchTxt = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 30)];
    searchTxt.delegate = self;
    [headerImg addSubview:searchTxt];
    searchTxt.backgroundColor = TRANSPARENT_GRAY;
    searchTxt.placeholder = @"Your Address";
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-120, SCREEN_WIDTH, SCREEN_HEIGHT-120)];
    bottomView.backgroundColor = TRANSPARENT_GRAY;
    [mapView addSubview:bottomView];
    
    UIImageView *bottomImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 80)];
    bottomImg.backgroundColor = [UIColor whiteColor];
    bottomImg.layer.cornerRadius = 5.0;
    [bottomView addSubview:bottomImg];
    
    UIImageView *markerImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 30)];
    markerImg.image = [UIImage imageNamed:@"vector-icon"];
    [bottomImg addSubview:markerImg];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame: CGRectMake(30, 5, bottomImg.frame.size.width-40, 30)];
    [bottomImg addSubview:nameLbl];
    nameLbl.text = @"500 W.Rand Rd, #108A,";
    
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, bottomImg.frame.size.width-40, 20)];
    [bottomImg addSubview:addressLbl];
    addressLbl.text = @"Arlington Heights, IL 60004";
    addressLbl.textColor = [UIColor grayColor];
    
    
    UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 55, bottomImg.frame.size.width-40, 20)];
    [bottomImg addSubview:phoneLbl];
    phoneLbl.text = @"+18 9856321478";
    phoneLbl.textColor = [UIColor grayColor];
    
    
    
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"sign_create_btn"] forState:UIControlStateNormal];
    [locationBtn setTitle:@"USE THIS LOCATION" forState:UIControlStateNormal];
    [locationBtn setTitleColor:DARK_GRAY forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:locationBtn];
    
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}
-(void)locationBtnAct{
    
}



@end
