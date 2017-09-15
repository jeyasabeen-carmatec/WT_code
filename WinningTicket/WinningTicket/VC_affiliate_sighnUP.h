//
//  VC_affiliate_sighnUP.h
//  WinningTicket
//
//  Created by Test User on 17/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatingTXT_white.h"

@interface VC_affiliate_sighnUP : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *VW_contents;
@property (nonatomic, weak) IBOutlet UIScrollView *scroll_contents;

//@property (nonatomic, weak) IBOutlet UIButton *BTN_affiliateorcharity;

@property (nonatomic, weak) IBOutlet UIView *IMG_BG;
@property (nonatomic, weak) IBOutlet UIImageView *IMG_logo_WT;
@property(nonatomic,weak)IBOutlet UIView *VW_back;

@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_F_name;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_L_name;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_titl;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_email;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_phone_num;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_golfcoursename;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_addr1;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_addr2;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_city;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_state;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_zip;
@property (nonatomic, weak) IBOutlet FloatingTXT_white *TXT_country;

@property(nonatomic,weak)IBOutlet UIButton *BTN_sighnUP;
@property (nonatomic, strong) UIPickerView *contry_pickerView;
@property (nonatomic, strong) UIPickerView *state_pickerView;


@end
