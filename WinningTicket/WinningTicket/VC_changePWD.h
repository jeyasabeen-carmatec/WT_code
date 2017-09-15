//
//  VC_changePWD.h
//  WinningTicket
//
//  Created by Test User on 05/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface VC_changePWD : UIViewController

@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_currentPWD;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_newPWD;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_confirmnewPWD;
@property(nonatomic,weak)IBOutlet UILabel *Stat_label;
@property(nonatomic,weak)IBOutlet UIButton *done_Btn;
@property(nonatomic,weak)IBOutlet UIView *actview;
@property(nonatomic,weak)IBOutlet UIActivityIndicatorView *actviewone;

@property(nonatomic,weak)IBOutlet UILabel *lbl_icon1;
@property(nonatomic,weak)IBOutlet UILabel *lbl_icon2;
@property(nonatomic,weak)IBOutlet UILabel *lbl_icon3;

@end
