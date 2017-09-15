//
//  VC_editAccount.h
//  WinningTicket
//
//  Created by Test User on 05/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface VC_editAccount : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_fname;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_lname;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_email;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_username;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_addr1;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_addr2;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_city;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_state;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_zip;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_phone;
@property (nonatomic, weak) IBOutlet ACFloatingTextField *TXT_country;
@property (nonatomic, strong) UIPickerView *state_pickerView;
@property(nonatomic,weak)IBOutlet UIButton *BTN_save;
@property (weak, nonatomic) IBOutlet UIView *VW_contents;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_contents;
@property (nonatomic, strong) UIPickerView *contry_pickerView;
@end
