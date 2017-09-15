//
//  VC_conf_Ordr.h
//  WinningTicket
//
//  Created by Test User on 31/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_conf_Ordr : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbl_ticketdetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;

//@property (weak, nonatomic) IBOutlet UIView *VW_qtycontent;

//@property (weak, nonatomic) IBOutlet UILabel *lbl_arrowpromocode;
//@property (weak, nonatomic) IBOutlet UIButton *BTN_promocode;

@property (weak, nonatomic) IBOutlet UIView *VW_line1;
@property (weak, nonatomic) IBOutlet UIView *VW_line2;
//@property (weak, nonatomic) IBOutlet UIView *VW_promo;

@property (weak, nonatomic) IBOutlet UILabel *lbl_titleSubtotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_datasubtotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_titleTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dataTotal;

//@property (weak, nonatomic) IBOutlet UITextField *TXT_qty;
@property (weak, nonatomic) IBOutlet UITextField *TXT_promocode;

@property (weak, nonatomic) IBOutlet UIButton *BTN_checkout;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_contents;

#pragma account view
@property (weak, nonatomic) IBOutlet UIView *VW_line;
@property (weak, nonatomic) IBOutlet UIView *VW_line3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_current_bal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_acbalance;
@property (weak, nonatomic) IBOutlet UILabel *lbl_acbalance_amount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_arrowaccount;
@property (weak, nonatomic) IBOutlet UIButton *BTN_Account;
@property (weak, nonatomic) IBOutlet UIView *VW_Account;
@property (weak, nonatomic) IBOutlet UILabel *TXT_account;
@property (weak, nonatomic) IBOutlet UISwitch *Switch_Ac;

@end
