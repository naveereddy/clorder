//
//  OrderHistoryVC.m
//  CLOrder
//
//  Created by Vegunta's on 16/08/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "OrderHistoryVC.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "LoginVC.h"
#import "CheckOut.h"
#import "HistoryOrderDtlV.h"


@interface OrderHistoryVC (){
    NSMutableArray *orderHistoryArr;
}

@end

@implementation OrderHistoryVC
@synthesize  fromhamburger;
- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgImg.image = [UIImage imageNamed:APP_BG_IMG];
//    [self.view addSubview:bgImg];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"%@",@"Order History"];
    

    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];

    //    NSLog(@"%d", [[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue]);
    
    if ([[[user objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue] > 0) {
        [APIRequest fetchClientOrderHistory:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"ClientID", [NSString stringWithFormat:@"%@", [[user objectForKey:@"userInfo"] objectForKey:@"UserId"]], @"UserId", nil] completion:^(NSMutableData *buffer){
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
                
                if (![[resObj objectForKey:@"ClientOrders"] isKindOfClass:[NSNull class]] && [[resObj objectForKey:@"ClientOrders"] count]) {
                    orderHistoryArr = [[NSMutableArray alloc] initWithArray:[resObj objectForKey:@"ClientOrders"]];
                    orderTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
                    orderTbl.delegate = self;
                    orderTbl.dataSource = self;
                    orderTbl.separatorColor = [UIColor clearColor];
                    [self.view addSubview:orderTbl];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You have no past orders so far." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert setTag:100];
                    [alert show];
                }
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You are not logged in, please login" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert setTag:200];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        [self leftBarAct];
    }
    if (alertView.tag == 200) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *nextView = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        
        [self.navigationController pushViewController:nextView animated:YES];
    }
}
-(void) rightBarAct{
    
}

-(void) proceedBtnAct{
    
}

-(void) leftBarAct{
    if(fromhamburger){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    header.backgroundColor = DARK_GRAY;
//    
//    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-50, 30)];
//    headerLbl.text = @"Nearby Places";
//    headerLbl.textColor = [UIColor whiteColor];
//    
//    UIButton *proceedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    proceedBtn.frame = CGRectMake(SCREEN_WIDTH-40, 5, 30, 30);
//    [proceedBtn setImage:[UIImage imageNamed:@"right-arrow-white"] forState:UIControlStateNormal];
//    [proceedBtn addTarget:self action:@selector(proceedBtnAct) forControlEvents:UIControlEventTouchUpInside];
//    
//    [header addSubview: headerLbl];
//    [header addSubview: proceedBtn];
//    return header;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return  5;
    return orderHistoryArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.5];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    //    NSData *imgData;
    UIImageView *placeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
//    placeIcon.image = [UIImage imageNamed:@"logo-dummy"];
    placeIcon.image = [UIImage imageNamed:@"new_Logo"];
    
    UILabel *placeName = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, SCREEN_WIDTH-85, 20)];
    placeName.textColor = [UIColor blackColor];
    placeName.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ClientName"]];
    [placeName setFont:APP_FONT_REGULAR_16];
    
    UILabel *OrderId = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, SCREEN_WIDTH-85-50, 20)];
    OrderId.textColor = [UIColor blackColor];
    OrderId.text = [NSString stringWithFormat:@"Order Id: %d", [[[orderHistoryArr objectAtIndex:indexPath.row] objectForKey:@"orderid"] intValue]];
    [OrderId setFont:APP_FONT_REGULAR_16];

    
    NSDateFormatter *dateForma  = [[NSDateFormatter alloc] init];
    NSDate *date = [[NSDate alloc] init];
    dateForma.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateForma setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    date = [dateForma dateFromString:[NSString stringWithFormat:@"%@",[[orderHistoryArr objectAtIndex:indexPath.row] objectForKey:@"OrderDate"]]];
    dateForma.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
    // Convert to new Date Format
    [dateForma setDateFormat:@"dd-MMM-yyyy hh:mm a"];
    NSString *newDate = [dateForma stringFromDate:date];
    
    
    UILabel *dateLbl =[[UILabel alloc] initWithFrame:CGRectMake(75, 45, SCREEN_WIDTH-85, 20)];
    dateLbl.numberOfLines = 0;
    dateLbl.textColor = [UIColor lightGrayColor];
    dateLbl.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", newDate]];
    dateLbl.font = APP_FONT_REGULAR_14;
    

    [cell.contentView addSubview:placeIcon];
    [cell.contentView addSubview:placeName];
    [cell.contentView addSubview:OrderId];
    [cell.contentView addSubview:dateLbl];    
    
    UIButton *totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.frame = CGRectMake(10, 72, SCREEN_WIDTH/2-15, 26);
    [totalBtn setTitle:[NSString
                        stringWithFormat:@"TOTAL: $%.2lf", [[[orderHistoryArr objectAtIndex:indexPath.row] objectForKey:@"OrderTotal"] doubleValue]] forState:UIControlStateNormal];
    totalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [totalBtn setTitleColor:APP_GOLD_COLOR forState:UIControlStateNormal];
    [totalBtn addTarget:self action:@selector(totalBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [totalBtn setTag:(100+indexPath.row)];
    [cell.contentView addSubview:totalBtn];
    [totalBtn.titleLabel setFont:APP_FONT_REGULAR_14];
    
    UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    optionBtn.frame = CGRectMake(SCREEN_WIDTH/2+5, 72, SCREEN_WIDTH/2-15, 26);
    [optionBtn setImage:[UIImage imageNamed:@"list_options"] forState:UIControlStateNormal];
    optionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [optionBtn setTitle:@"Order Now" forState:UIControlStateNormal];
    [optionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [optionBtn addTarget:self action:@selector(optionBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    [optionBtn setTag:(100+indexPath.row)];
   // [cell.contentView addSubview:optionBtn];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [orderTbl deselectRowAtIndexPath:indexPath animated:NO];
    
    if (orderHistoryArr.count > 0) {
        
        if (![[[orderHistoryArr objectAtIndex:indexPath.row] objectForKey:@"orderid"] isKindOfClass:[NSNull class]] &&
            [[[orderHistoryArr objectAtIndex:indexPath.row] objectForKey:@"orderid"] intValue]) {
            
            HistoryOrderDtlV *detailV = [[HistoryOrderDtlV alloc] init];
            detailV.orderId = [[orderHistoryArr objectAtIndex:indexPath.row] objectForKey:@"orderid"];
            [self.navigationController pushViewController:detailV animated:YES];
        }
    }
//    CheckOut *nextView = [[CheckOut alloc] init];
//    [self.navigationController pushViewController:nextView animated:YES];
}

-(void)totalBtnAct:(UIButton *)sender{
    
}

-(void)optionBtnAct:(UIButton *)sender{
    
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
