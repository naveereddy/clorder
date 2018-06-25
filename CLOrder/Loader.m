//
//  Loader.m
//  AdminDlink
//
//  Created by BasavaRaju D on 11/17/14.
//  Copyright (c) 2014 openSrc. All rights reserved.
//

#import "Loader.h"
#import "AppDelegate.h"
#import "AppHeader.h"

@implementation Loader
@synthesize retainCountVal;
UILabel * loadingLbl;
UIActivityIndicatorView * act;
- (id)init
{
    if (self) {
        retainCountVal = 0;
        
        AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CGSize size = appDel.window.frame.size;
        self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        indicatorImageArray = [[NSMutableArray alloc]init];
        for (int i=1; i <= 30; i++) {
            [indicatorImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"load-%d (dragged).tiff",i]]];
        }
        self.backgroundColor = [UIColor clearColor];
        int ht = size.height;
        
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, ht)];
        whiteView.backgroundColor =TRANSPARENT_GRAY;
        
        UIImageView *actIndicator=[[UIImageView alloc]initWithFrame:CGRectMake(size.width/2-50, (ht)/2-50, 100, 100)];
        actIndicator.animationImages = indicatorImageArray;
        [actIndicator startAnimating];
        
//        UILabel *statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(actIndicator.frame.size.width/2-40, actIndicator.frame.size.height/2-15, 80, 30)];
//        statusLbl.textAlignment = NSTextAlignmentCenter;
//        statusLbl.font = [UIFont boldSystemFontOfSize:12];
//        statusLbl.textColor = APP_GREEN_COLOR;
//        statusLbl.text = @"PROCESSING";
//        statusLbl.backgroundColor = [UIColor whiteColor];
//        statusLbl.layer.cornerRadius = 5.0;
//        [actIndicator addSubview:statusLbl];
        
        [whiteView addSubview:actIndicator];
        
        [self addSubview:whiteView];
    }
    return self;
}
-(void)showLoading:(bool)complteScreen {

    AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGSize size = appDel.window.frame.size;
    int ht = size.height;
    if(complteScreen)
        whiteView.frame=CGRectMake(0, 20, size.width, ht-20);
    else
        whiteView.frame=CGRectMake(0, 64, size.width, ht-64);
    
}

@end
