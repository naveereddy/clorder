//
//  AllDayMenuVC.m
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "AllDayMenuVC.h"
#import "AppHeader.h"
#import "ItemVC.h"
#import "CheckOut.h"
#import "AddItem.h"
#import "PayDetailStp1.h"
#import "PaymentDetails.h"
#import "AccountUpdateVC.h"
#import "LocationContact.h"
#import "OrderConfirmationV.h"
#import "SignUpView.h"
#import "APIRequest.h"
#import "CartObj.h"
#import "Menu.h"
#import "SideMenu.h"
#import "AppDelegate.h"


@implementation AllDayMenuVC{
    NSMutableArray *menuTypesArr;
    NSMutableArray *clientCategoriesArr;
    NSMutableArray *menuArr;
    int menuArrIndex;
    NSString *spclNoteStr;
    
    NSString *startTime;
    NSString *endTime;
    NSMutableArray *imagesdataArray;
    UIView *mainBgView;
    NSUserDefaults *user;
    UIButton *cartIcon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [NSUserDefaults standardUserDefaults];

    UIView *actionsView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    [actionsView setBackgroundColor:APP_COLOR_LIGHT_BACKGROUND];
    [self.view addSubview:actionsView];
    
    menuNamelbl=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, SCREEN_WIDTH-100, 30)];
    [menuNamelbl setTextColor:DARK_GRAY];
    [menuNamelbl setTextAlignment:NSTextAlignmentCenter];
    [actionsView addSubview:menuNamelbl];
    [menuNamelbl setFont:[UIFont fontWithName:@"Lora-Bold" size:18]];
    
    
    UIButton *righArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    righArrow.frame = CGRectMake(SCREEN_WIDTH-40, 10, 20, 20);
    [righArrow setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [righArrow addTarget:self action:@selector(righArrowAct) forControlEvents:UIControlEventTouchUpInside];
    [actionsView addSubview:righArrow];
    
    UIButton *leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    leftArrow.frame = CGRectMake(10, 10, 20, 20);
    [leftArrow setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftArrow addTarget:self action:@selector(leftArrowAct) forControlEvents:UIControlEventTouchUpInside];
    [actionsView addSubview:leftArrow];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    menuCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) collectionViewLayout:layout];
    [menuCollection setDataSource:self];
    [menuCollection setDelegate:self];
    [menuCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [menuCollection setBackgroundColor:APP_COLOR_LIGHT_WHITE];
    
    [self.view addSubview:menuCollection];
    
    imagesdataArray= [[NSMutableArray alloc] initWithCapacity:0];

    spclNoteStr = @"Special Notes..";
    [APIRequest fetchMenuWithCategories:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", nil] completion:^(NSMutableData *buffer){
        if (!buffer){
            NSLog(@"Unknown ERROR");
        }else{
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            menuArr = [[NSMutableArray alloc] initWithArray:[resObj objectForKey:@"clientMenuCategories"]];
            if ([menuArr count]) {
                clientCategoriesArr=[[NSMutableArray alloc] initWithArray:[[menuArr objectAtIndex:0] objectForKey:@"Categories"]];
                [self creatingmenu];
                [menuNamelbl setText:[NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:0] objectForKey:@"Title"]]];
                startTime = [NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:0] objectForKey:@"startTime"]];
                endTime = [NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:0] objectForKey:@"endTime"]];

            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error fetching menu details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
            
            [menuCollection reloadData];
        }
    }];
    
    cartIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    cartIcon.frame = CGRectMake(0, 0, 44, 44);
    [cartIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cartIcon.titleLabel setFont:[UIFont fontWithName:@"Lora-Bold" size:12]];
    [cartIcon.titleLabel.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cartIcon.titleLabel.layer setBorderWidth:1];
    [cartIcon.titleLabel.layer setCornerRadius:8];
    cartIcon.titleLabel.layer.masksToBounds = YES;
    [cartIcon.titleLabel setBackgroundColor:[UIColor blackColor]];
    [cartIcon setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [cartIcon addTarget:self action:@selector(cartBtnAct) forControlEvents:UIControlEventTouchUpInside];
    cartIcon.titleEdgeInsets = UIEdgeInsetsMake(-10,0,0,0);
    cartIcon.imageEdgeInsets = UIEdgeInsetsMake(10,10,0,0);
    UIBarButtonItem * rightBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:cartIcon];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarItem1, nil];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    if ([[user objectForKey:@"userInfo"] objectForKey:@"UserId"] > 0) {
        [backBtn setImage:[UIImage imageNamed:@"hamburger_menu"] forState:UIControlStateNormal];
    }else{
        [backBtn setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    }
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftBarItem, nil];
    
