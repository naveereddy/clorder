//
//  ChangePassword.m
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "ChangePassword.h"

@interface ChangePassword ()

@end

@implementation ChangePassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    oldPasswordtext.delegate = self;
    oldPasswordtext.leftViewMode= UITextFieldViewModeAlways;
    oldPasswordtext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    [oldPasswordtext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    oldPasswordtext.secureTextEntry = YES;

    newPasswordtext.delegate = self;
    newPasswordtext.leftViewMode= UITextFieldViewModeAlways;
    newPasswordtext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    [newPasswordtext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    newPasswordtext.secureTextEntry = YES;

    confirmPasswordtext.delegate = self;
    confirmPasswordtext.leftViewMode= UITextFieldViewModeAlways;
    confirmPasswordtext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-placeholder"]];
    [confirmPasswordtext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    confirmPasswordtext.secureTextEntry = YES;

}
-(CALayer *)bottomborderAdding:(CGFloat)width height:(CGFloat)height{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [[UIColor grayColor] CGColor];
    border.frame = CGRectMake(0, height-1, width, 1);
    return border;
}
-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)saveAction: (id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
