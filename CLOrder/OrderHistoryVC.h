//
//  OrderHistoryVC.h
//  CLOrder
//
//  Created by Vegunta's on 16/08/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    UITableView *orderTbl;
}

@property (nonatomic) BOOL fromhamburger;
@end
