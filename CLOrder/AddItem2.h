//
//  AddItem.h
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItem : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate> {
    UITableView *choicesTbl;
    UITableView *Moditbl;
    UIPickerView *choicePicker;
}
@property (nonatomic, assign)   int replaceIndex;
@property (nonatomic, retain) NSMutableDictionary *item;

@end
