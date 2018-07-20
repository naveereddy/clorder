//
//  Schedular.m
//  CLOrder
//
//  Created by Vegunta's on 27/12/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "Schedular.h"
#import "AppHeader.h"
#import "AccountUpdateVC.h"
#import "APIRequest.h"
#import "CartObj.h"

@implementation Schedular{
    UITextField *dateTxt;
    UIDatePicker *datePicker;
    UITextField *timeTxt;
    id controller;
    NSMutableArray *timeDisplayArr;
    UIPickerView *timePicker;
    NSUserDefaults *user;
    int weekDayNumber;
    UIButton *orderBtn;
    UIButton *scheduleOrderBtn;
    UILabel *noteLbl;
    NSString *dfltDt;
    NSString *dfltTime;
    UILabel *optionLbl;
    UILabel *orderDtLbl;
    UILabel *orderTimeLbl;
    bool todayClosed;
    NSDate *now;
    UIButton *closeBtn;
    UILabel *headerLbl;
}
- (id)initWithFrame:(CGRect)frame forController:(id)ctrl{
    user = [NSUserDefaults standardUserDefaults];
    
    todayClosed = false;
    dfltDt = [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderDate"];
    dfltTime = @"";
    self = [super initWithFrame:frame];
    if (self){
        controller = ctrl;
        [self initializeSceduleView];
        [self initializePopUpElements];
        [self getTimings];
    }
    return self;
}


-(void)getTimings{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    
    NSString *dateStr = [dfltDt length]?dfltDt:[formatter stringFromDate:datePicker.date];
    
    bool isPickup = YES;
    if ([[user objectForKey:@"OrderType"] intValue]==2) {
        isPickup = NO;
    }
    
    [APIRequest fetchRestTimeSlots:[NSDictionary dictionaryWithObjectsAndKeys:CLIENT_ID, @"clientId", dateStr, @"Date", [NSNumber numberWithBool:isPickup], @"isPickup", nil] completion:^(NSMutableData *buffer) {
        if (!buffer){
            NSLog(@"Unknown ERROR");
//            [closeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            dispatch_async(dispatch_get_main_queue(), ^{
                [closeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            });
            //            [Loader showErrorAlert:NETWORK_ERROR_MSG];
        }else{
            
            NSString *res = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
            // handle the response here
            NSError *error = nil;
            NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Response :\n %@",resObj);
            
            if ([[resObj objectForKey:@"isSuccess"] boolValue]) {
                
                NSMutableArray *timeArr = [[NSMutableArray alloc] initWithArray:[[resObj objectForKey:@"TimeSlots"] componentsSeparatedByString:@"|"]];
//                [timeArr removeAllObjects];
//                [timeArr addObject:@"Closed"];
                timeDisplayArr = [[NSMutableArray alloc] init];
                for (int i = 0; i<timeArr.count; i++) {
                    NSArray *tempArr = [[NSArray alloc] initWithArray:[[timeArr objectAtIndex:i] componentsSeparatedByString:@"-"]];
                    if ([[tempArr lastObject] length] && ![[tempArr lastObject] isEqualToString:@"ASAP"] &&[[tempArr lastObject] length] <= 8) {
                        [timeDisplayArr addObject:[tempArr lastObject]];
                    }
                }
                
                
                [formatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *setDate =  [dfltDt length]? [formatter dateFromString:dfltDt] :datePicker.date;
                NSString *dt1 = [formatter stringFromDate:[NSDate date]];
                NSString *dt2 = [formatter stringFromDate:setDate];
                formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT-8"];
                
//                [timeDisplayArr removeAllObjects];
//                [timeDisplayArr addObject:@"Closed"];
                
                if ([timeDisplayArr count] && ![[timeDisplayArr objectAtIndex:0] isEqualToString:@"Closed"]) {
                    
                    [[CartObj instance].userInfo setObject:[formatter stringFromDate:datePicker.date] forKey:@"OrderDate"];
                    
                    int currTime = 0;
                    if ([dt1 isEqualToString:dt2]) {
                        [user setObject:[NSNumber numberWithBool:0] forKey:@"TodayClosed"];
                        [formatter setDateFormat:@"hh:mm a"];
                        NSLog(@"%@", [formatter stringFromDate:[NSDate date]]);
                        currTime = [self timeInSeconds:[formatter stringFromDate:[NSDate date]]];
                        [[CartObj instance].userInfo setObject:timeDisplayArr forKey:@"timeArr"];
                    }
                    if (currTime) {
                        for (int i = 0; i<(timeDisplayArr.count-1); i++) {
                            int dispTime = [self timeInSeconds:[timeDisplayArr objectAtIndex:i]];
                            if (currTime > dispTime && currTime > [self timeInSeconds:[timeDisplayArr objectAtIndex:i+1]]) {
                                [timeDisplayArr removeObjectAtIndex:i];
                                i--;
                            }
                        }
                    }
                    
                }else{
                    if ([dt1 isEqualToString:dt2]) {
                        [user setObject:[NSNumber numberWithBool:1] forKey:@"TodayClosed"];
                    }
                }

//                if ([[CartObj instance].userInfo objectForKey:@"OrderTime"]) {
//                    timeTxt.text = [[CartObj instance].userInfo objectForKey:@"OrderTime"];
//                }else{
                    timeTxt.text = [timeDisplayArr count]?[timeDisplayArr objectAtIndex:0]:@"Closed";
//                }

                [[CartObj instance].userInfo setObject:timeTxt.text forKey:@"OrderTime"];

                
//                [user setObject:[NSNumber numberWithBool:1] forKey:@"TodayClosed"];
//                [timeDisplayArr removeAllObjects];
                [self createPopUp];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [closeBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                });
            }
        }
    }];
}

