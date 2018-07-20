//
//  LoginVC.m
//  CLOrder
//
//  Created by Vegunta's on 21/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "LoginVC.h"
#import "AppHeader.h"
#import "AccountUpdateVC.h"
#import "SignUpView.h"
#import "APIRequest.h"
#import "AllDayMenuVC.h"
#import "DeliveryVC.h"
#import "CartObj.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ForgotPassword.h"

//#import <GoogleSignIn/GoogleSignIn.h>
//#import <GoogleOpenSource/GoogleOpenSource.h>

#import "OrderHistoryVC.h"

@implementation LoginVC{
    int orderType;
    NSUserDefaults *appUser;
}

@synthesize reorder, signInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Customer Login";
    self.view.tintColor=[UIColor whiteColor];
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    appUser = [NSUserDefaults standardUserDefaults];
    orderType = [[appUser objectForKey:@"OrderType"] intValue];
    email.delegate = self;
    [email.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    email.leftViewMode= UITextFieldViewModeAlways;
    email.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email-palceholder"]];
    [self.view addSubview:email];

    password.delegate = self;
    password.leftViewMode= UITextFieldViewModeAlways;
    password.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    [password.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
     password.secureTextEntry = YES;
    
    
    NSMutableAttributedString *userbtntext = [[NSMutableAttributedString alloc] initWithString:
                                             [NSString stringWithFormat:@"New User / Register"]];
    [userbtntext addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,10)];
    [userbtntext addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(11, [userbtntext length]-11)];
    [newUserBtn setAttributedTitle:userbtntext forState:UIControlStateNormal];
    
    if ([FBSDKAccessToken currentAccessToken] ||[[GIDSignIn sharedInstance] hasAuthInKeychain]) {
    }
    loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2+40, SCREEN_WIDTH-100, 30)];
    [loginButton setHidden:YES];
    [loginButton setDelegate:self];
    loginButton.readPermissions =@[@"public_profile", @"email"];
    [self.view addSubview:loginButton];
    
    UIButton *facebookButton=[[UIButton alloc] initWithFrame:CGRectMake(70, SCREEN_HEIGHT/2+100, 50, 50)];
    [facebookButton setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(myButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookButton];
    
    
    UIButton *gmailButton=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+70
                                                                     
                                                                     , SCREEN_HEIGHT/2+100, 50, 50)];
    [gmailButton setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
    [gmailButton addTarget:self action:@selector(myGmailButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gmailButton];
    
    NSLayoutConstraint *facebookConstraint = [NSLayoutConstraint
                                              constraintWithItem:facebookButton
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                              multiplier:1.0f
                                              constant:30.0f];
    [self.view addConstraint:facebookConstraint];
    facebookConstraint = [NSLayoutConstraint
                          constraintWithItem:facebookButton
                          attribute:NSLayoutAttributeCenterX
                          relatedBy:NSLayoutRelationEqual
                          toItem:self.view
                          attribute:NSLayoutAttributeCenterX
                          multiplier:1.0f
                          constant:0.0f];
    [self.view addConstraint:facebookConstraint];
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    [signIn signOut];
    [signIn setScopes:[NSArray arrayWithObjects:@"https://www.googleapis.com/auth/plus.login",@"https://www.googleapis.com/auth/plus.me",@"https://www.googleapis.com/auth/userinfo.email",nil]];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    
    
    signInButton=[[GIDSignInButton alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2-40, SCREEN_WIDTH-100, 30)];
    [signInButton setHidden:YES];
    [self.view addSubview:signInButton];
    
    // Center the button vertically.
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:signInButton
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0f
                                      constant:-30.0f];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint
                  constraintWithItem:signInButton
                  attribute:NSLayoutAttributeCenterX
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeCenterX
                  multiplier:1.0f
                  constant:0.0f];
    [self.view addConstraint:constraint];
}
-(CALayer *)bottomborderAdding:(CGFloat)width height:(CGFloat)height{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [[UIColor grayColor] CGColor];
    border.frame = CGRectMake(0, height-1, width, 1);
    return border;
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        
    }else{
        [self googleClorderSignIn:user.profile.name :user.profile.email];
    }
}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
    }
}

-(void)myGmailButtonPressed
{
    [[GIDSignIn sharedInstance] signIn];
}
- (void)myButtonPressed {
    [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)loginButtonClicked{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (!error) {
                      NSLog(@"fetched user:%@", result);
                      NSLog(@"%@", [FBSDKProfile currentProfile].firstName);
                  }
              }];
         }
     }];
}


