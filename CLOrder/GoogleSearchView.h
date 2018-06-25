//
//  GoogleSearchView.h
//  CLOrder
//
//  Created by Naveen Thukkani on 21/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryVC.h"

@interface GoogleSearchView : UITableViewController<UISearchBarDelegate>{
    NSMutableArray *autoCompleteData;
    UISearchBar *searchBars;
}
@property (nonatomic, strong) DeliveryVC *object;

@end
