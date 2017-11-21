//
//  VC_scoreBoard.h
//  WinningTicket
//
//  Created by Test User on 20/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Update_Score.h"
#import "KSJActionSocket.h"

@interface VC_scoreBoard : UIViewController <UITableViewDelegate, UITableViewDataSource,Update_Score>

@property (nonatomic, retain) IBOutlet UIView *VW_navBAR;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Nav_mainTitl;
@property (nonatomic,weak) IBOutlet UILabel *lbl_navTITLE;
@property (nonatomic,weak) IBOutlet UIButton *BTN_leaveGame;

@property (nonatomic, retain) IBOutlet UIView *VW_segment;
@property (nonatomic,weak) IBOutlet UIButton *BTN_viewonMAP;

@property (nonatomic, retain) IBOutlet UITableView *TBL_scores;
@property (nonatomic, retain) IBOutlet UITableView *TBL_leaderboard;

@property (nonatomic, retain) IBOutlet UIView *VW_selectHANDICAP;
@property (nonatomic,weak) IBOutlet UIButton *BTN_PLUS;
@property (nonatomic,weak) IBOutlet UIButton *BTN_MInus;
@property (nonatomic,weak) IBOutlet UITextField *TXT_Handicap;
@property (nonatomic,weak) IBOutlet UILabel *lbl_HandicapDesc;
@property (nonatomic,weak) IBOutlet UIButton *BTN_ContinueHandicap;

@end
