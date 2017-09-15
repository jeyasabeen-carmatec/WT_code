//
//  VC_home.h
//  WinningTicket
//
//  Created by Test User on 27/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_home : UIViewController <UITabBarDelegate ,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UITabBar *tab_HOME;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_bottom;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_content;
@property (weak, nonatomic) IBOutlet UIView *VW_Scroll_CONTENT;

@property (weak, nonatomic) IBOutlet UITableView *tbl_upcomming_event;
@property (weak, nonatomic) IBOutlet UITableView *tbl_all_event;

@property (weak, nonatomic) IBOutlet UILabel *lbl_titleallevents;
@property (weak, nonatomic) IBOutlet UIView *VW_allevent_HEAD;

@property (weak, nonatomic) IBOutlet UILabel *lbl_upcoming_event;
@property (weak, nonatomic) IBOutlet UIView *VW_hold_BTN;
@property (weak, nonatomic) IBOutlet UIButton *BTN_view_all_event;
@property (weak, nonatomic) IBOutlet UILabel *lbl_titl_event_code;
@property (weak, nonatomic) IBOutlet UIView *VW_hold_code;
@property (weak, nonatomic) IBOutlet UIButton *BTN_cancel;
@property (weak, nonatomic) IBOutlet UIButton *BTN_enter_event_code;

@property (weak, nonatomic) IBOutlet UITextField *TXT_0;
@property (weak, nonatomic) IBOutlet UITextField *TXT_1;
@property (weak, nonatomic) IBOutlet UITextField *TXT_2;
@property (weak, nonatomic) IBOutlet UITextField *TXT_3;
@property (weak, nonatomic) IBOutlet UITextField *TXT_4;
@property (weak, nonatomic) IBOutlet UITextField *TXT_5;

@property (weak, nonatomic) IBOutlet UIButton *BTN_all_event;

@property (weak, nonatomic) IBOutlet UIView *VW_IMG_BG;
@property (weak, nonatomic) IBOutlet UIImageView *IMG_logo_WT;

@end
