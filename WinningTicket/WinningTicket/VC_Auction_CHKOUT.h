//
//  VC_Auction_CHKOUT.h
//  WinningTicket
//
//  Created by Test User on 30/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface VC_Auction_CHKOUT : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,weak)IBOutlet UIView *VW_main;
@property(nonatomic,weak)IBOutlet UILabel *lbl_name_ticket;
//@property(nonatomic,weak)IBOutlet UILabel *lbl_qty;
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
@property (nonatomic, retain) IBOutlet UIButton *BTN_back;

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

@property(nonatomic,weak)IBOutlet UILabel *lbl_nav_font;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title_acc_BAL;
@property (weak, nonatomic) IBOutlet UILabel *lbl_data_acc_BAL;
@property (weak, nonatomic) IBOutlet UIView *VW_line4;

@end

