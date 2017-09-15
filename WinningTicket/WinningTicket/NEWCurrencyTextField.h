//
//  NEWCurrencyTextField.h
//  WinningTicket
//
//  Created by Test User on 22/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEWCurrencyTextField : UITextField

@property (nonatomic) NSCharacterSet* invalidInputCharacterSet;
@property (nonatomic) NSNumberFormatter* currencyNumberFormatter;

@property (nonatomic) NSNumber* amount;

@end
