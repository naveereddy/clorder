//
//  EditProfile.m
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "EditProfile.h"
#import "AppHeader.h"
#import "APIRequester.h"
#import "APIRequest.h"

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
    emailtext.text=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"Email"];

    usernametext.delegate = self;
    [usernametext.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    usernametext.leftViewMode= UITextFieldViewModeAlways;
    usernametext.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name-palceholder"]];
    usernametext.text=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"FullName"];
    
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
    if([self textValidation]){
        NSDictionary * dic=[[NSDictionary alloc] initWithObjectsAndKeys:CLIENT_ID, @"clientId",emailtext.text,@"Email",usernametext.text,@"FullName",usernametext.text,@"FirstName",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"UserId"],@"UserId",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"UserAddress"],@"UserAddress",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"isFirstTimeUser"],@"isFirstTimeUser",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"lastOrderDays"],@"lastOrderDays",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"Password"],@"Password",usernametext.text,@"LastName",@"",@"PaymentInformation",nil];
        
        [APIRequest updateClorderUser:dic completion:^(NSMutableData *buffer) {
            if (!buffer){
                NSLog(@"Unknown ERROR");
            }else{
                NSError *error = nil;
                NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"Response :\n %@",resObj);
                if(![[resObj objectForKey:@"isSuccess"] boolValue]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[resObj objectForKey:@"status"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    emailtext.text=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"Email"];
                    usernametext.text=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"FullName"];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Failed to update user profile, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(bool)textValidation{
    if ((usernametext.text.length > 0) && (emailtext.text.length > 0) && ([self validateEmailDomain]) && [self validateEmailWithString:emailtext.text]) {
        return YES;
    }else
        return NO;
}
-(BOOL)validateEmailDomain{
    NSArray *domainList = [[NSArray alloc] initWithObjects:@"com", @"net", @"org", @"edu", @"co", nil];
    NSArray *domain = [emailtext.text componentsSeparatedByString:@"@"];
    domain = [[NSArray alloc] initWithArray:[[domain objectAtIndex:1] componentsSeparatedByString:@"."]];
    BOOL validMail = NO;
    if (domain.count > 1 && domain.count <= 3) {
        for (int i = 0; i < domainList.count; i++) {
            if ([[domain objectAtIndex:1] isEqualToString:[domainList objectAtIndex:i]]) {
                if ([[domainList objectAtIndex:i] isEqualToString:@"co"]) {
                    if (domain.count==3) {
                        if (([[domain objectAtIndex:2] isEqualToString:@"in"] || [[domain objectAtIndex:2] isEqualToString:@"nz"])) {
                            
                            validMail = YES;
                            break;
                        }else{
                            validMail = NO;
                            break;
                        }
                    }else{
                        validMail = NO;
                        break;
                    }
                }
                validMail = YES;
                break;
            }
        }
    }
    return validMail;
}
- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
