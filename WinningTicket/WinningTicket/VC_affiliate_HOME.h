//
//  VC_affiliate_HOME.h
//  WinningTicket
//
//  Created by Test User on 19/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "referal_cell.h"

@interface VC_affiliate_HOME : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(nonatomic,weak)IBOutlet UILabel *lbl_header;
@property(nonatomic,weak)IBOutlet UISearchBar *search_bar;
@property(nonatomic,weak)IBOutlet UITableView *tbl_referal;
//@property(nonatomic,weak)IBOutlet UIView *VW_content;
//@property(nonatomic,weak)IBOutlet UIView *VW_titl_contents;
@property(nonatomic,weak) IBOutlet UIButton *BTN_edit;
@property(nonatomic,weak) IBOutlet UIButton *BTN_filter;
@property(nonatomic,weak) IBOutlet UIButton *BTN_new_refral;
@property(nonatomic,weak) IBOutlet UIView *VW_title;
@property(nonatomic,weak) IBOutlet UIView *navigation_titlebar;
@property(nonatomic,weak) IBOutlet UILabel *title_lbl;
@property(nonatomic,weak) IBOutlet UIView *vw_LINE;

@property(nonatomic,weak) IBOutlet UIButton *BTN_logOUT;

@property(nonatomic,weak) IBOutlet UIView *VW_hldBTN;

@end
