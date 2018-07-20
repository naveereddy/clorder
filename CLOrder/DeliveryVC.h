//
//  DeliveryVC.h
//  CLOrder
//
//  Created by Vegunta's on 27/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DeliveryVC : UIViewController<UITextFieldDelegate, UIPickerViewDelegate , UIPickerViewDataSource>
@property (assign, nonatomic) BOOL isGuest;
@property (assign, nonatomic) BOOL isNewUser;
@property (nonatomic, assign) BOOL toCart;
-(void)addressSelection:(NSString *)address locationDetails:(CLLocationCoordinate2D )location;
@end
