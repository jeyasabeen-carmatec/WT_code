//
//  VC_addRefferel.h
//  WinningTicket
//
//  Created by Test User on 21/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface VC_addRefferel : UIViewController

@property(nonatomic,weak)IBOutlet UIView *VW_content;

@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_referal_name;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_referal_phone;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_referal_email;

@property (weak, nonatomic) IBOutlet UIButton *BTN_sponsor;
@property (weak, nonatomic) IBOutlet UIButton *BTN_contributer;
@property (weak, nonatomic) IBOutlet UIButton *BTN_organizer;
@property (weak, nonatomic) IBOutlet UIButton *BTN_affiliate;

@property (weak, nonatomic) IBOutlet UIButton *BTN_addRefeerel;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;

@end
