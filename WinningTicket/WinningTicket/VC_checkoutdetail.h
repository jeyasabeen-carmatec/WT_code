//
//  VC_checkoutdetail.h
//  WinningTicket
//
//  Created by Test User on 28/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_checkoutdetail : UIViewController

@property (weak, nonatomic) IBOutlet UIView *VW_contents;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_contents;

@property (weak, nonatomic) IBOutlet UILabel *lbl_email;
@property (weak, nonatomic) IBOutlet UILabel *lbl_address;
//@property (weak, nonatomic) IBOutlet UILabel *lbl_titlepaymentInfo;
//@property (weak, nonatomic) IBOutlet UILabel *lbl_paymentInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ticketDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_titleSubtotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_datasubtotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_titletotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_datatotal;
@property (nonatomic, retain) IBOutlet UIButton *BTN_back;

//@property (weak, nonatomic) IBOutlet UIButton *BTN_order1;
@property (weak, nonatomic) IBOutlet UIButton *BTN_order2;

@property (weak, nonatomic) IBOutlet UILabel *lbl_norms;

@property (weak, nonatomic) IBOutlet UIView *VW_line1;
@property (weak, nonatomic) IBOutlet UIView *VW_line2;
@property (weak, nonatomic) IBOutlet UIView *VW_line3;

@property (weak, nonatomic) IBOutlet UIImageView *img_icon;

@property (weak, nonatomic) IBOutlet UILabel *lbl_titl_payment_info;
@property (weak, nonatomic) IBOutlet UILabel *lbl_data_payment_info;

//New code
@property (weak, nonatomic) IBOutlet UIView *VW_line4;
@property (weak, nonatomic) IBOutlet UIView *VW_line5;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title_discount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_data_discount;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title_wallet;
@property (weak, nonatomic) IBOutlet UILabel *lbl_data_wallet;

@property (weak, nonatomic) IBOutlet UILabel *lbl_nav_font;


@end

