//
//  CartObj.m
//  CLOrder
//
//  Created by Vegunta's on 11/07/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import "CartObj.h"
#import <UIKit/UIKit.h>

@implementation CartObj

@synthesize itemsForCart, cartPrice, spclNote, subTotal;
static CartObj *gInstance = NULL;

+ (CartObj *)instance {
    @synchronized(self){
        if (gInstance == NULL) {
            gInstance = [[self alloc] init];
            gInstance.itemsForCart = [[NSMutableArray alloc] init];
            gInstance.userInfo = [[NSMutableDictionary alloc] init];
            gInstance.freeItemDic = [[NSMutableDictionary alloc] init];
            gInstance.cartPrice = @"$0";
            gInstance.subTotal = @"$0";

        }
    }
    return(gInstance);
    
}

+ (void)clearInstance{
    gInstance = NULL;
}

+(CartObj *)checkingObjectOfCart{
    return gInstance;
}

+(BOOL)checkPickupDelivery:(BOOL)isPickUp {
    int dType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DeliveryType"] intValue];
    if (isPickUp && dType!=1 && dType!=4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant doesn't take pickup orders." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else if (!isPickUp && dType!=2 && dType!=4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Restaurant doesn't take delivery orders." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

@end
