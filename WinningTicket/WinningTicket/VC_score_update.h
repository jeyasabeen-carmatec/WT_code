//
//  VC_score_update.h
//  WinningTicket
//
//  Created by Test User on 16/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Update_Score.h"


@interface VC_score_update : UIViewController

@property (nonatomic, assign) id<Update_Score> delegate;

@property (nonatomic,weak) IBOutlet UICollectionView *num_vw;
@property (nonatomic,weak) IBOutlet UIView *name_vw,*vw_nav;
@property (nonatomic,weak) IBOutlet UILabel *LBL_gross;
@property (nonatomic,weak) IBOutlet UILabel *LBL_Heading;

@property (nonatomic,weak) IBOutlet UILabel *LBL_player_name;

@property (strong) NSString *STR_parSTR;
@property (strong) NSString *STR_holeSTR;
@property (strong) NSString *STR_playernameSTR;

@end
