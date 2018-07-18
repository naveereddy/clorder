//
//  CheckOut.m
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "CheckOut.h"
#import "AppHeader.h"
#import "AllDayMenuVC.h"
#import "AddCardVC.h"
#import "APIRequest.h"
#import "ViewCouponVC.h"
#import "CartObj.h"
#import "AddItem.h"
#import "AccountUpdateVC.h"
#import "AllDayMenuVC.h"
//#import "ScheduleView.h"
#import "Schedular.h"
#import "LoginVC.h"

@implementation CheckOut{
    NSArray *tipArray;
    UITextField *tipTxt;
    CGFloat subTotal;

    UILabel *totalLbl;
    UITextField *userTip;
    UITextView *spclNote;
    double total;
    double discountAmnt;
    double deliveryAmnt;
    double taxAmnt;
    double tipAmnt;
    NSUserDefaults *user;
    
    UIButton *pickupBtn;
    UIButton *deliveryBtn;
    
    bool fetchTaxFailed;
    bool fetchDeliveryFailed;
    UIButton *addItemBtn;
    UIButton *checkOutBtn;
    UIView *lblView;
    NSInteger weekdayNumber;
    BOOL couponApplied;
    UIView *dummyV;
}
@synthesize couponId, orderId;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"YOUR FOOD ORDER";
    user = [NSUserDefaults standardUserDefaults];
//    NSLog(@"%@", [CartObj instance].itemsForCart);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[CartObj instance].itemsForCart
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    }
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    self.navigationItem.hidesBackButton = YES;
    
    pickupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pickupBtn.frame = CGRectMake(0, 64, SCREEN_WIDTH/2, 50);
    [pickupBtn addTarget:self action:@selector(pickupBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [pickupBtn.titleLabel setFont:APP_FONT_REGULAR_16];
    
    deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deliveryBtn.frame = CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2, 50);
    [deliveryBtn addTarget:self action:@selector(deliveryBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [deliveryBtn.titleLabel setFont:APP_FONT_REGULAR_16];
    
    if([[user objectForKey:@"DeliveryType"] integerValue] == 4){
        [self.view addSubview:pickupBtn];
        [self.view addSubview:deliveryBtn];
    }else if([[user objectForKey:@"DeliveryType"] integerValue] == 1){
        pickupBtn.frame=CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH/4), 64, SCREEN_WIDTH/2, 50);
        [self.view addSubview:pickupBtn];
    }else if([[user objectForKey:@"DeliveryType"] integerValue] == 2){
        deliveryBtn.frame=CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH/4), 64, SCREEN_WIDTH/2, 50);
        [self.view addSubview:deliveryBtn];
    }
    if ([[user objectForKey:@"OrderType"] intValue] == 2) {
        [pickupBtn setBackgroundColor:[UIColor grayColor]];
        [pickupBtn setImage:[UIImage imageNamed:@"Pickup_unselect"] forState:UIControlStateNormal];
        [deliveryBtn setImage:[UIImage imageNamed:@"delivery_select"] forState:UIControlStateNormal];
        [deliveryBtn setBackgroundColor:APP_GREEN_COLOR];
    }else if([[user objectForKey:@"OrderType"] intValue] == 1){
        [deliveryBtn setBackgroundColor:[UIColor grayColor]];
        [pickupBtn setBackgroundColor:APP_GREEN_COLOR];
        [pickupBtn setImage:[UIImage imageNamed:@"Pickup_select"] forState:UIControlStateNormal];
        [deliveryBtn setImage:[UIImage imageNamed:@"delivery_unselect"] forState:UIControlStateNormal];
    }else{
        [deliveryBtn setBackgroundColor:[UIColor grayColor]];
        [pickupBtn setBackgroundColor:APP_GREEN_COLOR];
        [pickupBtn setImage:[UIImage imageNamed:@"Pickup_select"] forState:UIControlStateNormal];
        [deliveryBtn setImage:[UIImage imageNamed:@"delivery_unselect"] forState:UIControlStateNormal];
        [user setObject:[NSNumber numberWithInt:1] forKey:@"OrderType"];
    }
    
    lblView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, 50)];
    lblView.backgroundColor = APP_COLOR_LIGHT_BACKGROUND;
    [self.view addSubview:lblView];
    
    UILabel *items = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2-20, 50)];
    [lblView addSubview:items];
    items.text = @"Order Summary";
    items.textColor = DARK_GRAY;
    items.font = APP_FONT_BOLD_18;
    
    UILabel *lnL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, 2, 30)];
//    [lblView addSubview:lnL];
    lnL.backgroundColor = [UIColor whiteColor];
    
    UILabel *qty = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+2, 0, SCREEN_WIDTH/4-15, 50)];
//    [lblView addSubview:qty];
    qty.text = @"QTY";
    qty.textColor = [UIColor whiteColor];
    qty.textAlignment = NSTextAlignmentCenter;
    qty.font = APP_FONT_BOLD_16;
    
    UILabel *lnR = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+qty.frame.size.width+2, 10, 2, 30)];
//    [lblView addSubview:lnR];
    lnR.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+qty.frame.size.width+4, 0, SCREEN_WIDTH/4-4, 50)];
