//
//  LocationsList.m
//  CLOrder
//
//  Created by Naveen Thukkani on 04/07/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "LocationsList.h"
#import "AppHeader.h"

@implementation LocationsList

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(10, 20, 40, 40);
    self.textLabel.frame= CGRectMake(65, 10, self.frame.size.width-65, 20);
    self.detailTextLabel.frame= CGRectMake(65,30, self.frame.size.width-65, 40);
    
    UILabel *line=[[UILabel alloc] initWithFrame:CGRectMake(5, self.frame.size.height-1,self.frame.size.width-10, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:line];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
