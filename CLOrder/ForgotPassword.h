//
//  ForgotPassword.h
//  CLOrder
//
//  Created by Naveen Thukkani on 25/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CLOrder-Swift.h"
#import <WebKit/WebKit.h>

@interface ForgotPassword : UIViewController<UITextFieldDelegate,UIWebViewDelegate>{
IBOutlet UITextField *email;
IBOutlet UIButton *sendButton;
IBOutlet  UIWebView *webView;
}
-(IBAction)sendAction: (id)sender;
@end