//    [lblView addSubview:price];
    price.text = @"PRICE";
    price.textColor = [UIColor whiteColor];
    price.textAlignment = NSTextAlignmentCenter;
    price.font = APP_FONT_BOLD_16;
    subTotal = [user objectForKey:@""]?[[user objectForKey:@""] doubleValue]:0.0;
    discountAmnt = 0.0;
    deliveryAmnt = ([[user objectForKey:@"DeliverCharge"] doubleValue] && [[user objectForKey:@"OrderType"] integerValue]==2) ? [[user objectForKey:@"DeliverCharge"] doubleValue]: 0.0;
    taxAmnt = 0.0;
   //tipAmnt = 0.0;
    total = 0.0;
    
    addItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addItemBtn.frame = CGRectMake(SCREEN_WIDTH/2-75, SCREEN_HEIGHT-90, 150, 30);
    addItemBtn.layer.cornerRadius = 3.0;
    [addItemBtn setBackgroundColor:APP_COLOR];
    [addItemBtn setTitle:@"ADD MORE" forState:UIControlStateNormal];
    [addItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addItemBtn addTarget:self action:@selector(addItemBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addItemBtn];
    addItemBtn.titleLabel.font = APP_FONT_REGULAR_16;
    
    checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkOutBtn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [checkOutBtn setBackgroundColor:APP_COLOR];
    [checkOutBtn setTitle:@"CHECKOUT" forState:UIControlStateNormal];
    [checkOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkOutBtn addTarget:self action:@selector(proceedForOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkOutBtn];
    checkOutBtn.titleLabel.font = APP_FONT_REGULAR_16;
    
    userTip = [[UITextField alloc] init];

    tipArray = [[NSArray alloc] initWithObjects:@"10", @"15", @"20", @"25", @"In Cash", @"Other", nil];
    UIToolbar *optionPickerTool=[[UIToolbar alloc]init];
    
    optionPickerTool.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(sendAction)];
    [optionPickerTool setItems:[[NSArray alloc] initWithObjects:button1, nil]];
    
    
    picker = [[UIPickerView alloc]init];
    picker.dataSource = self;
    picker.delegate = self;
    
    [picker selectRow:[[user objectForKey:@"TipIndex"] intValue] inComponent:0 animated:YES];
    tipTxt = [[UITextField alloc] init];
    tipTxt.inputView = picker;
    tipTxt.inputAccessoryView=optionPickerTool;
    
    NSLog(@"%@\n%@", [user objectForKey:@"TipIndex"],[user objectForKey:@"DefaultTip"]);
    if ([user objectForKey:@"TipIndex"]) {
        if ([[user objectForKey:@"TipIndex"] intValue] > 3) {
            tipTxt.text=[NSString stringWithFormat:@"%@",[tipArray objectAtIndex:[[user objectForKey:@"TipIndex"] intValue]]];
        }else{
            tipTxt.text=[NSString stringWithFormat:@"%@%%",[tipArray objectAtIndex:[[user objectForKey:@"TipIndex"] intValue]]];
        }
        
        
    }else{
        if ([user objectForKey:@"DefaultTip"] && [[user objectForKey:@"DefaultTip"] doubleValue] == 0.0) {
            tipTxt.text=[NSString stringWithFormat:@"%@%%",[tipArray objectAtIndex:0]];
            [user setObject:[NSNumber numberWithInt:0] forKey:@"TipIndex"];
            [picker selectRow:0 inComponent:0 animated:YES];

        }else{
            tipTxt.text=[NSString stringWithFormat:@"%@",[tipArray objectAtIndex:4]];
            userTip.text = [NSString stringWithFormat:@"%.2lf", [[user objectForKey:@"DefaultTip"] doubleValue]];
            [user setObject:[NSNumber numberWithInt:4] forKey:@"TipIndex"];
            [picker selectRow:4 inComponent:0 animated:YES];

            tipAmnt = [[user objectForKey:@"DefaultTip"] doubleValue];
        }
           
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if ([CartObj instance].itemsForCart.count) {
        
        orderTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 165, SCREEN_WIDTH, SCREEN_HEIGHT-100-165)];
        orderTbl.delegate = self;
        orderTbl.dataSource = self;
        orderTbl.separatorColor = [UIColor lightGrayColor];
        [self.view addSubview:orderTbl];
        //        NSLog(@"**************\n\n%@",[CartObj instance].itemsForCart);
        
        [self subTotalCalc];
        tipAmnt = [self tipCalc];
        total = subTotal - discountAmnt+[self tipCalc];
        [CartObj instance].cartPrice = [NSString stringWithFormat:@"%0.2f", total];
    }else{
        [self emptyCartMsg];
    }
    
}

-(void)pickupBtnAct{
    if(![CartObj checkPickupDelivery:YES])
        return;
    [user setObject:[NSNumber numberWithInt:1] forKey:@"OrderType"];
    deliveryAmnt = 0.0;
    [deliveryBtn setBackgroundColor:[UIColor grayColor]];
    [pickupBtn setBackgroundColor:APP_GREEN_COLOR];
    [pickupBtn setImage:[UIImage imageNamed:@"Pickup_select"] forState:UIControlStateNormal];
    [deliveryBtn setImage:[UIImage imageNamed:@"delivery_unselect"] forState:UIControlStateNormal];
    [self applyCouponAct];
    [orderTbl reloadData];
    if ([[user objectForKey:@"OrderType"] intValue] !=1) {
        [user removeObjectForKey:@"OrderDate"];
        [[CartObj instance].userInfo removeObjectForKey:@"OrderDate"];
        [[CartObj instance].userInfo removeObjectForKey:@"timeArr"];
    }
    [self checkOutBtnAct];
}

