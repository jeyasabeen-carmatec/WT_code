//
//  VC_viewCourseonMAP.h
//  WinningTicket
//
//  Created by Test User on 05/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "data_SEGMENT.h"

@interface VC_viewCourseonMAP : UIViewController <GMSMapViewDelegate>

@property (nonatomic, assign) id<data_SEGMENT> segmentdelegate;
@property (nonatomic, retain) IBOutlet GMSMapView *mapView;

@property (strong) NSString *STR_parSTR;
@property (strong) NSString *STR_holeSTR;
@property (strong) NSString *STR_yards;

@property (nonatomic, retain) IBOutlet UIView *VW_navBAR;
@property (nonatomic,weak) IBOutlet UILabel *lbl_Nav_mainTitl;
@property (nonatomic,weak) IBOutlet UILabel *lbl_navTITLE;
@property (nonatomic,weak) IBOutlet UIButton *BTN_leaveGame;

@property (nonatomic, retain) IBOutlet UIView *VW_segment;
@property (nonatomic,weak) IBOutlet UIButton *BTN_viewonMAP;

@property (nonatomic, retain) IBOutlet UIView *VW_end_Game;
@property (nonatomic,weak) IBOutlet UIButton *BTN_End_game;
@property (nonatomic,weak) IBOutlet UIButton *BTN_continue_playing;

@property (nonatomic,weak) IBOutlet UILabel *lbl_yardsToHole;
@property (nonatomic,weak) IBOutlet UILabel *lbl_hole;
@property (nonatomic,weak) IBOutlet UILabel *lbl_par;
@property (nonatomic,weak) IBOutlet UILabel *lbl_yards;
@property (nonatomic,weak) IBOutlet UIView *VW_score;

@property (nonatomic,weak) IBOutlet UIButton *BTN_next;
@property (nonatomic,weak) IBOutlet UIButton *BTN_prev;

@end