-(void)createPopUp{
    [self addSubview:headerLbl];
    [self addSubview:closeBtn];
    
    [self addSubview:noteLbl];
    [self addSubview:orderBtn];
    [self addSubview:optionLbl];
    [self addSubview:orderDtLbl];
    [self addSubview:dateTxt];
    [self addSubview:orderTimeLbl];
    [self addSubview:timeTxt];
    [self addSubview:scheduleOrderBtn];

    
    if ([[user objectForKey:@"TodayClosed"] boolValue]) {
        orderBtn.hidden = true;
        optionLbl.hidden = true;
        if (timeDisplayArr.count && ![[timeDisplayArr objectAtIndex:0] isEqualToString:@"Closed"]) {
            noteLbl.hidden = true;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 280);
            orderDtLbl.frame = CGRectMake(20, 60, self.frame.size.width-40, 30);
            dateTxt.frame = CGRectMake(20, 100, self.frame.size.width-40, 30);
            orderTimeLbl.frame = CGRectMake(20, 140, self.frame.size.width-40, 30);
            timeTxt.frame = CGRectMake(20, 170, self.frame.size.width-40, 30);
            scheduleOrderBtn.frame = CGRectMake(30, 220, self.frame.size.width-60, 40);
            scheduleOrderBtn.userInteractionEnabled = true;
            
        }else{
            noteLbl.hidden = false;
            noteLbl.frame = CGRectMake(5, 45, self.frame.size.width-10, 40);
            orderDtLbl.frame = CGRectMake(20, 90, self.frame.size.width-40, 30);
            dateTxt.frame = CGRectMake(20, 130, self.frame.size.width-40, 30);
            orderTimeLbl.frame = CGRectMake(20, 170, self.frame.size.width-40, 30);
            timeTxt.frame = CGRectMake(20, 200, self.frame.size.width-40, 30);
            scheduleOrderBtn.frame = CGRectMake(30, 250, self.frame.size.width-60, 40);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 310);
            scheduleOrderBtn.userInteractionEnabled = false;
        }
        
    }else{
        orderBtn.hidden = false;
        optionLbl.hidden = false;
        
        if (timeDisplayArr.count && ![[timeDisplayArr objectAtIndex:0] isEqualToString:@"Closed"]) {
            noteLbl.hidden = true;
            
            orderBtn.frame = CGRectMake(30, 60, self.frame.size.width-60, 40);
            optionLbl.frame =  CGRectMake(0, 110, self.frame.size.width, 20);
            orderDtLbl.frame = CGRectMake(20, 140, self.frame.size.width-40, 30);
            dateTxt.frame = CGRectMake(20, 170, self.frame.size.width-40, 30);
            orderTimeLbl.frame = CGRectMake(20, 210, self.frame.size.width-40, 30);
            timeTxt.frame = CGRectMake(20, 240, self.frame.size.width-40, 30);
            scheduleOrderBtn.frame = CGRectMake(30, 280, self.frame.size.width-60, 40);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 340);
            scheduleOrderBtn.userInteractionEnabled = true;
        }else{
            noteLbl.hidden = false;
            
            noteLbl.frame = CGRectMake(5, 45, self.frame.size.width-10, 40);
            orderBtn.frame = CGRectMake(30, 90, self.frame.size.width-60, 40);
            optionLbl.frame =  CGRectMake(0, 140, self.frame.size.width, 20);
            orderDtLbl.frame = CGRectMake(20, 170, self.frame.size.width-40, 30);
            dateTxt.frame = CGRectMake(20, 200, self.frame.size.width-40, 30);
            orderTimeLbl.frame = CGRectMake(20, 240, self.frame.size.width-40, 30);
            timeTxt.frame = CGRectMake(20, 270, self.frame.size.width-40, 30);
            scheduleOrderBtn.frame = CGRectMake(30, 310, self.frame.size.width-60, 40);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 370);
            scheduleOrderBtn.userInteractionEnabled = false;
        }
    }
    
    
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
//    [nowDateFormatter setDateFormat:@"MM/dd/yyyy"];
//    now =  [dfltDt length]? [nowDateFormatter dateFromString:dfltDt] :datePicker.date;
//    [nowDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-8"]];
//    
//    [nowDateFormatter setDateFormat:@"e"];
//    weekDayNumber = (NSInteger)[[nowDateFormatter stringFromDate:now] integerValue]-1;
//    if (([[user objectForKey:@"isRestOpen"] boolValue]) && [self checkPickUpClosed]) {
//        [noteLbl removeFromSuperview];
//        
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 320);
//        
//        orderBtn.frame = CGRectMake(30, 50, self.frame.size.width-60, 40);
//        optionLbl.frame =  CGRectMake(0, 100, self.frame.size.width, 20);
//        orderDtLbl.frame = CGRectMake(30, 130, self.frame.size.width-60, 30);
//        dateTxt.frame = CGRectMake(20, 160, self.frame.size.width-40, 30);
//        orderTimeLbl.frame = CGRectMake(20, 200, self.frame.size.width-40, 30);
//        timeTxt.frame = CGRectMake(20, 230, self.frame.size.width-40, 30);
//        scheduleOrderBtn.frame = CGRectMake(30, 270, self.frame.size.width-60, 40);
//        
//        
//        if (([[user objectForKey:@"OrderType"] intValue] == 2 && [self checkDeliveryClosed]) || [[user objectForKey:@"OrderType"] intValue] == 1) {
//            
//            NSString *dt1 = [format stringFromDate:[NSDate date]];
//            NSString *dt2 = [format stringFromDate:now];
//            
//            NSLog(@"%@\n%@", dt1, dt2);
//            if ([dt1 isEqualToString:dt2]) {
//                optionLbl.hidden=NO;
//                orderBtn.hidden = NO;
//                
//                orderBtn.userInteractionEnabled = YES;
//                [orderBtn setBackgroundColor:APP_COLOR];
//                [noteLbl removeFromSuperview];
//            }else{
//                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 320);
//                orderDtLbl.frame = CGRectMake(30, 130, self.frame.size.width-60, 30);
//                dateTxt.frame = CGRectMake(20, 160, self.frame.size.width-40, 30);
//                orderTimeLbl.frame = CGRectMake(20, 200, self.frame.size.width-40, 30);
//                timeTxt.frame = CGRectMake(20, 230, self.frame.size.width-40, 30);
//                scheduleOrderBtn.frame = CGRectMake(30, 270, self.frame.size.width-60, 40);
//            }
//            scheduleOrderBtn.userInteractionEnabled = YES;
////            [self getTimings];
//        }else{
//            
//            NSString *dt1 = [format stringFromDate:[NSDate date]];
//            NSString *dt2 = [format stringFromDate:now];
//            [self addSubview:noteLbl];
//            
//            NSLog(@"%@\n%@", dt1, dt2);
//            if ([dt1 isEqualToString:dt2]) {
//                //                    todayClosed = true;
//                optionLbl.hidden=YES;
//                orderBtn.hidden = YES;
//                orderBtn.userInteractionEnabled = false;
//                
//                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 285);
//                orderDtLbl.frame = CGRectMake(30, 95, self.frame.size.width-60, 30);
//                dateTxt.frame = CGRectMake(20, 125, self.frame.size.width-40, 30);
//                orderTimeLbl.frame = CGRectMake(20, 165, self.frame.size.width-40, 30);
//                timeTxt.frame = CGRectMake(20, 195, self.frame.size.width-40, 30);
//                scheduleOrderBtn.frame = CGRectMake(30, 235, self.frame.size.width-60, 40);
//                
//                //                    [orderBtn setBackgroundColor:[UIColor colorWithRed:229/255.0 green:139/255.0 blue:61/255.0 alpha:0.5]];
//                
//                
//            }else{
//                
//            }
//            timeTxt.text = @"Closed";
//            scheduleOrderBtn.userInteractionEnabled = false;
//            [timeDisplayArr removeAllObjects];
//            
//        }
//        
//    }else{
//        
//        [self addSubview:noteLbl];
//        
//        NSString *dt1 = [format stringFromDate:[NSDate date]];
//        NSString *dt2 = [format stringFromDate:now];
//        
//        NSLog(@"%@\n%@", dt1, dt2);
//        if ([dt1 isEqualToString:dt2]) {
//            optionLbl.hidden=YES;
//            orderBtn.hidden = YES;
//            todayClosed = true;
//            [user setObject:[NSNumber numberWithBool:todayClosed] forKey:@"TodayClosed"];
//            orderBtn.userInteractionEnabled = false;
//            
//            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 285);
//            orderDtLbl.frame = CGRectMake(30, 95, self.frame.size.width-60, 30);
//            dateTxt.frame = CGRectMake(20, 125, self.frame.size.width-40, 30);
//            orderTimeLbl.frame = CGRectMake(20, 165, self.frame.size.width-40, 30);
//            timeTxt.frame = CGRectMake(20, 195, self.frame.size.width-40, 30);
//            scheduleOrderBtn.frame = CGRectMake(30, 235, self.frame.size.width-60, 40);
//            //                [orderBtn setBackgroundColor:[UIColor colorWithRed:229/255.0 green:139/255.0 blue:61/255.0 alpha:0.5]];
//            
//            
//        }else{
//            if (todayClosed) {
//                
//                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 280);
//                orderDtLbl.frame = CGRectMake(30, 90, self.frame.size.width-60, 30);
//                dateTxt.frame = CGRectMake(20, 120, self.frame.size.width-40, 30);
//                orderTimeLbl.frame = CGRectMake(20, 160, self.frame.size.width-40, 30);
//                timeTxt.frame = CGRectMake(20, 190, self.frame.size.width-40, 30);
//                scheduleOrderBtn.frame = CGRectMake(30, 230, self.frame.size.width-60, 40);
//            }else{
//                
//                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 340);
//                orderBtn.frame = CGRectMake(30, 90, self.frame.size.width-60, 40);
//                optionLbl.frame =  CGRectMake(0, 135, self.frame.size.width, 20);
//                orderDtLbl.frame = CGRectMake(30, 160, self.frame.size.width-60, 30);
//                dateTxt.frame = CGRectMake(20, 190, self.frame.size.width-40, 30);
//                orderTimeLbl.frame = CGRectMake(20, 225, self.frame.size.width-40, 30);
//                timeTxt.frame = CGRectMake(20, 255, self.frame.size.width-40, 30);
//                scheduleOrderBtn.frame = CGRectMake(30, 290, self.frame.size.width-60, 40);
//            }
//            
//            
//        }
//        timeTxt.text = @"Closed";
//        scheduleOrderBtn.userInteractionEnabled = false;
//        [timeDisplayArr removeAllObjects];
//        //            [user removeObjectForKey:@"OrderDate"];
//        //            [user removeObjectForKey:@"OrderTime"];
//        
//    }
    
    
    
}