-(void)deliveryBtnAct{
    if(![CartObj checkPickupDelivery:NO])
        return;
    if (![[user objectForKey:@"DeliveryClosed"] boolValue]) {
        if ((subTotal < [[user objectForKey:@"MinDelivery"] doubleValue]) && [[[CartObj instance]itemsForCart] count]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"For delivery orders, Subtotal should be greater than $%.2lf.", [[user objectForKey:@"MinDelivery"] doubleValue]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }else{
            [self requestDelivery];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Delivery is closed at the moment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if ([[user objectForKey:@"OrderType"] intValue] == 3) {
        [self getOrderDetailsForReorder];
    }
    [user setObject:[NSNumber numberWithBool:0] forKey:@"AddMore"];
    NSDate *now = [NSDate date];
    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
    [nowDateFormatter setDateFormat:@"e"];
    weekdayNumber = (NSInteger)[[nowDateFormatter stringFromDate:now] integerValue]-1;
    
    discountAmnt = 0.0;
    if ([CartObj instance].itemsForCart.count) {
        [self subTotalCalc];
        [self tipCalc];
        [orderTbl setHidden:NO];
        [checkOutBtn setHidden:NO];
        [pickupBtn setHidden:NO];
        [deliveryBtn setHidden:NO];
        [lblView setHidden:NO];
        [[self.view viewWithTag:999] removeFromSuperview];
//        [orderTbl reloadData];
    }
}

-(void)getOrderDetailsForReorder{
    [APIRequest getOrderDetailsForReorder:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"ClientID", orderId, @"OrderId", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
        }
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    total = subTotal-discountAmnt+deliveryAmnt+taxAmnt+[[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue];
//    [user setObject:[totalLbl.text stringByReplacingOccurrencesOfString:@"$"
//                                                             withString:@""] forKey:@"cartPrice"];
    [user setObject:[NSString stringWithFormat:@"%.2lf", total] forKey:@"cartPrice"];
    [user setObject:[NSString stringWithFormat:@"%0.2lf", discountAmnt] forKey:@"DiscountAmount"];
    [user setObject:[NSString stringWithFormat:@"%0.2lf", subTotal] forKey:@"SubTotal"];
    [user setObject:[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"TipAmount"];
    [user setObject:[NSString stringWithFormat:@"%0.2lf", taxAmnt] forKey:@"TaxCost"];
    [user setObject:[NSString stringWithFormat:@"%0.2lf", deliveryAmnt] forKey:@"ShippingCost"];

}
-(CGFloat)tipCalc{
    tipAmnt = (subTotal*[[tipTxt.text substringToIndex:tipTxt.text.length-1] intValue]/100);
    if ([[user objectForKey:@"TipIndex"] intValue] == 5) {
        userTip.text = [NSString stringWithFormat:@"$%.2lf", [[user objectForKey:@"TipAmount"] doubleValue]];
    }
    
    [orderTbl reloadData];
    return  (subTotal*[[tipTxt.text substringToIndex:tipTxt.text.length-1] intValue]/100);
}
-(void)subTotalCalc{
    subTotal = 0.0;
    for (int i = 0; i < ([CartObj instance].itemsForCart.count); i++) {
        NSArray *modifierArr = [[NSArray alloc] initWithArray:[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"]];
        double modifierPrice = 0.0;
        for (int j = 0; j < [modifierArr count]; j++) {
            for (int k = 0; k < [[[modifierArr objectAtIndex:j] objectForKey:@"Options"] count]; k++) {
                if ([[[[[modifierArr objectAtIndex:j] objectForKey:@"Options"] objectAtIndex:k] objectForKey:@"Default"] intValue] &&
                    ![[[[[modifierArr objectAtIndex:j] objectForKey:@"Options"] objectAtIndex:k] objectForKey:@"Price"] isKindOfClass:[NSNull class]]) {
                    modifierPrice = modifierPrice + [[[[[modifierArr objectAtIndex:j] objectForKey:@"Options"] objectAtIndex:k] objectForKey:@"Price"] doubleValue];
                }
            }
        }
        
        subTotal = subTotal + (modifierPrice + [[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Price"] doubleValue] )* [[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Quantity"] intValue];
    }
    [user setObject:[NSString stringWithFormat:@"%.2f", subTotal] forKey:@"subTotalPrice"];
    [self requestTax];
    if ([[user objectForKey:@"OrderType"] intValue] == 2 && [[user objectForKey:@"ShippingOptionId"] intValue] == 4) {
        if ((subTotal < [[user objectForKey:@"MinDelivery"] doubleValue]) && [[[CartObj instance]itemsForCart] count]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"For delivery orders, Subtotal should be greater than $%.2lf.", [[user objectForKey:@"MinDelivery"] doubleValue]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }else{
            [self requestDelivery];
        }
        
    }
    [self applyCouponAct];
}


-(void)requestDelivery{
    
    NSDictionary *reqDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                            CLIENT_ID, @"clientId",
                            [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"Address1"], @"Address1",
                            [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"Address2"], @"Address2",
                            [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"City"], @"cityname",
                            [[[user objectForKey:@"userInfo"] objectForKey:@"UserAddress"] objectForKey:@"ZipPostalCode"], @"zipcode",
                            [NSString stringWithFormat:@"%.2lf", subTotal], @"SubTotal",
                            nil];
    
    [APIRequest fetchDeliveryFees:reqDic completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            fetchDeliveryFailed = YES;
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
            if ([[resObj objectForKey:@"isSuccess"] boolValue]) {
                
                if ([[user objectForKey:@"OrderType"] intValue] !=2) {
                    [user removeObjectForKey:@"OrderDate"];
                    [[CartObj instance].userInfo removeObjectForKey:@"OrderDate"];
                    [[CartObj instance].userInfo removeObjectForKey:@"timeArr"];
                }
                [user setObject:[NSNumber numberWithInt:2] forKey:@"OrderType"];
                [self applyCouponAct];
                [self checkOutBtnAct];
                
                [pickupBtn setBackgroundColor:[UIColor grayColor]];
                [deliveryBtn setBackgroundColor:APP_GREEN_COLOR];
                
                [pickupBtn setImage:[UIImage imageNamed:@"Pickup_unselect"] forState:UIControlStateNormal];
                [deliveryBtn setImage:[UIImage imageNamed:@"delivery_select"] forState:UIControlStateNormal];
                
                deliveryAmnt = [[resObj objectForKey:@"DeliverCharge"] doubleValue];
                [user setObject:[resObj objectForKey:@"DeliveryDist"] forKey:@"DeliveryDist"];
                [user setObject:[resObj objectForKey:@"DeliverCharge"] forKey:@"DeliverCharge"];
                [orderTbl reloadData];
                fetchDeliveryFailed = NO;
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [resObj objectForKey:@"status"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

-(void)requestTax{
    [APIRequest fetchTaxForOrder:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", [NSString stringWithFormat:@"%lf", subTotal], @"SubTotal", [NSString stringWithFormat:@"%.2lf", discountAmnt], @"DiscountAmount", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            fetchTaxFailed = YES;
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            fetchTaxFailed = NO;
            taxAmnt = [[resObj objectForKey:@"TaxAmount"] doubleValue];
            [orderTbl reloadData];
        }
    }];
}

-(void)getCouponId:(NSDictionary *)couponIdFromCpnVC{
    [user setObject:couponIdFromCpnVC forKey:@"CouponDetails"];
    couponId = [[NSDictionary alloc] initWithDictionary:couponIdFromCpnVC];
    if (!couponId ) {
        couponTxt.text = @"";
    }else{
        couponTxt.text = [NSString stringWithFormat:@"%@", [couponIdFromCpnVC objectForKey:@"Title"]];
    }
    [self applyCouponAct];
//    NSLog(@"%@", [user objectForKey:@"CouponDetails"]);
}


-(void) leftBarAct{
    
    NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
    int index = 0;
    for (UIViewController *vc in vcArr) {
        if ([vc isKindOfClass:[AllDayMenuVC class]]) {
            break;
        }
        index++;
    }
    if(index < vcArr.count)
        [self.navigationController popToViewController:[vcArr objectAtIndex:index]  animated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 50.0;
    }else
        return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (section==1) {
        UILabel *dummyLineTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, 2)];
        dummyLineTop.backgroundColor = [UIColor whiteColor];
        [header addSubview:dummyLineTop];
        
        UILabel *dummyLineBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, 2)];
        dummyLineBottom.backgroundColor = [UIColor whiteColor];
        [header addSubview:dummyLineBottom];
        
        spclNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, header.frame.size.height-10)];
        spclNote.font = APP_FONT_REGULAR_14;
        spclNote.backgroundColor = [UIColor groupTableViewBackgroundColor];
        spclNote.textColor = [UIColor grayColor];
        spclNote.text = @"Special Notes...\n(Example: Make it less spicy.)";
        spclNote.delegate = self;
        [header addSubview:spclNote];
    }
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [[CartObj instance].itemsForCart count];
    }else
        return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self heightForRow:indexPath]+10;
    }else
        return 35.0;
}

-(CGFloat)heightForRow:(NSIndexPath *)indexPath{
    NSMutableString *selectionStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", [self getDescStr:indexPath]]];
    
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",selectionStr] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :APP_FONT_REGULAR_14} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/14; i++){
        gap++;
    }
    return labelHeight.size.height+gap*4;
}