- (void) loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,birthday" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result valueForKey:@"id"]] forKey:@"profile"];
         [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"name"] forKey:@"userName"];
         [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"email"] forKey:@"emailId"];
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!error) {
                [self googleClorderSignIn: [result valueForKey:@"name"]:[result valueForKey:@"email"]];
             }
         });
     }];
    if ([FBSDKAccessToken currentAccessToken]) {

    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    [[FBSDKLoginManager new] logOut];
}

-(void)googleClorderSignIn:(NSString *)name :(NSString*)googleId{
    
    [APIRequest clorderGoogleSignup:[NSDictionary dictionaryWithObjectsAndKeys:name, @"FullName", googleId, @"Email", CLIENT_ID, @"clientid", nil] completion:^(NSMutableData *buffer){
        if (!buffer){
            NSLog(@"Unknown ERROR");
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if ([[resObj objectForKey:@"isSuccess"] boolValue] && [[resObj objectForKey:@"UserId"] intValue] > 0){
                if(![[appUser objectForKey:@"skipNow"] isEqualToString:@"skipNow"]){
                    [[CartObj instance].itemsForCart removeAllObjects];
                }
                [appUser removeObjectForKey:@"skipNow"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
                NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          [NSNumber numberWithInt:[[resObj objectForKey:@"UserId"] intValue]], @"UserId",
                                          [resObj objectForKey:@"Email"], @"Email",
                                          [resObj objectForKey:@"FullName"], @"FullName",
                                          [NSNumber numberWithBool:[[resObj objectForKey:@"isFirstTimeUser"] boolValue]], @"isFirstTimeUser",
                                          [NSNumber numberWithInt:[[resObj objectForKey:@"lastOrderDays"] intValue]], @"lastOrderDays",
                                          [[resObj objectForKey:@"FirstName"] isKindOfClass:[NSNull class]]? @"": [resObj objectForKey:@"FirstName"], @"FirstName",
                                          [[resObj objectForKey:@"LastName"] isKindOfClass:[NSNull class]]? @"": [resObj objectForKey:@"LastName"], @"LastName",
                                          [[resObj objectForKey:@"UserAddress"] isKindOfClass:[NSNull class]]?[self blankUserAddress]:[resObj objectForKey:@"UserAddress"], @"UserAddress",
                                          nil];
                [appUser setObject:userInfo forKey:@"userInfo"];
                
                
                if (![[resObj objectForKey:@"PaymentInformation"] isKindOfClass:[NSNull class]]) {
                    [appUser setObject:[resObj objectForKey:@"PaymentInformation"] forKey:@"PaymentInformation"];
                }
                [appUser setObject:[NSNumber numberWithInt:1] forKey:@"popIndex"];
                if (orderType == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                if (orderType == 3) {
                    OrderHistoryVC *nextView = [[OrderHistoryVC alloc] init];
                    [self.navigationController pushViewController:nextView animated: YES];
                }
                if (orderType == 2 || orderType == 1) {
                    DeliveryVC *nextView = [[DeliveryVC alloc] init];
                    [self.navigationController pushViewController:nextView animated: YES];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email and password" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
                [alert show];
            }
            
        }
    }];
}
-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction) signInAct: (id)sender{
    [email resignFirstResponder];
    [password resignFirstResponder];
    if ([self textValidation]) {
        [APIRequest loginUser:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", [NSString stringWithFormat:@"%@",email.text], @"Email",[NSString stringWithFormat:@"%@",password.text], @"Password", nil] completion:^(NSMutableData *buffer){
            if (!buffer){
                NSLog(@"Unknown ERROR");
            }else{
                
                NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
                // handle the response here
                NSError *error = nil;
                NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"Response :\n %@",resObj);
                if ([[resObj objectForKey:@"isSuccess"] boolValue] && [[resObj objectForKey:@"UserId"] intValue] > 0){
                    if(![[appUser objectForKey:@"skipNow"] isEqualToString:@"skipNow"]){
                        [[CartObj instance].itemsForCart removeAllObjects];
                    }
                    [appUser removeObjectForKey:@"skipNow"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
                    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [resObj objectForKey:@"UserId"], @"UserId",
                                              [resObj objectForKey:@"Email"], @"Email",
                                              [resObj objectForKey:@"FullName"], @"FullName",
                                              [resObj objectForKey:@"Password"], @"Password",
                                              [resObj objectForKey:@"isFirstTimeUser"], @"isFirstTimeUser",
                                              [resObj objectForKey:@"lastOrderDays"], @"lastOrderDays",
                                              [resObj objectForKey:@"FirstName"], @"FirstName",
                                              [resObj objectForKey:@"LastName"], @"LastName",
                                              [[resObj objectForKey:@"UserAddress"] isKindOfClass:[NSNull class]]?[self blankUserAddress]:[resObj objectForKey:@"UserAddress"], @"UserAddress",
                                              nil];
                    [appUser setObject:userInfo forKey:@"userInfo"];
                    if (![[resObj objectForKey:@"PaymentInformation"] isKindOfClass:[NSNull class]]) {
                        [appUser setObject:[resObj objectForKey:@"PaymentInformation"] forKey:@"PaymentInformation"];
                    }
                    [appUser setObject:[NSNumber numberWithInt:1] forKey:@"popIndex"];
                    if (orderType == 0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    if (orderType == 3) {
                        OrderHistoryVC *nextView = [[OrderHistoryVC alloc] init];
                        [self.navigationController pushViewController:nextView animated: YES];
                    }
                    if (orderType == 2 || orderType == 1) {
                        DeliveryVC *nextView = [[DeliveryVC alloc] init];
                        [self.navigationController pushViewController:nextView animated: YES];
                    }
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid login credentials !" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
                    [alert show];
                }
                
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email and password" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
        [alert setTag:100];
        [alert show];
    }
}
-(NSDictionary *)blankUserAddress{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"", @"Address1",
                         @"", @"Address2",
                         @"", @"City",
                         @"", @"PhoneNumber",
                         @"", @"ZipPostalCode" ,
                         nil];
    
    return dic;
}

-(bool)textValidation{
    
    if ((email.text.length > 0) && (password.text.length > 0) && [self validateEmailWithString:email.text]) {
        return YES;
    }else
        return NO;
    
}

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction) newUserAct: (id)sender{
    if(![[appUser objectForKey:@"skipNow"] isEqualToString:@"skipNow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cartPrice"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PaymentInformation"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CouponDetails"];
        
        [[CartObj instance].itemsForCart removeAllObjects];
        [CartObj clearInstance];
    }
    
    SignUpView *signUpV = [[SignUpView alloc] init];
    signUpV.emailId = email.text;
    signUpV.password = password.text;
    [self.navigationController pushViewController:signUpV animated:YES];
}
-(IBAction) guestUserAct: (id)sender{
    if(![[appUser objectForKey:@"skipNow"] isEqualToString:@"skipNow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cartPrice"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PaymentInformation"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CouponDetails"];
        
        [[CartObj instance].itemsForCart removeAllObjects];
        [CartObj clearInstance];
    }
    if (orderType == 2 || orderType == 0 || orderType == 1) {
        DeliveryVC *nextView = [[DeliveryVC alloc] init];
        nextView.isGuest = YES;
        [self.navigationController pushViewController:nextView animated: YES];
    }
    if (orderType == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No order history available for guest users" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert setTag:200];
        [alert show];
    }
    //    AccountUpdateVC *accountUpdateVC = [[AccountUpdateVC alloc] init];
    //    [self.navigationController pushViewController:accountUpdateVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)skipNowAction:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@"skipNow" forKey:@"skipNow"];
    AllDayMenuVC *nextView = [[AllDayMenuVC alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
}
-(IBAction) facebookAct: (id)sender{
    SignUpView *signUpV = [[SignUpView alloc] init];
    [self presentViewController:signUpV animated:YES completion:nil];
}
-(IBAction) forgotPasswordAct: (id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *nextView = [storyboard instantiateViewControllerWithIdentifier:@"ForgotPassword"];
    [self.navigationController pushViewController:nextView animated:YES];
}
-(IBAction) googleAct: (id)sender{
    //    ModifierVC *modiV = [[ModifierVC alloc] init];
    //    [self presentViewController:modiV animated:YES completion:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardWasShown:(NSNotification *)notification{
    CGRect frm = self.view.frame;
    frm.origin.y = (frm.origin.y<0)?frm.origin.y:-150;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = frm;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    CGRect frm = self.view.frame;
    frm.origin.y = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = frm;
    }];
}


@end
