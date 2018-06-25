//
//  SignUpView.h
//  CLOrder
//
//  Created by Vegunta's on 14/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpView : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) NSString *emailId;
@property (nonatomic, retain) NSString *password;

@end
