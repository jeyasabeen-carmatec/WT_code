//
//  purchase_Cell.m
//  winning_ticket_purchaseTicket
//
//  Created by anumolu prakash on 12/04/17.
//  Copyright © 2017 carmatec. All rights reserved.
//

#import "purchase_Cell.h"

@implementation purchase_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) dealloc
{
    [_fname release];
    [_lname release];
    [_email release];
    [_stat_lbl release];
    [_VW_contentcell release];
    
    [super dealloc];
}

@end
