//
//  HistoryOrderDtlV.m
//  CLOrder
//
//  Created by Vegunta's on 29/08/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "HistoryOrderDtlV.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "CheckOut.h"
#import "CartObj.h"
#import "DeliveryVC.h"
#import "Schedular.h"

@interface HistoryOrderDtlV (){
    NSMutableArray *itemArr;
    NSDictionary *resObj;
    UIView *dummyV;
    NSUserDefaults *user;
    NSInteger weekdayNumber;
}

@end

@implementation HistoryOrderDtlV
@synthesize orderId;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Order Details";
    
    user = [NSUserDefaults standardUserDefaults];
    NSDate *now = [NSDate date];
    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
    [nowDateFormatter setDateFormat:@"e"];
    NSLog(@"%@",[nowDateFormatter stringFromDate:now]);
    weekdayNumber = (NSInteger)[[nowDateFormatter stringFromDate:now] integerValue]-1;
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(20, SCREEN_HEIGHT-50, SCREEN_WIDTH/2-40, 40);
    orderBtn.layer.cornerRadius = 3.0;
    orderBtn.backgroundColor = APP_COLOR;
    orderBtn.tag = 1;
    [orderBtn setTitle:@"PICKUP" forState:UIControlStateNormal];
    orderBtn.titleLabel.textColor = [UIColor whiteColor];
    orderBtn.titleLabel.font = APP_FONT_REGULAR_16;
    [orderBtn addTarget:self action:@selector(orderBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *order = [UIButton buttonWithType:UIButtonTypeCustom];
    order.frame = CGRectMake(SCREEN_WIDTH/2+20, SCREEN_HEIGHT-50, SCREEN_WIDTH/2-40, 40);
    order.layer.cornerRadius = 3.0;
    order.backgroundColor = APP_COLOR;
    order.tag = 2;
    [order setTitle:@"DELIVERY" forState:UIControlStateNormal];
    order.titleLabel.textColor = [UIColor whiteColor];
    order.titleLabel.font = APP_FONT_REGULAR_16;
    [order addTarget:self action:@selector(orderBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[user objectForKey:@"DeliveryType"] integerValue] == 4){
        [self.view addSubview:orderBtn];
        [self.view addSubview:order];
    }else if([[user objectForKey:@"DeliveryType"] integerValue] == 1){
        orderBtn.frame=CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width/4-10), SCREEN_HEIGHT-50, self.view.frame.size.width/2-20, 40);
        [self.view addSubview:orderBtn];
    }else if([[user objectForKey:@"DeliveryType"] integerValue] == 2){
        order.frame=CGRectMake(self.view.frame.size.width/2-(self.view.frame.size.width/4-10), SCREEN_HEIGHT-50, self.view.frame.size.width/2-20, 40);
        [self.view addSubview:order];
    }
    [self getOrderDetails];
}

-(void)getOrderDetails{
    [APIRequest getOrderdetails:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"ClientID", [NSString stringWithFormat:@"%@", orderId], @"OrderId", nil] completion:^(NSMutableData *buffer){
        if (!buffer){
            NSLog(@"Unknown ERROR");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
            if (![[resObj objectForKey:@"SelectedItems"] isKindOfClass:[NSNull class]] && [[resObj objectForKey:@"SelectedItems"] count]) {
                itemArr = [[NSMutableArray alloc] initWithArray:[resObj objectForKey:@"SelectedItems"]];
                detailTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-60-64)];
                [self.view addSubview:detailTbl];
                detailTbl.delegate = self;
                detailTbl.dataSource = self;
                //                [detailTbl reloadData];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

-(void) leftBarAct{
//    NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
//    [self.navigationController popToViewController:[vcArr objectAtIndex:0] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 0)];
    headerV.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 135);
        
        UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 30)];
        [headerV addSubview:headerLbl];
        headerLbl.text = [NSString stringWithFormat:@"%@", @"Order Information"];
        headerLbl.textAlignment = NSTextAlignmentCenter;
        headerLbl.font = APP_FONT_BOLD_18;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [headerLbl addSubview:line];
        
        UILabel *orderIdLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-20, 20)];
        [headerV addSubview:orderIdLbl];
        orderIdLbl.text = [NSString stringWithFormat:@"Order Id: %@", [resObj objectForKey:@"orderId"]];
        orderIdLbl.font = APP_FONT_BOLD_16;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *placedDt = [formatter dateFromString:[resObj objectForKey:@"CreatedDate"]];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT-8"];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        UILabel *placedDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-20, 20)];
        [headerV addSubview:placedDateLbl];
        placedDateLbl.text = [NSString stringWithFormat:@"Placed On: %@", [formatter stringFromDate:placedDt]];
        placedDateLbl.font = APP_FONT_BOLD_16;
