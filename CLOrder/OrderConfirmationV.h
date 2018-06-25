//
//  OrderConfirmationV.h
//  CLOrder
//
//  Created by Vegunta's on 07/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface OrderConfirmationV : UIViewController < UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKAnnotation, MKMapViewDelegate>{
    UITableView *orderListTbl;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@end
