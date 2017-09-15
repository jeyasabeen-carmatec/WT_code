//
//  Normal_sighnUP.h
//  WinningTicket
//
//  Created by Test User on 23/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatingTXT_white.h"

@interface Normal_sighnUP : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_F_name;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_L_name;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_email;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_phone_number;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_country;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_state;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_addressLine_one;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_addressLine_two;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_city;
@property (nonatomic, strong) UIPickerView *contry_pickerView;
@property (nonatomic, strong) UIPickerView *state_pickerView;




@property (nonatomic, weak) IBOutlet UIView *VW_contents;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll_contents;

@property (nonatomic, weak) IBOutlet UIButton *BTN_affiliateorcharity;
@property (nonatomic, weak) IBOutlet UIButton *BTN_sighnUP;

@property (nonatomic, weak) IBOutlet UIView *IMG_BG;
@property (nonatomic, weak) IBOutlet UIImageView *IMG_logo_WT;
@property (nonatomic, weak) IBOutlet UIView *vw_background;;

@end
