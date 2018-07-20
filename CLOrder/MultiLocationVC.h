//
//  MultiLocationVC.h
//  CLOrder
//
//  Created by Naveen Thukkani on 03/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MultiLocationVC : UIViewController<UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>
{
    MKMapView *mapVu;
}
@property (nonatomic,strong) NSMutableArray *locationsList;
@property (nonatomic,assign) CLLocationCoordinate2D locationsObjects;
@property (nonatomic) bool fromOrderOnline;
@end
