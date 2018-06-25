//
//  HistoryOrderDtlV.h
//  CLOrder
//
//  Created by Vegunta's on 29/08/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryOrderDtlV : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
    UITableView *detailTbl;
}
@property (nonatomic, retain) NSString *orderId;
@end
