//
//  SignUpView.m
//  CLOrder
//
//  Created by Vegunta's on 14/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "SignUpView.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "Loader.h"
#import "DeliveryVC.h"
#import "CartObj.h"
#import "TextFieldEdit.h"

@implementation SignUpView{
    UITextField *nameTxt;
    UITextField *emailTxt;
    UITextField *passwordTxt;
    NSString *termsurl;
    NSString *privacyurl;
}

@synthesize  emailId, password;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Registration";
    self.view.backgroundColor=[UIColor whiteColor];
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"skipNow"] isEqualToString:@"skipNow"]){
        [[CartObj instance].itemsForCart removeAllObjects];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"subTotalPrice"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart"];
    }
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    termsurl=@"http://www.clorder.com/terms-conditions.html";
    privacyurl=@"http://www.clorder.com/privacy-policy.html";
    
//    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgImg.image = [UIImage imageNamed:APP_BG_IMG];
//    [self.view addSubview:bgImg];
//    [bgImg setUserInteractionEnabled:YES];
    
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
//    [bgImg addSubview:titleLbl];
//    titleLbl.text = ;
//    titleLbl.textColor = [UIColor  whiteColor];
//    titleLbl.font = [UIFont boldSystemFontOfSize:20];
//    titleLbl.textAlignment = NSTextAlignmentCenter;
//    titleLbl.backgroundColor = APP_COLOR;
    
