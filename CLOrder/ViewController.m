//
//  ViewController.m
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "ViewController.h"
#import "AppHeader.h"
#import "AllDayMenuVC.h"
#import "SelectedRestroVC.h"
#import "SignUpView.h"
#import "CheckOut.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI{
    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgImg.image = [UIImage imageNamed:APP_BG_IMG];
    [self.view addSubview:bgImg];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, self.view.frame.size.height/2-225, 200, 200)];
    logoImg.layer.cornerRadius = 100.0;
    logoImg.image = [UIImage imageNamed:APP_LOGO];
    [self.view addSubview:logoImg];
    
    UIImageView *orderFromImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-15, self.view.frame.size.width-40, 50)];
    orderFromImg.image = [UIImage imageNamed:ORDER_FROM_RIBBON];
    [self.view addSubview:orderFromImg];
    
    UIButton *selectedRestroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedRestroBtn.frame = CGRectMake(30, self.view.frame.size.height/2+60, self.view.frame.size.width-60, 40);
    [selectedRestroBtn setBackgroundImage:[UIImage imageNamed:BLUE_BTN_BG] forState:UIControlStateNormal];
    selectedRestroBtn.layer.cornerRadius = 3.0;
    [selectedRestroBtn setTitle:@"Jhonnie's NY Pizza-Santamonia" forState:UIControlStateNormal];
    selectedRestroBtn.titleLabel.textColor = [UIColor whiteColor];
    selectedRestroBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [selectedRestroBtn addTarget:self action:@selector(selectedRestro) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectedRestroBtn];
    
    UIButton *otherRestroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherRestroBtn.frame = CGRectMake((self.view.frame.size.width/2)-100, self.view.frame.size.height/2+115, 200, 40);
    [otherRestroBtn setImage:[UIImage imageNamed:PICK_ANOTHER] forState:UIControlStateNormal];
    //    [otherRestroBtn setTitle:@"Pick Another" forState:UIControlStateNormal];
    //    otherRestroBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    //    selectedRestroBtn.titleLabel.textColor = [UIColor blackColor];
    [otherRestroBtn addTarget:self action:@selector(otherRestroAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherRestroBtn];
    
    UIButton *logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.frame = CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 50);
    [logInBtn setBackgroundImage:[UIImage imageNamed:SIGN_IN_CREATE] forState:UIControlStateNormal];
    [logInBtn setTitle:@"Sign In or Create an Account" forState:UIControlStateNormal];
    [logInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logInBtn addTarget:self action:@selector(logInBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logInBtn];
    
    
    UIImageView *ownerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-25, SCREEN_WIDTH-20, 15)];
    [self.view addSubview:ownerImg];
    ownerImg.image = [UIImage imageNamed:@"footer-txt"];
    //
    //    UILabel *ownerDtl = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, self.view.frame.size.height-25, 200, 15)];
    //    ownerDtl.textColor = APP_COLOR;
    //    ownerDtl.text = APP_OWNER;
    //    ownerDtl.backgroundColor = [UIColor redColor];
    //    ownerDtl.font = [UIFont systemFontOfSize:14.0];
    //    ownerDtl.textAlignment = NSTextAlignmentCenter;
    //
    //    UILabel *leftLn = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-15, self.view.frame.size.width-(self.view.frame.size.width/2)-100-30, 1)];
    //    leftLn.backgroundColor = APP_COLOR;
    //
    //    UILabel *rightLn = [[UILabel alloc] initWithFrame:CGRectMake(ownerDtl.frame.origin.x+ownerDtl.frame.size.width+10, self.view.frame.size.height-15, self.view.frame.size.width-(self.view.frame.size.width/2)-100-30, 1)];
    //    rightLn.backgroundColor = APP_COLOR;
    //
    //    [self.view addSubview:leftLn];
    //    [self.view addSubview:rightLn];
    //    [self.view addSubview:ownerDtl];
    
}

- (void)logInBtnAct {
    SignUpView *signUp = [[SignUpView alloc]init];
    [self.navigationController pushViewController:signUp animated:YES];
}

- (void)selectedRestro {
//    CheckOut *menu = [[CheckOut alloc] init];
    AllDayMenuVC *menu = [[AllDayMenuVC alloc] init];
    [self.navigationController pushViewController:menu animated:YES];
}

- (void)otherRestroAct {
    SelectedRestroVC *menu = [[SelectedRestroVC alloc] init];
    [self.navigationController pushViewController:menu animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
