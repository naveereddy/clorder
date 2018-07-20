//
//  AddItem.m
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "AddItem.h"
#import "AppHeader.h"
#import "CheckOut.h"
#import "APIRequest.h"
#import "CartObj.h"
#import "AllDayMenuVC.h"

@implementation AddItem{
    UITextField *choiceText;
    UILabel *countLbl;
    UIView *modifierV;
    UIButton *checkOutBtn;
    UIButton *headerBtn;
    NSMutableDictionary *modifierDic;
    BOOL select;
    NSMutableArray *choiceArray;
    int radioTag;
    int checkBoxTag;
    int choicesTag;
    int quantity;
    double price;
    double subTotal;
    
    BOOL userChoice;
    
    NSMutableArray *radioArray;
    NSMutableArray *checkBoxArray;
    
    NSMutableDictionary *checkBoxDic;
    NSMutableDictionary *radioDic;
    NSDictionary *choiceDic;
    UITextView *instructionTxt;
    
    NSMutableArray *cartOptArray;
    NSMutableArray *choiceTxtArr;
    int indexOfChoiceText;
    UIButton *cartIcon;
}

@synthesize item, replaceIndex;

-(void)viewDidLoad{
    
    [super viewDidLoad];;
    
    self.title = @"Add To Cart";//[NSString stringWithFormat: @"%@", [item objectForKey:@"Title"]];
    
    radioTag = 1;
    checkBoxTag = 1;
    choicesTag = 1;
    
    checkBoxDic = [[NSMutableDictionary alloc] init];
    radioDic = [[NSMutableDictionary alloc] init];
    
    cartOptArray = [[NSMutableArray alloc] init];
    price = 0.0;
    countLbl = [[UILabel alloc] init];
    countLbl.text = @"0";
//    userChoice = false;
    if ([[item objectForKey:@"Quantity"] intValue]) {
        quantity = [[item objectForKey:@"Quantity"] intValue];
        
    }else{
        quantity = [[item objectForKey:@"MinQuantity"] intValue];
    }

    cartIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    cartIcon.frame = CGRectMake(0, 0, 44, 44);
    [cartIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cartIcon.titleLabel setFont:[UIFont fontWithName:@"Lora-Bold" size:12]];
    [cartIcon.titleLabel.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cartIcon.titleLabel setBackgroundColor:[UIColor blackColor]];
    [cartIcon.titleLabel.layer setBorderWidth:1];
    [cartIcon.titleLabel.layer setCornerRadius:8];
    cartIcon.titleLabel.layer.masksToBounds = YES;
    [cartIcon setNeedsLayout];
    [cartIcon layoutIfNeeded];
    [cartIcon setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [cartIcon addTarget:self action:@selector(cartBtnAct) forControlEvents:UIControlEventTouchUpInside];
    cartIcon.titleEdgeInsets = UIEdgeInsetsMake(-10,0,0,0);
    cartIcon.imageEdgeInsets = UIEdgeInsetsMake(10,10,0,0);
    UIBarButtonItem * rightBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:cartIcon];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarItem1, nil];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBarItem1, nil];
    
    
    UIButton *leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBar.frame = CGRectMake(0, 0, 20, 20);
    [leftBar setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    [leftBar addTarget:self action:@selector(leftBarAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:leftBarItem];
    
    choicesTbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
    choicesTbl.delegate = self;
    choicesTbl.dataSource = self;
    select = true;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomView];
    [bottomView setUserInteractionEnabled:YES];
    [bottomView setBackgroundColor:APP_COLOR];
    
    UIButton *addOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    addOrder.frame = CGRectMake(40, 0, SCREEN_WIDTH-100, 50);
    [addOrder.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [addOrder setTitle:@"ADD TO ORDER" forState:UIControlStateNormal];
    [addOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addOrder addTarget:self action:@selector(addOrderAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addOrder];
    [addOrder.titleLabel setFont:APP_FONT_REGULAR_16];
    
    checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkOutBtn.frame = CGRectMake(2*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 50);
    [checkOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkOutBtn.titleLabel setFont:APP_FONT_REGULAR_16];
    [checkOutBtn addTarget:self action:@selector(checkOutBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:checkOutBtn];
    [self.view addSubview:choicesTbl];
    
    if (replaceIndex < 0) {
        [self getModifiers];
    }else{
        [self getModifiersFromCart];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [cartIcon setTitle:[NSString stringWithFormat:@" %lu ",(unsigned long)[CartObj instance].itemsForCart.count] forState:UIControlStateNormal];

}
-(void) cartBtnAct{
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
-(void)getModifiersFromCart{
    modifierDic = [[NSMutableDictionary alloc] initWithDictionary:[item objectForKey:@"Modifiers"]];
    radioArray = [[NSMutableArray alloc] init];
    checkBoxArray = [[NSMutableArray alloc] init];
    choiceArray = [[NSMutableArray alloc] init];
    if (![[modifierDic objectForKey:@"clientFields"] isEqual:[NSNull null]] && [[modifierDic objectForKey:@"clientFields"] count]) {
        choiceTxtArr = [[NSMutableArray alloc] init];
        
        
        for (int i = 0; i<[[modifierDic objectForKey:@"clientFields"] count]; i++) {
            if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 2) {
                [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] setObject:[NSNumber numberWithInt:radioTag] forKey:@"Tag"];
                [radioArray insertObject:[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] mutableCopy] atIndex:(radioTag-1)];
                radioTag++;
            }
            if (([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 1) ||
                ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 4)) {
                [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] setObject:[NSNumber numberWithInt:checkBoxTag] forKey:@"Tag"];
                [checkBoxArray insertObject:[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] mutableCopy] atIndex:(checkBoxTag-1)];
                checkBoxTag++;
            }
            if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 3) {
                [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] setObject:[NSNumber numberWithInt:choicesTag] forKey:@"Tag"];
                [choiceArray insertObject:[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] mutableCopy] atIndex:(choicesTag-1)];
                UITextField *choiceTxt = [[UITextField alloc] init];
                [choiceTxtArr addObject:choiceTxt];
                choicesTag++;
            }
        }
    }
    [self dataForChoiceText];
    radioTag = 1;
    checkBoxTag = 1;
    choicesTag = 1;
}

