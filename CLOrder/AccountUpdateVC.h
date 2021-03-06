//
//  AccountUpdateVC.h
//  CLOrder
//
//  Created by Vegunta's on 31/05/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
//#import "PayPalConfiguration.h"
//#import "PayPalPaymentViewController.h"
#import "PayPalMobile.h"
#import <PassKit/PassKit.h>
#import "BTAPIClient.h"
#import "BraintreeApplePay.h"

@interface AccountUpdateVC : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, PKPaymentAuthorizationViewControllerDelegate>{
    UIView *dummyView;
    UITableView *cardTbl;
}
@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) PayPalConfiguration *paypalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) NSString *resultText;


@end
