//
//  DeliveryVC.m
//  CLOrder
//
//  Created by Vegunta's on 27/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "DeliveryVC.h"
#import "AppHeader.h"
#import "AccountUpdateVC.h"
#import "AllDayMenuVC.h"
#import "APIRequest.h"
#import "CartObj.h"
#import "CheckOut.h"
#import "GoogleSearchView.h"
@implementation DeliveryVC{
    UITextField *nameText;
    UITextField *addressText;
    UITextField *buildingText;
    UITextField *cityText;
    UITextField *zipText;
    UITextField *phoneText;
    UITextField *emailText;
    NSUserDefaults *user;
    NSString *errorMsg;
    UIScrollView *mainScroll;
    UIPickerView *adresspicker;
    bool googleSearch;
}

@synthesize isGuest, isNewUser, toCart;

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [NSUserDefaults standardUserDefaults];

    self.title = @"Address";
    
    if([[user objectForKey:@"OrderType"] intValue] == 1 ){
        self.title = @"Customer Address";

    }else if ([[user objectForKey:@"OrderType"] intValue] == 2 ){
        self.title = @"Deliver Address";
    }
    [self setUIForView];
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = APP_COLOR;
    [bottomView setUserInteractionEnabled:YES];
    
    UIButton *addOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    addOrder.frame = CGRectMake(10, 5, SCREEN_WIDTH-150, 40);
    [addOrder.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [addOrder setTitle:@"NEXT-STEP" forState:UIControlStateNormal];
    [addOrder addTarget:self action:@selector(nextAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addOrder];
    addOrder.titleLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16];
    
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-145, 15, 20, 20)];
    [image setImage:[UIImage imageNamed:@"right_arrow_border"]];
    [bottomView addSubview:image];
    
    UIButton *checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkOutBtn.titleLabel.font = [UIFont fontWithName:@"Lora-Regular" size:16];
    checkOutBtn.frame = CGRectMake(SCREEN_WIDTH-100, 5, 100, 40);
    [checkOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkOutBtn addTarget:self action:@selector(nextAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:checkOutBtn];
    if (isNewUser) {
        [checkOutBtn setTitle:@"ADD CARD" forState:UIControlStateNormal];
    } else if (toCart) {
        [checkOutBtn setTitle:@"CART" forState:UIControlStateNormal];
    }
    else{
        [checkOutBtn setTitle:@"MENU" forState:UIControlStateNormal];
    }
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

-(bool)validatingFields{
    errorMsg = @"";
    if (![nameText.text length]) {
        errorMsg = @"Please enter valid Name";
        [nameText becomeFirstResponder];
    }else if ([phoneText.text length] != 10 ) {
        errorMsg = @"Please enter valid Phone Number";
        [phoneText becomeFirstResponder];
    }else if (![self validateEmailDomain] || ![self validateEmailWithString:emailText.text]) {
        errorMsg = @"Please enter valid EmailId";
        [emailText becomeFirstResponder];
    }else if (![addressText.text length]) {
        errorMsg = @"Please enter valid address";
        [addressText becomeFirstResponder];
    }else if (![cityText.text length]) {
        errorMsg = @"Please enter valid City Name";
        [cityText becomeFirstResponder];
    }else if ([zipText.text length] != 5) {
        errorMsg = @"Please enter valid Zip Code";
        [zipText becomeFirstResponder];
    }
    
    if (errorMsg.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
    
}
-(BOOL)validateEmailDomain{
    NSArray *domainList = [[NSArray alloc] initWithObjects:@"com", @"net", @"org", @"edu", @"co", nil];
    BOOL validMail = NO;

    NSArray *domain = [emailText.text componentsSeparatedByString:@"@"];
    if (domain.count>1) {
        domain = [[NSArray alloc] initWithArray:[[domain objectAtIndex:1] componentsSeparatedByString:@"."]];
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
    }
    
    return validMail;
}

-(void) nextAct {
    if ([self validatingFields]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             addressText.text, @"Address1",
                             buildingText.text, @"Address2",
                             cityText.text, @"City",
                             phoneText.text, @"PhoneNumber",
                             zipText.text, @"ZipPostalCode" ,
                             nil];
        [[CartObj instance].userInfo setObject:dic forKey:@"UserAddress"];
        [[CartObj instance].userInfo setObject:nameText.text forKey:@"FullName"];
        [[CartObj instance].userInfo setObject:nameText.text forKey:@"LastName"];
        [[CartObj instance].userInfo setObject:nameText.text forKey:@"FirstName"];
        [[CartObj instance].userInfo setObject:emailText.text forKey:@"Email"];
        [[CartObj instance].userInfo setObject:[[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue]? [[user objectForKey:@"userInfo"] objectForKey:@"UserId"]: [NSNumber numberWithInt:0] forKey:@"UserId"];
        [[CartObj instance].userInfo setObject:[[user objectForKey:@"userInfo"] objectForKey:@"Password"]? [[user objectForKey:@"userInfo"] objectForKey:@"Password"]: @"" forKey:@"Password"];
        
        NSLog(@"%@", [CartObj instance].userInfo);
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] initWithDictionary:[user objectForKey:@"userInfo"]];
        [userInfoDic setObject:dic forKey:@"UserAddress"];
        
        if (isGuest) {
            [userInfoDic setObject:nameText.text forKey:@"FullName"];
            [userInfoDic setObject:nameText.text forKey:@"LastName"];
            [userInfoDic setObject:nameText.text forKey:@"FirstName"];
            [userInfoDic setObject:emailText.text forKey:@"Email"];
        }
        [user  setObject:userInfoDic forKey:@"userInfo"];
        if (isNewUser) {
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                   CLIENT_ID, @"clientId",
                   @"", @"PaymentInformation",
                   [[user objectForKey:@"userInfo"] objectForKey:@"UserId"], @"UserId",
                   [[user objectForKey:@"userInfo"] objectForKey:@"Email"], @"Email",
                   [[user objectForKey:@"userInfo"] objectForKey:@"FullName"], @"FullName",
                   [[user objectForKey:@"userInfo"] objectForKey:@"Password"], @"Password",
                   [[user objectForKey:@"userInfo"] objectForKey:@"isFirstTimeUser"], @"isFirstTimeUser",
                   [[user objectForKey:@"userInfo"] objectForKey:@"lastOrderDays"], @"lastOrderDays",
                   [[user objectForKey:@"userInfo"] objectForKey:@"FirstName"], @"FirstName",
                   [[user objectForKey:@"userInfo"] objectForKey:@"LastName"], @"LastName",
                   [[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"], @"UserAddress",
                   nil];
            [APIRequest updateClorderUser:dic completion:^(NSMutableData *buffer) {
                if (!buffer){
                    NSLog(@"Unknown ERROR");
                    //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
                }else{
                    
                    NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
                    // handle the response here
                    NSError *error = nil;
                    NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
                    NSLog(@"Response :\n %@",resObj);
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"skipNow"];
                }
            }];
        }
        
        if (isGuest || ([[user objectForKey:@"OrderType"] intValue] == 2 && [[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue]) ||
            ([[user objectForKey:@"OrderType"] intValue] == 1 && [[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue])) {
            
            if ([[user objectForKey:@"OrderType"] intValue] == 2) {
                [self isDistanceInRange];
            }else{
                if (toCart) {
                    CheckOut *checkOutV = [[CheckOut alloc] init];
//                    checkOutV.orderId = orderId;
                    [self.navigationController pushViewController:checkOutV animated:YES];
                }else {
                    
                    AllDayMenuVC *nextView = [[AllDayMenuVC alloc] init];
                    [self.navigationController pushViewController:nextView animated:YES];
                }
            }
        }else{
            AccountUpdateVC *nextView = [[AccountUpdateVC alloc] init];
            [self.navigationController pushViewController:nextView animated:YES];
        }
    }
    
}

-(BOOL)isDistanceInRange{
    
    NSDictionary *reqDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                            CLIENT_ID, @"Clientid",
                            cityText.text, @"cityname",
//                            phoneText.text, @"PhoneNumber",
                            zipText.text, @"zipcode" ,
                            addressText.text, @"Address1",
                            buildingText.text, @"Address2",
                            @"0.0", @"SubTotal",
                            nil];
    
    [APIRequest fetchDeliveryFees:reqDic completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if ([[resObj objectForKey:@"isSuccess"] boolValue]) {
                [user setObject:[resObj objectForKey:@"DeliverCharge"] forKey:@"DeliverCharge"];
                AllDayMenuVC *nextView = [[AllDayMenuVC alloc] init];
                [self.navigationController pushViewController:nextView animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [resObj objectForKey:@"status"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            
        }
    }];
    
    return YES;
}

-(void)setUIForView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainScroll.scrollEnabled = YES;
    [self.view addSubview:mainScroll];
    mainScroll.userInteractionEnabled = YES;
    mainScroll.showsVerticalScrollIndicator = YES;
    
    mainScroll.backgroundColor = [UIColor whiteColor];
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-100);
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
   // [mainScroll addSubview:headerImg];
    headerImg.backgroundColor = APP_COLOR;
    
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
    [headerImg addSubview:headerLbl];
    headerLbl.textColor = [UIColor whiteColor];
    headerLbl.backgroundColor = [UIColor clearColor];
    headerLbl.font = [UIFont boldSystemFontOfSize:18.0];
    headerLbl.text = @"ADDRESS";
    if([[user objectForKey:@"OrderType"] intValue] == 1 ){
        headerLbl.text = @"CUSTOMER ADDRESS";
        
    }else if ([[user objectForKey:@"OrderType"] intValue] == 2 ){
        headerLbl.text = @"DELIVERY ADDRESS";
    }
    
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 40)];
    [mainScroll addSubview:nameText];
    [nameText setPlaceholder:@"Name"];
    nameText.delegate = self;
    [nameText.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    
    
    phoneText = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, SCREEN_WIDTH-40, 40)];
    [mainScroll addSubview:phoneText];
    [phoneText setPlaceholder:@"Phone number*"];
    phoneText.delegate = self;
    [phoneText.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    
    
    emailText = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, SCREEN_WIDTH-40, 40)];
    [mainScroll addSubview:emailText];
    emailText.delegate = self;
    [emailText setPlaceholder:@"Email Id"];
    [emailText.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    
    
    addressText = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH-40, 40)];
    [mainScroll addSubview:addressText];
    [addressText setPlaceholder:@"Address"];
     addressText.delegate = self;
    [addressText.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];

    
    buildingText = [[UITextField alloc] initWithFrame:CGRectMake(20, 260, SCREEN_WIDTH-40, 40)];
    [mainScroll addSubview:buildingText];
    [buildingText setPlaceholder:@"Apt/Suit/Building"];
    buildingText.delegate = self;
    [buildingText.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    
    
    cityText = [[UITextField alloc] initWithFrame:CGRectMake(20, 320, SCREEN_WIDTH-40, 40)];
    [mainScroll addSubview:cityText];
    [cityText setPlaceholder:@"City"];
    cityText.delegate = self;
    [cityText.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    
    zipText = [[UITextField alloc] initWithFrame:CGRectMake(20, 380, SCREEN_WIDTH-40, 40)];
    [mainScroll addSubview:zipText];
    zipText.placeholder = @"Zip code*";
    zipText.delegate = self;
    [zipText.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    
    if (isNewUser) {
        nameText.userInteractionEnabled = NO;
        nameText.textColor = [UIColor grayColor];
        emailText.userInteractionEnabled = NO;
        emailText.textColor = [UIColor grayColor];
    }else{
        nameText.userInteractionEnabled = YES;
        nameText.textColor = [UIColor blackColor];
        emailText.userInteractionEnabled = YES;
        emailText.textColor = [UIColor blackColor];
    }
    
    if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
        if ([[user objectForKey:@"userInfo"] objectForKey:@"FullName"]) {
            nameText.text = [NSString stringWithFormat:@"%@", [[user objectForKey:@"userInfo"] objectForKey:@"FullName"]];
        }
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"Address1"]) {
            addressText.text = [NSString stringWithFormat:@"%@", [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"Address1"]];
        }
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"Address2"]) {
            buildingText.text = [NSString stringWithFormat:@"%@", [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"Address2"]];
        }
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"City"]) {
            cityText.text = [NSString stringWithFormat:@"%@", [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"City"]];
        }
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"ZipPostalCode"]) {
            zipText.text = [NSString stringWithFormat:@"%@", [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"ZipPostalCode"]];
        }
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"PhoneNumber"]) {
            phoneText.text = [NSString stringWithFormat:@"%@", [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"PhoneNumber"]];
        }
        if ([[user objectForKey:@"userInfo"] objectForKey:@"Email"]) {
            emailText.text = [NSString stringWithFormat:@"%@", [[user objectForKey:@"userInfo"] objectForKey:@"Email"]];
        }
    }
   
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [numberToolbar sizeToFit];
    
    zipText.inputAccessoryView = numberToolbar;
    phoneText.inputAccessoryView = numberToolbar;
    
    if([[user objectForKey:@"ShippingOptionId"] integerValue] == 2){
        [self addingPickerView];
        googleSearch=false;
    }else{
        googleSearch=true;
    }
}
-(void)addingPickerView{
    [zipText setHidden:YES];
    [cityText setHidden:YES];
    [buildingText setHidden:YES];
    UIToolbar *optionPickerTool=[[UIToolbar alloc]init];
    optionPickerTool.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(addressFieldDoneAction)];
    [optionPickerTool setItems:[[NSArray alloc] initWithObjects:button1, nil]];
    addressText.inputAccessoryView=optionPickerTool;
    
    adresspicker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-220, self.view.frame.size.width-40, 220)];
    addressText.inputView = adresspicker;
    
    adresspicker.delegate = self;
    adresspicker.dataSource = self;
    NSLog(@"address %@ nvmdkfvdfv   %@",[user objectForKey:@"DeliveryAddresses"],[[user objectForKey:@"DeliveryAddresses"] objectAtIndex:0]);
    
}
-(void)addressFieldDoneAction{
    [addressText resignFirstResponder];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return ((NSArray *)[user objectForKey:@"DeliveryAddresses"]).count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[[user objectForKey:@"DeliveryAddresses"] objectAtIndex:row] objectForKey:@"Address1"];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    addressText.text=[[[user objectForKey:@"DeliveryAddresses"] objectAtIndex:row] objectForKey:@"Address1"];
    cityText.text=[[[user objectForKey:@"DeliveryAddresses"] objectAtIndex:row] objectForKey:@"City"];
    zipText.text=[[[user objectForKey:@"DeliveryAddresses"] objectAtIndex:row] objectForKey:@"ZipPostalCode"];
}
-(CALayer *)bottomborderAdding:(CGFloat)width height:(CGFloat)height{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [[UIColor grayColor] CGColor];
    border.frame = CGRectMake(0, height-1, width, 1);
    return border;
}
-(void)cancelNumberPad{
    [phoneText resignFirstResponder];
    [zipText resignFirstResponder];
}