//    menuTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-64)];
//    menuTbl.delegate = self;
//    menuTbl.dataSource = self;
//    menuTbl.separatorColor = [UIColor clearColor];
//    [self.view addSubview:menuTbl];
    
}
-(void)creatingmenu{
    for (int i=0; i< clientCategoriesArr.count; i++){
        Menu *menu=[[Menu alloc] init];
        [imagesdataArray addObject:menu];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return clientCategoriesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if ([cell.contentView subviews]) {
        for (UIView *view in cell.subviews){
            [view removeFromSuperview];
        }
    }
    UIImageView *images=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width/2)-20, (self.view.frame.size.width/2)-20)];
    [images.layer setBorderColor:[APP_COLOR_LIGHT_WHITE CGColor]];
    [images.layer setBorderWidth:1];
    [images setTag:indexPath.row+100];
    images.contentMode=UIViewContentModeScaleAspectFit;
    images.image=[UIImage imageNamed:@"menu-placeholder"];
    [cell addSubview:images];


    UILabel *menuName=[[UILabel alloc] initWithFrame:CGRectMake(10,(self.view.frame.size.width/2)/2-15, (self.view.frame.size.width/2)-20, 30)];
    [menuName setTextColor:[UIColor whiteColor]];
    [menuName setFont:[UIFont fontWithName:@"Lora-Bold" size:18]];
    [menuName setTextAlignment:NSTextAlignmentCenter];
    [menuName setNumberOfLines:0];
    [images bringSubviewToFront:menuName];
    [images addSubview:menuName];
    [menuName setText:[NSString stringWithFormat:@"%@", [[clientCategoriesArr objectAtIndex:indexPath.row] objectForKey:@"CategoryTitle"]]];
    
    if(((Menu *)[imagesdataArray objectAtIndex:indexPath.row]).imagedata && indexPath.row == images.tag-100){
        images.image=[UIImage imageWithData:((Menu *)[imagesdataArray objectAtIndex:indexPath.row]).imagedata];
    }else{
       dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
           NSDictionary *dic=[clientCategoriesArr objectAtIndex:indexPath.row];
           NSString *path = @"";
           if([[dic allKeys] containsObject:@"CategoryImageURL"]){
               path=[dic objectForKey:@"CategoryImageURL"];
           }else{
//               path=@"https://s3.amazonaws.com/Clorder/Client/chickenplate-wb.png";
           }
         NSData *dta = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
         UIImage *image = [UIImage imageWithData:dta];
         dispatch_async(dispatch_get_main_queue(), ^(void){
            if (indexPath.row == images.tag-100){
                if(dta){
                    images.image=image;
                    if([imagesdataArray count] > indexPath.row){
                        ((Menu *)[imagesdataArray objectAtIndex:indexPath.row]).imagedata=dta;
                        ((Menu *)[imagesdataArray objectAtIndex:indexPath.row]).categoryTitle=[NSString stringWithFormat:@"%@", [[clientCategoriesArr objectAtIndex:indexPath.row] objectForKey:@"CategoryTitle"]];
                        ((Menu *)[imagesdataArray objectAtIndex:indexPath.row]).categoryId=[[clientCategoriesArr objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
                    }
                }else{
                    images.image=[UIImage imageNamed:@"menu-placeholder"];
                }
             }
         });
        });
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDateFormatter *formDt = [[NSDateFormatter alloc] init];
    [formDt setDateFormat:@"HH:mm"];
    NSDate *openTime = [formDt dateFromString:startTime];
    NSDate *closeTime= [formDt dateFromString:endTime];
    NSString *curTimeStr = [self selectedTimeInString];
    NSLog(@"%@",[[CartObj instance].userInfo objectForKey:@"OrderTime"]);
    NSDate *currTime = [formDt dateFromString:curTimeStr];
    
    if ([currTime compare:openTime] == NSOrderedDescending && [currTime compare:closeTime] == NSOrderedAscending ) {
        ItemVC *subItem = [[ItemVC alloc] init];
        subItem.categoryId = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        subItem.itemName = [NSString stringWithFormat:@"%@",[[clientCategoriesArr objectAtIndex:indexPath.row] objectForKey:@"CategoryTitle"]];
        subItem.clientCategoriesArr = clientCategoriesArr;
        [self.navigationController pushViewController:subItem animated:NO];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This menu is not available for selected time" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2-20, self.view.frame.size.width/2-20);
}
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(10,10,5,10);  // top, left, bottom, right
}