//        [formatter setDateFormat:@"EEEE MM/dd/yyyy hh:mm a"];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        placedDt = [formatter dateFromString:[resObj objectForKey:@"OrderDate"]];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT-8"];

//        [formatter setDateFormat:@"EEE yyyy-MM-dd hh:mm a"];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        
        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 20)];
        [headerV addSubview:dateLbl];
        dateLbl.text = [NSString stringWithFormat:@"Order Date: %@", [[resObj objectForKey:@"IsASAPOrder"] boolValue]?@"ASAP" :[formatter stringFromDate:placedDt]];
        dateLbl.font = APP_FONT_BOLD_16;
        
        UILabel *orderType = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH-20, 20)];
        [headerV addSubview:orderType];
        orderType.text = [NSString stringWithFormat:@"Order Type: %@", [resObj objectForKey:@"OrderType"]];
        orderType.font = APP_FONT_BOLD_16;
        
        UILabel *payMode = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, SCREEN_WIDTH-20, 20)];
        [headerV addSubview:payMode];
        payMode.text = [NSString stringWithFormat:@"Payment Mode: %@", [resObj objectForKey:@"paymentType"]];
        payMode.font = APP_FONT_BOLD_16;
        
        UILabel *separator = [[UILabel alloc] initWithFrame:CGRectMake(0, 132, SCREEN_WIDTH, 1)];
        separator.backgroundColor = [UIColor grayColor];
        [headerV addSubview:separator];
    }else{
        headerV.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 0);

        UILabel *qtyLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 40, 30)];
        [headerV addSubview:qtyLbl];
        qtyLbl.text = @"QTY";
        qtyLbl.textColor = [UIColor whiteColor];
        qtyLbl.textAlignment = NSTextAlignmentCenter;
        qtyLbl.backgroundColor = APP_BLUE_COLOR;
        
        UILabel *itemLbl = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH-44-72, 30)];
        [headerV addSubview:itemLbl];
        itemLbl.text = @"ITEM";
        itemLbl.textAlignment = NSTextAlignmentCenter;
        itemLbl.backgroundColor = APP_BLUE_COLOR;
        itemLbl.textColor = [UIColor whiteColor];
        
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 0, 68, 30)];
        [headerV addSubview:priceLbl];
        priceLbl.text = @"Price";
        priceLbl.textAlignment = NSTextAlignmentCenter;
        priceLbl.backgroundColor = APP_BLUE_COLOR;
        priceLbl.textColor = [UIColor whiteColor];
    }
    
    return  headerV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 135.0;
    }
    return 32.0;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return itemArr.count+2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [itemArr count]) {
        if ([[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Options"] length]) {
            return [self heightForRow:indexPath]+60+[self heightForNote:[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Notes"]];
        }else{
            return 60+[self heightForNote:[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Notes"]];
        }
    }else{
        return 130;
    }
}

-(CGFloat)heightForRow:(NSIndexPath *)indexPath{
    
    NSMutableString *selectionStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", [[itemArr objectAtIndex:indexPath.row] objectForKey:@"Options"]]];
    
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",selectionStr] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-44-72, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/16; i++)
    {
        gap++;
    }
    return labelHeight.size.height+gap*4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row < itemArr.count) {
        UILabel *ItmTitle = [[UILabel alloc] initWithFrame:CGRectMake(44, 5, SCREEN_WIDTH-44-72, 20)];
        [cell.contentView addSubview:ItmTitle];
        ItmTitle.text = [NSString stringWithFormat:@"%@", [[itemArr objectAtIndex:indexPath.row] objectForKey:@"Title"]];
        [ItmTitle setFont:APP_FONT_REGULAR_16];
        
        UILabel *ItmDtl = [[UILabel alloc] initWithFrame:CGRectMake(44, 25, SCREEN_WIDTH-44-72, [self heightForRow:indexPath])];
        [cell.contentView addSubview:ItmDtl];
        ItmDtl.numberOfLines = 0;
        ItmDtl.textColor = [UIColor lightGrayColor];
        ItmDtl.text = [NSString stringWithFormat:@"%@", [[itemArr objectAtIndex:indexPath.row] objectForKey:@"Options"]];
        [ItmDtl setFont:APP_FONT_REGULAR_14];
        double yPos;
        if ([[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Options"] length]) {
            yPos = 30+ItmDtl.frame.size.height;
        }else{
            yPos = 30;
        }
        
        UILabel *qtyLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 40, 20)];
        [cell.contentView addSubview:qtyLbl];
        qtyLbl.text = [NSString stringWithFormat:@"%dx", [[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Quantity"] intValue]];
        qtyLbl.textAlignment = NSTextAlignmentCenter;
        [qtyLbl setFont:APP_FONT_REGULAR_16];
        
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 5, 68, 20)];
        [cell.contentView addSubview:priceLbl];
        priceLbl.text = [NSString stringWithFormat:@"$%@", [[itemArr objectAtIndex:indexPath.row] objectForKey:@"TotalPrice"]];
        priceLbl.textAlignment = NSTextAlignmentCenter;
        [priceLbl setFont:APP_FONT_REGULAR_16];
        
        if (![[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Notes"] isKindOfClass:[NSNull class]] && [[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Notes"] length]) {
            
            UILabel *noteLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, yPos+25, SCREEN_WIDTH-20, [self heightForNote:[[itemArr objectAtIndex:indexPath.row] objectForKey:@"Notes"]])];
            [cell.contentView addSubview:noteLbl];
            noteLbl.numberOfLines = 0;
            noteLbl.text = [NSString stringWithFormat:@"Notes: %@", [[itemArr objectAtIndex:indexPath.row] objectForKey:@"Notes"]];
            [noteLbl setFont:APP_FONT_REGULAR_16];
        }
       
        
    }else if(indexPath.row == itemArr.count){
    
        UILabel *subtotalLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 5, 80, 20)];
        [cell.contentView addSubview:subtotalLbl];
        subtotalLbl.text = @"Subtotal:";
        
        UILabel *subtotalAmnt = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+80, 5, 70, 20)];
        [cell.contentView addSubview:subtotalAmnt];
        subtotalAmnt.textAlignment = NSTextAlignmentRight;
        subtotalAmnt.text = [NSString stringWithFormat:@"$%@", [resObj objectForKey:@"SubTotal"]];
        [subtotalAmnt setFont:APP_FONT_REGULAR_14];
        
        UILabel *taxLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 25, 80, 20)];
        [cell.contentView addSubview:taxLbl];
        taxLbl.text = @"Tax:";
        [taxLbl setFont:APP_FONT_REGULAR_14];
        
        UILabel *taxAmnt = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+80, 25, 70, 20)];
        [cell.contentView addSubview:taxAmnt];
        taxAmnt.textAlignment = NSTextAlignmentRight;
        taxAmnt.text = [NSString stringWithFormat:@"$%@", [resObj objectForKey:@"Tax"]];
        [taxAmnt setFont:APP_FONT_REGULAR_14];
        
        UILabel *deliveryLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 45, 80, 20)];
        [cell.contentView addSubview:deliveryLbl];
        deliveryLbl.text = @"Delivery:";
        [deliveryLbl setFont:APP_FONT_REGULAR_14];
        
        UILabel *deliveryAmnt = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+80, 45, 70, 20)];
        [cell.contentView addSubview:deliveryAmnt];
        deliveryAmnt.textAlignment = NSTextAlignmentRight;
        deliveryAmnt.text = [NSString stringWithFormat:@"$%@", [resObj objectForKey:@"ShippingCost"]];
        [deliveryAmnt setFont:APP_FONT_REGULAR_14];
        
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 65, 80, 20)];
        [cell.contentView addSubview:tipLbl];
        tipLbl.text = @"Tip:";
        [tipLbl setFont:APP_FONT_REGULAR_14];
        
        UILabel *tipAmnt = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+80, 65, 70, 20)];
        [cell.contentView addSubview:tipAmnt];
        tipAmnt.textAlignment = NSTextAlignmentRight;
        tipAmnt.text = [NSString stringWithFormat:@"$%@", [[resObj objectForKey:@"TipAmount"] length]?[resObj objectForKey:@"TipAmount"]:@"0.00"];
        [tipAmnt setFont:APP_FONT_REGULAR_14];
        
        UILabel *discountLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 85, (SCREEN_WIDTH-20)/2, 20)];
        [cell.contentView addSubview:discountLbl];
        discountLbl.text = @"Discount:";
        [discountLbl setFont:APP_FONT_REGULAR_14];
        
        UILabel *discountAmnt = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+80, 85, 70, 20)];
        [cell.contentView addSubview:discountAmnt];
        discountAmnt.textAlignment = NSTextAlignmentRight;
        discountAmnt.text = [NSString stringWithFormat:@"$%@", [resObj objectForKey:@"DiscountAmount"]];
        [discountAmnt setFont:APP_FONT_REGULAR_14];
        
        UILabel *totalLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2, 105, (SCREEN_WIDTH-20)/2, 20)];
        [cell.contentView addSubview:totalLbl];
        totalLbl.text = @"Total:";
        [totalLbl setFont:APP_FONT_REGULAR_16];
        
        UILabel *totalAmnt = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/2+80, 105, 70, 20)];
        [cell.contentView addSubview:totalAmnt];
        totalAmnt.textAlignment = NSTextAlignmentRight;
        totalAmnt.text = [NSString stringWithFormat:@"$%@", [resObj objectForKey:@"Total"]];
        [totalAmnt setFont:APP_FONT_REGULAR_16];
        
    }else{
        UILabel *spclNotes = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 50)];
        [cell.contentView addSubview:spclNotes];
        [spclNotes setFont:APP_FONT_REGULAR_16];
        spclNotes.text = [NSString stringWithFormat:@"Special Notes: %@",
                          [[resObj objectForKey:@"SpecialNotes"] isKindOfClass:[NSNull class]]?@" ":[[resObj objectForKey:@"SpecialNotes"] length]? [resObj objectForKey:@"SpecialNotes"]: @" "];

    }
    
    return  cell;
}