-(void) leftBarAct{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendAction{
    for (UITextField *textFld in choiceTxtArr) {
        [textFld resignFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == choicesTbl && section != 1) {
        return 40;
    }
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == choicesTbl) {
        return 3;
    }
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 40)];
    headerLbl.textColor = [UIColor whiteColor];
    [header addSubview:headerLbl];
    
    if (tableView == choicesTbl) {
        header.backgroundColor = APP_COLOR_LIGHT_BACKGROUND;
        headerLbl.font = [UIFont fontWithName:@"Lora-Bold" size:18];
        [headerLbl setTextColor: DARK_GRAY];
        if (section==0) {
            
            headerLbl.text = @"ITEM DETAILS";
            
            UILabel *undrLn = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, 2)];
            [header addSubview: undrLn];
            undrLn.backgroundColor = APP_COLOR_LIGHT_BACKGROUND;
            
            headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (select) {
                [headerBtn setImage:[UIImage imageNamed:@"up-arrow"] forState:UIControlStateNormal];
            }else{
                [headerBtn setImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
            }
            headerBtn.frame = CGRectMake(SCREEN_WIDTH-40, 5, 30, 30);
            headerBtn.layer.cornerRadius = 5.0;
            [headerBtn addTarget:self action:@selector(headerBtnAct) forControlEvents:UIControlEventTouchUpInside];
//            [header addSubview:headerBtn];
            
        }else if (section==2){
            headerLbl.text = @"REQUIRED CHOICES";
        }
    }
    return header;
}

