//
//  edit_referal_Cell.m
//  winning_ticket_AddReferals
//
//  Created by anumolu prakash on 19/04/17.
//  Copyright © 2017 carmatec. All rights reserved.
//

#import "edit_referal_Cell.h"

@implementation edit_referal_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.description_lbl.frame=CGRectMake(8, 3, self.description_lbl.frame.size.width, self.description_lbl.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
