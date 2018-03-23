//
//  STR_payment_mode.m
//  WinningTicket
//
//  Created by Test User on 18/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "STR_payment_mode.h"

@implementation STR_payment_mode

@synthesize STR_paymentTYPE;

+(STR_payment_mode *)PaymentTYPE {
    static dispatch_once_t pred;
    static STR_payment_mode *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[STR_payment_mode alloc] init];
        shared.STR_paymentTYPE = [[NSString alloc]init];
    });
    return shared;
}

@end
