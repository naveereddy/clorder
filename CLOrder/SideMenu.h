//
//  SideMenu.h
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllDayMenuVC.h"

@interface SideMenu : UIView <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIImageView *profileImage;
@property (strong, nonatomic) UILabel *emailName;
@property (strong, nonatomic) UILabel *userNameText;
@property (strong, nonatomic) AllDayMenuVC *delegate;

@end
