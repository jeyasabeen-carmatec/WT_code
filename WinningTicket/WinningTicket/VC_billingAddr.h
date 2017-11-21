//
//  VC_billingAddr.h
//  WinningTicket
//
//  Created by Test User on 09/05/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Braintree/Braintree.h>
#import "ACFloatingTextField.h"

@interface VC_billingAddr : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,weak)IBOutlet UIView *VW_main;
@property(nonatomic,weak)IBOutlet UILabel *lbl_name_ticket;
@property(nonatomic,weak)IBOutlet UILabel *lbl_qty;
@property(nonatomic,weak)IBOutlet UILabel *lbl_des_cription;
@property(nonatomic,weak)IBOutlet UILabel *lbl_amount_des;
@property(nonatomic,weak)IBOutlet UILabel *lbl_sub_total;
@property(nonatomic,weak)IBOutlet UILabel *lbl_sub_amount;
@property(nonatomic,weak)IBOutlet UILabel *lbl_total;
@property(nonatomic,weak)IBOutlet UILabel *lbl_total_amount;
@property(nonatomic,weak)IBOutlet UILabel *lbl_address;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_firstname;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_lastname;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_address1;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_address2;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_city;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_state;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_zip;
@property (nonatomic, weak) IBOutlet ACFloatingTextField *TXT_country;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_phonenumber;

@property (nonatomic, strong) UIPickerView *state_pickerView;
@property (weak, nonatomic) IBOutlet UIView *VW_line1;
@property (weak, nonatomic) IBOutlet UIView *VW_line2;
@property (nonatomic, strong) UIPickerView *contry_pickerView;

//@property (weak, nonatomic) IBOutlet UIButton *proceed_TOPAY;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_contents;

@property(nonatomic,weak)IBOutlet UILabel *lbl_agree;
@property(nonatomic,weak)IBOutlet UIButton *BTN_checkout;

@property(nonatomic,weak)IBOutlet UIView *VW_titladdress;
@property(nonatomic,weak)IBOutlet UIView *VW_address;

@property(nonatomic,weak)IBOutlet UIButton *BTN_edit;

//New changes add Promo
@property (weak, nonatomic) IBOutlet UIButton *BTN_addPromo;
@property (weak, nonatomic) IBOutlet UILabel *LBL_arrowPromo;
@property (weak, nonatomic) IBOutlet UIView *VW_account;
@property (weak, nonatomic) IBOutlet UITextField *TXT_getpromocode;
@property (weak, nonatomic) IBOutlet UIButton *BTN_apply;
@property (weak, nonatomic) IBOutlet UILabel *LBL_coupanCode;
@property (weak, nonatomic) IBOutlet UIButton *BTN_close;

// New changes use account balence
@property (weak, nonatomic) IBOutlet UIButton *BTN_useAccount;
@property (weak, nonatomic) IBOutlet UILabel *LBL_arrowAccount;
@property (weak, nonatomic) IBOutlet UIView *VW_useAccountt;
@property (weak, nonatomic) IBOutlet UISwitch *SWITCH_useAccount;
@property (weak, nonatomic) IBOutlet UILabel *LBL_wallet_bal;

// New content Title items
@property (weak, nonatomic) IBOutlet UIView *VW_line_promocode;
@property (weak, nonatomic) IBOutlet UILabel *LBL_titleDiscount;
@property (weak, nonatomic) IBOutlet UILabel *LBL_dataDiscount;
@property (weak, nonatomic) IBOutlet UIView *VW_line_wallet;
@property (weak, nonatomic) IBOutlet UILabel *LBL_titlewallet;
@property (weak, nonatomic) IBOutlet UILabel *LBL_datawallet;

@property (weak, nonatomic) IBOutlet UIView *VW_line_promo;


@end