//    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 30)];
//    [self.view addSubview:nameLbl];
//    nameLbl.text = @"Name*";
//    nameLbl.textColor = [UIColor  whiteColor];
//    nameLbl.font = [UIFont boldSystemFontOfSize:18];
//    nameLbl.textAlignment = NSTextAlignmentLeft;
//    nameLbl.backgroundColor = [UIColor clearColor];
    
    nameTxt = [[TextFieldEdit alloc] initWithFrame:CGRectMake(20, 105, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:nameTxt];
    nameTxt.textColor = [UIColor  blackColor];
    nameTxt.textAlignment = NSTextAlignmentLeft;
    nameTxt.delegate = self;
    nameTxt.placeholder = @"Name";
    [nameTxt setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    [nameTxt.layer addSublayer:[self bottomborderAdding:SCREEN_WIDTH-40 height:40]];
    nameTxt.leftViewMode= UITextFieldViewModeAlways;
    nameTxt.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name-palceholder"]];

//    UILabel *emailLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, SCREEN_WIDTH-40, 30)];
//    [bgImg addSubview:emailLbl];
//    emailLbl.text = @"Email*";
//    emailLbl.textColor = [UIColor  whiteColor];
//    emailLbl.font = [UIFont boldSystemFontOfSize:18];
//    emailLbl.textAlignment = NSTextAlignmentLeft;
//    emailLbl.backgroundColor = [UIColor clearColor];
    
    emailTxt = [[TextFieldEdit alloc] initWithFrame:CGRectMake(20, 190, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:emailTxt];
    emailTxt.textColor = [UIColor  blackColor];
    emailTxt.textAlignment = NSTextAlignmentLeft;
    emailTxt.delegate = self;
    emailTxt.placeholder = @"Email Id";
    emailTxt.leftViewMode= UITextFieldViewModeAlways;
    [emailTxt setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    [emailTxt.layer addSublayer:[self bottomborderAdding:SCREEN_WIDTH-40 height:40]];
    emailTxt.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email-palceholder"]];
    emailTxt.text = emailId;



//    UILabel *passwordLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, SCREEN_WIDTH-40, 30)];
//    [bgImg addSubview:passwordLbl];
//    passwordLbl.text = @"Password*";
//    passwordLbl.textColor = [UIColor  whiteColor];
//    passwordLbl.font = [UIFont boldSystemFontOfSize:18];
//    passwordLbl.textAlignment = NSTextAlignmentLeft;
//    passwordLbl.backgroundColor = [UIColor clearColor];
    
    passwordTxt = [[TextFieldEdit alloc] initWithFrame:CGRectMake(20, 265, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:passwordTxt];
    passwordTxt.textColor = [UIColor  blackColor];
    passwordTxt.textAlignment = NSTextAlignmentLeft;
    passwordTxt.delegate = self;
    passwordTxt.placeholder = @"Password";
    passwordTxt.secureTextEntry = YES;
    passwordTxt.leftViewMode= UITextFieldViewModeAlways;
    [passwordTxt setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    [passwordTxt.layer addSublayer:[self bottomborderAdding:SCREEN_WIDTH-40 height:40]];
    passwordTxt.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    passwordTxt.text = password;
    
    
    UITextView * links=[[UITextView alloc] initWithFrame:CGRectMake(20, 330, SCREEN_WIDTH-40, 60)];
    [links setTextAlignment:NSTextAlignmentCenter];
    [links setDelegate:self];
    [links setEditable:NO];
    [links setUserInteractionEnabled:YES];
    links.delaysContentTouches = NO;
    [links setSelectable:YES];
    [links setDataDetectorTypes:UIDataDetectorTypeLink];
    NSString *string=@"By creating an account you agree to our Terms of Use and Privacy Policy.";
    NSMutableAttributedString *terms=[[NSMutableAttributedString alloc] initWithString:string];
    NSRange trmrange=[string rangeOfString:@"Terms of Use"];
    NSRange policyrange=[string rangeOfString:@"Privacy Policy"];
    [terms addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:trmrange];
    [terms addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:policyrange];
    [terms addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:trmrange];
    [terms addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:policyrange];
    [terms addAttribute:NSLinkAttributeName value:termsurl range:trmrange];
    [terms addAttribute:NSLinkAttributeName value:privacyurl range:policyrange];
    [terms addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Lora-Regular" size:14] range:NSMakeRange(0, terms.length)];
    [links setAttributedText:terms];
    [self.view addSubview:links];
    
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame = CGRectMake(20, 410, 3*SCREEN_WIDTH/4-50, 40);
    createBtn.layer.cornerRadius = 5.0;
    [createBtn setBackgroundColor:APP_COLOR];
    [createBtn setTitle:@"CREATE ACCOUNT" forState:UIControlStateNormal];
    createBtn.titleLabel.textColor = [UIColor whiteColor];
    createBtn.titleLabel.font = [UIFont fontWithName:@"Lora-regular" size:16];
    [createBtn addTarget:self action:@selector(createBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(3*SCREEN_WIDTH/4-20, 410, SCREEN_WIDTH/4, 40);
    cancelBtn.layer.cornerRadius = 5.0;
    [cancelBtn setBackgroundColor:APP_COLOR];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"Lora-regular" size:16];
    [cancelBtn addTarget:self action:@selector(cancleBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signInBtn.frame = CGRectMake(0,self.view.frame.size.height-100, SCREEN_WIDTH, 40);
    [signInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSMutableAttributedString *signuptext = [[NSMutableAttributedString alloc] initWithString:
                                            [NSString stringWithFormat:@"Existing Customer / Login Here"]];
    [signuptext addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Lora-Regular" size:16] range:NSMakeRange(0, signuptext.length)];
    [signuptext addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,18)];
    [signuptext addAttribute:NSForegroundColorAttributeName value:APP_COLOR range:NSMakeRange(20, [signuptext length]-20)];
    [signInBtn setAttributedTitle:signuptext forState:UIControlStateNormal];
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [signInBtn addTarget:self action:@selector(signInBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    UIApplication *application = [UIApplication sharedApplication];
    if ([URL.absoluteString isEqualToString:termsurl]) {
        // Do whatever you want here as the action to the user pressing your 'actionString'
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSURL *URL = [NSURL URLWithString:termsurl];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        });
    }else if([URL.absoluteString isEqualToString:privacyurl]){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NSURL *URL = [NSURL URLWithString:privacyurl];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        });
    }
    return NO;
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
-(BOOL)validateEmailDomain{
    NSArray *domainList = [[NSArray alloc] initWithObjects:@"com", @"net", @"org", @"edu", @"co", nil];
    NSArray *domain = [emailTxt.text componentsSeparatedByString:@"@"];
    domain = [[NSArray alloc] initWithArray:[[domain objectAtIndex:1] componentsSeparatedByString:@"."]];
    BOOL validMail = NO;
    if (domain.count > 1 && domain.count <= 3) {
        for (int i = 0; i < domainList.count; i++) {
            if ([[domain objectAtIndex:1] isEqualToString:[domainList objectAtIndex:i]]) {
                if ([[domainList objectAtIndex:i] isEqualToString:@"co"]) {
                    if (domain.count==3) {
                        if (([[domain objectAtIndex:2] isEqualToString:@"in"] || [[domain objectAtIndex:2] isEqualToString:@"nz"])) {
                            
                            validMail = YES;
                            break;
                        }else{
                            validMail = NO;
                            break;
                        }
                    }else{
                        validMail = NO;
                        break;
                    }
                }
                validMail = YES;
                break;
            }
        }
    }
    return validMail;
}

-(void)createBtnAct {
    if (!nameTxt.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill mandatory fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];//Please enter Name
        [alert show];
        [nameTxt becomeFirstResponder];
    }else if(!emailTxt.text.length){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill mandatory fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];//Please enter valid Email Id
        [emailTxt becomeFirstResponder];
    }else if(![self validateEmailDomain] || ![self validateEmailWithString:emailTxt.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email Id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];//Please enter valid Email Id
        [emailTxt becomeFirstResponder];
    }else if(!passwordTxt.text.length){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill mandatory fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];//Please Enter Password
        [passwordTxt becomeFirstResponder];
    }else if (![self validatePassword]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password must be at least 8 characters, no more than 15 characters, and must include at least one upper case letter, one lower case letter, and one numeric digit"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        [APIRequest registerClorderUser:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", emailTxt.text, @"Email", passwordTxt.text, @"Password", nameTxt.text, @"FullName", nil] completion:^(NSMutableData *buffer){
            if (!buffer){
                NSLog(@"Unknown ERROR");
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                [alert show];
                //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
            }else{
                
                NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
                // handle the response here
                NSError *error = nil;
                NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"Response :\n %@",resObj);
                if ([[resObj objectForKey:@"UserId"] intValue] > 0) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    
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
                    [user setObject:userInfo forKey:@"userInfo"];
                    
                    user = [NSUserDefaults standardUserDefaults];
                    [user setObject:[NSNumber numberWithInt:0] forKey:@"OrderType"];
                    DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
                    deliveryV.isNewUser = YES;
                    [self.navigationController pushViewController:deliveryV animated:YES];
                    
                    //                [user setObject:[resObj objectForKey:@"UserId"] forKey:@"UserId"];
                    //                [user setObject:[resObj objectForKey:@"Email"] forKey:@"Email"];
                    //                [user setObject:[resObj objectForKey:@"Password"] forKey:@"Password"];
                    //                [user setObject:[resObj objectForKey:@"FullName"] forKey:@"FullName"];
                    //                [user setObject:[NSNumber numberWithInteger:1] forKey:@"FirstTimeUser"];
                    
                    //                UIAlertView *alert = [[UIAlertView  alloc]initWithTitle:nil message:[NSString stringWithFormat: @"User registration successfull with email id: %@", emailTxt.text] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    //                [alert setTag:100];
                    //                [alert show];
                    
                }else{
                    UIAlertView *alert = [[UIAlertView  alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [resObj objectForKey:@"status"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert setTag:200];
                    [alert show];
                }
            }
        }];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSNumber numberWithInt:0] forKey:@"OrderType"];
        DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
        deliveryV.isNewUser = YES;
        [self.navigationController pushViewController:deliveryV animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        nameTxt.text = @"";
//        emailTxt.text = @"";
//        passwordTxt.text = @"";
    }
}

-(void)cancleBtnAct {
//    DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
//    deliveryV.isNewUser = YES;
//    [self.navigationController pushViewController:deliveryV animated:YES];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)signInBtnAct {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if ((textField == emailTxt) && ![self validateEmailWithString:emailTxt.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email Id" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
////        [alert show];
//        return NO;
//    }else{
        [textField resignFirstResponder];
        return YES;
//    }
}

-(void)keyboardWasShown:(NSNotification *)notification{
    CGRect frm = self.view.frame;
    frm.origin.y = (frm.origin.y<0)?frm.origin.y:-40;
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

- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == nameTxt) {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.- "];
        
        NSString *output = [string stringByTrimmingCharactersInSet:[myCharSet invertedSet]];
        
        return [string isEqualToString:output];
    }
    return YES;
}

-(BOOL)validatePassword{
    BOOL lowerCaseLetter=NO,upperCaseLetter=NO,digit=NO,specialCharacter = 0;
    if([passwordTxt.text length] >= 8 && [passwordTxt.text length]<=15)
    {
        for (int i = 0; i < [passwordTxt.text length]; i++)
        {
            unichar c = [passwordTxt.text characterAtIndex:i];
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

@end
