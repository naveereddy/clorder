//
//  RestuarentListVC.h
//  CLOrder
//
//  Created by Naveen Thukkani on 06/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HCSStarRatingView.h"

@interface RestuarentListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate>
{
    NSMutableArray *locationsArray;
    CLLocationManager *locationManager;
}
@property (nonatomic, strong) CLGeocoder *myGeocoder;
@property (nonatomic, strong) NSString *address;
@property (nonatomic,assign) CLLocationCoordinate2D locationsObjects;
-(void)addressSelection:(NSString *)address locationDetails:(CLLocationCoordinate2D )location;
@end
