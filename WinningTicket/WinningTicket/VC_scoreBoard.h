//
//  VC_scoreBoard.h
//  WinningTicket
//
//  Created by Test User on 20/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_scoreBoard : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIView *VW_navBAR;
@property (nonatomic,weak) IBOutlet UILabel *lbl_navTITLE;
@property (nonatomic,weak) IBOutlet UIButton *BTN_leaveGame;

@property (nonatomic, retain) IBOutlet UIView *VW_segment;
@property (nonatomic,weak) IBOutlet UIButton *BTN_viewonMAP;

@property (nonatomic, retain) IBOutlet UITableView *TBL_scores;

@end
