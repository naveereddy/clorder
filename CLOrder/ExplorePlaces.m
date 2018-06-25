//
//  ExplorePlaces.m
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "ExplorePlaces.h"
#import "AppHeader.h"

@implementation ExplorePlaces

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImg.image = [UIImage imageNamed:APP_BG_IMG];
    [self.view addSubview:bgImg];
    
    self.title = [NSString stringWithFormat:@"%@",@"EXPLORE PLACES"];
    
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBar.frame = CGRectMake(0, 0, 20, 20);
    [rightBar setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
    [rightBar addTarget:self action:@selector(rightBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarItem,nil];
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    placesTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    placesTbl.delegate = self;
    placesTbl.dataSource = self;
    placesTbl.separatorColor = [UIColor clearColor];
    [self.view addSubview:placesTbl];
}

-(void) rightBarAct{
    
}

-(void) proceedBtnAct{
    
}

-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.backgroundColor = DARK_GRAY;
    
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-50, 30)];
    headerLbl.text = @"Nearby Places";
    headerLbl.textColor = [UIColor whiteColor];
    
    UIButton *proceedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proceedBtn.frame = CGRectMake(SCREEN_WIDTH-40, 5, 30, 30);
    [proceedBtn setImage:[UIImage imageNamed:@"right-arrow-white"] forState:UIControlStateNormal];
    [proceedBtn addTarget:self action:@selector(proceedBtnAct) forControlEvents:UIControlEventTouchUpInside];
    
    [header addSubview: headerLbl];
    [header addSubview: proceedBtn];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.5];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    //    NSData *imgData;
    UIImageView *placeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    placeIcon.image = [UIImage imageNamed:@"logo-dummy"];
    
    UILabel *placeName = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, SCREEN_WIDTH-85-50, 20)];
    placeName.textColor = [UIColor blackColor];
    placeName.text = [NSString stringWithFormat:@"%@", @"The Original Rinaldi's"];
    
    UILabel *placeAddress =[[UILabel alloc] initWithFrame:CGRectMake(75, 25, SCREEN_WIDTH-85, 30)];
    placeAddress.numberOfLines = 0;
    placeAddress.textColor = [UIColor lightGrayColor];
    placeAddress.text = [NSString stringWithFormat:@"%@", @"323 Main St, El Segundo, CA 90245, United States  323 Main St, El Segundo, CA 90245, United States"];
    placeAddress.font = [UIFont systemFontOfSize:12];
    
    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 5, 50, 20)];
    distance.textColor = APP_COLOR;
    distance.text = [NSString stringWithFormat:@"%@ mi", @"89"];
    
    [cell.contentView addSubview:placeName];
    [cell.contentView addSubview:placeIcon];
    [cell.contentView addSubview:placeAddress];
    [cell.contentView addSubview:distance];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [placesTbl deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
