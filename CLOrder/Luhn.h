//
//  Luhn.h
//  CLOrder
//
//  Created by Vegunta's on 27/09/16.
//  Copyright © 2016 Vegunta's. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OLCreditCardType) {
    OLCreditCardTypeAmex,
    OLCreditCardTypeVisa,
    OLCreditCardTypeMastercard,
    OLCreditCardTypeDiscover,
    OLCreditCardTypeDinersClub,
    OLCreditCardTypeJCB,
    OLCreditCardTypeUnsupported,
    OLCreditCardTypeInvalid
};

@interface Luhn : NSObject

+ (OLCreditCardType) typeFromString:(NSString *) string;
+ (BOOL) validateString:(NSString *) string forType:(OLCreditCardType) type;
+ (BOOL) validateString:(NSString *) string;

@end

@interface NSString (Luhn)

- (BOOL) isValidCreditCardNumber;
- (OLCreditCardType) creditCardType;

@end