-(void)viewWillAppear:(BOOL)animated{
    [cartIcon setTitle:[NSString stringWithFormat:@" %lu ",(unsigned long)[CartObj instance].itemsForCart.count] forState:UIControlStateNormal];
    [cartIcon setNeedsLayout];
    [cartIcon layoutIfNeeded];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 64)];
//    [self.view addSubview:bottomView];
    [bottomView setBackgroundColor:APP_COLOR];
    [bottomView setUserInteractionEnabled:YES];
    
    
    UIButton *itemsCount = [UIButton buttonWithType:UIButtonTypeCustom];
    itemsCount.frame = CGRectMake(10, 10, 90, 44);
    [itemsCount setTitle:[NSString stringWithFormat:@"%lu Item(s)",[CartObj instance].itemsForCart.count] forState: UIControlStateNormal];
    [itemsCount addTarget:self action:@selector(cartBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:itemsCount];
    [itemsCount.titleLabel setFont:[UIFont fontWithName:@"Lora-Regular" size:18]];
    
    UIButton *checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkOutBtn.frame = CGRectMake(110, 10, SCREEN_WIDTH-110-80, 44);
    [checkOutBtn setTitle:@"VIEW CART" forState:UIControlStateNormal];
    checkOutBtn.titleLabel.font = [UIFont fontWithName:@"Lora-Bold" size:18];
    [checkOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkOutBtn addTarget:self action:@selector(checkOutBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:checkOutBtn];
    
    UILabel *subTotalLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80,10,80,44)];
    subTotalLbl.textColor = [UIColor whiteColor];
    subTotalLbl.textAlignment = NSTextAlignmentCenter;
    subTotalLbl.font = [UIFont fontWithName:@"Lora-Regular" size:18];
    [bottomView addSubview:subTotalLbl];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"subTotalPrice"] ) {
        subTotalLbl.text = [NSString stringWithFormat:@"$%@",[user objectForKey:@"subTotalPrice"]];
    }else{
        subTotalLbl.text = [NSString stringWithFormat:@"$0"];
    }
}


-(void)backBtnAct{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AddMore"] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:0] forKey:@"AddMore"];
    }else{
        NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
        [self.navigationController popViewControllerAnimated:YES];

    }
}
-(void) righArrowAct{
    if ([menuArr count]) {
        if (menuArrIndex+1 < [menuArr count]) {
            ++menuArrIndex;
        }else{
            menuArrIndex = 0;
        }
        imagesdataArray.count ==1 ? [imagesdataArray  removeObjectAtIndex:0]:[imagesdataArray removeAllObjects];
        clientCategoriesArr=[[menuArr objectAtIndex:menuArrIndex] objectForKey:@"Categories"];
        [self creatingmenu];
        [menuNamelbl setText:[NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:menuArrIndex] objectForKey:@"Title"]]];
        startTime = [NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:menuArrIndex] objectForKey:@"startTime"]];
        endTime = [NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:menuArrIndex] objectForKey:@"endTime"]];
        [menuCollection reloadData];
        [menuCollection setCollectionViewLayout:[UICollectionViewFlowLayout new] animated:YES completion:nil];
        [menuCollection layoutIfNeeded];
    }
    
}

