//
//  CELL_leader.h
//  WinningTicket
//
//  Created by Test User on 09/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CELL_leader : UITableViewCell

//@property (nonatomic,weak) IBOutlet UILabel *lbl_leader;

#pragma mark - Titles
@property (nonatomic,weak) IBOutlet UILabel *lbl_title_OUT;
@property (nonatomic,weak) IBOutlet UILabel *lbl_title_IN;

#pragma mark - Menu Items
@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_hole1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_par1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_score1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_net1;

@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_hole2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_par2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_score2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_subTITL_net2;

#pragma mark - Results
@property (nonatomic,weak) IBOutlet UILabel *lbl_result_PAR;
@property (nonatomic,weak) IBOutlet UILabel *lbl_result_score;
@property (nonatomic,weak) IBOutlet UILabel *lbl_result_hcp;
@property (nonatomic,weak) IBOutlet UILabel *lbl_result_position;

#pragma mark - Horizontal Seperater
@property (nonatomic,weak) IBOutlet UIView *VW_hor1;
@property (nonatomic,weak) IBOutlet UIView *VW_hor2;
@property (nonatomic,weak) IBOutlet UIView *VW_hor3;
@property (nonatomic,weak) IBOutlet UIView *VW_hor4;
@property (nonatomic,weak) IBOutlet UIView *VW_hor5;
@property (nonatomic,weak) IBOutlet UIView *VW_hor6;
@property (nonatomic,weak) IBOutlet UIView *VW_hor7;
@property (nonatomic,weak) IBOutlet UIView *VW_hor8;

#pragma mark - Vertical Seperater
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_M1;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_M2;

@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_1;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_2;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_3;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_4;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_5;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_6;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_7;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_1_8;

@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_1;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_2;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_3;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_4;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_5;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_6;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_7;
@property (nonatomic,weak) IBOutlet UIView *VW_vertical_S_2_8;

#pragma mark - HeadingHoles
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_3;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_4;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_5;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_6;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_7;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_8;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_9;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_10;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_11;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_12;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_13;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_14;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_15;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_16;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_17;
@property (nonatomic,weak) IBOutlet UILabel *lbl_position_18;

#pragma mark - Label Par values 1
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_3;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_4;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_5;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_6;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_7;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_8;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par1_9;
@property (nonatomic,weak) IBOutlet UILabel *lbl_tot_par1;

#pragma mark - Lbl Score values 1
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_3;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_4;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_5;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_6;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_7;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_8;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score1_9;
@property (nonatomic,weak) IBOutlet UILabel *lbl_tot_score1;

#pragma mark - Lbl Net Score values 1
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_3;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_4;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_5;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_6;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_7;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_8;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore1_9;
@property (nonatomic,weak) IBOutlet UILabel *lbl_tot_Netscore1;

#pragma mark - Label Par values 2
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_3;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_4;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_5;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_6;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_7;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_8;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par2_9;
@property (nonatomic,weak) IBOutlet UILabel *lbl_tot_par2;

#pragma mark - Lbl Score values 2
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_3;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_4;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_5;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_6;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_7;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_8;
@property (nonatomic,weak) IBOutlet UILabel *lbl_score2_9;
@property (nonatomic,weak) IBOutlet UILabel *lbl_tot_score2;

#pragma mark - Lbl Net Score values 2
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_1;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_2;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_3;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_4;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_5;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_6;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_7;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_8;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Netscore2_9;
@property (nonatomic,weak) IBOutlet UILabel *lbl_tot_Netscore2;

@end
