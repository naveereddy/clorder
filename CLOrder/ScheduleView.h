//
//  ScheduleView.h
//  CLOrder
//
//  Created by Vegunta's on 29/11/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleView : UIView<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
- (id)initWithFrame:(CGRect)frame forController:(id)ctrl;
@end
