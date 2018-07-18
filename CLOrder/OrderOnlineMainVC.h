//
//  OrderOnlineMainVC.h
//  CLOrder
//
//  Created by Naveen Thukkani on 06/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RestuarentListVC.h"
#import "AppDelegate.h"

@interface OrderOnlineMainVC : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
- (IBAction)currentLocationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *findResturentsbutton;
- (IBAction)findRestuarentsAction:(id)sender;
@property (nonatomic, strong) CLGeocoder *myGeocoder;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
-(void)addressSelection:(NSString *)address locationDetails:(CLLocationCoordinate2D )location;
@property (nonatomic, assign) CLLocationCoordinate2D locationsObjects;

@end
