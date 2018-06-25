//
//  AppDelegate.h
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loader.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "PayPalMobile.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

+(void)loaderShow:(BOOL)val;

@end

