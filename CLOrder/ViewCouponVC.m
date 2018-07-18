//
//  ViewCouponVC.m
//  CLOrder
//
//  Created by Vegunta's on 07/07/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "ViewCouponVC.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "CheckOut.h"

@implementation ViewCouponVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"VIEW COUPONS";
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    couponTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    couponTbl.dataSource = self;
    couponTbl.delegate = self;
    [self.view addSubview:couponTbl];
    
    [APIRequest getRestaurentPromotions:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID,@"clientId", nil] completion:^(NSMutableData *buffer) {
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
            
            promotionArray = [[NSArray alloc] initWithArray:[resObj objectForKey:@"RestaurentPromotions"]];
            [couponTbl reloadData];
        }
    }];
    
}

-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50.0;
//}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
//    header.backgroundColor = [UIColor lightGrayColor];
//    
//    UILabel *couponIDLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (3.0/4.0)*SCREEN_WIDTH/2, 50)];
//    couponIDLbl.text = @"Coupon Id";
//    couponIDLbl.numberOfLines = 0;
//    couponIDLbl.textAlignment = NSTextAlignmentCenter;
//    couponIDLbl.font = [UIFont systemFontOfSize:16.0];
//    [header addSubview:couponIDLbl];
//    
//    UILabel *descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake((3.0/4.0)*SCREEN_WIDTH/2, 0, (3.0/4)*SCREEN_WIDTH/2, 50)];
//    descriptionLbl.text = @"Coupon Description";
//    descriptionLbl.numberOfLines = 0;
//    descriptionLbl.textAlignment = NSTextAlignmentCenter;
//    descriptionLbl.font = [UIFont systemFontOfSize:16.0];
//    [header addSubview:descriptionLbl];
//    
//    UILabel *expireDtLbl = [[UILabel alloc] initWithFrame:CGRectMake((3.0/4.0)*SCREEN_WIDTH, 0, (1.0/4)*SCREEN_WIDTH, 50)];
//    expireDtLbl.text = @"Expire Date";
//    expireDtLbl.numberOfLines = 0;
//    expireDtLbl.textAlignment = NSTextAlignmentCenter;
//    expireDtLbl.font = [UIFont systemFontOfSize:16.0];
//    [header addSubview:expireDtLbl];
//    
//    return header;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return promotionArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([promotionArray count] && [[[promotionArray objectAtIndex:indexPath.row] objectForKey:@"Active"] intValue]) {
        return [self textHeightForDescription:indexPath]+22+20;
    }
    return 40.0;
}

-(CGFloat)textHeightForDescription :(NSIndexPath *)indexPath{
    
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",[[promotionArray objectAtIndex:indexPath.row] objectForKey:@"Description"]] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-160, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :APP_FONT_REGULAR_14} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/14; i++)
    {
        gap++;
    }
    return labelHeight.size.height+gap*4;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    CGFloat heightForRow = [self textHeightForDescription:indexPath]+20;
    if ([[[promotionArray objectAtIndex:indexPath.row] objectForKey:@"Active"] intValue]) {
        
        UILabel *couponIDLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH, 20)];
        couponIDLbl.text = [NSString stringWithFormat:@"%@", [[promotionArray objectAtIndex:indexPath.row] objectForKey:@"Title"]];
        couponIDLbl.numberOfLines = 0;
        couponIDLbl.textAlignment = NSTextAlignmentLeft;
        couponIDLbl.font = APP_FONT_BOLD_18;
        [cell.contentView addSubview:couponIDLbl];
        
        UILabel *descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, SCREEN_WIDTH-120, heightForRow)];
        descriptionLbl.text = [NSString stringWithFormat:@"%@", [[promotionArray objectAtIndex:indexPath.row] objectForKey:@"Description"]];
        descriptionLbl.numberOfLines = 0;
        descriptionLbl.textAlignment = NSTextAlignmentLeft;
        descriptionLbl.font = APP_FONT_REGULAR_14;
        [cell.contentView addSubview:descriptionLbl];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date  = [dateFormatter dateFromString:[[promotionArray objectAtIndex:indexPath.row] objectForKey:@"DateExpire"]];
        
        // Convert to new Date Format
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        NSString *newDate = [dateFormatter stringFromDate:date];

        UIButton *applycoupn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-95,25,85, 30)];
        applycoupn.titleLabel.numberOfLines = 0;
        applycoupn.titleLabel.textAlignment = NSTextAlignmentCenter;
        applycoupn.titleLabel.font = APP_FONT_REGULAR_16;
        [applycoupn.layer setBorderWidth:1];
        [applycoupn.layer setBorderColor:[APP_COLOR CGColor]];
        [applycoupn setTitle:@"Apply" forState:UIControlStateNormal];
        [applycoupn setTitleColor:APP_COLOR forState:UIControlStateNormal];
        [applycoupn.layer setCornerRadius:3];
        [applycoupn setTag:indexPath.row];
        [applycoupn addTarget:self action:@selector(applycoupnAct:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:applycoupn];
    }
    
    return  cell;
}
-(void)applycoupnAct:(UIButton *)btn{
    [delegateOfPrevious getCouponId:[promotionArray objectAtIndex:btn.tag]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    CheckOut *checkOutV = [[CheckOut alloc] init];
    //    [checkOutV getCouponId:[[promotionArray objectAtIndex:indexPath.row] objectForKey:@"Title"]];
   
    [delegateOfPrevious getCouponId:[promotionArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDelegate:(id)_delegate{
    delegateOfPrevious=_delegate;
}
@end
