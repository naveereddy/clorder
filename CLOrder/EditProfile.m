//
//  EditProfile.m
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "EditProfile.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "APIRequester.h"

@interface EditProfile ()

@end

@implementation EditProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    emailtext.delegate = self;
    [emailtext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    emailtext.leftViewMode= UITextFieldViewModeAlways;
    emailtext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email-palceholder"]];
    
    usernametext.delegate = self;
    [usernametext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    usernametext.leftViewMode= UITextFieldViewModeAlways;
    usernametext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name-palceholder"]];
    
    profileImage.layer.cornerRadius=profileImage.frame.size.width/2;
    profileImage.layer.borderWidth=1;
    profileImage.layer.borderColor=[APP_COLOR_LIGHT CGColor];
    [profileImage setBackgroundColor:[UIColor whiteColor]];
    [profileImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateProfilePic)];
    [profileImage addGestureRecognizer:tap];
}
- (void)updateProfilePic {
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
    [actions showInView:self.view.superview];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imgPic = [[UIImagePickerController alloc] init];
    imgPic.delegate = self;
    switch (buttonIndex) {
        case 0:
            imgPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imgPic animated:YES completion:nil];
            break;
        case 1:
            imgPic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imgPic animated:YES completion:nil];
            break;
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    profileImage.image=[UIImage imageWithData:UIImageJPEGRepresentation(image, 0.2)];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
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
