//
//  VC_all_events.h
//  WinningTicket
//
//  Created by Test User on 22/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_all_events : UIViewController <UITabBarDelegate,UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

//@property (weak, nonatomic) IBOutlet UITabBar *tab_HOME;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_bottom;

@property (weak, nonatomic) IBOutlet UISearchBar *search_BAR;
@property (weak, nonatomic) IBOutlet UIView *VW_nav_TOP;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Serch_char;
@property (weak, nonatomic) IBOutlet UIView *VW_line;

@property (weak, nonatomic) IBOutlet UIView *VW_filter;
@property (weak, nonatomic) IBOutlet UIView *VW_event_titl;
@property (weak, nonatomic) IBOutlet UITableView *tbl_eventlst;

@property (weak, nonatomic) IBOutlet UITextField *TXT_state;
@property (weak, nonatomic) IBOutlet UITextField *TXT_fromdate;
@property (weak, nonatomic) IBOutlet UITextField *TXT_todate;

@property (nonatomic, strong) UIDatePicker *picker_fromdate;
@property (nonatomic, strong) UIDatePicker *picker_todate;

@property (nonatomic, strong) UIPickerView *state_pickerView;

//@property (weak, nonatomic) IBOutlet UITableView *tbl_search;
@property (weak, nonatomic) IBOutlet UIButton *apply;


@end
