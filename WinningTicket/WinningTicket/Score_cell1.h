//
//  Score_cell1.h
//  WinningTicket
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Score_cell1 : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *lbl_playerName;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score;

@property (nonatomic,weak) IBOutlet UILabel *lbl_hole;
@property (nonatomic,weak) IBOutlet UILabel *lbl_distance;
@property (nonatomic,weak) IBOutlet UILabel *lbl_gross_score;
@property (nonatomic,weak) IBOutlet UILabel *lbl_net_score;
@property (nonatomic,weak) IBOutlet UILabel *lbl_handicap;

@end
