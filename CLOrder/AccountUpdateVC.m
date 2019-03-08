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
    NSUserDefaults *user;
    NSDictionary *payThrough;
    PKPaymentButton *applePay;
    UIButton *payWithCard;
    UIButton *payPalBtn;
    UIButton *saveBtn;
    CGFloat paymentButtonsHeight;
    NSString *OrderId;

}

@synthesize paypalConfig, environment, resultText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:PRODUCTION_BAINTREE_AUTH];
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
    paymentButtonsHeight=200;
    cardTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-paymentButtonsHeight-64)];
    cardTbl.dataSource = self;
    cardTbl.delegate = self;
    
    
    applePay = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypePlain paymentButtonStyle:PKPaymentButtonStyleBlack];
    applePay.frame = CGRectMake(20, SCREEN_HEIGHT-195, SCREEN_WIDTH-40, 40);
    [applePay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applePay setBackgroundColor:APP_COLOR];
    applePay.tag=128;
    [applePay addTarget:self action:@selector(applePayBtnAct) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:applePay];
    [applePay setTitle:@"Apple pay" forState:UIControlStateNormal];
     applePay.titleLabel.font = APP_FONT_BOLD_18;
    
    payPalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payPalBtn.frame = CGRectMake(20, SCREEN_HEIGHT-145, SCREEN_WIDTH-40, 40);
    [payPalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payPalBtn setBackgroundColor:APP_COLOR];
    [payPalBtn addTarget:self action:@selector(payWithPaypal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payPalBtn];
    payPalBtn.tag=4;
    payPalBtn.titleLabel.font = APP_FONT_BOLD_18;
    [payPalBtn setTitle:@"Pay with PayPal" forState:UIControlStateNormal];
    payPalBtn.hidden = true;
    
    payWithCard = [UIButton buttonWithType:UIButtonTypeCustom];
    payWithCard.frame = CGRectMake(20, SCREEN_HEIGHT-95, SCREEN_WIDTH-40, 40);
    [payWithCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payWithCard setBackgroundColor:APP_COLOR];
    payWithCard.tag=2;
    [payWithCard addTarget:self action:@selector(payWithCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payWithCard];
    [payWithCard setTitle:@"Pay With Card" forState:UIControlStateNormal];
    payWithCard.titleLabel.font = APP_FONT_BOLD_18;
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(20, SCREEN_HEIGHT-45, SCREEN_WIDTH-40, 40);
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:APP_COLOR];
     saveBtn.tag=1;
    [saveBtn addTarget:self action:@selector(saveBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    saveBtn.titleLabel.font = APP_FONT_BOLD_18;
    
    [self showingPaymentButtonsBasedOnPymenySettings];
    cardTbl.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-paymentButtonsHeight-64);

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
-(void)showingPaymentButtonsBasedOnPymenySettings{
    [saveBtn setHidden:YES];
    [payPalBtn setHidden:YES];
    [payWithCard setHidden:YES];
    [applePay setHidden:YES];
    NSInteger paymentMode=[[user objectForKey:@"PaymentSetting"] integerValue];
    NSArray *values=@[@"128",@"64",@"32",@"16",@"8",@"4",@"2",@"1"];
    NSMutableArray *temp=[[NSMutableArray alloc] initWithCapacity:0];
    NSArray *buttons=@[saveBtn, payWithCard , payPalBtn, applePay];
    for(int i=0 ; i< values.count ; i++){
        if([[values objectAtIndex:i] integerValue] <= paymentMode){
            paymentMode=paymentMode-[[values objectAtIndex:i] integerValue];
            if([[values objectAtIndex:i] integerValue]==128 || [[values objectAtIndex:i] integerValue] == 4 || [[values objectAtIndex:i] integerValue] == 2 || [[values objectAtIndex:i] integerValue] == 1){
                [temp addObject:[values objectAtIndex:i]];
            }
            if(paymentMode == 0){
                [self enableRegardingButton:[[values objectAtIndex:i] integerValue]];
                break;
            }else{
                [self enableRegardingButton:[[values objectAtIndex:i] integerValue]];
            }
        }
    }
    paymentButtonsHeight=temp.count * 50;
    NSArray* reversedArray = [[temp reverseObjectEnumerator] allObjects];
    for(int i=0; i< reversedArray.count ; i++){
        if([[reversedArray objectAtIndex:i] integerValue] == 2){
            [self.view addSubview:cardTbl];
        }
        for(int j=0; j<buttons.count; j++){
            if([[reversedArray objectAtIndex:i] integerValue] == ((UIButton *)[buttons objectAtIndex:j]).tag){
                ((UIButton *)[buttons objectAtIndex:j]).frame=CGRectMake(20, SCREEN_HEIGHT-(((i+1)*50)-5), SCREEN_WIDTH-40, 40);
            }
        }
    }
}
-(void)enableRegardingButton:(NSInteger)paymentMode{
    switch (paymentMode) {
        case 1:
            [saveBtn setHidden:NO];
            break;
        case 2:
            [payWithCard setHidden:NO];
            break;
        case 4:
            [payPalBtn setHidden:NO];
            break;
        case 128:
            [applePay setHidden:NO];
            break;
        default:
            break;
    }
}
-(void) viewWillAppear:(BOOL)animated{
    cardArray = [[NSMutableArray alloc] initWithArray:[user objectForKey:@"PaymentInformation"]];
    [cardTbl reloadData];
}
-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) addCardBtnAct{
    AddCardVC *addCardView = [[AddCardVC alloc] init];
    addCardView.newCard = YES;
    [self.navigationController pushViewController:addCardView animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
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
        NSMutableArray *locationsary=[NSMutableArray arrayWithCapacity:0];
        for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:@"Locations"]) {
            NSDictionary *dic=[NSKeyedUnarchiver unarchiveObjectWithData:data];
            [locationsary addObject:dic];
        }
        if([locationsary count] > 1){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
-(void)payWithCard {
      if ([[CartObj instance].itemsForCart count]) {
          if (cardArray.count > 0){
              [user setObject:[NSNumber numberWithInteger:2] forKey:@"PaymentType"];
              payThrough = [[NSDictionary alloc] initWithDictionary:[cardArray objectAtIndex:0]];
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Pay bill trough card with card number: %@", [payThrough objectForKey:@"CreditCardNumber"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
              [alert setTag:5000];
              [alert show];
          }else{
            payThrough =[[NSDictionary alloc] init];
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please add cards for payment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
              [alert show];
          }
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
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate *orderDt = [[NSDate alloc] init];
    orderDt = [dateFormatter dateFromString:orderDtStr];
    NSString *timeStamp;
    timeStamp = [NSString stringWithFormat:@"%@", orderDt];
    timeStamp = [timeStamp substringToIndex:16];
    timeStamp = [timeStamp stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    
    
    bool isFutureOrder = NO;
    NSDateFormatter *formatForToday =  [[NSDateFormatter alloc] init];
    [formatForToday setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *currentDateStr = [formatForToday stringFromDate: [NSDate date]];
    NSDate *mydate = [formatForToday dateFromString:currentDateStr];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
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
                OrderId=[NSString stringWithFormat:@"%@",[resObj objectForKey:@"OrderId"]];
                if ([[user objectForKey:@"PaymentType"] intValue] == 4){
                    [self goForPayment:[NSString stringWithFormat:@"%@",[resObj objectForKey:@"OrderId"]]];
                }else if([[user objectForKey:@"PaymentType"] intValue] == 128){
                    [self goForApplePayment:[NSString stringWithFormat:@"%@",[resObj objectForKey:@"OrderId"]]];
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
-(void)applePayBtnAct{
    [user setObject:[NSNumber numberWithInteger:128] forKey:@"PaymentType"];
    payThrough = [[NSDictionary alloc] init];
    [self placeOrderReq:payThrough];
//    [self goForApplePayment:@"ApplePayorderID"];
}

-(void)goForPayment:(NSString *)orderId{
    
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
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:completedPayment.custom,@"OrderId",CLIENT_ID,@"ClientId",@"Success",@"PaymentResponse",[user objectForKey:@"PaymentType"],@"PaymentType",nil];
    [self sendCompletedPaymentToServer:dic]; // Payment was processed successfully; send to server for verification and fulfillment
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(NSDictionary *)dic{
    // TODO: Send completedPayment.confirmation to server
    [APIRequest confirmPaypalOrder:dic completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
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

//#pragma mark PayPalProfileSharingDelegate methods
- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    self.resultText = [profileSharingAuthorization description];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 5000 ) {
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
            }else{
                
                NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
                // handle the response here
                NSError *error = nil;
                NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"Response :\n %@",resObj);
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
-(void)goForApplePayment:(NSString *)orderId{
    if([PKPaymentAuthorizationViewController canMakePayments]){
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        request.countryCode = @"US";
        request.currencyCode = @"USD";
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantCapabilities = PKMerchantCapability3DS;
        request.merchantIdentifier = PRODUCTION_MERCHNAT;
        request.requiredShippingAddressFields=PKAddressFieldAll;
        request.shippingContact=[self addingAddresstoApplepay];
        
//        PKContact *contact = [[PKContact alloc] init];
//        NSPersonNameComponents *name = [[NSPersonNameComponents alloc] init];
//        name.givenName = orderId;
//        contact.name = name;
//
//        request.billingContact=contact;
//        PKPaymentSummaryItem *price = [PKPaymentSummaryItem summaryItemWithLabel:@"cartPrice" amount:[NSDecimalNumber decimalNumberWithString:[user objectForKey:@"cartPrice"]]];
        PKPaymentSummaryItem *tax = [PKPaymentSummaryItem summaryItemWithLabel:@"Tax" amount:[NSDecimalNumber decimalNumberWithString:[user objectForKey:@"TaxCost"]]];
        PKPaymentSummaryItem *discount = [PKPaymentSummaryItem summaryItemWithLabel:@"Discount" amount:[NSDecimalNumber decimalNumberWithString:[user objectForKey:@"DiscountAmount"]]];
        PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"Price" amount:[NSDecimalNumber decimalNumberWithString:[user objectForKey:@"SubTotal"]]];
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:[user objectForKey:@"cartPrice"]]];
        request.paymentSummaryItems = @[subtotal,tax,discount,total];
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        [self presentViewController:paymentPane animated:YES completion:nil];
    }else{
        NSLog(@"Can't Make payments");
    }
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion{
    NSLog(@"token %@", [payment.token description]);
    BTApplePayClient *applePayClient = [[BTApplePayClient alloc]
                                        initWithAPIClient:self.braintreeClient];
    [applePayClient tokenizeApplePayPayment:payment completion:^(BTApplePayCardNonce *tokenizedApplePayPayment, NSError *error) {
            if (tokenizedApplePayPayment) {
                // On success, send nonce to your server for processing.
                    // If applicable, address information is accessible in `payment`.
                        NSLog(@"nonce = %@", tokenizedApplePayPayment.nonce);
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                [dic setObject:CLIENT_ID forKey:@"ClientId"];
                [dic setObject:tokenizedApplePayPayment.nonce forKey:@"PaymentResponse"];
                [dic setObject:[user objectForKey:@"PaymentType"] forKey:@"PaymentType"];
                [dic setObject:OrderId forKey:@"OrderId"];
                [self sendCompletedPaymentToServer:dic];
                        // Then indicate success or failure via the completion callback, e.g.
                completion(PKPaymentAuthorizationStatusSuccess);
            
             } else {
                        // Tokenization failed. Check `error` for the cause of the failure.
                        // Indicate failure via the completion callback:
                            completion(PKPaymentAuthorizationStatusFailure);
            }
    }];
}
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKPaymentSummaryItem *> *summaryItems))completion{
    
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray<PKShippingMethod *> *shippingMethods,
                                                     NSArray<PKPaymentSummaryItem *> *summaryItems))completion{
    
}
-(PKContact *)addingAddresstoApplepay{
    NSPersonNameComponents *name = [[NSPersonNameComponents alloc] init];
    name.givenName = [[CartObj instance].userInfo objectForKey:@"FullName"];
    
    CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
    address.street = [[[CartObj instance].userInfo objectForKey:@"UserAddress"] objectForKey:@"Address1"];
    address.city = [[[CartObj instance].userInfo objectForKey:@"UserAddress"] objectForKey:@"City"];
    address.postalCode = [[[CartObj instance].userInfo objectForKey:@"UserAddress"] objectForKey:@"ZipPostalCode"];
    
    CNPhoneNumber *phone = [[CNPhoneNumber alloc] initWithStringValue:[[[CartObj instance].userInfo objectForKey:@"UserAddress"] objectForKey:@"PhoneNumber"]];

    PKContact *contact = [[PKContact alloc] init];
    contact.name = name;
    contact.emailAddress=[[CartObj instance].userInfo objectForKey:@"Email"];
    contact.postalAddress=address;
    contact.phoneNumber=phone;
    
    return contact;
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
