//
//  SideMenu.m
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "SideMenu.h"
#import "AppHeader.h"
#import "ChangePassword.h"
#import "OrderHistoryVC.h"
#import "EditProfile.h"


@interface SideMenu (){
    NSArray *images;
    NSArray *titles;
}
@end
@implementation SideMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    images = @[@"home",@"myorders",@"changePassword",@"logout"];
    titles = @[@"Home", @"My Orders", @"Change Password", @"Logout"];

    UIView *view= [[UIView alloc] init];
    [view setBackgroundColor:APP_COLOR];
    [self addSubview:view];
    
    CGFloat gap=10.0;
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width/2)-37, 25, 75, 75)];
    [imageView setImage:[UIImage imageNamed:@"edit_profile"]];
    [imageView setUserInteractionEnabled:YES];
    [view bringSubviewToFront:imageView];
    [view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editProfileAction)];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [imageView addGestureRecognizer:tap];

    _userNameText = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 +imageView.frame.size.height + gap , self.frame.size.width-30, 20)];
    _userNameText.textColor = [UIColor whiteColor];
    _userNameText.numberOfLines=0;
    [_userNameText setFont:APP_FONT_BOLD_18];
    [view addSubview:_userNameText];
    [_userNameText setText:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"FullName"]];
    
    _emailName = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 +imageView.frame.size.height+15 +20, self.frame.size.width-30, 45)];
    _emailName.textColor = [UIColor whiteColor];
    _emailName.numberOfLines=0;
    [_emailName setFont:APP_FONT_REGULAR_16];
    [self addSubview:_emailName];
    [_emailName setText:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"Email"]];
    
    view.frame=CGRectMake(0, 0, self.frame.size.width, imageView.frame.size.height+65+3*gap+25);
    
    UITableView *menuItems = [[UITableView alloc] initWithFrame:CGRectMake(0, view.frame.size.height, CGRectGetWidth(frame), CGRectGetHeight(frame)-view.frame.size.height) style:UITableViewStyleGrouped];
    menuItems.dataSource = self;
    menuItems.delegate = self;
    menuItems.backgroundColor = [UIColor whiteColor];
    [menuItems setSeparatorColor:[UIColor clearColor]];
    menuItems.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, menuItems.bounds.size.width, 0.01f)];
    [self addSubview:menuItems];
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.textLabel.text = titles[indexPath.row];
    if(indexPath.row == 0){
        cell.textLabel.textColor = APP_COLOR;
    }else{
        cell.textLabel.textColor = DARK_GRAY;
    }
    cell.textLabel.font = APP_FONT_BOLD_16;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [_delegate.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 1:
            [self myOrdersAction];
            break;
        case 2:
            [self changePasswordAction];
            break;
        case 3:
            [self logout];
            break;
        default:
            break;
    }
    [self closeMenu];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *imageView=touch.view;
    if([imageView isKindOfClass:[UIImageView class]]){
        return YES;
    }
    return NO;
}

-(void)editProfileAction{
    [self closeMenu];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfile *nextView = [storyboard instantiateViewControllerWithIdentifier:@"EditProfile"];
    [_delegate.navigationController pushViewController:nextView animated:YES];
}
-(void)myOrdersAction{
    OrderHistoryVC *nextView = [[OrderHistoryVC alloc] init];
    nextView.fromhamburger=true;
    [_delegate.navigationController pushViewController:nextView animated:YES];
}
-(void)changePasswordAction{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChangePassword *nextView = [storyboard instantiateViewControllerWithIdentifier:@"ChangePassword"];
    [_delegate.navigationController pushViewController:nextView animated:YES];
}
- (void)logout {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want logout from the application" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex){
        [_delegate logoutButtonClicked];
    }
}
- (void)closeMenu {
    [UIView animateWithDuration:0.5 animations:^{
        self.superview.frame = CGRectMake(CGRectGetWidth(self.superview.frame)*0.75*(-1), 0, CGRectGetWidth(self.superview.frame), CGRectGetHeight(self.frame));
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

@end
