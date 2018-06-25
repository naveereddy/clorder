//
//  PayDetailStp1.m
//  CLOrder
//
//  Created by Vegunta's on 30/05/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "PayDetailStp1.h"
#import "AppHeader.h"
#import "AccountUpdateVC.h"

@implementation PayDetailStp1


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PAYMENT DETAILS-STEP 1";
    
    [self setUIForView];
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    [doneBtn setBackgroundColor:[UIColor colorWithRed:10/255.0 green:61/255.0 blue:22/255.0 alpha:1.0]];
    [doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)setUIForView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    [self.view addSubview:headerImg];
    headerImg.backgroundColor = APP_COLOR;
    
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
    [headerImg addSubview:headerLbl];
    headerLbl.text = @"ADDRESS";
    headerLbl.textColor = [UIColor whiteColor];
    headerLbl.backgroundColor = [UIColor clearColor];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:nameLbl];
    nameLbl.text = @"Name*";
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:nameText];
    nameText.delegate = self;
    nameText.text = @"name";
    nameText.layer.borderColor = [[UIColor blackColor] CGColor];
    nameText.layer.borderWidth = 1.0;
    nameText.layer.cornerRadius = 3.0;
    
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:addressLbl];
    nameLbl.text = @"Address*";
    
    UITextField *addressText = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:addressText];
    addressText.delegate = self;
    addressText.text = @"addressText";
    addressText.layer.borderColor = [[UIColor blackColor] CGColor];
    addressText.layer.borderWidth = 1.0;
    addressText.layer.cornerRadius = 3.0;
    
    UILabel *buildingLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:buildingLbl];
    nameLbl.text = @"Apt/Suit/Building";
    
    UITextField *buildingText = [[UITextField alloc] initWithFrame:CGRectMake(20, 280, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:buildingText];
    buildingText.delegate = self;
    buildingText.text = @"buildingText";
    buildingText.layer.borderColor = [[UIColor blackColor] CGColor];
    buildingText.layer.borderWidth = 1.0;
    buildingText.layer.cornerRadius = 3.0;
    
    UILabel *cityLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:cityLbl];
    cityLbl.text = @"City*";
    
    UITextField *cityText = [[UITextField alloc] initWithFrame:CGRectMake(20, 350, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:cityText];
    cityText.delegate = self;
    cityText.text = @"cityText";
    cityText.layer.borderColor = [[UIColor blackColor] CGColor];
    cityText.layer.borderWidth = 1.0;
    cityText.layer.cornerRadius = 3.0;
    
    UILabel *zipLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 390, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:zipLbl];
    zipLbl.text = @"Zip code*";
    
    UITextField *zipText = [[UITextField alloc] initWithFrame:CGRectMake(20, 420, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:zipText];
    zipText.delegate = self;
    zipText.text = @"zipText";
    zipText.layer.borderColor = [[UIColor blackColor] CGColor];
    zipText.layer.borderWidth = 1.0;
    zipText.layer.cornerRadius = 3.0;
    
    UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 460, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:phoneLbl];
    phoneLbl.text = @"Phone number*";
    
    UITextField *phoneText = [[UITextField alloc] initWithFrame:CGRectMake(20, 490, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:phoneText];
    phoneText.delegate = self;
    phoneText.text = @"phoneText";
    phoneText.layer.borderColor = [[UIColor blackColor] CGColor];
    phoneText.layer.borderWidth = 1.0;
    phoneText.layer.cornerRadius = 3.0;
    
    UILabel *emailLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 530, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:emailLbl];
    emailLbl.text = @"Email address";
    
    UITextField *emailText = [[UITextField alloc] initWithFrame:CGRectMake(20, 560, SCREEN_WIDTH-40, 30)];
    [self.view addSubview:emailText];
    emailText.delegate = self;
    emailText.text = @"emailText";
    emailText.layer.borderColor = [[UIColor blackColor] CGColor];
    emailText.layer.borderWidth = 1.0;
    emailText.layer.cornerRadius = 3.0;
    
}

-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) doneBtnAct{
    AccountUpdateVC *update = [[AccountUpdateVC alloc]init];
    [self.navigationController pushViewController:update animated:NO];
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
