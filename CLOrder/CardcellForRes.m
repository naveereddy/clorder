//
//  CardcellForRes.m
//  CLOrder
//
//  Created by Naveen Thukkani on 06/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "CardcellForRes.h"
#import "AppHeader.h"

@implementation CardcellForRes
@synthesize image,title,address,distance,Delivery,cardView,devlivaryStatus,deliveystatusLabel,openorclosetime,
CuisineName,cousineView,cousineImageView;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        CGSize size=self.frame.size;

        cardView=[[UIView alloc] initWithFrame:CGRectMake(5,10,size.width-10, 320)];
        cardView.layer.cornerRadius = 5.0;
        cardView.layer.borderColor  =  [[UIColor groupTableViewBackgroundColor] CGColor];
        cardView.layer.borderWidth = 2.0;
        cardView.layer.shadowOpacity = 0.5;
        cardView.layer.shadowColor = [[UIColor grayColor] CGColor];
        cardView.layer.shadowRadius = 5.0;
        cardView.layer.shadowOffset = CGSizeMake(5,5);
        cardView.layer.masksToBounds = YES;
        [self addSubview:cardView];
        
        image=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5,cardView.frame.size.width-20, 150)];
        image.contentMode=UIViewContentModeScaleAspectFill;
        image.clipsToBounds=YES;
        image.image=[UIImage imageNamed:@"menu-placeholder"];
        [cardView addSubview:image];
        
        cousineView=[[UIView alloc] initWithFrame:CGRectMake(0, image.frame.size.height-20,image.frame.size.width,20)];
        [cousineView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.54]];
        [image addSubview:cousineView];

        CuisineName=[[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width-180, image.frame.size.height-20,155,20)];
        CuisineName.textColor=[UIColor whiteColor];
        CuisineName.backgroundColor=[UIColor clearColor];
        [CuisineName setTextAlignment:NSTextAlignmentRight];
        CuisineName.font=APP_FONT_REGULAR_14;
        [image addSubview:CuisineName];
        [image bringSubviewToFront:CuisineName];
        
        cousineImageView=[[UIImageView alloc] initWithFrame:CGRectMake(image.frame.size.width-20, image.frame.size.height-18, 15, 15)];
        [image addSubview:cousineImageView];
        [image bringSubviewToFront:cousineImageView];

        title=[[UILabel alloc] initWithFrame:CGRectMake(20, 160,cardView.frame.size.width-40,20)];
        title.textColor=APP_GREEN_COLOR;
        title.font=APP_FONT_BOLD_18;
        [cardView addSubview:title];
        
        address=[[UILabel alloc] initWithFrame:CGRectMake(20,180,cardView.frame.size.width-40,50)];
        address.textColor=[UIColor grayColor];
        address.font=APP_FONT_REGULAR_16;
        address.numberOfLines=0;
        [cardView addSubview:address];
        
        distance=[[UILabel alloc] initWithFrame:CGRectMake(20,230,cardView.frame.size.width-40,20)];
        distance.font=APP_FONT_REGULAR_16;
        [cardView addSubview:distance];
        
        Delivery=[[UILabel alloc] initWithFrame:CGRectMake(20,250,cardView.frame.size.width-40,20)];
        Delivery.font=APP_FONT_REGULAR_16;
        [cardView addSubview:Delivery];
        
        devlivaryStatus=[[UIView alloc] initWithFrame:CGRectMake(0, 275, cardView.frame.size.width, 45)];
        [devlivaryStatus setBackgroundColor:[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]];
        [cardView addSubview:devlivaryStatus];
        
        deliveystatusLabel=[[UILabel alloc] initWithFrame:CGRectMake(20,0,cardView.frame.size.width-40,20)];
        deliveystatusLabel.font=APP_FONT_REGULAR_16;
        [devlivaryStatus addSubview:deliveystatusLabel];
        
        openorclosetime=[[UILabel alloc] initWithFrame:CGRectMake(20,20,cardView.frame.size.width-40,20)];
        openorclosetime.font=APP_FONT_REGULAR_16;
        openorclosetime.textColor=APP_GREEN_COLOR;
        [devlivaryStatus addSubview:openorclosetime];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
     CGSize size=self.frame.size;
     cardView.frame=CGRectMake(5,10,size.width-10, 320);
    
    image.frame=CGRectMake(10,5,cardView.frame.size.width-20, 150);
    cousineView.frame=CGRectMake(0,image.frame.size.height-20,image.frame.size.width,20);
    CuisineName.frame=CGRectMake(image.frame.size.width-180, image.frame.size.height-20,155,20);
    cousineImageView.frame=CGRectMake(image.frame.size.width-20, image.frame.size.height-18, 15, 15);
    
    title.frame=CGRectMake(20,160,cardView.frame.size.width-40,20);
    address.frame=CGRectMake(20,180,cardView.frame.size.width-40,50);
    distance.frame=CGRectMake(20,230,cardView.frame.size.width-40,20);
    Delivery.frame=CGRectMake(20,250,cardView.frame.size.width-40,20);
    devlivaryStatus.frame=CGRectMake(0, 275, cardView.frame.size.width,45);
    deliveystatusLabel.frame=CGRectMake(20,0,cardView.frame.size.width-40,20);
    openorclosetime.frame=CGRectMake(20,20,cardView.frame.size.width-40,20);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
