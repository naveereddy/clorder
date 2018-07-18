//
//  ForgotPassword.m
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "ForgotPassword.h"
#import "AppHeader.h"
#import "AppDelegate.h"
#import "APIRequester.h"
#import "APIRequest.h"

@interface ForgotPassword ()

@end

@implementation ForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    [sendButton setEnabled:NO];
    email.delegate = self;
    [email.layer addSublayer:[self bottomborderAdding:self.view.frame.size.width-40 height:40]];
    email.leftViewMode= UITextFieldViewModeAlways;
    email.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email-palceholder"]];
    
//   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"recapcha" ofType:@"html"];
    NSURL *nsurl=[NSURL URLWithString:@"http://api.clorder.com/recaptcha/index.html"];
    webView.scrollView.scrollEnabled = YES;
    webView.userInteractionEnabled=YES;
    webView.delegate=self;
    NSURLRequest *req=[[NSURLRequest alloc] initWithURL:nsurl];
    [webView loadRequest:req];
    [AppDelegate loaderShow:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
//    [webView removeFromSuperview];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"URL from webview %@",request.URL);
    if([request.URL.absoluteString containsString:@"verificationSucess"]){
        [self verificationSucess:request.URL.absoluteString];
        [sendButton setEnabled:YES];
        return NO;
    }else{
        return YES;
    }
}
-(void)verificationSucess:(NSString *) string{
    NSLog(@"verification string %@",string);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [AppDelegate loaderShow:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [AppDelegate loaderShow:NO];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)sendAction: (id)sender{
    [email resignFirstResponder];
    if([self textValidation]){
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:email.text,@"UserEmailId",CLIENT_ID,@"Clientid",nil];
    [APIRequest forgotPasswordApi:dic completion:^(NSMutableData *buffer){
        if(!buffer){
            NSLog(@"Unknown ERROR");
        }else{
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            if(![[resObj objectForKey:@"IsSuccess"] boolValue]){
                [email setText:@""];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[resObj objectForKey:@"UserEmailId"] message:[resObj objectForKey:@"Status"] delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
                [alert setTag:100];
                [alert show];
            }else{
                [email setText:@""];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email" delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
        [alert setTag:100];
        [alert show];
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(bool)textValidation{
    if ((email.text.length > 0) && [self validateEmailWithString:email.text]) {
        return YES;
    }else
        return NO;
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

@end
