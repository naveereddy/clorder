//
//  ListOfRestuarents.h
//  CLOrder
//
//  Created by Naveen Thukkani on 06/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListOfRestuarents : NSObject

@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) NSString *CuisineId;
@property (nonatomic, strong) NSString *CuisineName;
@property (nonatomic, strong) NSString *Dinner;
@property (nonatomic, strong) NSString *Distance;
@property (nonatomic, strong) NSString *ImageUrl;
@property (nonatomic, strong) NSString *IsLaunch;
@property (nonatomic, strong) NSString *IsPremier;
@property (nonatomic) double Lat;
@property (nonatomic) double Long;
@property (nonatomic, strong) NSString *Lunch;
@property (nonatomic, strong) NSString *LunchDelivery;
@property (nonatomic, strong) NSString *NavTitle;
@property (nonatomic, strong) NSString *OrderNowUrl;
@property (nonatomic, strong) NSString *Price;
@property (nonatomic, strong) NSString *Rating;
@property (nonatomic, strong) NSString *RestRank;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *ViewMenuUrl;
@property (nonatomic, strong) NSString *ZipCode;
@property (nonatomic, strong) NSString *geoJson;
@property (nonatomic, strong) NSString *geohash;
@property (nonatomic, strong) NSString *hashKey;
@property (nonatomic, strong) NSString *ordermenu;
@property (nonatomic, strong) NSString *rangeKey;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSMutableArray *Timing;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic , strong) NSString *RestaurantID;
@property (nonatomic , strong) NSString *DinnerDelivery;

@end
