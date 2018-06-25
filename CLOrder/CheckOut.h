//
//  CheckOut.h
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckOut : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate> {
    UITableView *orderTbl;
    UITextField *couponTxt;
    UIPickerView *picker;
}

@property (nonatomic, retain) NSDictionary *couponId;
@property (nonatomic, assign) int replaceIndex;
@property (nonatomic, assign) NSString *orderId;

-(void)getCouponId:(NSDictionary *)couponIdFromCpnVC;

@end