-(void)initializePopUpElements{
    
    noteLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, self.frame.size.width-10, 40)];
    noteLbl.textColor = [UIColor redColor];
    noteLbl.textAlignment = NSTextAlignmentCenter;
    noteLbl.font = [UIFont fontWithName:@"Lora-Regular" size:14];
    noteLbl.numberOfLines = 0;
    noteLbl.text = @"Note: Restaurant is closed. You can schedule your order for next working day.";
    
    orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(30, 10, self.frame.size.width-60, 40);
    [orderBtn setBackgroundColor:[UIColor whiteColor]];
    [orderBtn setTitle:@"Order For Now" forState:UIControlStateNormal];
    [orderBtn setTitleColor:APP_COLOR forState:UIControlStateNormal];
    [orderBtn.layer setBorderColor:[APP_COLOR CGColor]];
    [orderBtn.layer setBorderWidth:2];
    [orderBtn.layer setCornerRadius:2];
    [orderBtn.titleLabel setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    [orderBtn addTarget:controller action:@selector(orderScheduledForToday:) forControlEvents:UIControlEventTouchUpInside];
    
    optionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 20)];
    optionLbl.text = @"(OR)";
    optionLbl.font = [UIFont fontWithName:@"Lora-Bold" size:18];
    optionLbl.textAlignment = NSTextAlignmentCenter;
    optionLbl.textColor = [UIColor blackColor];
    
    orderDtLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, self.frame.size.width-40, 30)];
    orderDtLbl.backgroundColor = [UIColor clearColor];
    orderDtLbl.textColor = [UIColor blackColor];
    orderDtLbl.text = @"Order Date";
    [orderDtLbl setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    
    dateTxt = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, self.frame.size.width-40, 30)];
    dateTxt.delegate = self;
    dateTxt.backgroundColor = [UIColor whiteColor];
    dateTxt.placeholder = @"Select Date";
    [dateTxt setFont: [UIFont fontWithName:@"Lora-Regular" size:16]];
    [dateTxt.layer addSublayer:[self bottomborderAdding:self.frame.size.width-40 height:30]];
    dateTxt.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderDate"]? [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderDate"] : @"Today";
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(20, self.frame.size.height-200, self.frame.size.width-40, 200)];
    dateTxt.inputView = datePicker;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    
    orderTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, self.frame.size.width-40, 30)];
    orderTimeLbl.backgroundColor = [UIColor clearColor];
    orderTimeLbl.textColor = [UIColor blackColor];
    orderTimeLbl.text = @"Order Time";
    [orderTimeLbl setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    
    timeTxt = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, self.frame.size.width-40, 30)];
    timeTxt.delegate = self;
    timeTxt.backgroundColor = [UIColor whiteColor];
    timeTxt.placeholder = @"Select Time";
    [timeTxt.layer addSublayer:[self bottomborderAdding:self.frame.size.width-40 height:30]];
    timeTxt.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"]? [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderTime"] : @"";
    [timeTxt setFont:[UIFont fontWithName:@"Lora-Regular" size:16]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(20, self.frame.size.height-200, self.frame.size.width-40, 200)];
    dateTxt.inputView = datePicker;
    [datePicker addTarget:self action:@selector(updateTextField:)
         forControlEvents:UIControlEventValueChanged];
    UIToolbar *optionPickerTool=[[UIToolbar alloc]init];
    
    optionPickerTool.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                style:UIBarButtonItemStyleDone target:self
                                                               action:@selector(sendAction)];
    [optionPickerTool setItems:[[NSArray alloc] initWithObjects:button1, nil]];
    dateTxt.inputAccessoryView=optionPickerTool;
    timeTxt.inputAccessoryView=optionPickerTool;
    
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, self.frame.size.height-220, self.frame.size.width-40, 220)];
    timeTxt.inputView = timePicker;
    
    timePicker.delegate = self;
    timePicker.dataSource = self;
    
    scheduleOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scheduleOrderBtn.frame = CGRectMake(30, 250, self.frame.size.width-60, 40);
    [scheduleOrderBtn setBackgroundColor:APP_COLOR];
    [scheduleOrderBtn.titleLabel setFont:[UIFont fontWithName:@"Lora-Bold" size:18]];
    [scheduleOrderBtn setTitle:@"Schedule For Later" forState:UIControlStateNormal];
    [scheduleOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scheduleOrderBtn addTarget:controller action:@selector(orderScheduled:) forControlEvents:UIControlEventTouchUpInside];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDate *todate = [currentDate initWithTimeInterval:1296000 sinceDate:currentDate];//1296000 = 15Days * 24Hours * 60Min * 60Sec
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:todate options:0];
    [comps setYear:0];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [datePicker setMaximumDate:maxDate];
    [datePicker setMinimumDate:minDate];
    
    [formatter setDateFormat:@"MM/dd/yyyy"];
    if ([[user objectForKey:@"OrderDate"] length]) {
        [datePicker setDate:[formatter dateFromString:dfltDt]];
    }
    
