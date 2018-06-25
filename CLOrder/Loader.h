//
//  Loader.h
//  AdminDlink
//
//  Created by BasavaRaju D on 11/17/14.
//  Copyright (c) 2014 openSrc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Loader : UIView{
    int retainCountVal;
    NSMutableArray *indicatorImageArray;
    UIView * whiteView;
//    UILabel * toasterLbl;

}
@property(nonatomic, assign) int retainCountVal;
-(void)showLoading:(bool)complteScreen;

@end
