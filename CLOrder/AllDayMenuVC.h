//
//  AllDayMenuVC.h
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AllDayMenuVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate , UICollectionViewDataSource> {
    UITableView *menuTbl;
    UICollectionView *menuCollection;
    UILabel *menuNamelbl;
}
- (void) logoutButtonClicked;

@end
