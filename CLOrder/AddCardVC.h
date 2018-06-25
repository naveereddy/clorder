//
//  AddCardVC.h
//  CLOrder
//
//  Created by Vegunta's on 21/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCardVC : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *monthsArr;
    UITextField *expMonthTxt;
    UIPickerView *picker;
    UITextField *nameText;
    UITextField *cardNumberText;
}

@property(nonatomic, retain) NSMutableDictionary *cardDic;
@property (nonatomic) BOOL newCard;
@end
