//
//  ChangePassword.m
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "ChangePassword.h"
#import "APIRequest.h"
#import "APIRequester.h"
#import "AppHeader.h"
#import "CartObj.h"
#import "CardIO.h"

@interface ChangePassword ()

@end

@implementation ChangePassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    oldPasswordtext.delegate = self;
    oldPasswordtext.leftViewMode= UITextFieldViewModeAlways;
    oldPasswordtext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    [oldPasswordtext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    oldPasswordtext.secureTextEntry = YES;

    newPasswordtext.delegate = self;
    newPasswordtext.leftViewMode= UITextFieldViewModeAlways;
    newPasswordtext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    [newPasswordtext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    newPasswordtext.secureTextEntry = YES;

    confirmPasswordtext.delegate = self;
    confirmPasswordtext.leftViewMode= UITextFieldViewModeAlways;
    confirmPasswordtext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    [confirmPasswordtext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    confirmPasswordtext.secureTextEntry = YES;

}
-(CALayer *)bottomborderAdding:(CGFloat)width height:(CGFloat)height{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [[UIColor grayColor] CGColor];
    border.frame = CGRectMake(0, height-1, width, 1);
    return border;
}
-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)saveAction: (id)sender{
    if(!oldPasswordtext.text.length || !newPasswordtext.text.length || !confirmPasswordtext.text.length){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill mandatory fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        if(!oldPasswordtext.text.length)
            [oldPasswordtext becomeFirstResponder];
        else if (!newPasswordtext.text.length)
            [newPasswordtext becomeFirstResponder];
        else if(!confirmPasswordtext.text.length)
            [confirmPasswordtext becomeFirstResponder];
    }else if (![self validatePassword:oldPasswordtext.text] || ![self validatePassword:oldPasswordtext.text] || ![self validatePassword:oldPasswordtext.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password must be at least 8 characters, no more than 15 characters, and must include at least one upper case letter, one lower case letter, and one numeric digit"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else if(![newPasswordtext.text isEqualToString:confirmPasswordtext.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Newpassword and confirm password should be same"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        [self changePasswordAPIRequest];
    }
}
-(void)changePasswordAPIRequest{
    NSDictionary * dic=[NSDictionary dictionaryWithObjectsAndKeys:oldPasswordtext.text,@"OldPassword",newPasswordtext.text,@"NewPassword",CLIENT_ID,@"ClientId",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"Email"],@"UserEmailId",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"UserId"],@"UserId",nil];
    [APIRequest changePasswordApi:dic completion:^(NSMutableData *buffer) {
        if(!buffer){
            
        }else{
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if ([[resObj objectForKey:@"isSuccess"] boolValue]){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cartPrice"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PaymentInformation"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CouponDetails"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TipIndex"];
                [[CartObj instance].itemsForCart removeAllObjects];
                [CartObj clearInstance];
                
                [[GIDSignIn sharedInstance] signOut];
                [[FBSDKLoginManager new] logOut];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [resObj objectForKey:@"status"]] delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)validatePassword:(NSString *) password{
    BOOL lowerCaseLetter=NO,upperCaseLetter=NO,digit=NO,specialCharacter = 0;
    if([password length] >= 8 && [password length]<=15)
    {
        for (int i = 0; i < [password length]; i++)
        {
            unichar c = [password characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            if(!specialCharacter)
            {
                specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            }
        }
        
        return (/*specialCharacter && */digit && lowerCaseLetter && upperCaseLetter);
    }
    else
    {
        return NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
