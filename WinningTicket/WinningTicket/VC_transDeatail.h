//
//  VC_transDeatail.h
//  WinningTicket
//
//  Created by Test User on 02/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_transDeatail : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *lbl_trans_TKT;
@property (retain, nonatomic) IBOutlet UIView *VW_hold_lbl;

@property (retain, nonatomic) IBOutlet UILabel *lbl_transtype;

@property (retain, nonatomic) IBOutlet UIScrollView *scroll_contents;
@property (retain, nonatomic) IBOutlet UIView *VW_contents;

@property (retain, nonatomic) IBOutlet UILabel *lbl_time;
@property (retain, nonatomic) IBOutlet UILabel *lbl_ticketDetail;

@end
