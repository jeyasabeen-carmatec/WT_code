//
//  cell_player.h
//  WinningTicket
//
//  Created by Test User on 06/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cell_player : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *lbl_Position;
@property (nonatomic,weak) IBOutlet UILabel *lbl_playerNAme;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Score;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Topar;

@end
