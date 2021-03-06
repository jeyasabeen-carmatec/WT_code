//
//  Ppurchase_Controller.h
//  winning_ticket_purchaseTicket
//
//  Created by anumolu prakash on 12/04/17.
//  Copyright © 2017 carmatec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ppurchase_Controller : UIViewController
@property(nonatomic,weak)IBOutlet UILabel *name_ticket;
@property(nonatomic,weak)IBOutlet UILabel *qty;
@property(nonatomic,weak)IBOutlet UILabel *des_cription;
//@property(nonatomic,weak)IBOutlet UILabel *amount_des;
@property(nonatomic,weak)IBOutlet UILabel *sub_total;
@property(nonatomic,weak)IBOutlet UILabel *sub_amount;
@property(nonatomic,weak)IBOutlet UILabel *total;
@property(nonatomic,weak)IBOutlet UILabel *total_amount;
@property(nonatomic,weak)IBOutlet UIView *pur_view;
@property (weak, nonatomic) IBOutlet UILabel *status_Label;
@property (weak, nonatomic) IBOutlet UILabel *confirm_mail;
@property (weak, nonatomic) IBOutlet UILabel *order;
@property (weak, nonatomic) IBOutlet UILabel *order_summary;
@property(nonatomic,weak)IBOutlet UIView *start_View;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
//@property(nonatomic,weak)IBOutlet UIView *content_view;
//@property (weak, nonatomic) IBOutlet UILabel *descripton_status;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (nonatomic, retain) IBOutlet UIButton *BTN_back;


@property (weak, nonatomic) IBOutlet UIView *sec_vw;
@property (strong, nonatomic) IBOutlet UIView *first_VW;
@property (nonatomic,weak) IBOutlet UIButton *_BTN_Ok;


@property (weak, nonatomic) IBOutlet UIView *VW_head;

@property(nonatomic,weak)IBOutlet UILabel *lbl_nav_font;

@property (weak, nonatomic) IBOutlet UIView *VW_line4;
@property (weak, nonatomic) IBOutlet UIView *VW_line5;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title_discount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_data_discount;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title_wallet;
@property (weak, nonatomic) IBOutlet UILabel *lbl_data_wallet;


@end

