//
//  CELL_virtualBAG.h
//  WinningTicket
//
//  Created by Test User on 22/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CELL_virtualBAG : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_offername;
@property (weak, nonatomic) IBOutlet UILabel *lbl_status;

@property (weak, nonatomic) IBOutlet UIButton *BTN_viewOffer;
@property (weak, nonatomic) IBOutlet UIImageView *IMG_giftIcon;

@end