-(CGFloat)heightForNote:(NSString *)noteStr{
    if ([noteStr length]) {
        NSMutableString *selectionStr = [NSMutableString stringWithString:noteStr];
        
        CGRect labelHeight = [[NSString stringWithFormat:@"%@",selectionStr] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :APP_FONT_REGULAR_16} context:nil];
        int gap=0;
        for(int i=0; i < labelHeight.size.height/16; i++)
        {
            gap++;
        }
        return labelHeight.size.height+gap*4;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [detailTbl deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getOrderDetailsForReorder{
    [APIRequest getOrderDetailsForReorder:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"ClientID", [NSString stringWithFormat:@"%@", orderId], @"OrderId", nil] completion:^(NSMutableData *buffer){
        if (!buffer){
            NSLog(@"Unknown ERROR");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
            NSMutableArray *items = [NSMutableArray array];
            for (NSDictionary *itm in [resObj objectForKey:@"SelectedItems"]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:itm];
                
                NSMutableArray *modifiers = [NSMutableArray array];
                for (int i=0;i<((NSArray *)dic[@"clientFields"]).count;i++) {
                    NSMutableDictionary *mod = [NSMutableDictionary dictionaryWithDictionary:((NSArray *)dic[@"clientFields"])[i]];
                    NSString *selected = [dic[@"SelectedOptions"] objectForKey:[NSString stringWithFormat:@"%d",[mod[@"ID"] intValue]]];
                    NSArray *selOpts = [selected componentsSeparatedByString:@","];
                    NSMutableArray *opts = [NSMutableArray array];
                    for (int j=0;j<((NSArray *)mod[@"Options"]).count;j++) {
                        NSMutableDictionary *opt = [NSMutableDictionary dictionaryWithDictionary:mod[@"Options"][j]];
                        opt[@"Default"] = [NSNumber numberWithBool:NO];
                        if(selOpts.count && [selOpts containsObject:[NSString stringWithFormat:@"%d",[opt[@"OptionId"] intValue]]])
                            opt[@"Default"] = [NSNumber numberWithBool:YES];
                        [opts addObject:opt];
                    }
                    mod[@"Options"] = opts;
                    [modifiers addObject:mod];
                }
                dic[@"clientFields"] = modifiers;
                
                
                [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:dic[@"clientFields"],@"clientFields", nil] forKey:@"Modifiers"];
                [dic setObject:dic[@"quatity"] forKey:@"Quantity"];
                [dic removeObjectForKey:@"clientFields"];
                [items addObject:dic];
            }
            if ([[resObj objectForKey:@"SelectedItems"] count]) {
                [CartObj instance].itemsForCart = items;
                DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
                deliveryV.toCart = YES;
                [self.navigationController pushViewController:deliveryV animated:YES];
            }
        }
    }];
}

