//
//  AccountUpdateVC.m
//  CLOrder
//
//  Created by Vegunta's on 31/05/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "AccountUpdateVC.h"
#import "AppHeader.h"
#import "AppDelegate.h"
#import "AddCardVC.h"
#import "CartObj.h"
#import "APIRequest.h"
#import "OrderConfirmationV.h"

#define kPayPalEnvironment PayPalEnvironmentNoNetwork


@implementation AccountUpdateVC {
    NSMutableArray *cardArray;
    //    NSMutableDictionary *cardDic;
    NSUserDefaults *user;
    NSDictionary *payThrough;
}

@synthesize paypalConfig, environment, resultText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PAYMENT INFO";
    self.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:APP_BG_IMG]
                                                      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch]  forBarMetrics:UIBarMetricsCompact];
    
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    user = [NSUserDefaults standardUserDefaults];
    
    cardTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-150)];
    cardTbl.dataSource = self;
    cardTbl.delegate = self;
    [self.view addSubview:cardTbl];
    
    UIButton *payWithCard = [UIButton buttonWithType:UIButtonTypeCustom];
    payWithCard.frame = CGRectMake(0, SCREEN_HEIGHT-145, SCREEN_WIDTH, 40);
    [payWithCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payWithCard setBackgroundColor:APP_COLOR];
    [payWithCard addTarget:self action:@selector(saveBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payWithCard];
    [payWithCard setTitle:@"Pay With Card" forState:UIControlStateNormal];
    payWithCard.titleLabel.font = APP_FONT_BOLD_18;
    
    
    UIButton *payPalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payPalBtn.frame = CGRectMake(0, SCREEN_HEIGHT-95, SCREEN_WIDTH, 40);
    [payPalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payPalBtn setBackgroundColor:APP_COLOR];
    [payPalBtn addTarget:self action:@selector(payWithPaypal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payPalBtn];
    payPalBtn.titleLabel.font = APP_FONT_BOLD_18;
    [payPalBtn setTitle:@"Pay with PayPal" forState:UIControlStateNormal];
    payPalBtn.hidden = true;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 40);
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:APP_COLOR];
    [saveBtn addTarget:self action:@selector(saveBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    saveBtn.titleLabel.font = APP_FONT_BOLD_18;

    if ([[CartObj instance].itemsForCart count]) {
        [saveBtn setTitle:@"Pay Cash" forState:UIControlStateNormal];
        payPalBtn.hidden = false;
    }else{
        [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        payPalBtn.hidden = true;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}


-(void) viewWillAppear:(BOOL)animated{
    cardArray = [[NSMutableArray alloc] initWithArray:[user objectForKey:@"PaymentInformation"]];
    [cardTbl reloadData];
}


-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) addCardBtnAct{
    //    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
    
    AddCardVC *addCardView = [[AddCardVC alloc] init];
    addCardView.newCard = YES;
    [self.navigationController pushViewController:addCardView animated:YES];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        //        return 5;
        return cardArray.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50.0;
    }else{
        return 200.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && ![cardArray count]) {
        return 0.1;
    }else{
        return 40.0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 40.0)];
    headerView.backgroundColor = APP_COLOR_LIGHT_BACKGROUND;
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 30)];
    [headerView addSubview:headerLbl];
    headerLbl.font = APP_FONT_BOLD_16;
    if (section==0) {
        if ([cardArray count]) {
            headerLbl.text = @"YOUR EXISTING CARD(S)";
            
        }else{
            headerLbl.text = @"";
        }
    }else{
        headerLbl.text = @"ADD NEW CARD";
    }
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.section == 1) {
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 100)];
        detailLbl.text = @"Your payment information will be strictly used for easy checkouts. It is stored in compliance with industry's best security practices.";
        detailLbl.numberOfLines=0;
        [cell.contentView addSubview:detailLbl];
        
        UIButton *addCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addCardBtn.frame = CGRectMake(self.view.frame.size.width/2-80, 110, 180, 40);
        addCardBtn.layer.cornerRadius = 5.0;
        [addCardBtn setTitle:@"ADD A CARD" forState:UIControlStateNormal];
        [addCardBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        [addCardBtn setBackgroundColor:[UIColor whiteColor]];
        [addCardBtn.layer setBorderColor:[APP_COLOR CGColor]];
        addCardBtn.titleEdgeInsets = UIEdgeInsetsMake(5,-10, 5, 5);
        addCardBtn.imageEdgeInsets = UIEdgeInsetsMake(5,150,5,0);
        [addCardBtn setImage:[UIImage imageNamed:@"plus_card"] forState:UIControlStateNormal];
        [addCardBtn.layer setBorderWidth:1];
        [addCardBtn addTarget:self action:@selector(addCardBtnAct) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addCardBtn];
        addCardBtn.titleLabel.font = APP_FONT_BOLD_18;
        [addCardBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, SCREEN_WIDTH-20, 40)];
        [cell.contentView addSubview:msg];
        msg.textAlignment = NSTextAlignmentCenter;
        msg.textColor = [UIColor lightGrayColor];
        msg.numberOfLines = 0;
        msg.text = @"Please sign out and sign in again if any cards have been added from any other device.";
        msg.font = APP_FONT_REGULAR_12;
        
    }else{
        UIImageView *cardImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 30)];
        [cell.contentView addSubview:cardImg];
        switch ([[[cardArray objectAtIndex:indexPath.row] objectForKey:@"CreditCardType"] intValue]) {
            case 1:
                cardImg.image = [UIImage imageNamed:@"AmericanExpressCard_Logo"];
                break;
                
            case 2:
                cardImg.image = [UIImage imageNamed:@"discoverCard_Logo"];
                break;
                
            case 4:
                cardImg.image = [UIImage imageNamed:@"MasterCard_Logo"];
                break;
                
            case 8:
                cardImg.image = [UIImage imageNamed:@"VisaCard_Logo"];
                break;
                
            case 16:
                cardImg.image = [UIImage imageNamed:@"DinersClubCard_Logo"];
                break;
                
            case 32:
                cardImg.image = [UIImage imageNamed:@"JCBCard_Logo"];
                break;
                
            default:
                cardImg.image = [UIImage imageNamed:@"order-confirmation_mastercard"];
                break;
        }
        
        
        UILabel *crdNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 148, 30)];
        crdNoLbl.text = [NSString stringWithFormat:@"%@", [[cardArray objectAtIndex:indexPath.row] objectForKey:@"CreditCardNumber"]];
        crdNoLbl.font = APP_FONT_REGULAR_16;
        [cell.contentView addSubview:crdNoLbl];
     
        
        UIButton *editCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editCardBtn setTag:(200+indexPath.row)];
        editCardBtn.frame = CGRectMake(CGRectGetWidth(cardTbl.frame)-120, 10, 30, 30);
        [editCardBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        editCardBtn.titleLabel.font = APP_FONT_REGULAR_16;
        [editCardBtn addTarget:self action:@selector(editCardBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:editCardBtn];
        
        UIButton *deleteCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteCardBtn setTag:(200+indexPath.row)];
        deleteCardBtn.frame = CGRectMake(CGRectGetWidth(cardTbl.frame)-70, 10, 65, 30);
        [deleteCardBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        deleteCardBtn.titleLabel.font = APP_FONT_REGULAR_14;
        [deleteCardBtn addTarget:self action:@selector(deleteCardBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteCardBtn];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [cardTbl deselectRowAtIndexPath:indexPath animated:YES];
    if ([[CartObj instance].itemsForCart count]) {
        
        if (indexPath.section == 0) {
            [user setObject:[NSNumber numberWithInteger:2] forKey:@"PaymentType"];
            payThrough = [[NSDictionary alloc] initWithDictionary:[cardArray objectAtIndex:indexPath.row]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Pay bill trough card with card number: %@", [payThrough objectForKey:@"CreditCardNumber"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [alert setTag:5000];
            [alert show];
        }
    }
    
}

-(void) saveBtnAct{
    if ([[CartObj instance].itemsForCart count]) {
        if ([[user objectForKey:@"SubTotal"] doubleValue] <= [[user objectForKey:@"maxCashValue"] doubleValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Pay Order with Cash" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [alert setTag:5000];
            [alert show];
            [user setObject:[NSNumber numberWithInteger:1] forKey:@"PaymentType"];
            payThrough = [[NSDictionary alloc] init];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Maximum amount for cash order is $%.2lf", [[user objectForKey:@"maxCashValue"] doubleValue]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)placeOrderReq:(NSDictionary *)card{
    NSMutableArray *cartItmArr = [[NSMutableArray alloc] init];
    NSLog(@"%@",[CartObj instance].itemsForCart);
    for (int i = 0; i < [[CartObj instance].itemsForCart count]; i++) {
        NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        [[[CartObj instance].itemsForCart objectAtIndex: i] objectForKey:@"CategoryId"], @"CategoryId",
                                        [[[CartObj instance].itemsForCart objectAtIndex: i] objectForKey:@"ItemId"], @"ItemId",
                                        [[[CartObj instance].itemsForCart objectAtIndex: i] objectForKey:@"Notes"], @"Notes",
                                        [[[CartObj instance].itemsForCart objectAtIndex: i] objectForKey:@"Price"], @"Price",
                                        [[[CartObj instance].itemsForCart objectAtIndex: i] objectForKey:@"Title"], @"Title",
                                        [[[CartObj instance].itemsForCart objectAtIndex: i] objectForKey:@"Quantity"], @"Quantity",
                                        @"00000000-0000-0000-0000-000000000000",@"CartItemInstanceId",
                                        nil];
        NSMutableDictionary *selectedOptionsDic = [[NSMutableDictionary alloc] init];
        if (![[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] isKindOfClass:[NSNull class]] &&
            [[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]) {
            
            for (int j = 0; j < [[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]; j++) {
                
                NSMutableString *optionStr = [[NSMutableString alloc] init];
                
                for (int k = 0; k < [[[[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex: j] objectForKey:@"Options"] count]; k++) {
                    if ([[[[[[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex: j] objectForKey:@"Options"] objectAtIndex: k] objectForKey:@"Default"] intValue]) {
                        
                        [optionStr appendString:[NSString stringWithFormat:@"%d,",
                                                 [[[[[[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex: j] objectForKey:@"Options"] objectAtIndex: k] objectForKey:@"OptionId"] intValue]]];
                    }
                }
                
                if ([optionStr length] > 0) {
                    optionStr = (NSMutableString *)[optionStr substringToIndex:[optionStr length] - 1];
                }
                [selectedOptionsDic setObject:optionStr forKey:[NSString stringWithFormat:@"%d",
                                                                [[[[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex: j] objectForKey:@"ID"] intValue]]];
            }
        }
        [itemDic setObject:selectedOptionsDic forKey:@"SelectedOptions"];
        [cartItmArr addObject:itemDic];
    }
    
    NSMutableDictionary *cartDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    @"0", @"AddfreeItemCouponApplied",
                                    @"0", @"InstanceIdFreeItemAdded",
                                    [NSNumber numberWithInt:0], @"FreeAddedItemId",
                                    cartItmArr, @"CartItems",
                                    [user objectForKey:@"TaxCost"], @"TaxCost",
                                    [[user objectForKey:@"TipAmount"] intValue]?[user objectForKey:@"TipAmount"]:@"0.0", @"TipAmount",
                                    [user objectForKey:@"ShippingCost"], @"ShippingCost",
                                    [user objectForKey:@"DiscountAmount"], @"DiscountAmount",
                                    [user objectForKey:@"SubTotal"], @"SubTotal",
                                    [user objectForKey:@"cartPrice"], @"Total",
                                    @"0", @"TipType",
                                    [user objectForKey:@"DiscountCode"], @"DiscountCode",
                                    nil];
    
    NSLog(@"\n\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",[user objectForKey:@"TaxCost"],
          [user objectForKey:@"TipAmount"],
          [user objectForKey:@"ShippingCost"],
          [user objectForKey:@"DiscountCode"],
          [user objectForKey:@"DiscountAmount"],
          [user objectForKey:@"SubTotal"],
          [user objectForKey:@"cartPrice"]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *orderDtStr = [[user objectForKey:@"OrderDate"] stringByAppendingString:[NSString stringWithFormat:@" %@",[user objectForKey:@"OrderTime"]]];
    
    
//    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *orderDt = [[NSDate alloc] init];
    orderDt = [dateFormatter dateFromString:orderDtStr];
    
    NSString *timeStamp;// = [dateFormatter stringFromDate:orderDt];
    
    
    timeStamp = [NSString stringWithFormat:@"%@", orderDt];
    timeStamp = [timeStamp substringToIndex:16];
    timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    
    
    bool isFutureOrder = NO;
    NSDateFormatter *formatForToday =  [[NSDateFormatter alloc] init];
    [formatForToday setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    formatForToday.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    NSString *currentDateStr = [formatForToday stringFromDate: [NSDate date]];
//    formatForToday.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    NSDate *mydate = [formatForToday dateFromString:currentDateStr];
    
    
//    NSTimeZone *tzz = [NSTimeZone systemTimeZone];
//    NSInteger second = [tzz secondsFromGMTForDate: mydate];
//    mydate =  [NSDate dateWithTimeInterval: second sinceDate: mydate];
//    
//    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
//    NSInteger seconds = [tz secondsFromGMTForDate: orderDt];
//    orderDt =  [NSDate dateWithTimeInterval: seconds sinceDate: orderDt];
    
//    NSString *timeStamp = [dateFormatter stringFromDate:orderDt];
//
//    
//    timeStamp = [NSString stringWithFormat:@"%@", orderDt];
//    timeStamp = [timeStamp substringToIndex:16];
//    timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
//    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT-12"];
//    [dateFormatter setTimeZone:gmt];

    NSLog(@"%@\n%@\n%@", [mydate dateByAddingTimeInterval:45*60], orderDt, [NSDate date]);
    
    if ([[[NSDate date] dateByAddingTimeInterval:45*60] compare:orderDt] == NSOrderedAscending) {
        isFutureOrder = YES;
    }else{
        isFutureOrder = NO;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                CLIENT_ID, @"ClientId",
                                @"0", @"OrderId",
                                [NSString stringWithFormat:@"%@", [[CartObj instance].userInfo objectForKey:@"UserId"]], @"MemberId",
                                [NSString stringWithFormat:@"%@", [user objectForKey:@"OrderType"]], @"DeliveryPreference",
                                cartDic, @"CartInfo",
                                [CartObj instance].userInfo, @"UserDataInfo",
                                @"", @"IpAddress",
                                timeStamp, @"OrderDate",
                                [NSString stringWithFormat:@"%@", [[CartObj instance].spclNote length]?[CartObj instance].spclNote:@""], @"OverallNotes",
                                card, @"PaymentInfo",
                                [NSNumber numberWithBool:isFutureOrder], @"isFutureOrder",
                                [user objectForKey:@"PaymentType"], @"PaymentType",
                                [user objectForKey:@"DeliveryDist"], @"DeliveryDist",
                                nil];
    
    [self placeOrderRequest: dic];
}

-(void)placeOrderRequest:(NSMutableDictionary *)dic{
    [APIRequest placeOrder:dic completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if ([[resObj objectForKey:@"isSuccess"] intValue]) {
                [[CartObj instance].userInfo setObject:[resObj objectForKey:@"OrderId"] forKey:@"OrderId"];
                [[CartObj instance].userInfo setObject:[resObj objectForKey:@"OrderDate"] forKey:@"OrderDate"];
                [[CartObj instance].userInfo setObject:[NSNumber numberWithBool:[[resObj objectForKey:@"isFutureOrder"] boolValue]] forKey:@"isFutureOrder"];

                if ([[user objectForKey:@"PaymentType"] intValue] == 4){
                    [self goForPayment:[NSString stringWithFormat:@"%@",[resObj objectForKey:@"OrderId"]]];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Order placed successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert setTag:4000];
                    [alert show];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[resObj objectForKey:@"statusMessage"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert setTag:6000];
                [alert show];
            }
        }
    }];
}

-(void)editCardBtnAct: (UIButton *)sender{
    int index = (int)sender.tag%200;
    
    AddCardVC *addCardView = [[AddCardVC alloc] init];
    addCardView.cardDic = [cardArray objectAtIndex:index];
    addCardView.newCard =  NO;
    [self.navigationController pushViewController:addCardView animated:YES];
}

-(void)deleteCardBtnAct: (UIButton *)sender{
    
    int index = (int)sender.tag%200;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure? Card will be removed from your list." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert setTag:index];
    [alert show];
}

-(void)payWithPaypal{
    [user setObject:[NSNumber numberWithInteger:4] forKey:@"PaymentType"];
    payThrough = [[NSDictionary alloc] init];
    [self placeOrderReq:payThrough];
}

-(void)goForPayment:(NSString *)orderId{

//    [PayPalMobile initializeWithClientIdsForEnvironments:@{/*PayPalEnvironmentProduction : @"access_token$sandbox$cdphrs9mxpghkb6s$3c1dcd6e3bce7440eaf77ed5785a7eb6",*/
//                                                           PayPalEnvironmentSandbox : @"access_token$sandbox$cdphrs9mxpghkb6s$3c1dcd6e3bce7440eaf77ed5785a7eb6"}];
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];

    paypalConfig = [[PayPalConfiguration alloc] init];
    paypalConfig.acceptCreditCards = YES;
    paypalConfig.merchantName = @"";
    paypalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    paypalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    paypalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    paypalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    PayPalItem *cartItem = [PayPalItem itemWithName:@"myCart" withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:[user objectForKey:@"cartPrice"]] withCurrency:@"USD" withSku:@"SKU-myCart"];
    
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:[NSDecimalNumber decimalNumberWithString:[user objectForKey:@"cartPrice"]] withShipping:[NSDecimalNumber decimalNumberWithString:@"0"] withTax:[NSDecimalNumber decimalNumberWithString:@"0"]];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [NSDecimalNumber decimalNumberWithString:[user objectForKey:@"cartPrice"]];
    payment.currencyCode = @"USD";
    payment.shortDescription = [NSString stringWithFormat:@"%@-Food Order",[[NSBundle mainBundle]
                                                                            objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    payment.custom = orderId;
    payment.items = [NSArray arrayWithObjects:cartItem, nil];
    payment.paymentDetails = paymentDetails;
    payment.payeeEmail = [NSString stringWithFormat:@"%@", [[user objectForKey:@"userInfo"] objectForKey:@"Email"]];
    
    
    
    PayPalPaymentViewController *paypalVC = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:paypalConfig delegate:self];
    [self presentViewController:paypalVC animated:YES completion:nil];
}


- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!--------%@",[completedPayment description]);
    self.resultText = [completedPayment description];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID,@"ClientId",completedPayment.custom,@"OrderId",@"Success",@"PaypalResponse", nil];
    
    [APIRequest confirmPaypalOrder:dic completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //            [alert show];
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if ([[resObj objectForKey:@"isSuccess"] intValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Order placed successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert setTag:4000];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[resObj objectForKey:@"statusMessage"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert setTag:6000];
                [alert show];
            }
        }
    }];
}



//#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    self.resultText = [futurePaymentAuthorization description];
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}


#pragma mark - Authorize Profile Sharing

//- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
//    
//    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
//    
//    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.paypalConfig delegate:self];
//    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
//}


//#pragma mark PayPalProfileSharingDelegate methods
//
- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    self.resultText = [profileSharingAuthorization description];
    
//    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
//- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
//    // TODO: Send authorization to server
//    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
//}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        if (alertView.tag == 5000 ) {
//            [self goForPayment];
            [self placeOrderReq:payThrough];
        }else{
            NSMutableDictionary *cardDic = [[NSMutableDictionary alloc] initWithDictionary:[[cardArray objectAtIndex:alertView.tag] mutableCopy]];
            [cardDic setObject:[NSNumber numberWithBool:YES] forKey:@"IsDeleted"];
            [cardArray replaceObjectAtIndex:alertView.tag withObject:cardDic];
            [self updateCard:alertView.tag];
        }
    }
    if (buttonIndex == 0 && alertView.tag == 4000) {
        OrderConfirmationV *nextView = [[OrderConfirmationV alloc] init];
        [self.navigationController pushViewController:nextView animated:YES];
        //        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)updateCard:(NSInteger)index{
    NSArray *cardArr = [[NSArray alloc] initWithObjects:[cardArray objectAtIndex:index], nil];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         CLIENT_ID, @"clientId",
                         cardArr, @"PaymentInformation",
                         [[CartObj instance].userInfo objectForKey:@"UserId"], @"UserId",
                         [[CartObj instance].userInfo objectForKey:@"Email"], @"Email",
                         [[CartObj instance].userInfo objectForKey:@"FullName"], @"FullName",
                         
                         [[CartObj instance].userInfo objectForKey:@"FirstName"], @"FirstName",
                         [[CartObj instance].userInfo objectForKey:@"LastName"], @"LastName",
                         [[CartObj instance].userInfo objectForKey:@"UserAddress"], @"UserAddress",
                         [[user objectForKey:@"userInfo"] objectForKey:@"Password"]?[[user objectForKey:@"userInfo"] objectForKey:@"Password"]:@"", @"Password",
                         [[CartObj instance].userInfo objectForKey:@"isFirstTimeUser"], @"isFirstTimeUser",
                         [[CartObj instance].userInfo objectForKey:@"lastOrderDays"], @"lastOrderDays",
                         nil];
    NSLog(@"%@",[[user objectForKey:@"userInfo"] objectForKey:@"UserId"]);
    
    if (![[user objectForKey:@"userInfo"] objectForKey:@"UserId"]) {
        [user removeObjectForKey:@"PaymentInformation"];
        [cardArray removeAllObjects];
        [cardTbl reloadData];
    }else{
        [APIRequest updateClorderUser:dic completion:^(NSMutableData *buffer) {
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
                //            cardArray = [[NSMutableArray alloc] initWithArray:[resObj objectForKey:@"PaymentInformation"]];
                //            for (int i = 0; i < cardArray.count; i++) {
                //                if ([[[cardArray objectAtIndex:i] objectForKey:@"IsDeleted"] intValue] == 1) {
                //                    [cardArray removeObjectAtIndex:i];
                //                }
                //            }
                
                //            [cardArray replaceObjectAtIndex:alertView.tag withObject:cardDic];
                
                if ([[resObj objectForKey:@"isSuccess"] boolValue]) {
                    
                    if (![[resObj objectForKey:@"PaymentInformation"] isKindOfClass:[NSNull class]]) {
                        cardArray = [[NSMutableArray alloc] initWithArray:[resObj objectForKey:@"PaymentInformation"]];
                    }
                    for (NSDictionary *cardObj in cardArray) {
                        if ([[cardObj objectForKey:@"IsDeleted"] intValue]) {
                            [cardArray removeObject:cardObj];
                        }
                    }
                    [user setObject:cardArray forKey:@"PaymentInformation"];
                    [cardTbl reloadData];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Failed to delete card from your credit card list, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }
            }
        }];
    }
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

-(void)keyboardWasShown:(NSNotification *)notification{
    CGRect frm = self.view.frame;
    frm.origin.y = (frm.origin.y<0)?frm.origin.y:-250;
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
