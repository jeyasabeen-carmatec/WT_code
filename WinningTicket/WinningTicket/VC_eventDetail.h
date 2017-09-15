//
//  VC_eventDetail.h
//  WinningTicket
//
//  Created by Test User on 27/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_eventDetail : UIViewController <UITabBarDelegate>

//@property (weak, nonatomic) IBOutlet UITabBar *tab_HOME;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_bottom;

@property (weak, nonatomic) IBOutlet UIImageView *img_event;
@property (weak, nonatomic) IBOutlet UILabel *lbl_eventname;
@property (weak, nonatomic) IBOutlet UIView *VW_dateandtime;
@property (weak, nonatomic) IBOutlet UIImageView *img_cstmlbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl_code;
@property (weak, nonatomic) IBOutlet UILabel *lbl_location;
@property (weak, nonatomic) IBOutlet UILabel *lbl_eventdetail;
@property(nonatomic,weak) IBOutlet UILabel *lbl_date;
@property(nonatomic,weak) IBOutlet UILabel *lbl_time;

@property (weak, nonatomic) IBOutlet UIView *VW_eventcontent;

@property (weak, nonatomic) IBOutlet UILabel *lbl_ticketdescription;
@property (weak, nonatomic) IBOutlet UIButton *BTN_purchasetkt;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_contents;

@end
