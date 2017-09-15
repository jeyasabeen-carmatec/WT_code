//
//  bidding_Cell.h
//  winning_ticket_BiddingHistory
//
//  Created by anumolu prakash on 22/04/17.
//  Copyright © 2017 carmatec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bidding_Cell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *AC_no;
@property(nonatomic,weak)IBOutlet UILabel *date;
@property(nonatomic,weak)IBOutlet UILabel *amount;
@end
