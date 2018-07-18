//
//  ChangePassword.h
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ChangePassword : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *oldPasswordtext;
    IBOutlet UITextField *newPasswordtext;
    IBOutlet UITextField *confirmPasswordtext;
    IBOutlet UIButton *saveButton;

}
-(IBAction)saveAction: (id)sender;

@end
