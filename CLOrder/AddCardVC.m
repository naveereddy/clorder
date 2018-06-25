//
//  AddCardVC.m
//  CLOrder
//
//  Created by Vegunta's on 21/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "AddCardVC.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "Luhn.h"

@implementation AddCardVC{
    UITextField *cvvTxt;
    UITextField *zipTxt;
    UITextField *expYearTxt;
    NSString *expiry;
    NSUserDefaults *user;
    int cardType;
}

@synthesize cardDic, newCard;

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"ACCOUNT UPDATE";
    self.view.backgroundColor = [UIColor whiteColor];
    
    user = [NSUserDefaults standardUserDefaults];
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    
    monthsArr = [[NSArray alloc] initWithObjects:@"01-January", @"02-February", @"03-March", @"04-April", @"05-May", @"06-June", @"07-July", @"08-August", @"09-September", @"10-October", @"11-November", @"12-December", nil];
    
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    [self.view addSubview:cardView];
    [cardView setBackgroundColor:APP_COLOR_LIGHT_BACKGROUND];

    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, cardView.frame.size.width-40, 30)];
    headerLbl.text = @"PAYMENT-ADD A CARD";
    headerLbl.textColor = DARK_GRAY;
    [cardView addSubview:headerLbl];
    headerLbl.font = APP_FONT_BOLD_18;
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, cardView.frame.size.width-20, 30)];
    [self.view addSubview:nameLbl];
    nameLbl.text = @"Name on Card*";
    nameLbl.font = APP_FONT_BOLD_16;
    
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(20, 150, cardView.frame.size.width-40, 30)];
    [self.view addSubview:nameText];
    nameText.delegate = self;
    nameText.text = [NSString stringWithFormat:@"%@",[cardDic objectForKey:@"CreditCardName"]?[cardDic objectForKey:@"CreditCardName"]:@""];
    nameText.layer.borderColor = [[UIColor blackColor] CGColor];
    nameText.layer.borderWidth = 1.0;
    nameText.layer.cornerRadius = 3.0;
    [nameText setFont:APP_FONT_REGULAR_16];
    
    UILabel *cardNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, cardView.frame.size.width-40, 30)];
    [self.view addSubview:cardNumberLbl];
    cardNumberLbl.text = @"Card Number*";
    cardNumberLbl.font = APP_FONT_BOLD_16;
    
    cardNumberText = [[UITextField alloc] initWithFrame:CGRectMake(20, 220, cardView.frame.size.width-40, 30)];
    [self.view addSubview:cardNumberText];
    cardNumberText.delegate = self;
    cardNumberText.text = [cardDic objectForKey:@"CreditCardNumber"];
    cardNumberText.layer.borderColor = [[UIColor blackColor] CGColor];
    cardNumberText.layer.borderWidth = 1.0;
    cardNumberText.layer.cornerRadius = 3.0;
    [cardNumberText setFont:APP_FONT_REGULAR_16];

    
    UILabel *cardNumHelpLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 160, 15)];
    [self.view addSubview:cardNumHelpLbl];
    cardNumHelpLbl.textColor = [UIColor lightGrayColor];
    cardNumHelpLbl.text = @"enter number without space";
    cardNumHelpLbl.font = APP_FONT_REGULAR_12;
    
    UIImageView *cardImg = [[UIImageView alloc] initWithFrame:CGRectMake(180, 250, 100, 15)];
    cardImg.image = [UIImage imageNamed:@"Accountupdate_cards"];
    [self.view addSubview:cardImg];
    expiry = [NSString stringWithFormat:@"%d-01", 01];
    NSString *monthIndex = @"1";
    if ([cardDic objectForKey:@"CreditCardExpired"]) {
        monthIndex = [[[cardDic objectForKey:@"CreditCardExpired"] substringFromIndex:5] substringToIndex:2];
        expiry = [NSString stringWithFormat:@"%d-01", [monthIndex intValue]];
    }
    
    
    
    UILabel *expiryLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 275, cardView.frame.size.width-40, 30)];
    [self.view addSubview:expiryLbl];
    expiryLbl.text = @"Expiry Date*";
    expiryLbl.font = APP_FONT_BOLD_16;
    
    UIToolbar *optionPickerTool=[[UIToolbar alloc]init];
    
    optionPickerTool.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(sendAction)];
    [optionPickerTool setItems:[[NSArray alloc] initWithObjects:button1, nil]];
    
    picker = [[UIPickerView alloc]init];
    picker.dataSource = self;
    picker.delegate = self;
    
    expMonthTxt = [[UITextField alloc] initWithFrame:CGRectMake(20, 305, cardView.frame.size.width/2-25, 30)];
    [self.view addSubview:expMonthTxt];
    
    expMonthTxt.inputView = picker;
    expMonthTxt.inputAccessoryView=optionPickerTool;
    expMonthTxt.text=[NSString stringWithFormat:@"%@",[monthsArr objectAtIndex:[monthIndex intValue]-1]];
    expMonthTxt.delegate = self;
    expMonthTxt.layer.borderColor = [[UIColor blackColor] CGColor];
    expMonthTxt.layer.borderWidth = 1.0;
    expMonthTxt.layer.cornerRadius = 3.0;
    [expMonthTxt setFont:APP_FONT_REGULAR_16];
    
    expYearTxt = [[UITextField alloc] initWithFrame:CGRectMake(cardView.frame.size.width/2+5, 305, cardView.frame.size.width/2-25, 30)];
    [self.view addSubview:expYearTxt];
    expYearTxt.delegate = self;
    expYearTxt.text = @"2018";
    expYearTxt.layer.borderColor = [[UIColor blackColor] CGColor];
    expYearTxt.layer.borderWidth = 1.0;
    expYearTxt.layer.cornerRadius = 3.0;
    [expYearTxt setFont:APP_FONT_REGULAR_16];
    if ([cardDic objectForKey:@"CreditCardExpired"]) {
        expYearTxt.text = [[cardDic objectForKey:@"CreditCardExpired"] substringToIndex:4];
    }
   
    UILabel *cvvLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 335, cardView.frame.size.width-40, 30)];
    [self.view addSubview:cvvLbl];
    cvvLbl.text = @"CVV*";
    cvvLbl.font = APP_FONT_BOLD_16;
    cvvTxt = [[UITextField alloc] initWithFrame:CGRectMake(20, 365, cardView.frame.size.width-40, 30)];
    [self.view addSubview:cvvTxt];
    cvvTxt.delegate = self;
    cvvTxt.text = [cardDic objectForKey:@"CreditCardCSC"];
    cvvTxt.layer.borderColor = [[UIColor blackColor] CGColor];
    cvvTxt.layer.borderWidth = 1.0;
    cvvTxt.layer.cornerRadius = 3.0;
    cvvTxt.secureTextEntry = YES;
    [cvvTxt setFont:APP_FONT_REGULAR_16];
    
    UILabel *zipLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 395, cardView.frame.size.width-40, 30)];
    [self.view addSubview:zipLbl];
    zipLbl.text = @"Billing ZIP Code*";
    zipLbl.font = APP_FONT_BOLD_16;
    
    zipTxt = [[UITextField alloc] initWithFrame:CGRectMake(20, 425, cardView.frame.size.width/2-40, 30)];
    [self.view addSubview:zipTxt];
    zipTxt.delegate = self;
    zipTxt.text = [cardDic objectForKey:@"BillingZipCode"];
    zipTxt.layer.borderColor = [[UIColor blackColor] CGColor];
    zipTxt.layer.borderWidth = 1.0;
    zipTxt.layer.cornerRadius = 3.0;
    [zipTxt setFont:APP_FONT_REGULAR_16];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [addBtn setTitle:@"ADD CARD" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:APP_COLOR];
    [addBtn addTarget:self action:@selector(addBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    addBtn.titleLabel.font = APP_FONT_BOLD_18;
    
//    if (cardDic) {
//        nameText.text = [cardDic objectForKey:@"Name"];
//        cardNumberText.text = [cardDic objectForKey:@"Number"];
//        if ([[cardDic objectForKey:@"ExpiryMonth"] intValue]) {
//            expMonthTxt.text = [monthsArr objectAtIndex: [[cardDic objectForKey:@"ExpiryMonth"] intValue]-1];
//        }else{
//            expMonthTxt.text = [monthsArr objectAtIndex:0];
//
//        }
//        expYearTxt.text = [cardDic objectForKey:@"ExpiryYear"];
//        cvvTxt.text = [cardDic objectForKey:@"CVV"];
//    }

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];

    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [numberToolbar sizeToFit];
    cardNumberText.inputAccessoryView = numberToolbar;
    zipTxt.inputAccessoryView = numberToolbar;
    cvvTxt.inputAccessoryView = numberToolbar;
    expYearTxt.inputAccessoryView = numberToolbar;
}
-(void)cancelNumberPad{
    [cardNumberText resignFirstResponder];
    [cvvTxt resignFirstResponder];
    [zipTxt resignFirstResponder];
    [expYearTxt resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)cardExpValidation{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    
    NSString *str = [formatter stringFromDate:date];
    NSLog( @"%d ------ %d", [expYearTxt.text intValue], [str intValue]);
    
    if ([str intValue] > [expYearTxt.text intValue]) {
        return NO;
    }else if([str intValue] == [expYearTxt.text intValue]){
        [formatter setDateFormat:@"MM-DD"];
        str = [formatter stringFromDate:date];
        if ([[str substringToIndex:2] intValue] <= [[expMonthTxt.text substringToIndex:2] intValue]) {
            NSLog(@"%d---- %d", [[str substringToIndex:2] intValue], [[expMonthTxt.text substringToIndex:2] intValue]);
            return YES;
            
        }else{
            return NO;
        }
    }else{
        return YES;
    }
    
    
    
//    if (([str intValue] < [expYearTxt.text intValue]) || ([str intValue] == [expYearTxt.text intValue])) {
//        
//        [formatter setDateFormat:@"MM-DD"];
//        str = [formatter stringFromDate:date];
//        if ([[str substringToIndex:2] intValue] <= [[expMonthTxt.text substringToIndex:2] intValue]) {
//            NSLog(@"%d---- %d", [[str substringToIndex:2] intValue], [[expMonthTxt.text substringToIndex:2] intValue]);
//            return YES;
//
//        }else{
//            return NO;
//        }
//    }else{
//        return NO;
//    }
    
}

-(void)addBtnAct{
    BOOL addCard = YES;
    if (newCard) {
        for (int i = 0; i < [[user objectForKey:@"PaymentInformation"] count]; i++) {
            if ([[[[user objectForKey:@"PaymentInformation"] objectAtIndex:i] objectForKey:@"CreditCardNumber"]
                 isEqualToString: cardNumberText.text]) {
                addCard = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This card is already in your credit card list" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                break;
            }
        }
    }
   
    if (addCard) {
        if ([self cardValidation]) {
            if ([self cardExpValidation]) {
                if ([self checkCreditCardType]) {
                    if (nameText.text.length && cvvTxt.text.length && zipTxt.text.length) {
                        [self cardAddRequest];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Mandatory fields missing" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alert show];
                    }
                }else{
                    [self errorMesage];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Expiry date can not be past date" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            
           
        }else{
            [self errorMesage];
        }
        
    }
}
-(void)errorMesage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This is not a valid card" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(int)checkCreditCardType{
    cardType = 0;
    if ([cardNumberText.text length] >= 13 && [cardNumberText.text length] <=16 ) {
        if (!cardType) {
            int prefix = [[cardNumberText.text substringToIndex:2] intValue];
            
            switch (prefix) {
                case 34://americanExpress
                case 37://americanExpress
                    cardType = 1;
                    NSLog(@"americanExpress");
                    break;
                case 36://Diners Club
                    cardType = 16;
                    NSLog(@"Diners Club");
                    break;
                case 38://Carte Blanche
                    cardType = 8;
                    NSLog(@"Carte Blanche");
                    break;
                    
                case 51://Master Card
                case 52://Master Card
                case 53://Master Card
                case 54://Master Card
                case 55://Master Card
                    cardType = 4;
                    NSLog(@"Master Card");
                    break;
                    
                default:
                    cardType = 0;
                    break;
            }
            
            if (!cardType) {
                int prefix = [[cardNumberText.text substringToIndex:3] intValue];
                switch (prefix) {
                    case 300://American Diners Club
                    case 301://American Diners Club
                    case 302://American Diners Club
                    case 303://American Diners Club
                    case 304://American Diners Club
                    case 305://American Diners Club
                        cardType = 16;
                        NSLog(@"American Diners Club");
                        break;
                        
                    case 603://Maestro
                    case 630://Maestro
                        cardType = 0;
                        NSLog(@"Maestro");
                        break;
                    default:
                        cardType = 0;
                        break;
                }
            }
            
            if (!cardType) {
                int prefix = [[cardNumberText.text substringToIndex:4] intValue];
                switch (prefix) {
                    case 6011://Discover
                        cardType = 2;
                        NSLog(@"Discover");
                        break;
                        
                    case 2014://EnRoute
                    case 2149://EnRoute
                        cardType = 8;
                        NSLog(@"EnRoute");
                        break;
                        
                    case 2131://JCB
                    case 1800://JCB
                        cardType = 32;
                        NSLog(@"JCB");
                        break;
                        
                    default:
                        cardType = 0;
                        break;
                }
            }
            
            if (!cardType) {
                int prefix = [[cardNumberText.text substringToIndex:1] intValue];
                switch (prefix) {
                    case 3://JCB
                        cardType = 32;
                        NSLog(@"JCB");
                        break;
                        
                    case 4://Visa
                        cardType = 8;
                        NSLog(@"Visa");
                        break;
                        
                    default:
                        cardType = 0;
                        break;
                }
            }
        }
        
    }
    return cardType;
}

-(void)cardAddRequest{
//    int cardType = [Luhn typeFromString:cardNumberText.text];
//    NSLog(@">>>>>>>>>>>>>>>>> %d <<<<<<<<<<<<<<<", cardType);
    
    NSDictionary *cardDetailsDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                             [nameText.text length]? nameText.text :@"", @"CreditCardName",
                             [cardNumberText.text length]? cardNumberText.text :@"", @"CreditCardNumber",
                             [cvvTxt.text length]? cvvTxt.text :@"", @"CreditCardCSC",
                             [zipTxt.text length]? zipTxt.text :@"", @"BillingZipCode",
                             [NSString stringWithFormat:@"%@-%@", expYearTxt.text, expiry], @"CreditCardExpired",
                             [NSString stringWithFormat:@"%d", cardType], @"CreditCardType",
                             [cardDic objectForKey:@"CreditCardNumber"]? [cardDic objectForKey:@"CardId"]:@"", @"CardId",
                             [NSNumber numberWithBool:false], @"IsDeleted",
                             nil];
    
    
    if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
        NSArray *cardArr = [[NSArray alloc] initWithObjects:cardDetailsDic, nil];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             CLIENT_ID, @"clientId",
                             cardArr, @"PaymentInformation",
                             [[user objectForKey:@"userInfo"] objectForKey:@"UserId"]?[[user objectForKey:@"userInfo"] objectForKey:@"UserId"]:@"", @"UserId",
                             [[user objectForKey:@"userInfo"] objectForKey:@"Email"]?[[user objectForKey:@"userInfo"] objectForKey:@"Email"]:@"", @"Email",
                             [[user objectForKey:@"userInfo"] objectForKey:@"FullName"]?[[user objectForKey:@"userInfo"] objectForKey:@"FullName"]:@"", @"FullName",
                             [[user objectForKey:@"userInfo"] objectForKey:@"Password"]?[[user objectForKey:@"userInfo"] objectForKey:@"Password"]:@"", @"Password",
                             [[user objectForKey:@"userInfo"] objectForKey:@"isFirstTimeUser"]?[[user objectForKey:@"userInfo"] objectForKey:@"isFirstTimeUser"]:@"", @"isFirstTimeUser",
                             [[user objectForKey:@"userInfo"] objectForKey:@"lastOrderDays"]?[[user objectForKey:@"userInfo"] objectForKey:@"lastOrderDays"]:@"", @"lastOrderDays",
                             [[user objectForKey:@"userInfo"] objectForKey:@"FirstName"]?[[user objectForKey:@"userInfo"] objectForKey:@"FirstName"]:@"", @"FirstName",
                             [[user objectForKey:@"userInfo"] objectForKey:@"LastName"]?[[user objectForKey:@"userInfo"] objectForKey:@"LastName"]:@"", @"LastName",
                             [[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"]?[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"]:@"", @"UserAddress",
                             nil];
        
        [self addCardRequest:dic];
    }else{
        NSMutableArray *cardArray = [[NSMutableArray alloc] initWithObjects:cardDetailsDic, nil];
        for (NSDictionary *cardObj in cardArray) {
            if ([[cardObj objectForKey:@"IsDeleted"] intValue]) {
                [cardArray removeObject:cardObj];
            }
        }
        
        [user setObject:cardArray forKey:@"PaymentInformation"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)addCardRequest: (NSDictionary *)dic{
    [APIRequest updateClorderUser:dic completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //            [alert show];
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
            if ([[resObj objectForKey:@"isSuccess"] boolValue] && ![[resObj objectForKey:@"PaymentInformation"] isKindOfClass:[NSNull class]]) {
                
                NSMutableArray *cardArray = [[NSMutableArray alloc] initWithArray:[resObj objectForKey:@"PaymentInformation"]];
                
                
                //                if ([cardDic objectForKey:@"CreditCardNumber"]) {
                //                    for (int i =0; i < [cardArray count]; i++) {
                //                        if ([[[cardArray objectAtIndex:i] objectForKey:@"CreditCardNumber"] intValue] == [[cardDic objectForKey:@"CreditCardNumber"] intValue]) {
                //                            [cardArray removeObjectAtIndex:i];
                //                        }
                //                    }
                //                }
                
                //                [cardArray addObject:[[resObj objectForKey:@"PaymentInformation"] objectAtIndex:0]];
                
                for (NSDictionary *cardObj in cardArray) {
                    if ([[cardObj objectForKey:@"IsDeleted"] intValue]) {
                        [cardArray removeObject:cardObj];
                    }
                }
                
                [user setObject:cardArray forKey:@"PaymentInformation"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Failed to add credit card" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

-(BOOL)cardValidation{
    return [Luhn validateString:cardNumberText.text];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 12;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [monthsArr objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    expMonthTxt.text = [NSString stringWithFormat:@"%@",[monthsArr objectAtIndex:row]];
    expiry = [NSString stringWithFormat:@"%ld-01", row+1];
}

-(void)sendAction{
    [expMonthTxt resignFirstResponder];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (textField == cardNumberText || textField == cvvTxt || textField == zipTxt || textField == expYearTxt) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (!(textField == nameText || textField == cardNumberText)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    return YES;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == nameText) {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];
        
        NSString *output = [string stringByTrimmingCharactersInSet:[myCharSet invertedSet]];
        
        return [string isEqualToString:output];
    }
    return YES;
}

-(void)keyboardWasShown:(NSNotification *)notification{
    CGRect frm = self.view.frame;
    frm.origin.y = (frm.origin.y<0)?frm.origin.y:-200;
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
