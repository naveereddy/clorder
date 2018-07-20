//
//  LoginVC.h
//  CLOrder
//
//  Created by Vegunta's on 21/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginVC : UIViewController <UITextFieldDelegate, GIDSignInUIDelegate,FBSDKLoginButtonDelegate,GIDSignInDelegate> {
    
    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    IBOutlet UIButton *signInBtn;
    IBOutlet UIButton *guestUserBtn;
    IBOutlet UIButton *newUserBtn;
    IBOutlet UIButton *forgotPassword;
    FBSDKLoginButton *loginButton;
    IBOutlet UIButton *skipNowButton;
}
- (IBAction)skipNowAction:(id)sender;
-(IBAction) signInAct: (id)sender;
-(IBAction) guestUserAct: (id)sender;
-(IBAction) newUserAct: (id)sender;
-(IBAction) forgotPasswordAct: (id)sender;

@property (retain, nonatomic) GIDSignInButton *signInButton;

@property (assign, nonatomic) BOOL reorder;
@end