-(void)scheduleOrder{
    dummyV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:dummyV];
    dummyV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //    ScheduleOrderViewController *scheduleV = [[ScheduleOrderViewController alloc] init];
    //    [self presentViewController:scheduleV animated:NO completion:nil];
    
    [user removeObjectForKey:@"OrderDate"];
    [[CartObj instance].userInfo removeObjectForKey:@"OrderDate"];
    [[CartObj instance].userInfo removeObjectForKey:@"OrderTime"];
    [[CartObj instance].userInfo removeObjectForKey:@"timeArr"];
    [user removeObjectForKey:@"TodayClosed"];
    Schedular *scheduleV = [[Schedular alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT/2-170, SCREEN_WIDTH-40, 340) forController:self];
    [self.view addSubview:scheduleV];
    scheduleV.backgroundColor = [UIColor whiteColor];
}

-(void)orderBtnAct:(UIButton *)sender {
 /*   NSLog(@"%@",[CartObj instance].userInfo);
    [[CartObj instance].userInfo setObject:[resObj objectForKey:@"Email"] forKey:@"Email"];
    [[CartObj instance].userInfo setObject:[resObj objectForKey:@"CustomerName"] forKey:@"FirstName"];
    [[CartObj instance].userInfo setObject:[resObj objectForKey:@"CustomerName"] forKey:@"FullName"];
    [[CartObj instance].userInfo setObject:[resObj objectForKey:@"CustomerName"] forKey:@"LastName"];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [resObj objectForKey:@"CustomerAddress1"],@"Address1",
                         [resObj objectForKey:@"CustomerAddress2"],@"Address2",
                         [resObj objectForKey:@"CustomerCity"],@"City",
                         [resObj objectForKey:@"CustomerPhoneNumber"],@"PhoneNumber",
                         [resObj objectForKey:@"CustomerZipCode"],@"ZipPostalCode",
                         nil];
    
    [[CartObj instance].userInfo setObject:dic forKey:@"UserAddress"];
*/
    /*
     {
     Email = "qqq@qqq.com";
     FirstName = "qqq qwerty";
     FullName = "qqq qwerty";
     LastName = "qqq qwerty";
     UserAddress =     {
     Address1 = poooooo;
     Address2 = ooooooo;
     City = "South Jordan";
     PhoneNumber = 2096848765;
     ZipPostalCode = 84095;
     };
     UserId = 92967;
     }
     */
    sender.tag==1?[self pickupBtnAct]:[self deliveryBtnAct];
//    [self getOrderDetailsForReorder];
}

