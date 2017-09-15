//
//  referal_cell.h
//  winning_ticket_AddReferals
//
//  Created by anumolu prakash on 18/04/17.
//  Copyright © 2017 carmatec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface referal_cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *description_lbl;
@property (weak, nonatomic) IBOutlet UILabel *date_time_lbl;
@property (weak, nonatomic) IBOutlet UIButton *BTN_referalDETAIL;

@end
