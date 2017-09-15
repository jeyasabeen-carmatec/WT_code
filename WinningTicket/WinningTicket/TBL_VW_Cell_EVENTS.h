//
//  TBL_VW_Cell_EVENTS.h
//  WinningTicket
//
//  Created by Test User on 15/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBL_VW_Cell_EVENTS : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_event_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_event_time;

@property (weak, nonatomic) IBOutlet UIButton *BTN_View_detail;

@end
