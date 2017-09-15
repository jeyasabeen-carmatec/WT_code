//
//  auction_CellTableViewCell.h
//  winningTicket_LiveAuction
//
//  Created by anumolu prakash on 11/04/17.
//  Copyright © 2017 carmatec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface auction_CellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_display;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *currency_lbl;
@property (weak, nonatomic) IBOutlet UILabel *bid_Lbl;

@end