-(void)headerBtnAct{
    
    select = !select;
    [choicesTbl reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (select) {
            return 1;
        }else{
            return 0;
        }
    }else if(section == 1){
        return 2;
    }else{
        if (![[modifierDic objectForKey:@"clientFields"] isKindOfClass:[NSNull class]]) {
            return [[modifierDic objectForKey:@"clientFields"] count]+1;
        }else
            return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0) {
            return 30;
        }else if(indexPath.section == 1){
            return 45;
        }else{
            if (indexPath.row == [[modifierDic objectForKey:@"clientFields"] count]){
                return 100;
            }else{
                if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Type"] intValue] == 3) {
                    return 50;
                }else{
                    return [[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Options"] count]*30+10;
                }
            }
    }
}

-(CGFloat)headerHeight{
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",[item objectForKey:@"Description"]] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/14; i++)
    {
        gap++;
    }
    return labelHeight.size.height+gap*4;
}

-(CGFloat)heightForSelectedModifier{
    CGRect labelHeight = [[NSString stringWithFormat:@"%@",[self getSelectedModifier]] boundingRectWithSize:CGSizeMake(self.view.frame.size.width-90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil];
    int gap=0;
    for(int i=0; i < labelHeight.size.height/12; i++)
    {
        gap++;
    }
    return labelHeight.size.height+gap*4;
}


-(NSMutableString *)getSelectedModifier{
    
    NSMutableString *selectionStr = [NSMutableString stringWithString:@""];
    
    if (![[modifierDic objectForKey:@"clientFields"] isEqual:[NSNull null]] && [[modifierDic objectForKey:@"clientFields"] count]) {
        for (int i = 0; i < [[modifierDic objectForKey:@"clientFields"] count]; i++) {
            NSMutableString *tempTitleStr = [NSMutableString stringWithString:@""];
            
            if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] count]) {
                NSMutableString *tempModifierStr = [NSMutableString stringWithFormat:@""];
                
                for (int j = 0; j < [[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] count]; j++) {
                    
                    if (([[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Default"] intValue] == 1) &&
                        (![[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Title"] isKindOfClass:[NSNull class]])) {
                        
                        [tempModifierStr appendString:[NSString stringWithFormat:@" %@,", [[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Title"]]];
                    }
                    
                }
                if ([tempModifierStr length]>0) {
                    [tempTitleStr appendString:[NSString stringWithFormat:@"%@ %@", [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Name"], tempModifierStr]];
                    tempTitleStr = [NSMutableString stringWithString: [tempTitleStr substringToIndex:[tempTitleStr length]-1]];
                    
                }
            }
            if ([tempTitleStr length]>0) {
                [selectionStr appendString:[NSString stringWithFormat:@"\n%@", tempTitleStr]];
            }
        }
    }else {
        [selectionStr appendString:@"Make your selection"];
    }
    
    return selectionStr;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-80, 20)];
            titleLbl.font = [UIFont boldSystemFontOfSize:16.0];
            titleLbl.textColor = [UIColor blackColor];
            titleLbl.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"Title"]];
            [titleLbl setTextAlignment:NSTextAlignmentCenter];
            
            UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, SCREEN_WIDTH-40, [self headerHeight]+10)];
            descLbl.text = [NSString stringWithFormat:@"Description: %@", [item objectForKey:@"Description"]];
            descLbl.numberOfLines = 0;
            titleLbl.font = [UIFont fontWithName:@"Lora-Regular" size:16];
            [cell.contentView addSubview:titleLbl];
            return  cell;
        }else if(indexPath.section == 1){
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-80, 20)];
            titleLbl.font = [UIFont boldSystemFontOfSize:16.0];
            if (indexPath.row == 0){
                titleLbl.text = [NSString stringWithFormat:@"%@", @"QUANTITY"];
                titleLbl.textColor = DARK_GRAY;
                [cell.contentView addSubview:titleLbl];
                
                UIButton *decreaseCount = [UIButton buttonWithType:UIButtonTypeCustom];
                decreaseCount.frame = CGRectMake(SCREEN_WIDTH-130, 5, 30, 30);
                [decreaseCount setBackgroundColor:[UIColor whiteColor]];
                [decreaseCount setTitle:@"-" forState:UIControlStateNormal];
                [decreaseCount setTitleColor:APP_COLOR forState:UIControlStateNormal];
                [decreaseCount addTarget:self action:@selector(decreaseCountAct) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:decreaseCount];
                decreaseCount.layer.borderColor = [APP_COLOR CGColor];
                decreaseCount.layer.borderWidth = 1.0;
                [decreaseCount.titleLabel setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];

                countLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130+30, 5, 55, 30)];
                countLbl.textColor = DARK_GRAY;
                countLbl.text = [NSString stringWithFormat:@"%d",quantity];
                countLbl.textAlignment = NSTextAlignmentCenter;
                countLbl.backgroundColor = [UIColor whiteColor];
                countLbl.layer.borderColor = [APP_COLOR CGColor];
                countLbl.layer.borderWidth = 1.0;
                [cell.contentView addSubview:countLbl];
                [countLbl setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
                
                UIButton *increaseCount = [UIButton buttonWithType:UIButtonTypeCustom];
                increaseCount.frame = CGRectMake(SCREEN_WIDTH-130+30+55, 5, 30, 30);
                [increaseCount setBackgroundColor:[UIColor whiteColor]];
                [increaseCount setTitle:@"+" forState:UIControlStateNormal];
                [increaseCount setTitleColor:APP_COLOR forState:UIControlStateNormal];
                increaseCount.layer.borderColor = [APP_COLOR CGColor];
                increaseCount.layer.borderWidth = 1.0;
                [increaseCount.titleLabel setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];

                [increaseCount addTarget:self action:@selector(increaseCounttAct) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:increaseCount];
            }
            if (indexPath.row == 1) {
                titleLbl.text = [NSString stringWithFormat:@"%@", @"ITEM PRICE"];
                titleLbl.textColor  = DARK_GRAY;
                [cell.contentView addSubview:titleLbl];
                
                UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 80, cell.contentView.frame.size.height)];
                priceLbl.textColor = [UIColor blackColor];
                priceLbl.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:priceLbl];
                [priceLbl setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
                
                price = [[item objectForKey:@"Price"] doubleValue];
                
                if(![[modifierDic objectForKey:@"clientFields"] isEqual:[NSNull null]] && [[modifierDic objectForKey:@"clientFields"] count]){
                    for (int i = 0; i < [[modifierDic objectForKey:@"clientFields"] count]; i++) {
                        if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]) {
                            for (int j = 0; j < [[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]; j++) {
                                if (([[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Default"] intValue] ==1) &&
                                    (![[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] isKindOfClass:[NSNull class]])) {
                                    price = price + [[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] doubleValue];
                                }
                            }
                        }
                    }
                }
                
                priceLbl.text = [NSString stringWithFormat:@"$%.2lf",price];
                [checkOutBtn setTitle:[NSString stringWithFormat:@"$%.2lf", price*[countLbl.text intValue]] forState:UIControlStateNormal];
                
            }
            return  cell;
        }else{
            if (indexPath.row == [[modifierDic objectForKey:@"clientFields"] count]) {

                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-80, 20)];
                titleLbl.font = [UIFont boldSystemFontOfSize:16.0];
                titleLbl.text = [NSString stringWithFormat:@"%@", @"SPECIAL INSTRUCTIONS"];
                titleLbl.textColor  = DARK_GRAY;
                [cell.contentView addSubview:titleLbl];
                
                instructionTxt = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH-40, 60)];
                instructionTxt.delegate = self;
                instructionTxt.font = [UIFont fontWithName:@"Lora-Regular" size:14];
                instructionTxt.layer.borderColor = [[UIColor blackColor] CGColor];
                instructionTxt.layer.borderWidth = 1.0;
                instructionTxt.layer.cornerRadius = 5.0;
                [cell.contentView addSubview:instructionTxt];
                
                if ([item objectForKey:@"SpecialInstruction"]) {
                    instructionTxt.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"SpecialInstruction"]];
                }else{
                    instructionTxt.text = @"";
                }
                return  cell;
            }else{
                
                UITableViewCell *modifierCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%ld",(long)indexPath.row]];
                if (modifierCell == nil) {
                    modifierCell = [self cellForModifiertbl:indexPath];
                }
                return modifierCell;
            }
            
        }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [choicesTbl deselectRowAtIndexPath:indexPath animated:NO];
}

