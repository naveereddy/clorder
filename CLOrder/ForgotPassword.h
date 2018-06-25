//
//  ForgotPassword.h
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPassword : UIViewController<UITextFieldDelegate>{
IBOutlet UITextField *email;
IBOutlet UIButton *sendButton;
}
-(IBAction)sendAction: (id)sender;

@end
