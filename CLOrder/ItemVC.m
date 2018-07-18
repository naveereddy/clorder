//
//  ItemVC.m
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "ItemVC.h"
#import "AppHeader.h"
#import "APIRequest.h"
#import "AddItem.h"
#import "CheckOut.h"
#import "CartObj.h"
#import "Item.h"

@implementation ItemVC{
    NSMutableArray *clientItemsArr;
    int clientCategoriesArrIndex;
    NSString *spclNoteStr;
    NSMutableArray *imagesdataArray;
    UIButton *cartIcon;
}
@synthesize categoryId, itemName, clientCategoriesArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@",[[clientCategoriesArr objectAtIndex:clientCategoriesArrIndex] objectForKey:@"CategoryTitle"]];
    spclNoteStr = @"Special Notes..";
    
    clientCategoriesArrIndex = [categoryId intValue];
    
    UIView *actionsView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    [actionsView setBackgroundColor:APP_COLOR_LIGHT_BACKGROUND];
    [self.view addSubview:actionsView];
    
    menuNamelbl=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, SCREEN_WIDTH-100, 30)];
    [menuNamelbl setTextColor:DARK_GRAY];
    [menuNamelbl setTextAlignment:NSTextAlignmentCenter];
    [menuNamelbl setFont:[UIFont fontWithName:@"Lora-Bold" size:18]];
    [actionsView addSubview:menuNamelbl];
    
    
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
    
    ItemTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40)];
    ItemTbl.delegate = self;
    ItemTbl.dataSource = self;
    ItemTbl.separatorColor = [UIColor clearColor];
    [self.view addSubview:ItemTbl];
    
    imagesdataArray= [[NSMutableArray alloc] initWithCapacity:0];

    [self fetchClientItems];
    

    
    cartIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    cartIcon.frame = CGRectMake(0, 0, 44, 44);
    [cartIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cartIcon.titleLabel setFont:[UIFont fontWithName:@"Lora-Bold" size:12]];
    [cartIcon.titleLabel.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cartIcon.titleLabel.layer setBorderWidth:1];
    [cartIcon.titleLabel.layer setCornerRadius:8];
    [cartIcon.titleLabel setBackgroundColor:[UIColor blackColor]];
    cartIcon.titleLabel.layer.masksToBounds = YES;
    [cartIcon setNeedsLayout];
    [cartIcon layoutIfNeeded];
    [cartIcon setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [cartIcon addTarget:self action:@selector(cartBtnAct) forControlEvents:UIControlEventTouchUpInside];
    cartIcon.titleEdgeInsets = UIEdgeInsetsMake(-10,0,0,0);
    cartIcon.imageEdgeInsets = UIEdgeInsetsMake(10,10,0,0);
    UIBarButtonItem * rightBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:cartIcon];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarItem1, nil];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftBarItem, nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [cartIcon setTitle:[NSString stringWithFormat:@" %lu ",(unsigned long)[CartObj instance].itemsForCart.count] forState:UIControlStateNormal];

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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchClientItems{
    NSDictionary *payload = [[NSDictionary alloc] initWithObjectsAndKeys:CLIENT_ID, @"clientId", [[clientCategoriesArr objectAtIndex:clientCategoriesArrIndex] objectForKey:@"CategoryId"] , @"CategoryId", nil];
    [APIRequest fetchClientItems:payload completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            clientItemsArr = [[NSMutableArray alloc] init];

            if (![[resObj objectForKey:@"clientItems"] isKindOfClass:[NSNull class]] && [[resObj objectForKey:@"clientItems"] count]>0) {
                clientItemsArr = [resObj objectForKey:@"clientItems"];
            }
            [self createItems];
            [ItemTbl reloadData];
             [menuNamelbl setText:[NSString stringWithFormat:@"%@",[[clientCategoriesArr objectAtIndex:clientCategoriesArrIndex] objectForKey:@"CategoryTitle"]]];
        }
    }];
}
-(void)createItems{
    for (int i=0; i<clientItemsArr.count; i++ ){
        Item *item=[[Item alloc] init];
        [imagesdataArray addObject:item];
    }
}
-(void) righArrowAct{
    if (clientCategoriesArrIndex+1 == [clientCategoriesArr count]) {
        clientCategoriesArrIndex = 0;
    }else{
        ++clientCategoriesArrIndex;
    }
    [self fetchClientItems];
}