-(UITableViewCell *)cellForModifiertbl:(NSIndexPath*) indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell%ld",(long)indexPath.row]];
    
    UILabel *cellLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 90, cell.contentView.frame.size.height)];
    cellLbl.numberOfLines = 0;
    [cellLbl setFont:APP_FONT_REGULAR_16];
    [cell.contentView addSubview:cellLbl];
    cellLbl.text = [NSString stringWithFormat:@"%@", [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    
    if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Active"] integerValue]) {
        
        switch ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Type"] integerValue]) {
                
            case 1://checkbox
                if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Active"] intValue]) {
                    NSMutableArray *checkBoxBtnArr = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < [[checkBoxArray objectAtIndex:(checkBoxTag-1)] count]; i++) {
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn setTag:checkBoxTag*100+i];
                        btn.frame = CGRectMake(100, i*5+i*25, (SCREEN_WIDTH-125), 25);
                        btn.titleLabel.font = APP_FONT_REGULAR_14;
                        
                        if (![[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Title"] isKindOfClass:[NSNull class]]) {
                            
                            if (![[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Price"] isKindOfClass:[NSNull class]]  && ([[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Price"] doubleValue]>0)) {
                                [btn setTitle:[NSString stringWithFormat:@"%@($%.2lf)",
                                               [[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Title"],
                                               [[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Price"] doubleValue]]
                                     forState:UIControlStateNormal];
                            }else{
                                [btn setTitle:[NSString stringWithFormat:@"%@",[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Title"]]
                                     forState:UIControlStateNormal];
                            }
                        }
                        
                        
                        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        btn.titleLabel.numberOfLines = 0;
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(checkBoxBtnAct:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setImage:[UIImage imageNamed:@"checkboxUnchecked"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"checkboxChecked"] forState:UIControlStateSelected];
                        
                        
                        
                        if ([[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Default"] intValue]) {
                            [btn setSelected:YES];
                        }else{
                            [btn setSelected:NO];
                            
                        }
                        
                        
                        [checkBoxBtnArr  insertObject:btn atIndex:i];
                        
                        [cell.contentView addSubview:btn];
                    }
                    [checkBoxDic setObject:checkBoxBtnArr forKey:[NSString stringWithFormat:@"%d", checkBoxTag]];
                    checkBoxTag++;
                    
                }
                if ((checkBoxTag-1) ==([checkBoxArray count])) {
                    checkBoxTag = 1;
                }
                break;
                
            case 2://radio btn
                if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Active"] intValue]) {
                    NSMutableArray *radioBtnArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [[radioArray objectAtIndex:(radioTag-1)] count]; i++) {
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn setTag:radioTag*100+i];
                        btn.frame = CGRectMake(100, i*5+i*25, (SCREEN_WIDTH-125), 25);
                        btn.titleLabel.font = APP_FONT_REGULAR_14;
                        
                        if (![[[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i] objectForKey:@"Title"] isKindOfClass:[NSNull class]]) {
                            
                            if (![[[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i] objectForKey:@"Price"] isKindOfClass:[NSNull class]] && ([[[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i] objectForKey:@"Price"] doubleValue]>0)) {
                                [btn setTitle:[NSString stringWithFormat:@"%@($%.2lf)",
                                               [[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i] objectForKey:@"Title"],
                                               [[[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i] objectForKey:@"Price"] doubleValue]]
                                     forState:UIControlStateNormal];
                            }else{
                                [btn setTitle:[NSString stringWithFormat:@"%@",[[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i] objectForKey:@"Title"]]
                                     forState:UIControlStateNormal];
                            }
                        }
                                                
                        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        btn.titleLabel.numberOfLines = 0;
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(radioBtnAct:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        if ([[[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i] objectForKey:@"Default"] intValue]) {
                            btn.selected = YES;
                            [cartOptArray addObject:[[radioArray objectAtIndex:(radioTag-1)] objectAtIndex:i]];
                        }else{
                            btn.selected = NO;
                        }
                        
                        [btn setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"radio-on"] forState:UIControlStateSelected];
                        [cell.contentView addSubview:btn];
                        [radioBtnArr insertObject:btn atIndex:i];
                    }
                    [radioDic setObject:radioBtnArr forKey:[NSString stringWithFormat:@"%d", radioTag]];
                    radioTag++;
                }
                if ((radioTag-1) == ([radioArray count])) {
                    radioTag = 1;
                    
                }
                break;
                
            case 3://DropDown,
                
                if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Active"] intValue]) {
                    //                    choiceArray = [[NSMutableArray alloc]initWithArray:[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Options"]];
                    
                    
                    
                    [cell.contentView addSubview:((UITextField *)[choiceTxtArr objectAtIndex:indexOfChoiceText])];

                    
                afterSelection:;
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTag:100+indexOfChoiceText];
                    btn.frame = CGRectMake(95+((UITextField *)[choiceTxtArr objectAtIndex:indexOfChoiceText]).frame.size.width-25, 15, 20, 20);
                    [btn setImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
                    [btn setBackgroundColor:DARK_GRAY];
                    btn.layer.cornerRadius = 3.0;
                    [btn addTarget:self action:@selector(dropDownAct: ) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                    indexOfChoiceText++;
                    
                }
                break;
            case 4:	//CheckboxList
                
                if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:indexPath.row] objectForKey:@"Active"] intValue]) {
                    NSMutableArray *checkBoxBtnArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [[checkBoxArray objectAtIndex:(checkBoxTag-1)] count]; i++) {
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn setTag:checkBoxTag*100+i];
                        btn.frame = CGRectMake(100, i*5+i*25, (SCREEN_WIDTH-125), 25);
                        btn.titleLabel.font = APP_FONT_REGULAR_14;
                        
                        
                        if (![[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Title"] isKindOfClass:[NSNull class]]) {
                            
                            if (![[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Price"] isKindOfClass:[NSNull class]]  && ([[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Price"] doubleValue]>0)) {
                                [btn setTitle:[NSString stringWithFormat:@"%@($%.2lf)",
                                               [[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Title"],
                                               [[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Price"] doubleValue]]
                                     forState:UIControlStateNormal];
                            }else{
                                [btn setTitle:[NSString stringWithFormat:@"%@",[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Title"]]
                                     forState:UIControlStateNormal];
                            }
                        }
                        
                        
                        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        btn.titleLabel.numberOfLines = 0;
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(checkBoxBtnAct:) forControlEvents:UIControlEventTouchUpInside];
                        
                        if ([[[[checkBoxArray objectAtIndex:(checkBoxTag-1)] objectAtIndex:i] objectForKey:@"Default"] intValue]) {
                            [btn setSelected:YES];
                        }else{
                            [btn setSelected:NO];
                        }
                        
                        
                        [btn setImage:[UIImage imageNamed:@"checkboxUnchecked"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"checkboxChecked"] forState:UIControlStateSelected];
                        [checkBoxBtnArr insertObject:btn atIndex:i];
                        [cell.contentView addSubview:btn];
                    }
                    [checkBoxDic setObject:checkBoxBtnArr forKey:[NSString stringWithFormat:@"%d", checkBoxTag]];
                    checkBoxTag++;
                }
                if ((checkBoxTag-1) == ([checkBoxArray count])) {
                    checkBoxTag = 1;
                    
                }
                break;
            default:
                
                
                break;
        }
    }
    
    return cell;
}

-(void)dataForChoiceText{
    
    UIToolbar *optionPickerTool=[[UIToolbar alloc]init];
    
    optionPickerTool.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(sendAction)];
    [optionPickerTool setItems:[[NSArray alloc] initWithObjects:button1, nil]];
    
    
    if ([choiceArray count]) {
        for (int i = 0; i < [choiceArray count]; i++) {
            
            UIPickerView *choicePicker1 = [[UIPickerView alloc]init];
            choicePicker1.dataSource = self;
            choicePicker1.delegate = self;
            
            [choicePicker1 setTag:100+i];
            
            if ([[choiceArray objectAtIndex:i] count]) {
                
                ((UITextField *)[choiceTxtArr objectAtIndex:i]).frame = CGRectMake(100, 10, (SCREEN_WIDTH-125), 30);
                ((UITextField *)[choiceTxtArr objectAtIndex:i]).font = [UIFont systemFontOfSize:14.0];
                ((UITextField *)[choiceTxtArr objectAtIndex:i]).layer.borderWidth = 1;
                ((UITextField *)[choiceTxtArr objectAtIndex:i]).inputView = choicePicker1;
                ((UITextField *)[choiceTxtArr objectAtIndex:i]).inputAccessoryView=optionPickerTool;
                
                for (int j = 0; j < [[choiceArray objectAtIndex:i] count]; j++) {
                    
                    if ([[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Default"] intValue]) {
                        if (![[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Price"] isKindOfClass:[NSNull class]] && ([[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Price"] doubleValue] > 0)) {
                            ((UITextField *)[choiceTxtArr objectAtIndex:i]).text=[NSString stringWithFormat:@"  %@($%.2lf)",[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Title"], [[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Price"] doubleValue]];
                        }else{
                            ((UITextField *)[choiceTxtArr objectAtIndex:i]).text=[NSString stringWithFormat:@"  %@",[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Title"]];
                        }
                        
                        break;
                    }else{
                        
                        if (![[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Price"] isKindOfClass:[NSNull class]] && ([[[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Price"] doubleValue] > 0)) {
                            ((UITextField *)[choiceTxtArr objectAtIndex:i]).text=[NSString stringWithFormat:@"  %@($%@)",[[[choiceArray objectAtIndex:i] objectAtIndex:0] objectForKey:@"Title"], [[[choiceArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"Price"]];
                        }else{
                            ((UITextField *)[choiceTxtArr objectAtIndex:i]).text=[NSString stringWithFormat:@"  %@",[[[choiceArray objectAtIndex:i] objectAtIndex:0] objectForKey:@"Title"]];
                        }
                    }
                    
                }
            }
            
        }
    }
}

-(void)dropDownAct: (UIButton*)sender{
    int index = sender.tag%100;
    [[choiceTxtArr objectAtIndex:index] becomeFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    int index = (int)((pickerView.tag)%100);
    return [[choiceArray objectAtIndex:index] count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    int index = (int)((pickerView.tag)%100);
    if (![[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] isKindOfClass:[NSNull class]] && ([[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] doubleValue] > 0)) {
        return [NSString stringWithFormat:@"  %@($%.2lf)",[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Title"], [[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] doubleValue]];
    }else{
        return [NSString stringWithFormat:@"  %@",[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Title"]];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int index = (int)((pickerView.tag)%100);
    ((UITextField *)[choiceTxtArr objectAtIndex:index]).text = [NSString stringWithFormat:@"  %@",[[[choiceArray objectAtIndex:index] objectAtIndex:row] objectForKey:@"Title"]];
    
    if (![[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] isKindOfClass:[NSNull class]] && ([[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] doubleValue] > 0)) {
        ((UITextField *)[choiceTxtArr objectAtIndex:index]).text = [NSString stringWithFormat:@"  %@($%.2lf)",[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Title"], [[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] doubleValue]];
    }else{
        ((UITextField *)[choiceTxtArr objectAtIndex:index]).text = [NSString stringWithFormat:@"  %@",[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Title"]];
    }
    
    for (int i = 0; i < [[choiceArray objectAtIndex:index] count]; i++) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:[[[choiceArray objectAtIndex:index] objectAtIndex:i] mutableCopy]];
        [tempDic setObject:[NSNumber numberWithBool:false] forKey:@"Default"];
        [[choiceArray objectAtIndex:index] replaceObjectAtIndex:i withObject:tempDic];
    }
    [[[choiceArray objectAtIndex:index] objectAtIndex:row] setObject:[NSNumber numberWithBool:true] forKey:@"Default"];
    
    for (int i = 0; i < [[modifierDic objectForKey:@"clientFields"] count]; i++) {
        if (([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Tag"] intValue] == index+1) && ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 3)){
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] mutableCopy]];
            if ([array count]) {
                for (int j = 0; j < [array count]; j++) {
                    NSMutableDictionary  *dic = [[NSMutableDictionary alloc] initWithDictionary:[[array objectAtIndex:j] mutableCopy]];
                    
                    if (j == row) {
                        [dic setObject:[NSNumber numberWithInt:1] forKey:@"Default"];
                    }else{
                        [dic setObject:[NSNumber numberWithInt:0] forKey:@"Default"];
                    }
                    [array replaceObjectAtIndex:j withObject:dic];
                }
                [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] setObject:array forKey:@"Options"];
            }
            
        }
    }
    
    if (![[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] isKindOfClass:[NSNull class]] && ([[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"] doubleValue] > 0)) {
        ((UITextField *)[choiceTxtArr objectAtIndex:index]).text =  [NSString stringWithFormat:@"  %@($%@)",[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Title"], [[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Price"]];
    }else{
        ((UITextField *)[choiceTxtArr objectAtIndex:index]).text =  [NSString stringWithFormat:@"  %@",[[[choiceArray objectAtIndex:(index)] objectAtIndex:row] objectForKey:@"Title"]];
    }
    
    choiceDic = [[NSDictionary alloc] initWithDictionary:[[choiceArray objectAtIndex:index] objectAtIndex:row]];
    [self clacAmount];
}
-(void) addOrderAct {
    
    if (quantity > 0) {
        
        [item setObject:[NSNumber numberWithInt:quantity] forKey:@"Quantity"];
        [item setObject:instructionTxt.text forKey:@"SpecialInstruction"];
        //        BOOL added = false;
        //        NSLog(@"Item to be added into cart-- \n%@", item);
        if(!([CartObj instance]==NULL)){
            //NSLog(@"No cartObj");
            
            if (self.replaceIndex >= 0) {
                [[CartObj instance].itemsForCart replaceObjectAtIndex:self.replaceIndex withObject:item];
            }else{
                [[CartObj instance].itemsForCart addObject:item];
            }
            
        }else{
            NSLog(@"cartObj **");
        }
        
        // NSLog(@"%@", [CartObj instance].itemsForCart);
        NSUserDefaults *cart = [NSUserDefaults standardUserDefaults];
        NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
        for (NSDictionary *personObject in [CartObj instance].itemsForCart) {
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:personObject];
            [archiveArray addObject:personEncodedObject];
        }
        [cart setObject: archiveArray forKey:@"cart"];
        [self subTotalCalc];
        //        CheckOut *checkOutView = [[CheckOut alloc] init];
        //        checkOutView.replaceIndex = self.replaceIndex;
        //        [self.navigationController pushViewController:checkOutView animated:YES];
//        if (replaceIndex >= 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
            NSArray *vcArr = [[NSArray alloc] initWithArray:[self.navigationController viewControllers]];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AddMore"] boolValue]) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    
                    //Do not forget to import AnOldViewController.h
                    if ([controller isKindOfClass:[CheckOut class]]) {
                        
                        [self.navigationController popToViewController:controller
                                                              animated:YES];
                        break;
                    }
                }
//                [self.navigationController popToViewController: [vcArr objectAtIndex:[vcArr count]-4]  animated:YES];
            }else{
                //if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"OrderType"] intValue] == 2) {
                  //  [self.navigationController popToViewController:[vcArr objectAtIndex:3]  animated:YES];
               // }else{
                    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"UserId"] intValue]) {
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            
                            //Do not forget to import AnOldViewController.h
                            if ([controller isKindOfClass:[AllDayMenuVC class]]) {
                                
                                [self.navigationController popToViewController:controller
                                                                      animated:YES];
                                break;
                            }
                        }
//                        [self.navigationController popToViewController:
//                         [vcArr objectAtIndex:(2+[[[NSUserDefaults standardUserDefaults] objectForKey:@"popIndex"] intValue])]  animated:YES];
                    }else{
                        [self.navigationController popToViewController:
                         [vcArr objectAtIndex:(3+[[[NSUserDefaults standardUserDefaults] objectForKey:@"popIndex"] intValue])]  animated:YES];
                    }
                    
                //}
            }
//        }
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Quantity can not be 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}


-(void)subTotalCalc{
    subTotal = 0.0;
    for (int i = 0; i < ([CartObj instance].itemsForCart.count); i++) {
        NSArray *modifierArr = [[NSArray alloc] initWithArray:[[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Modifiers"] objectForKey:@"clientFields"]];
        double modifierPrice = 0.0;
        for (int j = 0; j < [modifierArr count]; j++) {
            for (int k = 0; k < [[[modifierArr objectAtIndex:j] objectForKey:@"Options"] count]; k++) {
                if ([[[[[modifierArr objectAtIndex:j] objectForKey:@"Options"] objectAtIndex:k] objectForKey:@"Default"] intValue] &&
                    ![[[[[modifierArr objectAtIndex:j] objectForKey:@"Options"] objectAtIndex:k] objectForKey:@"Price"] isKindOfClass:[NSNull class]]) {
                    modifierPrice = modifierPrice + [[[[[modifierArr objectAtIndex:j] objectForKey:@"Options"] objectAtIndex:k] objectForKey:@"Price"] doubleValue];
                }
            }
        }
        
        subTotal = subTotal + (modifierPrice + [[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Price"] doubleValue] )* [[[[CartObj instance].itemsForCart objectAtIndex:i] objectForKey:@"Quantity"] intValue];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2lf", subTotal] forKey:@"subTotalPrice"];
}

-(void)radioBtnAct:(UIButton *)sender{
    int index = (int)(sender.tag / 100);
    for (int i = 0; i<[[radioDic objectForKey:[NSString stringWithFormat:@"%d",index]] count]; i++) {
        //        [[[radioDic objectForKey:[NSString stringWithFormat:@"%d",index]] objectAtIndex:i] setImage:[UIImage imageNamed:@"radio-off"] forState:UIControlStateNormal];
        ((UIButton *)[[radioDic objectForKey:[NSString stringWithFormat:@"%d",index]] objectAtIndex:i]).selected = NO;
    }
    for (int i = 0; i < [[modifierDic objectForKey:@"clientFields"] count]; i++) {
        if (([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Tag"] intValue] == index) && ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 2)){
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] mutableCopy]];
            for (int j = 0; j < [array count]; j++ ) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[array objectAtIndex:j] mutableCopy]];
                
                if (j == (sender.tag % 100)) {
                    [dic setObject:[NSNumber numberWithInt:1] forKey:@"Default"];
                }else{
                    [dic setObject:[NSNumber numberWithInt:0] forKey:@"Default"];
                }
                
                [array replaceObjectAtIndex:j withObject:dic];
            }
            
            [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] setObject:array forKey:@"Options"];
        }
    }
    sender.selected = YES;
    [self clacAmount];
}

-(void)checkBoxBtnAct:(UIButton *)sender {
    sender.selected = !sender.selected;
    int index = (int)(sender.tag / 100);
    
    for (int i = 0; i < [[modifierDic objectForKey:@"clientFields"] count]; i++) {
        if (([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Tag"] intValue] == index) && (([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 1) || ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Type"] intValue] == 4))){
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] objectForKey:@"Options"] mutableCopy]];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[array objectAtIndex:(sender.tag % 100)] mutableCopy]];
            
            
            if (sender.selected) {
                //set default as 1
                [dic setObject:[NSNumber numberWithInt:1] forKey:@"Default"];
                
            }else{
                //set default as 0
                [dic setObject:[NSNumber numberWithInt:0] forKey:@"Default"];
                
            }
            [array replaceObjectAtIndex:(sender.tag % 100) withObject:dic];
            
            [[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i] setObject:array forKey:@"Options"];
        }
    }
    [self clacAmount];
}

-(void)pickerBtnAct{
    
    radioTag = 1;
    checkBoxTag = 1;
    choicesTag = 1;
    
//    if (userChoice) {

    //    }
    
    
    if (![[modifierDic objectForKey:@"clientFields"] isEqual:[NSNull null]] && [[modifierDic objectForKey:@"clientFields"] count]) {
        
        choiceDic = [[NSDictionary alloc]init];
        //        userChoice = true;
        //        [self.navigationController setNavigationBarHidden:YES];
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        
        
        modifierV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [self.view addSubview:modifierV];
        modifierV.backgroundColor = TRANSPARENT_GRAY;
        
        UIView *dummyV = [[UIView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, [self ViewHeightCalc])];
        dummyV.center = modifierV.center;
        [modifierV addSubview:dummyV];
        dummyV.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dummyV.frame.size.width, 40)];
        headLbl.textColor = [UIColor whiteColor];
        headLbl.backgroundColor = APP_COLOR;
        headLbl.text = @"MODIFIERS";
        headLbl.textAlignment = NSTextAlignmentCenter;
        [headLbl setFont:APP_FONT_REGULAR_16];
        [dummyV addSubview:headLbl];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(dummyV.frame.size.width-30, 10, 20, 20);
        [closeBtn setImage:[UIImage imageNamed:@"closebutton_white"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnAct) forControlEvents:UIControlEventTouchUpInside];
        [dummyV addSubview:closeBtn];
        
        Moditbl = [[UITableView alloc] initWithFrame:CGRectMake(0, 50,  dummyV.frame.size.width,  dummyV.frame.size.height-100)];
        [dummyV addSubview:Moditbl];
        Moditbl.delegate = self;
        Moditbl.dataSource = self;
        
        UIButton *setModifierBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setModifierBtn.frame = CGRectMake(dummyV.frame.size.width/2-75, dummyV.frame.size.height-40, 150, 30);
        [setModifierBtn setBackgroundColor:APP_COLOR];
        [setModifierBtn.titleLabel setFont:APP_FONT_REGULAR_16];
        [setModifierBtn setTitle:@"DONE" forState:UIControlStateNormal];
        [setModifierBtn addTarget:self action:@selector(setModifierAct) forControlEvents:UIControlEventTouchUpInside];
        [dummyV addSubview:setModifierBtn];
        indexOfChoiceText=0;
        [Moditbl reloadData];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"No option available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(CGFloat)ViewHeightCalc{
    
    int choiceCount = 0;
    
    if ([radioArray count]) {
        for (int i = 0; i < [radioArray count]; i++) {
            if ([[radioArray objectAtIndex:i] count]) {
                choiceCount = choiceCount+(int)[[radioArray objectAtIndex:i] count];
            }
        }
    }
    
    if ([checkBoxArray count]) {
        for (int i = 0; i < [checkBoxArray count]; i++) {
            if ([[checkBoxArray objectAtIndex:i] count]) {
                choiceCount = choiceCount+(int)[[checkBoxArray objectAtIndex:i] count];
            }
        }
    }
    
    if (choiceCount*35+90+[choiceArray count]*45 > SCREEN_HEIGHT-125) {
        return SCREEN_HEIGHT-125;
    }else
        return choiceCount*35+90+[choiceArray count]*45;
    
}
-(void)getModifiers{
    indexOfChoiceText = 0;
    [APIRequest getModifiersForItem:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", [item objectForKey:@"ItemId"], @"ItemID", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something went wrong, Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            [alert show];
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            modifierDic = [[NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error] mutableCopy];
            NSLog(@"Response :\n %@",modifierDic);
            
            [item setObject:modifierDic forKey:@"Modifiers"];
            
            radioArray = [[NSMutableArray alloc] init];
            checkBoxArray = [[NSMutableArray alloc] init];
            choiceArray = [[NSMutableArray alloc] init];
            if (![[modifierDic objectForKey:@"clientFields"] isEqual:[NSNull null]]&& [[modifierDic objectForKey:@"clientFields"] count]) {
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[[modifierDic objectForKey:@"clientFields"] mutableCopy]];
                choiceTxtArr = [[NSMutableArray alloc] init];

                for (int i = 0; i<[tempArray count]; i++) {
                    if ([[[tempArray objectAtIndex:i] objectForKey:@"Type"] intValue] == 2) {
                        [radioArray insertObject:[[[tempArray objectAtIndex:i] objectForKey:@"Options"] mutableCopy] atIndex:(radioTag-1)];
                        NSMutableDictionary *dic = [[tempArray objectAtIndex:i] mutableCopy];
                        [dic setObject:[NSNumber numberWithInt:radioTag++] forKey:@"Tag"];
                        [tempArray replaceObjectAtIndex:i withObject:dic];
                    }
                    if (([[[tempArray objectAtIndex:i] objectForKey:@"Type"] intValue] == 1) ||
                        ([[[tempArray objectAtIndex:i] objectForKey:@"Type"] intValue] == 4)) {
                        [checkBoxArray insertObject:[[[tempArray objectAtIndex:i] objectForKey:@"Options"] mutableCopy] atIndex:(checkBoxTag-1)];
                        NSMutableDictionary *dic = [[tempArray objectAtIndex:i] mutableCopy];
                        [dic setObject:[NSNumber numberWithInt:checkBoxTag++] forKey:@"Tag"];
                        [tempArray replaceObjectAtIndex:i withObject:dic];
                    }
                    if ([[[tempArray objectAtIndex:i] objectForKey:@"Type"] intValue] == 3) {
                        [choiceArray insertObject:[[[tempArray objectAtIndex:i] objectForKey:@"Options"] mutableCopy] atIndex:(choicesTag-1)];
                        NSMutableDictionary *dic = [[tempArray objectAtIndex:i] mutableCopy];
                        [dic setObject:[NSNumber numberWithInt:choicesTag++] forKey:@"Tag"];
                        [tempArray replaceObjectAtIndex:i withObject:dic];
                        UITextField *choiceTxt = [[UITextField alloc] init];
                        [choiceTxtArr addObject:choiceTxt];

                    }
                }
                [modifierDic setObject:tempArray forKey:@"clientFields"];
            }
            radioTag = 1;
            checkBoxTag = 1;
            choicesTag = 1;
            [self dataForChoiceText];
            [choicesTbl reloadData];
        }
    }];
}

