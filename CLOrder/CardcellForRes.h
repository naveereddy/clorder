//
//  CardcellForRes.h
//  CLOrder
//
//  Created by Naveen Thukkani on 06/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardcellForRes : UITableViewCell
@property (nonatomic , strong) UIImageView *image;
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UILabel *address;
@property (nonatomic , strong) UILabel *distance;
@property (nonatomic , strong) UILabel *Delivery;
@property (nonatomic , strong) UIView *cardView;
@property (nonatomic , strong) UIView *devlivaryStatus;
@property (nonatomic , strong) UILabel *deliveystatusLabel;
@property (nonatomic , strong) UILabel *openorclosetime;
@property (nonatomic , strong) UILabel *CuisineName;
@property (nonatomic , strong) UIView *cousineView;
@property (nonatomic , strong) UIImageView *cousineImageView;

@end
