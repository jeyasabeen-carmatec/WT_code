//
//  VC_edit_referal_update.h
//  WinningTicket
//
//  Created by Test User on 10/06/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface VC_edit_referal_update : UIViewController
@property(nonatomic,weak)IBOutlet UIView *VW_content;

@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_referal_name;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_referal_phone;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_referal_email;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *TXT_referal_role;
- (IBAction)cancelBTN:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *BTN_addRefeerel;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@end
