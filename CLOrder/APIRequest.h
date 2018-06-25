//
//  APIRequest.h
//  CLOrder
//
//  Created by Vegunta's on 16/06/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequester.h"

@interface APIRequest : NSObject

+ (void)registerClorderUser:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)loginUser:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchClientSettings:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchClientMenu:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchClientItems:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchClientCategories:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)getModifiersForItem:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)getRestaurentPromotions:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)getRestaurentHours:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchMenuWithCategories:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchClientOrderHistory:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)getOrderdetails:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)getOrderDetailsForReorder:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)placeOrder:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)confirmPaypalOrder:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchDeliveryFees:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchTaxForOrder:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)updateClorderUser:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)clorderGoogleSignup:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchDiscount:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)fetchRestTimeSlots:(NSDictionary *)dict completion:(RequestCallback)cb;
+ (void)googleAutoComplteApi:(NSDictionary *)dict url:(NSString *)url completion:(RequestCallback)cb;


@end
