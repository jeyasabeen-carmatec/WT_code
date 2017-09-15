//
//  VC_qty_detail.h
//  WinningTicket
//
//  Created by Test User on 19/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_qty_detail : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tbl_content;
@property (nonatomic, retain) IBOutlet UIButton *BTN_checkout;

@property (nonatomic, retain) IBOutlet UIScrollView *scroll_TBL;

@property (nonatomic, retain) IBOutlet UIView *VW_main;
@property (nonatomic, retain) IBOutlet UILabel *lbl_name_ticket;
@property (nonatomic, retain) IBOutlet UILabel *lbl_qty;
@property (nonatomic, retain) IBOutlet UILabel *lbl_des_cription;
@property (nonatomic, retain) IBOutlet UILabel *lbl_amount_des;
@property (nonatomic, retain) IBOutlet UILabel *lbl_sub_total;
@property (nonatomic, retain) IBOutlet UILabel *lbl_sub_amount;
@property (nonatomic, retain) IBOutlet UILabel *lbl_total;
@property (nonatomic, retain) IBOutlet UILabel *lbl_total_amount;
@property (nonatomic, retain) IBOutlet UIView *VW_line1;
@property (nonatomic, retain) IBOutlet UIView *VW_line2;

@end
