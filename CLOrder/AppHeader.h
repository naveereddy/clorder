//
//  AppHeader.h
//  CLOrder
//
//  Created by Vegunta's on 12/04/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#ifndef AppHeader_h
#define AppHeader_h

#define CLIENT_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"MainClientId"]
#define ORDER_ONLINE [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"OrderOnlineStatus"]]


#define SANBOX_MERCHNAT @"merchant.com.clorder.OrderOnlineBrianTreeTest"
#define PRODUCTION_MERCHNAT @"merchant.com.clorder.orderonline"

#define SANBOX_BAINTREE_AUTH @"sandbox_m32bhjjg_x8xhk82f9y5vzx8k"
#define PRODUCTION_BAINTREE_AUTH @"production_hkggt9bz_9qx7w4yw7cdm4mbk"

#define APP_BG_IMG @"home_screen_bg.png"
#define ORDER_FROM_RIBBON @"order_from.png"
#define APP_COLOR_LIGHT_WHITE [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define APP_COLOR [UIColor colorWithRed:250/255.0 green:91/255.0 blue:91/255.0 alpha:1.0]
#define APP_COLOR_LIGHT [UIColor colorWithRed:243/255.0 green:241/255.0 blue:242/255.0 alpha:1.0]
#define APP_COLOR_LIGHT_BACKGROUND [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0]
#define DARK_GRAY [UIColor colorWithRed:29/255.0  green:33/255.0 blue:38/255.0 alpha:1]
#define TRANSPARENT_GRAY [UIColor colorWithRed:29/255.0  green:33/255.0 blue:38/255.0 alpha:0.5]
#define APP_BLUE_COLOR [UIColor colorWithRed:38/255.0 green:189/255.0 blue:241/255.0 alpha:1.0]
#define APP_GREEN_COLOR [UIColor colorWithRed:119/255.0 green:194/255.0 blue:47/255.0 alpha:1.0]
#define APP_GOLD_COLOR [UIColor colorWithRed:233/255.0 green:160/255.0 blue:111/255.0 alpha:1.0]
#define APP_OWNER @"powered by: clorder.com"

#define APP_FONT_REGULAR_10 [UIFont fontWithName:@"Lora-Regular" size:10]
#define APP_FONT_REGULAR_12 [UIFont fontWithName:@"Lora-Regular" size:12]
#define APP_FONT_REGULAR_14 [UIFont fontWithName:@"Lora-Regular" size:14]
#define APP_FONT_REGULAR_16 [UIFont fontWithName:@"Lora-Regular" size:16]
#define APP_FONT_REGULAR_18 [UIFont fontWithName:@"Lora-Regular" size:18]

#define APP_FONT_BOLD_10 [UIFont fontWithName:@"Lora-Bold" size:10]
#define APP_FONT_BOLD_12 [UIFont fontWithName:@"Lora-Bold" size:12]
#define APP_FONT_BOLD_14 [UIFont fontWithName:@"Lora-Bold" size:14]
#define APP_FONT_BOLD_16 [UIFont fontWithName:@"Lora-Bold" size:16]
#define APP_FONT_BOLD_18 [UIFont fontWithName:@"Lora-Bold" size:18]

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height
#define FRAME_WIDTH frame.size.width
#define FRAME_HEIGHT frame.size.height

#define  GOOGLE_API_KEY @"AIzaSyCZjRFntVLR5DNvDTIB73JHiS6PkrO7cC0"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif /* AppHeader_h */