//    [formatter setDateStyle: NSDateFormatterLongStyle];
}

-(void)initializeSceduleView{
    headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    headerLbl.backgroundColor = APP_COLOR;
    headerLbl.textAlignment = NSTextAlignmentCenter;
    headerLbl.font = [UIFont fontWithName:@"Lora-Bold" size:18];
    headerLbl.textColor = [UIColor whiteColor];
    headerLbl.text = @"Schedule Order";
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.frame.size.width-30, 10, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"closebutton_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:controller action:@selector(removeDummyView:) forControlEvents:UIControlEventTouchUpInside];
}
-(CALayer *)bottomborderAdding:(CGFloat)width height:(CGFloat)height{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [[UIColor grayColor] CGColor];
    border.frame = CGRectMake(0, height-1, width, 1);
    return border;
}
-(int)timeInSeconds:(NSString *)timeStr{
    NSArray *arr = [timeStr componentsSeparatedByString:@" "];
    int addOffset = 0;
    if ([arr count]==1 && ([arr[0] isEqualToString:@"ASAP"] || !((NSString *)arr[0]).length))
        return 0;
    if ([[arr objectAtIndex:1] isEqualToString:@"PM"]) {
        addOffset = 12*60*60;
    }
    
    NSArray *arr2 = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
    
    if ([[arr2 objectAtIndex:0] isEqualToString:@"12"] && [[arr objectAtIndex:1] isEqualToString:@"PM"]) {
        addOffset=0;
    }
    if ([[arr2 objectAtIndex:0] isEqualToString:@"12"] && [[arr objectAtIndex:1] isEqualToString:@"AM"]){
        return [[arr2 objectAtIndex:1] intValue]*60+addOffset;
    }else{
        return [[arr2 objectAtIndex:0] intValue]*60*60+[[arr2 objectAtIndex:1] intValue]*60+addOffset;
    }
    
}

