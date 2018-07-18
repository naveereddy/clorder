//
//  MapViewVC.h
//  CLOrder
//
//  Created by Naveen Thukkani on 10/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ListOfRestuarents.h"

@interface MapViewVC : UIViewController<MKMapViewDelegate>
{
    MKMapView *mapVu;
}
@property (nonatomic , strong) NSMutableArray *locationsArray;
@property (nonatomic,assign) CLLocationCoordinate2D locationsObjects;
@property (nonatomic,assign) CLLocationCoordinate2D regionLocation;

@end
