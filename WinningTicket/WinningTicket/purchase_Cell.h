//
//  purchase_Cell.h
//  winning_ticket_purchaseTicket
//
//  Created by anumolu prakash on 12/04/17.
//  Copyright © 2017 carmatec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACFloatingTextField.h"

@interface purchase_Cell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *stat_lbl;
@property (nonatomic, retain) IBOutlet ACFloatingTextField *fname;
@property (nonatomic, retain) IBOutlet ACFloatingTextField *lname;
@property (nonatomic, retain) IBOutlet UIView *VW_contentcell;
@property (nonatomic, retain) IBOutlet ACFloatingTextField *email;



@end
