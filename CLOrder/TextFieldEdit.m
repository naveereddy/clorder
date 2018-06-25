//
//  textFieldEdit.m
//  CLOrder
//
//  Created by Naveen Thukkani on 14/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import "TextFieldEdit.h"

@implementation TextFieldEdit
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}
// Placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 0, 0);

    return UIEdgeInsetsInsetRect(rect, insets);
}

// Text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 0, 0);

    return UIEdgeInsetsInsetRect(rect, insets);
}

@end