-(void) leftArrowAct{
    if (clientCategoriesArrIndex == 0) {
        clientCategoriesArrIndex = (int)[clientCategoriesArr count]-1;
    }else{
        --clientCategoriesArrIndex;
    }
    [self fetchClientItems];
}

-(void) cartBtnAct{
    [self checkOutBtnAct];
}

-(void) checkOutBtnAct{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AddMore"] boolValue]) {
        NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController: [vcArr objectAtIndex:[vcArr count]-3]  animated:YES];
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
    return  clientItemsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(CGFloat)textHeightForDescription :(NSIndexPath *)indexPath{
    
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",[[clientItemsArr objectAtIndex:indexPath.row] objectForKey:@"Description"]] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/14; i++)
    {
        gap++;
    }
    return labelHeight.size.height+gap*4;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.5];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UIImageView *images=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [cell addSubview:images];
    images.contentMode=UIViewContentModeScaleAspectFit;
    images.tag=indexPath.row;
    images.image=[UIImage imageNamed:@"menu-placeholder"];

    if(((Item *)[imagesdataArray objectAtIndex:indexPath.row]).imagedata && indexPath.row == images.tag){
        images.image=[UIImage imageWithData:((Item *)[imagesdataArray objectAtIndex:indexPath.row]).imagedata];
    }else{
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSString *path =[[clientItemsArr objectAtIndex:indexPath.row] objectForKey:@"ImageUrl"];
            NSData *dta = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            UIImage *image = [UIImage imageWithData:dta];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (indexPath.row == images.tag){
                    if(dta){
                        images.image=image;
                        if([imagesdataArray count] > indexPath.row){
                        ((Item *)[imagesdataArray objectAtIndex:indexPath.row]).imagedata=dta;
                        ((Item *)[imagesdataArray objectAtIndex:indexPath.row]).imageUrl=[NSString stringWithFormat:@"%@", [[clientItemsArr objectAtIndex:indexPath.row] objectForKey:@"ImageUrl"]];
                        ((Item *)[imagesdataArray objectAtIndex:indexPath.row]).categoryId=[[clientItemsArr objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
                        }
                    }else{
                        images.image=[UIImage imageNamed:@"menu-placeholder"];
                    }
                }
            });
        });
        
    }
    
    UILabel *itemNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, SCREEN_WIDTH-140, 20)];
    itemNameLbl.text = [NSString stringWithFormat:@"%@", [[clientItemsArr objectAtIndex:indexPath.row] objectForKey:@"Title"]];
    itemNameLbl.textColor = [UIColor blackColor];
    itemNameLbl.numberOfLines = 1;
    itemNameLbl.font = [UIFont fontWithName:@"Lora-Bold" size:16];
    [cell.contentView addSubview:itemNameLbl];
    
    UILabel *itemDesc = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, SCREEN_WIDTH-70, 35)];
    itemDesc.text = [NSString stringWithFormat:@"%@",[[clientItemsArr objectAtIndex:indexPath.row] objectForKey:@"Description"]];
    itemDesc.textColor = [UIColor lightGrayColor];
    itemDesc.numberOfLines = 0;
    itemDesc.font = [UIFont fontWithName:@"Lora-Regular" size:14];
    [cell.contentView addSubview:itemDesc];
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 70, 20)];
    priceLbl.textColor = [UIColor blackColor];
    priceLbl.textAlignment = NSTextAlignmentRight;
    priceLbl.text = [NSString stringWithFormat:@"$%.2f",[[[clientItemsArr objectAtIndex:indexPath.row] objectForKey:@"Price"] doubleValue]];
    priceLbl.font = [UIFont fontWithName:@"Lora-Bold" size:16];
    [cell.contentView addSubview:priceLbl];
        
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [ItemTbl deselectRowAtIndexPath:indexPath animated:YES];
    
    AddItem *addItemView = [[AddItem alloc] init];
    addItemView.item = [[clientItemsArr objectAtIndex:indexPath.row] mutableCopy];
    addItemView.replaceIndex = -1;
    [self.navigationController pushViewController:addItemView animated:YES];
}

-(void)moreBtnAct{
    
}
@end
