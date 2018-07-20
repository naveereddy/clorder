//
//  GoogleSearchView.h
//  CLOrder
//
//  Created by Naveen Thukkani on 21/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryVC.h"
#import <CoreLocation/CoreLocation.h>
#import "OrderOnlineMainVC.h"

@interface GoogleSearchView : UITableViewController<UISearchBarDelegate>{
    NSMutableArray *autoCompleteData;
    UISearchBar *searchBars;
}
@property (nonatomic, strong) DeliveryVC *object;
@property (nonatomic, strong) id objects;
@property (nonatomic) bool fromOrderOnline;
@property (nonatomic, assign) CLLocationCoordinate2D locationsObjects;

@end