-(NSMutableString *)getDescStr:(NSIndexPath *)indexPath{
    NSMutableString *selectionStr = [NSMutableString stringWithString:@""] ;
    
    if( [[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]){
        for (int i = 0; i < [[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]; i++) {
            NSMutableString *tempTitleStr = [NSMutableString stringWithString:@""];
            
            if ([[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]) {
                NSMutableString *tempModifierStr = [NSMutableString stringWithString:@""];
                
                for (int j = 0; j < [[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]; j++) {
                    
                    
                    if (([[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Default"] intValue] ==1) &&
                        (![[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Title"] isKindOfClass:[NSNull class]])) {
                        
                        [tempModifierStr appendString:[NSString stringWithFormat:@" %@,",[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Title"]]];
                        
                    }
                }
                if ([tempModifierStr length] > 0) {
                    tempTitleStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@ %@",[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Name"], tempModifierStr]];
                    tempTitleStr = [NSMutableString stringWithString: [tempTitleStr substringToIndex:[tempTitleStr length]-1]];
                }
                
            }
            if ([tempTitleStr length] > 0) {
                [selectionStr appendString:[NSString stringWithFormat:@"%@\n", tempTitleStr]];
            }
            
        }
        
    }
    return selectionStr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if(indexPath.section == 0) {
        UILabel *itemName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2-10, 20)];
        [cell.contentView addSubview:itemName];
        UILabel *itemDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH-20, [self heightForRow:indexPath])];
        [cell.contentView addSubview:itemDesc];
        itemDesc.numberOfLines = 0;
        itemDesc.textColor =[UIColor lightGrayColor];
        itemDesc.font = APP_FONT_REGULAR_14;
        
        itemName.text = [NSString stringWithFormat:@"%@", [[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Title"]];
        NSMutableString *selectionStr = [self getDescStr:indexPath];
        itemName.font = APP_FONT_BOLD_16;
        
        itemDesc.text = [NSString stringWithFormat:@"%@", selectionStr];
        
        UILabel *quantity = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 5, SCREEN_WIDTH/4-20, 25)];
        [cell.contentView addSubview:quantity];
        quantity.text = [NSString stringWithFormat:@"%@",[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Quantity"]];
        quantity.textAlignment = NSTextAlignmentCenter;
        quantity.layer.borderWidth = 1.0;
        quantity.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [cell.contentView addSubview:quantity];
        quantity.font = APP_FONT_BOLD_16;
        
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4-15, 5, SCREEN_WIDTH/4-15, 25)];
        [cell.contentView addSubview:priceLbl];
        priceLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:priceLbl];
        priceLbl.font = APP_FONT_BOLD_16;
        
        CGFloat itemPrice = [[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Price"] doubleValue];
        
        if ([[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]) {
            for (int i = 0; i < [[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] count]; i++) {
                
                if ([[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] count]) {
                    for (int j = 0; j < [[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] count]; j++) {
                        
                        if ([[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Default"] integerValue]) {
                            
                            if (![[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] isKindOfClass:[NSNull class]]) {
                                
                                itemPrice = itemPrice +[[[[[[[[[CartObj instance].itemsForCart objectAtIndex:indexPath.row] objectForKey:@"Modifiers"] objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] doubleValue] ;
                            }
                        }
                    }
                }
                
            }
        }
        
        priceLbl.text = [NSString stringWithFormat:@"$%.2f", itemPrice * [quantity.text intValue]];
        //        subTotal = subTotal+(itemPrice * [quantity.text intValue]);
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH-32, 0, 30, 30);
        [deleteBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTag:(100+indexPath.row)];
        [cell.contentView addSubview:deleteBtn];
        
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, SCREEN_WIDTH/2+SCREEN_WIDTH/4-30, 25)];
        leftLbl.textAlignment = NSTextAlignmentLeft;
        leftLbl.font = APP_FONT_BOLD_16;
        UILabel *rightLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4-15, 3, SCREEN_WIDTH/4, 25)];
        rightLbl.textAlignment = NSTextAlignmentCenter;
        rightLbl.font = APP_FONT_REGULAR_16;
        rightLbl.font = APP_FONT_BOLD_16;
        if (indexPath.row == 1) {
            
            UIButton *applyCoupon = [UIButton buttonWithType:UIButtonTypeCustom];
            applyCoupon.frame = CGRectMake(10, 2, SCREEN_WIDTH/3-10, 28);
            [applyCoupon setBackgroundColor:APP_GREEN_COLOR];
            [applyCoupon setTitle:@"Apply Coupon" forState:UIControlStateNormal];
            [applyCoupon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [applyCoupon addTarget:self action:@selector(applyCouponAct) forControlEvents:UIControlEventTouchUpInside];
            applyCoupon.titleLabel.font = APP_FONT_BOLD_14;
            [cell.contentView addSubview:applyCoupon];
            
            UIButton *viewCoupon = [UIButton buttonWithType:UIButtonTypeCustom];
            viewCoupon.frame = CGRectMake(SCREEN_WIDTH/3+5, 2, SCREEN_WIDTH/3-10, 28);
            [viewCoupon setBackgroundColor:[UIColor lightGrayColor]];
            [viewCoupon setTitle:@"View Coupons" forState:UIControlStateNormal];
            [viewCoupon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [viewCoupon addTarget:self action:@selector(viewCouponAct) forControlEvents:UIControlEventTouchUpInside];
            viewCoupon.titleLabel.font = APP_FONT_BOLD_14;
            
            [cell.contentView addSubview:viewCoupon];
            
            couponTxt = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+SCREEN_WIDTH/3+2, 2, SCREEN_WIDTH/3-10, 28)];
            [cell.contentView addSubview:couponTxt];
            couponTxt.placeholder = @"Coupon Code";
            couponTxt.textColor = [UIColor blackColor];
            couponTxt.textAlignment = NSTextAlignmentCenter;
            couponTxt.layer.borderWidth = 1.0;
            couponTxt.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            if ([user objectForKey:@"CouponDetails"]) {
                couponTxt.text = [NSString stringWithFormat:@"%@", [[user objectForKey:@"CouponDetails"] objectForKey:@"Title"]];
            }
            
            couponTxt.delegate = self;
            couponTxt.font = APP_FONT_BOLD_14;
            
        }else{
            [cell.contentView addSubview:leftLbl];
            [cell.contentView addSubview:rightLbl];
        }
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        UIButton *dropDnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        switch (indexPath.row) {
            case 0:
                leftLbl.text = [NSString stringWithFormat:@"%@",@"Subtotal"];
                leftLbl.textColor = [UIColor blackColor];
                //[self subTotalCalc];
                rightLbl.text = [NSString stringWithFormat:@"$%0.2lf",subTotal];
                break;
                
            case 1:
                leftLbl.text = [NSString stringWithFormat:@"%@",@"Apply Coupon"];
                leftLbl.backgroundColor = [UIColor colorWithRed:119/255.0 green:194/255.0 blue:47/255.0 alpha:1.0];
                leftLbl.textColor = [UIColor whiteColor];
                
                break;
                
            case 2:
                leftLbl.text = [NSString stringWithFormat:@"%@",@"Tax"];
                leftLbl.textColor = [UIColor blackColor];
                
                rightLbl.text = [NSString stringWithFormat:@"$%.2lf",taxAmnt];
                break;
                
            case 3:
                leftLbl.text = [NSString stringWithFormat:@"%@",@"Delivery Charge"];
                leftLbl.textColor = [UIColor blackColor];
                
                rightLbl.text = [NSString stringWithFormat:@"$%.2lf", deliveryAmnt];
                break;
                
            case 4:
                leftLbl.text = [NSString stringWithFormat:@"%@",@"Tip"];
                //                leftLbl.backgroundColor = [UIColor colorWithRed:38/255.0 green:189/255.0 blue:241/255.0 alpha:1.0];
                leftLbl.textColor = [UIColor blackColor];
                leftLbl.frame = CGRectMake(10, 3, SCREEN_WIDTH/3-5, 25);
                
                tipTxt.frame = CGRectMake(SCREEN_WIDTH/3+5, 2, SCREEN_WIDTH/3-35, 28);
                tipTxt.textAlignment = NSTextAlignmentCenter;
                tipTxt.textColor = DARK_GRAY;
                tipTxt.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                tipTxt.layer.borderWidth = 1.0;
                [cell.contentView addSubview:tipTxt];
                
                
                dropDnBtn.frame = CGRectMake(SCREEN_WIDTH/3+5+SCREEN_WIDTH/3-35, 2, 30, 28);
                [dropDnBtn setImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
                dropDnBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                dropDnBtn.layer.borderWidth = 1.0;
                dropDnBtn.backgroundColor = [UIColor lightGrayColor];
                [dropDnBtn addTarget:self action:@selector(dropDnBtnAct) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:dropDnBtn];
                
                userTip.frame = CGRectMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4-15, 3, SCREEN_WIDTH/4, 25);
                [cell.contentView addSubview:userTip];
                userTip.delegate = self;
                if ([[user objectForKey:@"TipIndex"] intValue] == 5) {
                    userTip.text = [NSString stringWithFormat:@"$%.2lf", [[user objectForKey:@"TipAmount"] doubleValue]];
                }else{
                    userTip.text = [NSString stringWithFormat:@"$%.2f", tipAmnt];
                }
                
                userTip.textAlignment = NSTextAlignmentCenter;
                userTip.layer.borderWidth = 1.0;
                userTip.layer.borderColor = [[UIColor clearColor] CGColor];
                
                numberToolbar.barStyle = UIBarStyleBlackTranslucent;
                numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                                        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
                [numberToolbar sizeToFit];
                userTip.inputAccessoryView = numberToolbar;
                
                //                rightLbl.text = [NSString stringWithFormat:@"%@",@"$2.0"];
                break;
                
            case 5:
                leftLbl.text = [NSString stringWithFormat:@"%@",@"Discount"];
                leftLbl.textColor = [UIColor blackColor];
                
                rightLbl.text = [NSString stringWithFormat:@"-$%0.2lf",discountAmnt];
                
                break;
                
            case 6:
                leftLbl.text = [NSString stringWithFormat:@"%@",@"Total"];
                leftLbl.textColor = DARK_GRAY;
                totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4-15, 3, SCREEN_WIDTH/4, 25)];
                totalLbl.textAlignment = NSTextAlignmentCenter;
                
                totalLbl.text = [NSString stringWithFormat:@"$%.2lf",subTotal-discountAmnt+deliveryAmnt+taxAmnt+[[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]];
                totalLbl.textColor = DARK_GRAY;
                totalLbl.font = APP_FONT_BOLD_16;
                [cell.contentView  addSubview:totalLbl];
                [CartObj instance].cartPrice =  [totalLbl.text stringByReplacingOccurrencesOfString:@"$"
                                                                                         withString:@""];
                //                NSLog(@"%@",  [CartObj instance].cartPrice);
                
                break;
        }
        
    }
    
    return  cell;
}
-(void)dropDnBtnAct{
    [tipTxt becomeFirstResponder];
}
-(void)cancelNumberPad{
    totalLbl.text = [NSString stringWithFormat:@"$%.2lf",subTotal-discountAmnt+deliveryAmnt+taxAmnt+[[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]];
    [CartObj instance].cartPrice =  [totalLbl.text stringByReplacingOccurrencesOfString:@"$"
                                                                             withString:@""];
    
    [userTip resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [orderTbl deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0){
        [user setObject:[NSNumber numberWithBool:1] forKey:@"AddMore"];
        AddItem *addItemV = [[AddItem alloc] init];
        addItemV.item = [[CartObj instance].itemsForCart objectAtIndex:indexPath.row];
        addItemV.replaceIndex = (int)indexPath.row;
        [self.navigationController pushViewController:addItemV animated:YES];
//        NSLog(@"%@", [[CartObj instance].itemsForCart objectAtIndex:indexPath.row]);
        
    }
    //    [self.navigationController pushViewController:] animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return tipArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [tipArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    userTip.layer.borderColor = [[UIColor clearColor] CGColor];
    [user setObject:[NSString stringWithFormat:@"%ld", (long)row] forKey:@"TipIndex"];
    if((row == ([tipArray count]-1)) ||(row == ([tipArray count]-2))) {
        tipTxt.text = [NSString stringWithFormat:@"%@",[tipArray objectAtIndex:row]];
        tipAmnt = [self tipCalc];
        userTip.text = [NSString stringWithFormat:@"$%.2f", tipAmnt];
        
        if (row == ([tipArray count]-1)) {
            userTip.layer.borderColor = [APP_COLOR CGColor];
            totalLbl.text = [NSString stringWithFormat:@"$%.2lf",subTotal-discountAmnt+deliveryAmnt+taxAmnt+[[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]];;
            
        }else{
            totalLbl.text = [NSString stringWithFormat:@"$%.2lf",subTotal-discountAmnt+deliveryAmnt+taxAmnt+[[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]];
        }
    }else{
        tipTxt.text = [NSString stringWithFormat:@"%@%%",[tipArray objectAtIndex:row]];
        userTip.text = [NSString stringWithFormat:@"$%.2f", [self tipCalc]];
        totalLbl.text = [NSString stringWithFormat:@"$%.2lf",subTotal-discountAmnt+deliveryAmnt+taxAmnt+[[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]];
    }
    [CartObj instance].cartPrice =  [totalLbl.text stringByReplacingOccurrencesOfString:@"$"
                                                                             withString:@""];
    [user setObject:[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"TipAmount"];

}

-(void)sendAction{
    [tipTxt resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == userTip) {
        totalLbl.text = [NSString stringWithFormat:@"$%.2lf",subTotal-discountAmnt+deliveryAmnt+taxAmnt+[[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]];
        [CartObj instance].cartPrice =  [totalLbl.text stringByReplacingOccurrencesOfString:@"$"
                                                                                 withString:@""];
        [user setObject:[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"TipAmount"];

    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == userTip) {
        [user setObject:[NSNumber numberWithInt:5] forKey:@"TipIndex"];

        textField.keyboardType = UIKeyboardTypeNumberPad;
        tipTxt.text = [NSString stringWithFormat:@"%@",[tipArray objectAtIndex:[tipArray count]-1]];
        if ([userTip.text doubleValue] == 0) {
            userTip.text = @"00.00";
        }
        userTip.layer.borderColor = [APP_COLOR CGColor];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [user setObject:[userTip.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"TipAmount"];

    if ([string length]) {
        if (([string characterAtIndex:0] < 48) || ([string characterAtIndex:0] > 57)) {
            return NO;
        }
    }
    
    if (range.location>=5) {
        return NO;
    }
    
    NSMutableString *tmpStr = [NSMutableString stringWithString: textField.text];
    if ((range.location == 1) && (range.length == 1)) {
        return YES;
    }
    if (([tmpStr length]==2)) {
        [tmpStr appendString:[NSString stringWithFormat:@"."]];
    }
    textField.text = [NSString stringWithFormat:@"%@", tmpStr];
    if (([textField.text doubleValue] <= 99.99) && ([textField.text doubleValue] >= 0.0)){
        return YES;
    }else{
        return NO;
    }

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


-(void)deleteBtnAct:(UIButton *)sender{
//    NSLog(@"%ld",(long)sender.tag);
    [[CartObj instance].itemsForCart removeObjectAtIndex:sender.tag%100];
    NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
    for (NSDictionary *personObject in [CartObj instance].itemsForCart) {
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:personObject];
        [archiveArray addObject:personEncodedObject];
    }
    [user setObject:archiveArray forKey:@"cart"];
    if ([CartObj instance].itemsForCart.count) {
//        subTotal = 0.0;
        [self subTotalCalc];
        [self tipCalc];
        [orderTbl reloadData];
    }else{
        [self emptyCartMsg];
//        [CartObj clearInstance];
        [user removeObjectForKey:@"cart"];
        [user removeObjectForKey:@"cartPrice"];
        [user removeObjectForKey:@"subTotalPrice"];
        [user removeObjectForKey:@"CouponDetails"];
        subTotal = 0.0;
    }
    
}

-(void) emptyCartMsg{
//    [addItemBtn removeFromSuperview];
    [orderTbl setHidden:YES];
    [checkOutBtn setHidden:YES];
    [pickupBtn setHidden:YES];
    [deliveryBtn setHidden:YES];
    [lblView setHidden:YES];
//    [user setObject:[NSNumber numberWithInt:4] forKey:@"TipIndex"];
    UILabel *msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2-30, SCREEN_WIDTH-20, 60)];
    msgLbl.numberOfLines = 0;
    msgLbl.text = @"Your Cart is Hungry\nPlease fill it with Food";
    msgLbl.textAlignment = NSTextAlignmentCenter;
    msgLbl.font = APP_FONT_BOLD_16;
    msgLbl.tag = 999;
    [self.view addSubview:msgLbl];
}

-(void)applyCouponAct{
//    [user setObject:[[user objectForKey:@"CouponDetails"] objectForKey:@"CouponId"] forKey:@"DiscountCode"];
    if ([[[user objectForKey:@"CouponDetails"]objectForKey:@"ValidForOrderType"] intValue] == [[user objectForKey:@"OrderType"] intValue] ||
        [[[user objectForKey:@"CouponDetails"]objectForKey:@"ValidForOrderType"] intValue]== 4) {
        [self discountCalc];
    }else{
        if ([user objectForKey:@"CouponDetails"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat: @"This coupon is not valid for %@ orders", ([[user objectForKey:@"OrderType"] intValue]==1) ? @"Pick up": @"Delivery"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            discountAmnt = 0.0;
         
        }
           [user removeObjectForKey:@"DiscountCode"];
    }
    
    
//    AddCardVC *addCardView = [[AddCardVC alloc] init];
//    [self.navigationController pushViewController:addCardView animated:YES];
}

-(void)viewCouponAct{
    ViewCouponVC *viewCouponVC = [[ViewCouponVC alloc] init];
    viewCouponVC.delegate = self;
    [self.navigationController pushViewController:viewCouponVC animated:YES];
}

-(void)discountCalc{
    NSDictionary *ReqDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                            CLIENT_ID, @"clientid",
                            [[user objectForKey:@"CouponDetails"] objectForKey:@"Title"], @"CouponCode",
                            [[user objectForKey:@"CouponDetails"] objectForKey:@"DiscountType"], @"CouponType",
                            [NSString stringWithFormat:@"%lf", subTotal], @"SubTotal",
                            [user objectForKey:@"OrderType"] , @"orderType",
                            [[CartObj instance].userInfo objectForKey:@"UserId"], @"MemberId",
                            nil];
    [APIRequest fetchDiscount:ReqDic completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
            fetchDeliveryFailed = YES;
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if ([[resObj objectForKey:@"isSuccess"] boolValue]) {
                [user setObject:[[user objectForKey:@"CouponDetails"] objectForKey:@"Title"] forKey:@"DiscountCode"];
                discountAmnt = [[resObj objectForKey:@"DiscountAmount"] doubleValue];
                if ([[resObj objectForKey:@"ItemIdofFreeItem"] intValue]) {
                    [[CartObj instance].freeItemDic setObject:[resObj objectForKey:@"ItemIdofFreeItem"] forKey:@"ItemIdofFreeItem"];
                }else{
                    [[CartObj instance].freeItemDic removeObjectForKey:@"ItemIdofFreeItem"];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@", [resObj objectForKey:@"status"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                [user removeObjectForKey:@"CouponDetails"];
                
            }
            
            [orderTbl reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestTax];
            });
        }
    }];
}




-(void)showErrorMessage:(NSString *)errMsg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errMsg delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
    [alert show];
    discountAmnt = 0.0;
    [user removeObjectForKey:@"DiscountCode"];
}

-(void)lessSubtotalMsg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"This coupon can be used on amount greater than $%@", [[user objectForKey:@"CouponDetails"] objectForKey:@"TotalAmount"]]
                                                   delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
    [alert show];
}

-(int)couponExpiryCheck{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date  = [dateFormatter dateFromString:[[user objectForKey:@"CouponDetails"] objectForKey:@"DateExpire"]];
    
    NSDate *todayDate = [NSDate date];
    return [date timeIntervalSinceDate:todayDate];
}
-(void)addItemBtnAct{
    [user setObject:[CartObj instance].cartPrice forKey:@"cartPrice"];
    [user setObject:[NSNumber numberWithBool:1] forKey:@"AddMore"];
    
    if ([CartObj instance].itemsForCart.count) {
        AllDayMenuVC *menuVC = [[AllDayMenuVC alloc] init];
        [self.navigationController pushViewController:menuVC animated:YES];
    }else{
        NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
        [user setObject:[NSNumber numberWithBool:0] forKey:@"AddMore"];
//        if ([[user objectForKey:@"OrderType"] intValue] == 2) {
//            [self.navigationController popToViewController:[vcArr objectAtIndex:0]  animated:YES];
//        }else{
//            [self.navigationController popToViewController:[vcArr objectAtIndex:(2+[[user objectForKey:@"popIndex"] intValue])]  animated:YES];
//        }
//        NSLog(@"%@", [[CartObj instance].userInfo objectForKey:@"UserId"]);
        int index = 0;
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[AllDayMenuVC class]]) {
                break;
            }
            index++;
        }
        if (index < vcArr.count)
            [self.navigationController popToViewController:[vcArr objectAtIndex:index]  animated:YES];
        else { //When coming from reorder, there is no Menu view loaded before
            [user setObject:[NSNumber numberWithBool:1] forKey:@"AddMore"];
            AllDayMenuVC *menuVC = [[AllDayMenuVC alloc] init];
            [self.navigationController pushViewController:menuVC animated:YES];
        }
    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    spclNote.textColor = [UIColor blackColor];
    if ([spclNote.text isEqualToString:@"Special Notes...\n(Example: Make it less spicy.)"]) {
        spclNote.text = @"";
    }
    
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textView.inputAccessoryView = keyboardToolBar;
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([spclNote.text length]<=0) {
        spclNote.textColor = [UIColor grayColor];
        spclNote.text = @"Special Notes...\n(Example: Make it less spicy.)";
    }else{
        [CartObj instance].spclNote = spclNote.text;
    }
}

- (void)resignKeyboard{
    [spclNote resignFirstResponder];
}
-(BOOL)checkRestroClosed{
    BOOL closed = YES;
    
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Closed"] boolValue]) {
            closed = NO;
            break;
        }else{
            closed = YES;
        }
    }
    return closed;
}

-(BOOL)checkDeliveryClosed{
    BOOL closed = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"DeliveryClosed"] boolValue]) {
            closed = NO;
            break;
        }else{
            closed = YES;
        }
    }
    return closed;
}

-(BOOL)checkPickUpClosed{
    BOOL closed = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Closed"] boolValue]) {
            closed = NO;
            break;
        }else{
            closed = YES;
        }
    }
    return closed;
}

-(void)checkOutBtnAct{
    if (!dummyV)
        dummyV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    dummyV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.navigationController.navigationBar.userInteractionEnabled = false;
    [self.view addSubview:dummyV];
    Schedular *scheduleV = [[Schedular alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT/2-170, SCREEN_WIDTH-40, 340) forController:self];
    [self.view addSubview:scheduleV];
    scheduleV.backgroundColor = [UIColor whiteColor];
    
}

-(void)removeDummyView:(UIButton *)sender{
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [sender.superview removeFromSuperview];
    [dummyV removeFromSuperview];
}

- (void)orderScheduledForToday:(UIButton *)sender {
    BOOL proceed = NO;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *orderDate = [formatter stringFromDate:[NSDate date]];
//    [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderDate"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    NSLog(@"%@", [[CartObj instance].userInfo objectForKey:@"timeArr"]);
    [formatter setDateFormat:@"hh:mm a"];
    NSString *orderTime = [formatter stringFromDate:[NSDate date]];
//    [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderTime"];
    
    NSLog(@"%@\n%@", orderDate, orderTime);
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    proceed = [self canPlaceOrderForNow: orderTime];
    
    if (!proceed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed at the moment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];

    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/YYYY"];
        [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderDate"];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
        NSLog(@"%@", [[CartObj instance].userInfo objectForKey:@"timeArr"]);
        [formatter setDateFormat:@"hh:mm a"];
        [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderTime"];
        
        [dummyV removeFromSuperview];
        [sender.superview removeFromSuperview];
        [self proceedForOrder:nil];
    }
    
    
}

-(BOOL)canPlaceOrderForNow: (NSString *)timeStr{
    bool canPlace = NO;
    int currTime = [self timeInSeconds:timeStr];
    
    
    for (NSDictionary *businessTimings in [user objectForKey:@"BusinessHours"]) {
        if ([[businessTimings objectForKey:@"Day"] intValue] == weekdayNumber) {
            
            if ([[user objectForKey:@"OrderType"] intValue] == 1) {
                
                int breakFastStart  = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastStartTime"]];
                int breakFastEnd    = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastEndTime"]];
                
                int lunchStart      = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchStartTime"]];
                int lunchEnd        = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchEndTime"]];
                
                int dinnerStart     = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerStartTime"]];
                int dinnerEnd       = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerEndTime"]];
                
                
                if (breakFastStart != breakFastEnd) {
                    breakFastEnd = breakFastEnd? breakFastEnd :(lunchStart? lunchStart:(lunchEnd? lunchEnd:(dinnerStart?dinnerStart:dinnerEnd)));
                }
                
                if (lunchStart != lunchEnd) {
                    lunchEnd = lunchEnd? lunchEnd : (dinnerStart? dinnerStart: dinnerEnd);
                    
                    lunchStart = lunchStart? lunchStart: (breakFastEnd? breakFastEnd: breakFastStart);
                }
                if (dinnerStart != dinnerEnd) {
                    dinnerStart = dinnerStart? dinnerStart : ([self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchEndTime"]]? [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchEndTime"]]: (lunchStart? lunchStart: (breakFastEnd? breakFastEnd: breakFastStart)));
                }
                
                
                if (breakFastStart < breakFastEnd) {
                    NSLog(@"%d ... %d", (breakFastStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60), (breakFastEnd?breakFastEnd:(lunchEnd?lunchEnd:dinnerEnd)));
                    if (currTime >= (breakFastStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60) &&
                        (currTime <= (breakFastEnd?breakFastEnd:(lunchEnd?lunchEnd:dinnerEnd)))) {
                        
                        canPlace = YES;
                        break;
                    }
                }
                
                if(lunchStart < lunchEnd){
                    if (currTime >= (lunchStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60) &&
                        (currTime <= (lunchEnd?lunchEnd:dinnerEnd))) {
                        //                        NSLog(@"%d",(lunchEnd?lunchEnd:dinnerEnd) );
                        canPlace = YES;
                        break;
                    }
                }
                
                if(dinnerStart < dinnerEnd){
                    if (currTime >= (dinnerStart + [[user objectForKey:@"PickupTimeOffset"] intValue]*60) && currTime <= dinnerEnd) {
                        canPlace = YES;
                        break;
                    }
                }
                
            }
            
            
            if ([[user objectForKey:@"OrderType"] intValue] == 2) {
                
                int breakFastDelStart  = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastDeliveryStartTime"]];
                int breakFastDelEnd    = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"BreakfastDeliveryEndTime"]];
                
                int lunchDelStart      = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryStartTime"]];
                int lunchDelEnd        = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryEndTime"]];
                
                int dinnerDelStart     = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerDeliveryStartTime"]];
                int dinnerDelEnd       = [self longTimeFormatInSeconds:[businessTimings objectForKey:@"DinnerDeliveryEndTime"]];
                
                if (breakFastDelStart != breakFastDelEnd) {
                    breakFastDelEnd = breakFastDelEnd? breakFastDelEnd :(lunchDelStart? lunchDelStart:(lunchDelEnd? lunchDelEnd
                                                                                                       : (dinnerDelStart? dinnerDelStart:dinnerDelEnd)));
                }
                if (lunchDelStart != lunchDelEnd) {
                    lunchDelEnd = lunchDelEnd? lunchDelEnd : (dinnerDelStart? dinnerDelStart: dinnerDelEnd);
                    lunchDelStart = lunchDelStart? lunchDelStart: (breakFastDelEnd? breakFastDelEnd: breakFastDelStart);
                }
                if (dinnerDelStart != dinnerDelEnd) {
                    
                    dinnerDelStart = dinnerDelStart? dinnerDelStart : ([self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryEndTime"]]? [self longTimeFormatInSeconds:[businessTimings objectForKey:@"LunchDeliveryEndTime"]]: (lunchDelStart? lunchDelStart: (breakFastDelEnd? breakFastDelEnd: breakFastDelStart)));
                }
                
                
                if (breakFastDelStart < breakFastDelEnd) {
                    
                    if (currTime >= (breakFastDelStart + [[user objectForKey:@"DelTimeOffset"] intValue]*60) &&
                        (currTime <= (breakFastDelEnd? breakFastDelEnd:(lunchDelEnd?lunchDelEnd:dinnerDelEnd) ))) {
                        
                        canPlace = YES;
                        break;
                    }
                }
                
                if(lunchDelStart < lunchDelEnd){
                    if (currTime >= (lunchDelStart + [[user objectForKey:@"DelTimeOffset"] intValue]*60) &&
                        (currTime <= (lunchDelEnd? lunchDelEnd:dinnerDelEnd ))) {
                        
                        canPlace = YES;
                        break;
                    }
                }
                
                if(dinnerDelStart < dinnerDelEnd){
                    if (currTime >= (dinnerDelStart + [[user objectForKey:@"DelTimeOffset"] intValue]*60) && currTime <= dinnerDelEnd) {
                        canPlace = YES;
                        break;
                    }
                }
                
            }
            
            break;
            
        }
    }
    
    return canPlace;
}


-(int)longTimeFormatInSeconds:(NSString *)timeStr{
    
    NSArray *timeArr = [timeStr componentsSeparatedByString:@":"];
    
    if (timeArr.count == 3) {
        return (([[timeArr objectAtIndex:0] intValue]*60*60) +
                ([[timeArr objectAtIndex:1] intValue]*60) +
                ([[timeArr objectAtIndex:2] intValue]));
    }else
        return 0;
}


-(int)timeInSeconds:(NSString *)timeStr{
    NSArray *arr = [timeStr componentsSeparatedByString:@" "];
    int addOffset = 0;
    if ([[arr objectAtIndex:1] isEqualToString:@"PM"]) {
        addOffset = 12*60*60;
    }
    NSArray *arr2 = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
    
    if ([[arr2 objectAtIndex:0] isEqualToString:@"12"] && [[arr objectAtIndex:1] isEqualToString:@"PM"]) {
        addOffset=0;
    }
    if ([[arr2 objectAtIndex:0] isEqualToString:@"12"] && [[arr objectAtIndex:1] isEqualToString:@"AM"]){
        return [[arr2 objectAtIndex:1] intValue]*60+addOffset;
    }else{
        return [[arr2 objectAtIndex:0] intValue]*60*60+[[arr2 objectAtIndex:1] intValue]*60+addOffset;
    }
}

- (void)orderScheduled:(UIButton *)sender {
    if ([[CartObj instance].userInfo objectForKey:@"OrderDate"] && ![[[CartObj instance].userInfo objectForKey:@"OrderTime"] isEqualToString:@"Closed"]) {
        [user setObject:[[CartObj instance].userInfo objectForKey:@"OrderDate"] forKey:@"OrderDate"];
        [user setObject:[[CartObj instance].userInfo objectForKey:@"OrderTime"] forKey:@"OrderTime"];
        
        NSLog(@"%@\n%@", [[NSUserDefaults standardUserDefaults]  objectForKey:@"OrderDate"], [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"]);
        [dummyV removeFromSuperview];
        [sender.superview removeFromSuperview];
        [self proceedForOrder:nil];
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed at the moment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)proceedForOrder:(UIButton *)sender{
    NSLog(@"%@", [CartObj instance].itemsForCart);
    if([[user objectForKey:@"skipNow"] isEqualToString:@"skipNow"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *nextView = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:nextView animated:YES];
    }else{
            if (fetchTaxFailed || fetchDeliveryFailed) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert setTag:200];
            [alert show];
        }else if([[user objectForKey:@"isRestOpen"] boolValue]){
            [user setObject:[CartObj instance].cartPrice forKey:@"cartPrice"];
            if ([CartObj instance].itemsForCart.count) {
                    if ([[user objectForKey:@"OrderType"] intValue] == 2 && (subTotal < [[user objectForKey:@"MinDelivery"] doubleValue]) && [[[CartObj instance]itemsForCart] count]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"For delivery orders, Subtotal should be greater than $%.2lf.", [[user objectForKey:@"MinDelivery"] doubleValue]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alert show];
                    }else if ([[user objectForKey:@"OrderType"] intValue] == 2 &&  fetchDeliveryFailed && [[user objectForKey:@"ShippingOptionId"] intValue] == 4) {
                        [self requestDelivery];
                    }
                    else{
                       if ([user objectForKey:@"OrderDate"] && [user objectForKey: @"OrderTime"] && ([[[CartObj instance].userInfo objectForKey:@"UserId"] intValue] || !sender)) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Order Time" message:[NSString stringWithFormat:@"Your order is scheduled for %@, %@", [user objectForKey:@"OrderDate"], [user objectForKey: @"OrderTime"]] delegate:self cancelButtonTitle:@"Change" otherButtonTitles: @"Confirm", nil];
                            [alert setTag:300];
                            [alert show];
                        }else{
                            [self checkOutBtnAct];
                        }
                    }
            }else{
                [self leftBarAct];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed today" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
}
-(void)closeRestMsg{
    UIAlertView *alert;
    if ([[user objectForKey:@"OrderType"] intValue] == 1) {
        alert =  [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed for pickup today" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }else if([[user objectForKey:@"OrderType"] intValue] == 2){
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed for delivery today" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200 && buttonIndex == 0) {
        if (fetchDeliveryFailed && [[user objectForKey:@"ShippingOptionId"] intValue] == 4) {
            if ((subTotal < [[user objectForKey:@"MinDelivery"] doubleValue]) && [[[CartObj instance]itemsForCart] count]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"For delivery orders, Subtotal should be greater than $%.2lf.", [[user objectForKey:@"MinDelivery"] doubleValue]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }else{
                [self requestDelivery];
            }
        }
        if (fetchTaxFailed) {
            [self requestTax];
        }
    }
    if (alertView.tag == 300) {
        if (buttonIndex==1) {
            AccountUpdateVC *nextView = [[AccountUpdateVC alloc] init];
            [self.navigationController pushViewController:nextView animated:YES];
        }else{
            [self checkOutBtnAct];
        }
        
        
    }
}
@end