-(void) leftArrowAct{
    if ([menuArr count]) {
        if (menuArrIndex-1 >= 0) {
            --menuArrIndex;
        }else{
            menuArrIndex = [menuArr count]-1;
        }
        imagesdataArray.count ==1 ? [imagesdataArray  removeObjectAtIndex:0]:[imagesdataArray removeAllObjects];
        clientCategoriesArr=[[menuArr objectAtIndex:menuArrIndex] objectForKey:@"Categories"];
        [self creatingmenu];
        [menuNamelbl setText:[NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:menuArrIndex] objectForKey:@"Title"]]];
        startTime = [NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:menuArrIndex] objectForKey:@"startTime"]];
        endTime = [NSString stringWithFormat:@"%@", [[menuArr objectAtIndex:menuArrIndex] objectForKey:@"endTime"]];
        [menuCollection reloadData];
        [menuCollection setCollectionViewLayout:[UICollectionViewFlowLayout new] animated:YES completion:nil];
        [menuCollection layoutIfNeeded];
    }
}


-(void) cartBtnAct{
    [self checkOutBtnAct];
}

-(void) checkOutBtnAct{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AddMore"] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
            for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:@"cart"]) {
                NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:data]);
            }
            CheckOut *checkOutV = [[CheckOut alloc] init];
            [self.navigationController pushViewController:checkOutV animated:YES];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:0] forKey:@"AddMore"];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0)];
    UILabel *spclNotes = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, [self headerHeight])];
    spclNotes.numberOfLines = 0;
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:spclNotes];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)headerHeight{
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",spclNoteStr] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/14; i++){
        gap++;
    }
    return labelHeight.size.height+gap*4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  clientCategoriesArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(5, 3, SCREEN_WIDTH-10, cell.frame.size.height-5)];
    cellView.layer.cornerRadius = 5.0;
    cellView.layer.borderColor = [DARK_GRAY CGColor];
    cellView.layer.borderWidth=1.0;
    cellView.backgroundColor = [UIColor whiteColor];
    
    UILabel *itemName = [[UILabel alloc] initWithFrame:CGRectMake(10, cellView.frame.size.height/2-15, cellView.frame.size.width-60, 30)];
    itemName.text = [NSString stringWithFormat:@"%@", [[clientCategoriesArr objectAtIndex:indexPath.row] objectForKey:@"CategoryTitle"]];
    itemName.textColor = DARK_GRAY;
    itemName.font = [UIFont boldSystemFontOfSize:18];
    
    UIImageView *cellSel = [[UIImageView alloc] initWithFrame:CGRectMake(cellView.frame.size.width-45, cellView.frame.size.height/2-15, 30, 30)];
    cellSel.image = [UIImage imageNamed:@"direction_right_withbg"];
    cellSel.backgroundColor = DARK_GRAY;
    cellSel.layer.cornerRadius = 15;
    [cellView addSubview: itemName];
    [cellView addSubview: cellSel];
    
    [cell.contentView addSubview:cellView];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [menuTbl deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDateFormatter *formDt = [[NSDateFormatter alloc] init];
    [formDt setDateFormat:@"HH:mm"];
    NSDate *openTime = [formDt dateFromString:startTime];
    NSDate *closeTime= [formDt dateFromString:endTime];
    NSString *curTimeStr = [self selectedTimeInString];
    NSLog(@"%@",[[CartObj instance].userInfo objectForKey:@"OrderTime"]);
    NSDate *currTime = [formDt dateFromString:curTimeStr];
    
    if ([currTime compare:openTime] == NSOrderedDescending && [currTime compare:closeTime] == NSOrderedAscending ) {
        ItemVC *subItem = [[ItemVC alloc] init];
        subItem.categoryId = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        subItem.itemName = [NSString stringWithFormat:@"%@",[[clientCategoriesArr objectAtIndex:indexPath.row] objectForKey:@"CategoryTitle"]];
        subItem.clientCategoriesArr = clientCategoriesArr;
        [self.navigationController pushViewController:subItem animated:NO];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This menu is not available for selected time" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(NSString *)selectedTimeInString{
    NSString *timeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"];
    if (!timeStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/YYYY"];
        [[NSUserDefaults standardUserDefaults] setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderDate"];
        AppDelegate * appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:[appDel findTimeZoneId:[user objectForKey:@"TimeZone"]]];
        NSLog(@"%@", [[CartObj instance].userInfo objectForKey:@"timeArr"]);
        [formatter setDateFormat:@"hh:mm a"];
        [[NSUserDefaults standardUserDefaults] setObject:[formatter stringFromDate:[NSDate date]] forKey:@"OrderTime"];
    }
    timeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"];
    NSArray *arr = [timeStr componentsSeparatedByString:@" "];
    int addHour = 0;
    
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithArray:[[arr objectAtIndex:0] componentsSeparatedByString:@":"]];
    if ([[arr objectAtIndex:1] isEqualToString:@"PM"] && ![[arr1 objectAtIndex:0] isEqualToString:@"12"]) {
        addHour = 12;
    }
    [arr1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:[[arr1 objectAtIndex:0] intValue]+addHour]];
    
    return [NSString stringWithFormat:@"%@:%@", [arr1 objectAtIndex:0], [arr1 objectAtIndex:1]];
}

