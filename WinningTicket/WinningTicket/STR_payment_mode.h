//
//  STR_payment_mode.h
//  WinningTicket
//
//  Created by Test User on 18/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STR_payment_mode : NSObject

@property (atomic, strong) NSString *STR_paymentTYPE;
+(STR_payment_mode *)PaymentTYPE;

@end