-(void)removeDummyView:(UIButton *)sender{
    [sender.superview removeFromSuperview];
    [dummyV removeFromSuperview];
}


- (void)orderScheduledForToday:(UIButton *)sender {
    
    BOOL proceed = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderDate"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    NSLog(@"%@", [[CartObj instance].userInfo objectForKey:@"timeArr"]);
    [formatter setDateFormat:@"hh:mm a"];
    [user setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderTime"];
    
    NSLog(@"%@\n%@", [user  objectForKey:@"OrderDate"], [user objectForKey:@"OrderTime"]);
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    
    proceed = [self canPlaceOrderForNow];

    if (!proceed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed at the moment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else{
        [dummyV removeFromSuperview];
        [sender.superview removeFromSuperview];
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
//            DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
//            [self.navigationController pushViewController:deliveryV animated:YES];
            [self getOrderDetailsForReorder];
        }
    }
    
}

-(BOOL)canPlaceOrderForNow{
    bool canPlace = NO;
    int currTime = [self timeInSeconds:[user objectForKey:@"OrderTime"]];
    
    
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
    if (!timeStr.length)
        return 0;
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
        NSLog(@"%@\n%@", [[CartObj instance].userInfo objectForKey:@"OrderTime"], [[CartObj instance].userInfo objectForKey:@"OrderDate"]);
        [dummyV removeFromSuperview];
        [sender.superview removeFromSuperview];
        if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
//            DeliveryVC *deliveryV = [[DeliveryVC alloc] init];
//            [self.navigationController pushViewController:deliveryV animated:YES];
            [self getOrderDetailsForReorder];
        }else{
//            [self pushLoginScreen];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed at the moment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}


-(BOOL)checkRestroClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Closed"] boolValue]) {
            open = NO;
            break;
        }else{
            open = YES;
        }
    }
    return open;
}

