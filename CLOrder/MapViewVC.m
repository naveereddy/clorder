//
//  MapViewVC.m
//  CLOrder
//
//  Created by Naveen Thukkani on 10/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "MapViewVC.h"

@interface MapViewVC ()
@end

@implementation MapViewVC
@synthesize locationsArray,locationsObjects,regionLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Order Online Mapview";
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    [self.view addSubview:[self mapViewShowing]];
    for(int i=0 ; i<locationsArray.count; i++){
        locationsObjects.latitude=((ListOfRestuarents *)[locationsArray objectAtIndex:i]).Lat;
        locationsObjects.longitude=((ListOfRestuarents *)[locationsArray objectAtIndex:i]).Long;
         [self createMapviewWithLocation:locationsObjects mapView:mapVu title:((ListOfRestuarents *)[locationsArray objectAtIndex:i]).Title index:i];
    }
    [self setCenter:regionLocation forMap:mapVu];
}
-(void)leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)mapViewShowing
{
    mapVu=[[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    mapVu.delegate=self;
    return mapVu;
}
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationView";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapVu dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil){
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    annotationView.image = [UIImage imageNamed:@"resturants_defaulticon"];
    annotationView.annotation = annotation;
    annotationView.canShowCallout=YES;
    return annotationView;
}
- (void)createMapviewWithLocation:(CLLocationCoordinate2D)location mapView:(MKMapView *)mapView title:(NSString *)title index:(int)index {
     MKPointAnnotation *mapAnnotation = [[MKPointAnnotation alloc] init];
     mapAnnotation.title=title;
     NSString *string;
        if([((ListOfRestuarents *)[locationsArray objectAtIndex:index]).LunchDelivery isEqualToString:@"Available"] || [((ListOfRestuarents *)[locationsArray objectAtIndex:index]).DinnerDelivery isEqualToString:@"Available"]){
            string=@"Available";
        }else{
            string=@"Not Available";
        }
     mapAnnotation.subtitle=[NSString stringWithFormat:@"Delivery: %@",string];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
