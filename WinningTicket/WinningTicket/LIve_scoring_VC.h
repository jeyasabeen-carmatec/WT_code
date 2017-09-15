//
//  LIve_scoring_VC.h
//  WinningTicket
//
//  Created by Test User on 04/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIve_scoring_VC : UIViewController
@property (nonatomic,weak) IBOutlet UIScrollView *scroll_content;
@property (nonatomic,weak) IBOutlet UIImageView *main_img;
@property (nonatomic,weak) IBOutlet UILabel *live_score_lbl;
@property (nonatomic,weak) IBOutlet UILabel *scorecard;
@property (nonatomic,weak) IBOutlet UIView *location_view;
@property (nonatomic,weak) IBOutlet UILabel *location_description;
@property (nonatomic,weak) IBOutlet UIButton *BTN_enable;
@property (nonatomic,weak) IBOutlet UIButton *BTN_not_now;
@property (nonatomic,weak) IBOutlet UIView *vw_line1;
@property (nonatomic,weak) IBOutlet UIView *vw_line2;
@property (nonatomic,weak) IBOutlet UILabel *event_name;
@property (nonatomic,weak) IBOutlet UILabel *event_location;
@property (nonatomic,weak) IBOutlet UIButton *live_score;
@property (nonatomic,weak) IBOutlet UIView *BG_vw;
@property (nonatomic,weak) IBOutlet UILabel *event_dtl_lbl;
@property (nonatomic,weak) IBOutlet UILabel *event_addr_lbl;

@end
