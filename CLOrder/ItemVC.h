//
//  ItemVC.h
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemVC : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    UITableView *ItemTbl;
    UILabel *menuNamelbl;
}
@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *itemName;

@property (nonatomic, retain) NSArray *clientCategoriesArr;

@end
