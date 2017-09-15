//
//  VC_addFUNDS.h
//  WinningTicket
//
//  Created by Test User on 30/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Braintree/Braintree.h>
#import "BraintreeCore.h"
#import "BraintreeDropIn.h"

@interface VC_addFUNDS : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,BTViewControllerPresentingDelegate,UIGestureRecognizerDelegate>

//@property (nonatomic, strong) Braintree *braintree;
@property (weak, nonatomic) IBOutlet UITextField *TXT_amount;
@property (weak, nonatomic) IBOutlet UIView *VW_contents;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_Contents;

//@property (weak, nonatomic) IBOutlet UITextField *TXT_firstname;
//@property (weak, nonatomic) IBOutlet UITextField *TXT_lastname;
//@property (weak, nonatomic) IBOutlet UITextField *TXT_address1;
//@property (weak, nonatomic) IBOutlet UITextField *TXT_address2;
//@property (weak, nonatomic) IBOutlet UITextField *TXT_city;
//@property (weak, nonatomic) IBOutlet UITextField *TXT_state;
//@property (weak, nonatomic) IBOutlet UITextField *TXT_zip;
//@property (weak, nonatomic) IBOutlet UITextField *TXT_phonenumber;
//@property (nonatomic, weak) IBOutlet UITextField *TXT_country;
//@property (nonatomic, strong) UIPickerView *contry_pickerView;
//
////@property (weak, nonatomic) IBOutlet UIButton *BTN_state;
//@property (nonatomic, strong) UIPickerView *state_pickerView;
//
////@property (weak, nonatomic) IBOutlet UIPickerView *PICK_state;
////@property (weak, nonatomic) IBOutlet UIToolbar *TOOL_state;
//@property(nonatomic,weak)IBOutlet UILabel *lbl_address;
//@property(nonatomic,weak)IBOutlet UIView *VW_titladdress;
//@property(nonatomic,weak)IBOutlet UIView *VW_address;
//@property (weak, nonatomic) IBOutlet UIButton *BTN_edit;
@property (weak, nonatomic) IBOutlet UIButton *ADD_funds;
@property(weak,nonatomic) IBOutlet UICollectionView *amount_collection;




@end