- (void)toggleMenu:(UIButton *)sender {
    if ([[user objectForKey:@"userInfo"] objectForKey:@"UserId"] > 0) {
    if (!mainBgView) {
        mainBgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        mainBgView.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].delegate.window addSubview:mainBgView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.tag = 73;
        bgView.alpha = 0.3;
        [mainBgView addSubview:bgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
        [bgView addGestureRecognizer:tap];
        
        SideMenu *menu = [[SideMenu alloc] initWithFrame:CGRectMake(CGRectGetWidth(bgView.frame)*0.75*(-1), 0, CGRectGetWidth(bgView.frame)*0.75, CGRectGetHeight(bgView.frame))];
        menu.tag = 77;
        [mainBgView addSubview:menu];
        menu.delegate=self;
        [UIView animateWithDuration:0.5 animations:^{
            menu.frame = CGRectMake(0, 0, CGRectGetWidth(bgView.frame)*0.75, CGRectGetHeight(bgView.frame));
        }];
        CGRect r = bgView.frame;
        r.size.width *= 3;
        bgView.frame = r;
    } else {
        mainBgView.frame = [[UIScreen mainScreen] bounds];
        CGRect r = mainBgView.frame;
        r.size.width *= 3;
        [mainBgView viewWithTag:73].frame = r;
        [[UIApplication sharedApplication].delegate.window addSubview:mainBgView];
        [mainBgView viewWithTag:77].frame = CGRectMake(CGRectGetWidth(mainBgView.frame)*0.75*(-1), 0, CGRectGetWidth(mainBgView.frame)*0.75, CGRectGetHeight(mainBgView.frame));
        [UIView animateWithDuration:0.5 animations:^{
            [mainBgView viewWithTag:77].frame = CGRectMake(0, 0, CGRectGetWidth(mainBgView.frame)*0.75, CGRectGetHeight(mainBgView.frame));
        }];
    }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeMenu:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.5 animations:^{
        tap.view.superview.frame = CGRectMake(CGRectGetWidth(tap.view.frame)*0.75*(-1), 0, CGRectGetWidth(tap.view.frame), CGRectGetHeight(tap.view.frame));
    } completion:^(BOOL finished) {
        [tap.view.superview removeFromSuperview];
    }];
}
- (void) logoutButtonClicked{
    [user removeObjectForKey:@"userInfo"];
    [user removeObjectForKey:@"cartPrice"];
    [user removeObjectForKey:@"PaymentInformation"];
    [user removeObjectForKey:@"subTotalPrice"];
    [user removeObjectForKey:@"cart"];
    [user removeObjectForKey:@"CouponDetails"];
    [user removeObjectForKey:@"TipIndex"];
    [[CartObj instance].itemsForCart removeAllObjects];
    [CartObj clearInstance];
    
    [[GIDSignIn sharedInstance] signOut];
    [[FBSDKLoginManager new] logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
