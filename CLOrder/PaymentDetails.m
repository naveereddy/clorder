//
//  PaymentDetails.m
//  CLOrder
//
//  Created by Vegunta's on 31/05/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "PaymentDetails.h"
#import "AppHeader.h"

@implementation PaymentDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PAYMENT DETAILS";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    [self.view addSubview:headerImg];
    headerImg.backgroundColor = APP_COLOR;
    
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
    [headerImg addSubview:headerLbl];
    headerLbl.text = @"PAYMENT";
    headerLbl.textColor = [UIColor whiteColor];
    headerLbl.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomView];
    [bottomView setUserInteractionEnabled:YES];
    
    bottomView.image = [UIImage imageNamed:@"Bottom_strip"];
    //    bottomView.backgroundColor = APP_GREEN_COLOR;
    
    UIButton *FinalOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    FinalOrderBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH-150, 50);
    [FinalOrderBtn setBackgroundColor:[UIColor clearColor]];
    [FinalOrderBtn setTitle:@"Finalize Order" forState:UIControlStateNormal];
    [FinalOrderBtn addTarget:self action:@selector(FinalOrderBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:FinalOrderBtn];
    
    UIButton *totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.frame = CGRectMake(bottomView.frame.size.width-150, 0, 150, 50);
    [totalBtn setBackgroundColor:[UIColor clearColor]];
    [totalBtn setTitle:@"$4.17" forState:UIControlStateNormal];
    [totalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [totalBtn addTarget:self action:@selector(totalBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:totalBtn];
    
}

-(void) FinalOrderBtnAct{
    
}

-(void) totalBtnAct{
    
}

-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
