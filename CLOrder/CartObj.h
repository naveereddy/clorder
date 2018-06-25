//
//  CartObj.h
//  CLOrder
//
//  Created by Vegunta's on 11/07/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartObj : NSObject

@property (nonatomic, retain) NSMutableArray *itemsForCart;
@property (nonatomic, retain) NSString *cartPrice;
@property (nonatomic, retain) NSString *subTotal;
@property (nonatomic, retain) NSString *spclNote;
@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, retain) NSMutableDictionary *freeItemDic;

+ (CartObj *) instance;
+ (void) clearInstance;
+ (CartObj *) checkingObjectOfCart;
+ (BOOL)checkPickupDelivery:(BOOL)isPickUp;

@end