-(void)closeBtnAct{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [modifierV removeFromSuperview];
}
-(void)setModifierAct{
//    userChoice = true;
    [item setObject:modifierDic forKey:@"Modifiers"];
    [self closeBtnAct];
    [choicesTbl reloadData];
}

-(void) decreaseCountAct {
    if (quantity > [[item objectForKey:@"MinQuantity"] intValue]) {
        countLbl.text = [NSString stringWithFormat:@"%d",--quantity];
    }
    [checkOutBtn setTitle:[NSString stringWithFormat:@"$%.2lf", price*quantity] forState:UIControlStateNormal];
}

-(void)increaseCounttAct{
    countLbl.text = [NSString stringWithFormat:@"%d",++quantity];
    [checkOutBtn setTitle:[NSString stringWithFormat:@"$%.2lf", price*quantity] forState:UIControlStateNormal];
}

-(void)checkOutBtnAct{
    [self addOrderAct];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)keyboardWasShown:(NSNotification *)notification{
    CGRect frm = self.view.frame;
    frm.origin.y = (frm.origin.y<0)?frm.origin.y:-240;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = frm;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    CGRect frm = self.view.frame;
    frm.origin.y = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = frm;
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textView.inputAccessoryView = keyboardToolBar;
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}
-(void)resignKeyboard{
    [instructionTxt resignFirstResponder];
}
-(void)clacAmount{
    price = [[item objectForKey:@"Price"] doubleValue];
    if(![[modifierDic objectForKey:@"clientFields"] isEqual:[NSNull null]] && [[modifierDic objectForKey:@"clientFields"] count]){
        for (int i = 0; i < [[modifierDic objectForKey:@"clientFields"] count]; i++) {
            if ([[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]) {
                for (int j = 0; j < [[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] count]; j++) {
                    if (([[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Default"] intValue] ==1) &&
                        (![[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] isKindOfClass:[NSNull class]])) {
                        price = price + [[[[[[modifierDic objectForKey:@"clientFields"] objectAtIndex:i]objectForKey:@"Options"] objectAtIndex:j] objectForKey:@"Price"] doubleValue];
                    }
                }
            }
        }
    }
    [checkOutBtn setTitle:[NSString stringWithFormat:@"$%.2lf", price*quantity] forState:UIControlStateNormal];
}


@end