-(BOOL)checkDeliveryClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"DeliveryClosed"] boolValue]) {
            open = NO;
            break;
        }else{
            open = YES;
        }
    }
    return open;
}

-(BOOL)checkPickUpClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekdayNumber){
            if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Closed"] boolValue]) {
                open = NO;
                break;
            }else{
                open = YES;
            }
        }else{
            open = YES;
        }
    }
    return open;
}

-(void)goForPickUp{
    [user setObject:[NSNumber numberWithInt:1] forKey:@"OrderType"];
    [self scheduleOrder];
}
-(void)goForDelivery{
    [user setObject:[NSNumber numberWithInt:2] forKey:@"OrderType"];
    [self scheduleOrder];
}

-(void)pickupBtnAct{
    if(![CartObj checkPickupDelivery:YES])
        return;
    if ([[user objectForKey:@"BusinessHours"] count] <=0) {
//        [self fetchClientSettings];
    }else{
        if ([[user objectForKey:@"isRestOpen"] boolValue] && [self checkPickUpClosed]) {
            [self goForPickUp];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed for pickup today" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: @"Continue", nil];
            [alert setTag:100];
            [alert show];
        }
    }
    
}
-(void)deliveryBtnAct{
    if(![CartObj checkPickupDelivery:NO])
        return;
    if ([[user objectForKey:@"BusinessHours"] count] <=0) {
//        [self fetchClientSettings];
    }else{
        if ([[user objectForKey:@"isRestOpen"] boolValue] && [self checkPickUpClosed] && [self checkDeliveryClosed]){
            [self goForDelivery];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant is closed for delivery today" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: @"Continue", nil];//@
            [alert setTag:200];
            [alert show];
        }
    }
    
    //    ScheduleDeliveryVC *scheduleOrderV = [[ScheduleDeliveryVC alloc] init];
    //    [self.navigationController pushViewController:scheduleOrderV animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        buttonIndex?[self goForPickUp]:nil;
    }
    else if (alertView.tag == 200) {
        buttonIndex?[self goForDelivery]:nil;
    }
    else if (buttonIndex == 0){
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
