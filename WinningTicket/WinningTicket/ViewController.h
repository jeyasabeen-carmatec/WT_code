//
//  ViewController.h
//  WinningTicket
//
//  Created by Test User on 22/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>

//View's Used
@property (nonatomic, weak) IBOutlet UIView *VW_holdCNT;
@property (nonatomic, weak) IBOutlet UIView *VW_content;

@property (nonatomic, weak) IBOutlet UITextField *TXT_username;
@property (nonatomic, weak) IBOutlet UITextField *TXT_password;

//Buttons Used
@property (nonatomic, weak) IBOutlet UIButton *BTN_login;
@property (nonatomic, weak) IBOutlet UIButton *BTN_signup;
@property (nonatomic, weak) IBOutlet UIButton *BTN_forget_PWD;

@property (nonatomic, weak) IBOutlet UISwitch *SWITCH_rememberme;

@property(nonatomic, strong)UIAlertAction *submit_action;

@end

