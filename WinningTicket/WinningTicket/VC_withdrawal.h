//
//  VC_withdrawal.h
//  WinningTicket
//
//  Created by Test User on 03/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"
@interface VC_withdrawal : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbl_availableBAL;

//ContentVIEW & Scrollview
@property (weak, nonatomic) IBOutlet UIView *VW_Contents;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_contents;

@property (weak, nonatomic) IBOutlet UIButton *BTN_banktransfer;
@property (weak, nonatomic) IBOutlet UIButton *BTN_paypal;
@property (weak, nonatomic) IBOutlet UIButton *BTN_submit_paypal;
@property (weak, nonatomic) IBOutlet UIButton *BTN_submit_account;



@property (weak, nonatomic) IBOutlet UIView *VW_paypal;
@property (weak, nonatomic) IBOutlet UIView *VW_banktransfer;

@property (weak, nonatomic) IBOutlet UIView *VW_holdBTN;

@property (weak, nonatomic) IBOutlet UILabel *lbl_titleAMT;
@property (weak, nonatomic) IBOutlet UILabel *lbl_titleAMT1;

@property (weak, nonatomic) IBOutlet UITextField *TXT_amtbank;
@property (weak, nonatomic) IBOutlet UITextField *TXT_amtpaypal;
@property (weak, nonatomic) IBOutlet UITextField *TXT_accholdername;
@property (weak, nonatomic) IBOutlet UITextField *TXT_acconroutingnumber;
@property (weak, nonatomic) IBOutlet UITextField *TXT_accountnumber;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_email;

@property(nonatomic,weak) IBOutlet UIView *bank_transfer_BG;

@property(nonatomic,weak) IBOutlet UIView *pay_pal_BG;

@end
