//
//  Schedular.h
//  CLOrder
//
//  Created by Vegunta's on 27/12/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Schedular : UIView<UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
- (id)initWithFrame:(CGRect)frame forController:(id)ctrl;

@end
