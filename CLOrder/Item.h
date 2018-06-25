//
//  Item.h
//  CLOrder
//
//  Created by Naveen Thukkani on 19/06/18.
//  Copyright © 2018 Vegunta's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
@property (nonatomic, strong) NSData *imagedata;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *imageUrl;

@end
