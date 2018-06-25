//
//  ViewCouponVC.h
//  CLOrder
//
//  Created by Vegunta's on 07/07/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewCouponVC : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    UITableView *couponTbl;
    NSArray *promotionArray;
    id delegateOfPrevious;
    
}
-(void)setDelegate:(id)_delegate;

@end