-(BOOL)checkDeliveryClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekDayNumber &&
            [[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"DeliveryClosed"] boolValue]) {
            open = NO;
            break;
        }else{
            open = YES;
        }
    }
    return open;
}

-(BOOL)checkPickUpClosed{
    BOOL open = YES;
    for (int i = 0; i < [[user objectForKey:@"BusinessHours"] count]; i++) {
        if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Day"] integerValue] == weekDayNumber){
            if ([[[[user objectForKey:@"BusinessHours"] objectAtIndex:i] objectForKey:@"Closed"] boolValue]) {
                open = NO;
                break;
            }else{
                open = YES;
            }
        }else{
            open = YES;
        }
    }
    return open;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return timeDisplayArr.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (timeDisplayArr.count) {
        return [timeDisplayArr objectAtIndex:row];
    }else
        return @"Closed";
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (timeDisplayArr.count) {
        timeTxt.text = [timeDisplayArr objectAtIndex:row];
        [[CartObj instance].userInfo setObject:timeTxt.text forKey:@"OrderTime"];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == dateTxt) {
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker setTag:100];
    }
    if (textField == timeTxt) {
        [datePicker setDatePickerMode:UIDatePickerModeTime];
        [datePicker setTag:200];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == dateTxt) {
        [self getTimings];
    }
}
-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    if (sender.tag == 100) {
        dateTxt.text = [formatter stringFromDate:datePicker.date];
        [formatter setDateFormat:@"MM/dd/YYYY"];
        
    }
    if (sender.tag == 200) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"h:mm a"];
        timeTxt.text = [outputFormatter stringFromDate:sender.date];
    }
}


-(void)sendAction{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    dateTxt.text = [formatter stringFromDate:datePicker.date];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    if ([[formatter stringFromDate:datePicker.date] isEqualToString: [formatter stringFromDate:[NSDate date]]]) {
        dateTxt.text = @"Today";
    }
    dfltDt = [formatter stringFromDate:datePicker.date];
    dfltTime = timeTxt.text;
    
    [dateTxt resignFirstResponder];
    [timeTxt resignFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}


@end
