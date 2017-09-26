//
//  ScoreCell2.h
//  WinningTicket
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCell2 : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *lbl_hole;
@property (nonatomic,weak) IBOutlet UILabel *lbl_distance;
@property (nonatomic,weak) IBOutlet UILabel *lbl_gross_score;
@property (nonatomic,weak) IBOutlet UIView *VW_grossScore;
@property (nonatomic,weak) IBOutlet UILabel *lbl_net_score;
@property (nonatomic,weak) IBOutlet UILabel *lbl_handicap;

@end