-(void) leftBarAct{
    
    NSMutableArray *locationsary=[NSMutableArray arrayWithCapacity:0];
    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:@"Locations"]) {
        NSDictionary *dic=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [locationsary addObject:dic];
    }
    if([locationsary count] > 1){
        NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController:[vcArr objectAtIndex:1]  animated:YES];
    }else{
        NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController:[vcArr objectAtIndex:0]  animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == addressText && [[user objectForKey:@"ShippingOptionId"] integerValue] != 2){
        [textField resignFirstResponder];
        GoogleSearchView *search = [[GoogleSearchView alloc] init];
        search.object=self;
        [self.navigationController pushViewController:search animated:YES];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    return YES;
}

-(void)keyboardWasShown:(NSNotification *)notification{
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+210);
    CGRect frm = self.view.frame;
    frm.origin.y = (frm.origin.y<0)?frm.origin.y:-0;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = frm;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-100);
    CGRect frm = self.view.frame;
    frm.origin.y = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = frm;
    }];
}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField{
    
    if (textField == phoneText || textField == zipText) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == phoneText){
        if (textField.text.length >= 10 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
    }
    if (textField == nameText) {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.- "];
        
        NSString *output = [string stringByTrimmingCharactersInSet:[myCharSet invertedSet]];
        
        return [string isEqualToString:output];
    }
    return YES;
}
-(void)addressSelection:(NSString *)address locationDetails:(CLLocationCoordinate2D )location{
    NSArray *adrresArray =[address componentsSeparatedByString:@","];
    addressText.text= [adrresArray objectAtIndex:0];
    if(adrresArray.count > 1){
        cityText.text = [adrresArray objectAtIndex:1];
    }
    if (adrresArray.count > 2){
        NSString *string = [[adrresArray objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([string rangeOfString:@" "].location == NSNotFound){
            zipText.text = @"";
        }else{
            zipText.text = ((NSArray*)[string componentsSeparatedByString:@" "]).count > 1?[[string componentsSeparatedByString:@" "] objectAtIndex:1]: @"";
        }
        
    }
}

@end
