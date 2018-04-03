//
//  VC_scoreBoard.m
//  WinningTicket
//
//  Created by Test User on 20/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_scoreBoard.h"
#import "Score_cell1.h"
#import "ScoreCell2.h"
#import "CEL_titl_leader.h"
#import "cell_player.h"
#import "CELL_leader.h"

#import "HMSegmentedControl.h"
#import "DICTIN_holes.h"
#import "VC_score_update.h"
#import "VC_viewCourseonMAP.h"
#import <AVFoundation/AVFoundation.h>

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface VC_scoreBoard ()<UIAlertViewDelegate, KSJActionSocketDelegate>
{
    NSMutableArray *ARR_holes;
    NSString *STR_update_handicap;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSArray *ARR_displayScore;
    
    NSString *STR_psition;
    
    NSIndexPath *INdex_Selected,*INDX_STR,*INDX_expanded;
//    NSMutableArray *ARR_netScore;
//    NSMutableArray *ARR_grossScore;
    NSMutableArray *ARR_color;
    
    NSMutableDictionary *DICTIN_PlayerINfo;
    
    NSMutableArray *ARR_leaders;
    
    NSMutableDictionary *dictin_Scores;
}

@property (nonatomic) KSJActionSocket *actionSocket;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) NSIndexPath *expandingIndexPath;
@property (nonatomic) NSIndexPath *expandedIndexPath;

- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)indexPath;
- (void)createDataSourceArray;

@end

@implementation VC_scoreBoard


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [ARR_grossScore Clear_ARR];
    
    /*Code to add Player list*/
    
    _VW_end_Game.hidden = YES;
    
    NSString *STR_url = [NSString stringWithFormat:@"ws://%@",ACTION_CABLE];
    self.actionSocket = [KSJActionSocket socketWithURL:[NSURL URLWithString:STR_url]];
    [self.actionSocket open];
    self.actionSocket.delegate = self;
    
    
    NSString *text_STR;
    double VAL_STR = [[[NSUserDefaults standardUserDefaults] valueForKey:@"handicap1"] doubleValue];
    
    if (VAL_STR == 0) {
        text_STR = [NSString stringWithFormat:@"There will be no effect on your gross score."];
    }
    else if (VAL_STR < 0) {
        text_STR = [NSString stringWithFormat:@"You will have a stroke taken off your gross score for each of the %.f hardest holes on the course.",(0 - VAL_STR)];
    }
    else
    {
        text_STR = [NSString stringWithFormat:@"You will have a stroke added for each of the %.f easiest holes on the course.",VAL_STR];
    }
    
    
    
    UIFont *font = _lbl_HandicapDesc.font;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 14.5f;
    paragraphStyle.maximumLineHeight = 14.5f;
    paragraphStyle.alignment = NSTextAlignmentCenter; 
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text_STR attributes:attributes];
    _lbl_HandicapDesc.attributedText = attributedText;
    
    [self createDataSourceArray];
    
    _TBL_leaderboard.hidden = YES;
    [self setup_View];
    [self addSEgmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Setup View
-(void) setup_View
{
    //    NSString *STR_title = @"VIEW\nCOURSE\nMAP";
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:STR_title];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineSpacing = 2.0;
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [STR_title length])];
    

    CGRect frame_BTN = _BTN_viewonMAP.frame;
    frame_BTN.size.width = (_TBL_scores.frame.size.width / 5) + 20;
    frame_BTN.size.height = (_TBL_scores.frame.size.width / 5) + 20;
    _BTN_viewonMAP.frame = frame_BTN;
    
    UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame_BTN.size.width, frame_BTN.size.height)];
    lbl_title.numberOfLines = 3;
    lbl_title.textAlignment = NSTextAlignmentCenter;
    lbl_title.font = [UIFont fontWithName:@"GothamMedium" size:13.0];
    lbl_title.text = @"VIEW\nCOURSE\nMAP";
    
    //    _BTN_viewonMAP.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    _BTN_viewonMAP.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _BTN_viewonMAP.titleLabel.text = STR_title;
    [_BTN_viewonMAP addSubview:lbl_title];
    
    _BTN_viewonMAP.layer.shadowColor = [UIColor blackColor].CGColor;
    _BTN_viewonMAP.layer.shadowOffset = CGSizeMake(0, 5.0f);
    _BTN_viewonMAP.layer.shadowRadius = 6.0f;
    _BTN_viewonMAP.layer.shadowOpacity = 0.5f;
    _BTN_viewonMAP.layer.cornerRadius = _BTN_viewonMAP.frame.size.width / 2;
    _BTN_viewonMAP.layer.masksToBounds = NO;
    _BTN_viewonMAP.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_BTN_viewonMAP.bounds cornerRadius:_BTN_viewonMAP.layer.cornerRadius].CGPath;
    
    [_BTN_viewonMAP addTarget:self action:@selector(ACTN_viewONMAP) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_leaveGame addTarget:self action:@selector(ACTN_leaveGame) forControlEvents:UIControlEventTouchUpInside];
    
    _lbl_navTITLE.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_name"];
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = NO;
    
    [VW_overlay addSubview:_VW_selectHANDICAP];
    
    NSString *STR_handicap = [[NSUserDefaults standardUserDefaults] valueForKey:@"handicap1"];
    if ([STR_handicap isEqualToString:@""] || [STR_handicap isEqualToString:@" "]) {
        STR_handicap = @"0";
    }
    _TXT_Handicap.text = STR_handicap;
    
    _TXT_Handicap.layer.borderWidth = 2.0f;
    _TXT_Handicap.layer.borderColor = [UIColor blackColor].CGColor;
    
    _VW_selectHANDICAP.center = self.view.center;
    _VW_selectHANDICAP.layer.cornerRadius = 5.0f;
    _VW_selectHANDICAP.layer.masksToBounds = YES;
    
    _BTN_PLUS.layer.cornerRadius = _BTN_PLUS.frame.size.width / 2;
    _BTN_PLUS.layer.masksToBounds = YES;
    [_BTN_PLUS addTarget:self action:@selector(ACTN_btnPLUS) forControlEvents:UIControlEventTouchUpInside];
    
    _BTN_MInus.layer.cornerRadius = _BTN_MInus.frame.size.width / 2;
    _BTN_MInus.layer.masksToBounds = YES;
    [_BTN_MInus addTarget:self action:@selector(ACTN_btnMiNUS) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_ContinueHandicap addTarget:self action:@selector(ACTN_continueHandicap) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - add Custom Segmentcontrol
-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    self.segmentedControl4.sectionTitles = @[@"SCOREBOARD  \t",@"  \tLEADERBOARD"];
    
    UIFont *font_name = [UIFont fontWithName:@"GothamBold" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 0.50 * font_name.lineHeight;
    self.segmentedControl4.backgroundColor = [UIColor blackColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:font_name};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : self.view.tintColor,NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:font_name};
    self.segmentedControl4.selectionIndicatorColor = self.view.tintColor;
    //    self.segmentedControl4.selectionIndicatorColor
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.selectionIndicatorHeight = 7.0f;
    
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl4];
    _BTN_viewonMAP.center = _VW_segment.center;
    
    CGRect rect_BTN = _BTN_viewonMAP.frame;
    rect_BTN.origin.y = _BTN_viewonMAP.frame.origin.y - 10;
    _BTN_viewonMAP.frame = rect_BTN;
    
    [self.view addSubview:_BTN_viewonMAP];
    
    self.segmentedControl4.userInteractionEnabled = NO;
    _BTN_viewonMAP.userInteractionEnabled = NO;
}
#pragma mark - Segment Button IBACTION
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged) aaa", (long)segmentedControl4.selectedSegmentIndex);
    switch (segmentedControl4.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"Index 0");

            NSString *STR_nav_title = @"Your Scorecard";
            _lbl_Nav_mainTitl.text = [STR_nav_title uppercaseString];
            _TBL_leaderboard.hidden = YES;
            _TBL_scores.hidden = NO;
        }
            break;
            
        case 1:
        {
            
//            if (VW_overlay.hidden == NO) {
//                NSLog(@"Index 1");
            
            self.expandingIndexPath = nil;
            self.expandedIndexPath = nil;
            
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(Leaders_API) withObject:activityIndicatorView afterDelay:0.01];
            
             NSString *STR_nav_title = @"Live Leaderboard";
                _lbl_Nav_mainTitl.text = [STR_nav_title uppercaseString];
                _TBL_scores.hidden = YES;
                _TBL_leaderboard.hidden = NO;
//            }
//            else
//            {
//                _segmentedControl4.selectedSegmentIndex = 0;
//            }
        }
            break;
            
        case 2:
            NSLog(@"Index 2");
            break;
            
        default:
            break;
    }
}

#pragma mark - UIButton Actions
-(void) ACTN_leaveGame
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Leave Game" message:@"Are you sure to leave the game" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",@"Cancel", nil];
//    alert.tag = 1;
//    [alert show];
    
    self.segmentedControl4.userInteractionEnabled = NO;
    _BTN_viewonMAP.userInteractionEnabled = NO;

    _VW_end_Game.center = self.view.center;
    _VW_end_Game.layer.cornerRadius = 5.0f;
    _VW_end_Game.layer.masksToBounds = YES;
    
    VW_overlay.hidden= NO;
    _VW_end_Game.hidden = NO;
    [VW_overlay addSubview:_VW_end_Game];
    
    [_BTN_End_game addTarget:self action:@selector(ACT_leave_game) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_continue_playing addTarget:self action:@selector(ACT_continue_playing) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) ACT_leave_game
{
    NSLog(@"Action leave game tapped");
    _VW_end_Game.hidden = YES;
    VW_overlay.hidden = YES;
    
    self.segmentedControl4.userInteractionEnabled = YES;
    _BTN_viewonMAP.userInteractionEnabled = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) ACT_continue_playing
{
    self.segmentedControl4.userInteractionEnabled = YES;
    _BTN_viewonMAP.userInteractionEnabled = YES;
    
    _VW_end_Game.hidden = YES;
    VW_overlay.hidden = YES;
}
-(void) ACTN_viewONMAP
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(load_map_VC) withObject:activityIndicatorView afterDelay:0.01];
}
-(void) load_map_VC
{
    [self performSegueWithIdentifier:@"scorebordtomapIdentifier" sender:self];
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;

}

-(void) ACTN_btnPLUS
{
    NSLog(@"Btn Plus tapped");
    
    double VAL_STR = [_TXT_Handicap.text doubleValue];
    if (VAL_STR != 36) {
        VAL_STR = VAL_STR + 1;
        _TXT_Handicap.text = [NSString stringWithFormat:@"%.0f",VAL_STR];
        
        NSString *text_STR;
        
        
        
        if (VAL_STR == 0) {
            text_STR = [NSString stringWithFormat:@"There will be no effect on your gross score."];
        }
        else if (VAL_STR < 0) {
            text_STR = [NSString stringWithFormat:@"You will have a stroke taken off your gross score for each of the %.f hardest holes on the course.",(0 - VAL_STR)];
        }
        else
        {
            text_STR = [NSString stringWithFormat:@"You will have a stroke added for each of the %.f easiest holes on the course.",VAL_STR];
        }
        
        UIFont *font = _lbl_HandicapDesc.font;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 14.5f;
        paragraphStyle.maximumLineHeight = 14.5f;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text_STR attributes:attributes];
        _lbl_HandicapDesc.attributedText = attributedText;
        
    }
    
}
-(void) ACTN_btnMiNUS
{
    NSLog(@"Btn Minus tapped");
    
    double VAL_STR = [_TXT_Handicap.text doubleValue];
    
    if (VAL_STR != -36) {
        VAL_STR = VAL_STR - 1;
        _TXT_Handicap.text = [NSString stringWithFormat:@"%.0f",VAL_STR];
        
        NSString *text_STR;

        
        if (VAL_STR == 0) {
            text_STR = [NSString stringWithFormat:@"There will be no effect on your gross score."];
        }
        else if (VAL_STR < 0) {
            text_STR = [NSString stringWithFormat:@"You will have a stroke taken off your gross score for each of the %.f hardest holes on the course.",(0 - VAL_STR)];
        }
        else
        {
            text_STR = [NSString stringWithFormat:@"You will have a stroke added for each of the %.f easiest holes on the course.",VAL_STR];
        }
        
        UIFont *font = _lbl_HandicapDesc.font;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 14.5f;
        paragraphStyle.maximumLineHeight = 14.5f;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text_STR attributes:attributes];
        _lbl_HandicapDesc.attributedText = attributedText;
    }
    
}
-(void) ACTN_continueHandicap
{
    self.segmentedControl4.userInteractionEnabled = YES;
    _BTN_viewonMAP.userInteractionEnabled = YES;
    NSLog(@"Btn handicap continue tapped");
    _VW_selectHANDICAP.hidden = YES;
    VW_overlay.hidden = NO;
    
    //    [self UPDATE_handicap];
    
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(UPDATE_handicap) withObject:activityIndicatorView afterDelay:0.01];
}

#pragma mark - Tableview Datasource/Deligate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _TBL_leaderboard)
    {
        //return 1;//Leaderboard value
        if (self.expandedIndexPath) {
            return [ARR_leaders count] + 2;
        }
        
        return [ARR_leaders count] + 1;
    }
    return [ARR_holes count] + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _TBL_leaderboard)
    {
        if (indexPath.row == 0) {
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            CEL_titl_leader *cell = (CEL_titl_leader *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"CEL_titl_leader~iPad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"CEL_titl_leader" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            float width_titles;
            if ([indexPath isEqual:self.expandedIndexPath]) {
                static NSString *simpleTableIdentifier = @"ExpandedCellIdentifier";
                CELL_leader *cell = (CELL_leader *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (cell == nil)
                {
                    NSArray *nib;
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        width_titles = 228;
                        nib = [[NSBundle mainBundle] loadNibNamed:@"CELL_leader~iPad" owner:self options:nil];
                    }
                    else
                    {
                        width_titles = 114;
                        nib = [[NSBundle mainBundle] loadNibNamed:@"CELL_leader" owner:self options:nil];
                    }
                    cell = [nib objectAtIndex:0];
                }
                
//                cell.lbl_leader.text = [NSString stringWithFormat:@"Leader at index %ld",indexPath.row -2];
                float FR_width = (_TBL_leaderboard.frame.size.width - width_titles) / 9;
                float FR_height = (FR_width * 8) + 34;
                float FR_originalHT = (FR_height - 35) / 8;
                
                //This is VW
                CGRect rectVW = cell.VW_hor1.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT;
//                rectVW.size.width = width_titles /2;
                cell.VW_hor1.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_hole1.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = 1;
                rectVW.size.height = FR_originalHT - 1;
                rectVW.size.width = (width_titles/2);
                cell.lbl_subTITL_hole1.frame = rectVW;
                
                //This is vertical VW main
                rectVW = cell.VW_vertical_M1.frame;
                rectVW.origin.x = cell.lbl_subTITL_hole1.frame.origin.x + cell.lbl_subTITL_hole1.frame.size.width;
                rectVW.origin.y = 5;
                rectVW.size.height = (FR_width * 8) - 5;
                cell.VW_vertical_M1.frame = rectVW;
                
                //This is hole position 1
                rectVW = cell.lbl_position_1.frame;
                rectVW.origin.x = cell.lbl_subTITL_hole1.frame.origin.x + cell.lbl_subTITL_hole1.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_1.frame = rectVW;
                
                rectVW = cell.lbl_position_2.frame;
                rectVW.origin.x = cell.lbl_position_1.frame.origin.x + cell.lbl_position_1.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_2.frame = rectVW;
                
                rectVW = cell.lbl_position_3.frame;
                rectVW.origin.x = cell.lbl_position_2.frame.origin.x + cell.lbl_position_2.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_3.frame = rectVW;
                
                rectVW = cell.lbl_position_4.frame;
                rectVW.origin.x = cell.lbl_position_3.frame.origin.x + cell.lbl_position_3.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_4.frame = rectVW;
                
                rectVW = cell.lbl_position_5.frame;
                rectVW.origin.x = cell.lbl_position_4.frame.origin.x + cell.lbl_position_4.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_5.frame = rectVW;
                
                rectVW = cell.lbl_position_6.frame;
                rectVW.origin.x = cell.lbl_position_5.frame.origin.x + cell.lbl_position_5.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_6.frame = rectVW;
                
                rectVW = cell.lbl_position_7.frame;
                rectVW.origin.x = cell.lbl_position_6.frame.origin.x + cell.lbl_position_6.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_7.frame = rectVW;
                
                rectVW = cell.lbl_position_8.frame;
                rectVW.origin.x = cell.lbl_position_7.frame.origin.x + cell.lbl_position_7.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_8.frame = rectVW;
                
                rectVW = cell.lbl_position_9.frame;
                rectVW.origin.x = cell.lbl_position_8.frame.origin.x + cell.lbl_position_8.frame.size.width + 1;
                rectVW.origin.y = 1;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_9.frame = rectVW;
                
                //This is label par 1 - 9
                rectVW = cell.lbl_par1_1.frame;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_1.frame = rectVW;
                
                
                rectVW = cell.lbl_par1_2.frame;
                rectVW.origin.x = cell.lbl_par1_1.frame.origin.x + cell.lbl_par1_1.frame.size.width + 7.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_2.frame = rectVW;
                
                
                rectVW = cell.lbl_par1_3.frame;
                rectVW.origin.x = cell.lbl_par1_2.frame.origin.x + cell.lbl_par1_2.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_3.frame = rectVW;
                
                
                rectVW = cell.lbl_par1_4.frame;
                rectVW.origin.x = cell.lbl_par1_3.frame.origin.x + cell.lbl_par1_3.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_4.frame = rectVW;
                
                rectVW = cell.lbl_par1_5.frame;
                rectVW.origin.x = cell.lbl_par1_4.frame.origin.x + cell.lbl_par1_4.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_5.frame = rectVW;
                
                rectVW = cell.lbl_par1_6.frame;
                rectVW.origin.x = cell.lbl_par1_5.frame.origin.x + cell.lbl_par1_5.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_6.frame = rectVW;
                
                rectVW = cell.lbl_par1_7.frame;
                rectVW.origin.x = cell.lbl_par1_6.frame.origin.x + cell.lbl_par1_6.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_7.frame = rectVW;
                
                rectVW = cell.lbl_par1_8.frame;
                rectVW.origin.x = cell.lbl_par1_7.frame.origin.x + cell.lbl_par1_7.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_8.frame = rectVW;
                
                rectVW = cell.lbl_par1_9.frame;
                rectVW.origin.x = cell.lbl_par1_8.frame.origin.x + cell.lbl_par1_8.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par1_9.frame = rectVW;
                
                rectVW = cell.lbl_tot_par1.frame;
//                rectVW.origin.x = cell.lbl_par1_9.frame.origin.x + cell.lbl_par1_9.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 2;
                rectVW.size.height = FR_width - 1;
                cell.lbl_tot_par1.frame = rectVW;
                
                //This is vertical seporater hole 1 - 9
                rectVW = cell.VW_vertical_S_1_1.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 2 + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_1.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_1_2.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_1_1.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_2.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_1_3.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_1_2.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_3.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_1_4.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_1_3.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_4.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_1_5.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_1_4.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_5.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_1_6.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_1_5.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_6.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_1_7.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_1_6.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_7.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_1_8.frame;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_1_7.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_1_8.frame = rectVW;
                
                //This is VW
                rectVW = cell.VW_hor2.frame; 
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT * 2;
                cell.VW_hor2.frame = rectVW;
                
                
                //This is label Score 1 - 9
                rectVW = cell.lbl_score1_1.frame;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_1.frame = rectVW;
                
                rectVW = cell.lbl_score1_2.frame;
                rectVW.origin.x = cell.lbl_score1_1.frame.origin.x + cell.lbl_score1_1.frame.size.width + 7.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_2.frame = rectVW;

                rectVW = cell.lbl_score1_3.frame;
                rectVW.origin.x = cell.lbl_score1_2.frame.origin.x + cell.lbl_score1_2.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_3.frame = rectVW;
                
                rectVW = cell.lbl_score1_4.frame;
                rectVW.origin.x = cell.lbl_score1_3.frame.origin.x + cell.lbl_score1_3.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_4.frame = rectVW;
                
                rectVW = cell.lbl_score1_5.frame;
                rectVW.origin.x = cell.lbl_score1_4.frame.origin.x + cell.lbl_score1_4.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_5.frame = rectVW;
                
                rectVW = cell.lbl_score1_6.frame;
                rectVW.origin.x = cell.lbl_score1_5.frame.origin.x + cell.lbl_score1_5.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_6.frame = rectVW;
                
                rectVW = cell.lbl_score1_7.frame;
                rectVW.origin.x = cell.lbl_score1_6.frame.origin.x + cell.lbl_score1_6.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_7.frame = rectVW;
                
                rectVW = cell.lbl_score1_8.frame;
                rectVW.origin.x = cell.lbl_score1_7.frame.origin.x + cell.lbl_score1_7.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_8.frame = rectVW;
                
                rectVW = cell.lbl_score1_9.frame;
                rectVW.origin.x = cell.lbl_score1_8.frame.origin.x + cell.lbl_score1_8.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score1_9.frame = rectVW;
                
                rectVW = cell.lbl_tot_score1.frame;
//                rectVW.origin.x = cell.lbl_score1_9.frame.origin.x + cell.lbl_score1_9.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_tot_score1.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_par1.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = cell.VW_hor1.frame.origin.y + 1;
                rectVW.size.height = FR_originalHT - 1;
                cell.lbl_subTITL_par1.frame = rectVW;
                
                //This is VW
                rectVW = cell.VW_hor3.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT * 3;
                cell.VW_hor3.frame = rectVW;
                
                //This is label Net Score 1 - 9
                rectVW = cell.lbl_Netscore1_1.frame;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_1.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_2.frame;
                rectVW.origin.x = cell.lbl_Netscore1_1.frame.origin.x + cell.lbl_Netscore1_1.frame.size.width + 7.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_2.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_3.frame;
                rectVW.origin.x = cell.lbl_Netscore1_2.frame.origin.x + cell.lbl_Netscore1_2.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_3.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_4.frame;
                rectVW.origin.x = cell.lbl_Netscore1_3.frame.origin.x + cell.lbl_Netscore1_3.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_4.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_5.frame;
                rectVW.origin.x = cell.lbl_Netscore1_4.frame.origin.x + cell.lbl_Netscore1_4.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_5.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_6.frame;
                rectVW.origin.x = cell.lbl_Netscore1_5.frame.origin.x + cell.lbl_Netscore1_5.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_6.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_7.frame;
                rectVW.origin.x = cell.lbl_Netscore1_6.frame.origin.x + cell.lbl_Netscore1_6.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_7.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_8.frame;
                rectVW.origin.x = cell.lbl_Netscore1_7.frame.origin.x + cell.lbl_Netscore1_7.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_8.frame = rectVW;
                
                rectVW = cell.lbl_Netscore1_9.frame;
                rectVW.origin.x = cell.lbl_Netscore1_8.frame.origin.x + cell.lbl_Netscore1_8.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore1_9.frame = rectVW;
                
                rectVW = cell.lbl_tot_Netscore1.frame;
//                rectVW.origin.x = cell.lbl_Netscore1_9.frame.origin.x + cell.lbl_Netscore1_9.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_tot_Netscore1.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_score1.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = cell.VW_hor2.frame.origin.y + 1;
                rectVW.size.height = FR_originalHT - 1;
                cell.lbl_subTITL_score1.frame = rectVW;
                
                //This is VW
                rectVW = cell.VW_hor4.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT * 4;
                cell.VW_hor4.frame = rectVW;
                
                
                //This is hole position 2
                rectVW = cell.lbl_position_10.frame;
                rectVW.origin.x = cell.lbl_subTITL_hole1.frame.origin.x + cell.lbl_subTITL_hole1.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_10.frame = rectVW;
                
                rectVW = cell.lbl_position_11.frame;
                rectVW.origin.x = cell.lbl_position_10.frame.origin.x + cell.lbl_position_10.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_11.frame = rectVW;
                
                rectVW = cell.lbl_position_12.frame;
                rectVW.origin.x = cell.lbl_position_11.frame.origin.x + cell.lbl_position_11.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_12.frame = rectVW;
                
                rectVW = cell.lbl_position_13.frame;
                rectVW.origin.x = cell.lbl_position_12.frame.origin.x + cell.lbl_position_12.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_13.frame = rectVW;
                
                rectVW = cell.lbl_position_14.frame;
                rectVW.origin.x = cell.lbl_position_13.frame.origin.x + cell.lbl_position_13.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_14.frame = rectVW;
                
                rectVW = cell.lbl_position_15.frame;
                rectVW.origin.x = cell.lbl_position_14.frame.origin.x + cell.lbl_position_14.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_15.frame = rectVW;
                
                rectVW = cell.lbl_position_16.frame;
                rectVW.origin.x = cell.lbl_position_15.frame.origin.x + cell.lbl_position_15.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_16.frame = rectVW;
                
                rectVW = cell.lbl_position_17.frame;
                rectVW.origin.x = cell.lbl_position_16.frame.origin.x + cell.lbl_position_16.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_17.frame = rectVW;
                
                rectVW = cell.lbl_position_18.frame;
                rectVW.origin.x = cell.lbl_position_17.frame.origin.x + cell.lbl_position_17.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.width = FR_width - 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_position_18.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_net1.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = cell.VW_hor3.frame.origin.y + 1;
                rectVW.size.height = FR_originalHT - 1;
                cell.lbl_subTITL_net1.frame = rectVW;
                
                //This is VW
                rectVW = cell.VW_hor5.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT * 5;
                cell.VW_hor5.frame = rectVW;
                
                //This is label par 9 - 18
                rectVW = cell.lbl_par2_1.frame;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_1.frame = rectVW;
                
                rectVW = cell.lbl_par2_2.frame;
                rectVW.origin.x = cell.lbl_par2_1.frame.origin.x + cell.lbl_par2_1.frame.size.width + 7.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_2.frame = rectVW;
                
                rectVW = cell.lbl_par2_3.frame;
                rectVW.origin.x = cell.lbl_par2_2.frame.origin.x + cell.lbl_par2_2.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_3.frame = rectVW;
                
                rectVW = cell.lbl_par2_4.frame;
                rectVW.origin.x = cell.lbl_par2_3.frame.origin.x + cell.lbl_par2_3.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_4.frame = rectVW;
                
                rectVW = cell.lbl_par2_5.frame;
                rectVW.origin.x = cell.lbl_par2_4.frame.origin.x + cell.lbl_par2_4.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_5.frame = rectVW;
                
                rectVW = cell.lbl_par2_6.frame;
                rectVW.origin.x = cell.lbl_par2_5.frame.origin.x + cell.lbl_par2_5.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_6.frame = rectVW;
                
                rectVW = cell.lbl_par2_7.frame;
                rectVW.origin.x = cell.lbl_par2_6.frame.origin.x + cell.lbl_par2_6.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_7.frame = rectVW;
                
                rectVW = cell.lbl_par2_8.frame;
                rectVW.origin.x = cell.lbl_par2_7.frame.origin.x + cell.lbl_par2_7.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_8.frame = rectVW;
                
                rectVW = cell.lbl_par2_9.frame;
                rectVW.origin.x = cell.lbl_par2_8.frame.origin.x + cell.lbl_par2_8.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_par2_9.frame = rectVW;
                
                rectVW = cell.lbl_tot_par2.frame;
//                rectVW.origin.x = cell.lbl_par2_9.frame.origin.x + cell.lbl_par2_9.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_tot_par2.frame = rectVW;
                
                
                //This is vertical seporater hole 9 - 18
                rectVW = cell.VW_vertical_S_2_1.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 2 + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_1.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_2_2.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_2_1.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_2.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_2_3.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_2_2.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_3.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_2_4.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_2_3.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_4.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_2_5.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_2_4.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_5.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_2_6.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_2_5.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_6.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_2_7.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_2_6.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_7.frame = rectVW;
                
                rectVW = cell.VW_vertical_S_2_8.frame;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y;
                rectVW.origin.x = cell.VW_vertical_S_2_7.frame.origin.x + FR_width;
                rectVW.size.height = FR_width * 3;
                cell.VW_vertical_S_2_8.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_hole2.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 1;
                rectVW.size.height = FR_originalHT - 1;
                cell.lbl_subTITL_hole2.frame = rectVW;
                
                //This is VW
                rectVW = cell.VW_hor6.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT * 6;
                cell.VW_hor6.frame = rectVW;
                
                //This is label Score 2
                rectVW = cell.lbl_score2_1.frame;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_1.frame = rectVW;
                
                rectVW = cell.lbl_score2_2.frame;
                rectVW.origin.x = cell.lbl_score2_1.frame.origin.x + cell.lbl_score2_1.frame.size.width + 7.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_2.frame = rectVW;
                
                rectVW = cell.lbl_score2_3.frame;
                rectVW.origin.x = cell.lbl_score2_2.frame.origin.x + cell.lbl_score2_2.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_3.frame = rectVW;
                
                rectVW = cell.lbl_score2_4.frame;
                rectVW.origin.x = cell.lbl_score2_3.frame.origin.x + cell.lbl_score2_3.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_4.frame = rectVW;
                
                rectVW = cell.lbl_score2_5.frame;
                rectVW.origin.x = cell.lbl_score2_4.frame.origin.x + cell.lbl_score2_4.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_5.frame = rectVW;
                
                rectVW = cell.lbl_score2_6.frame;
                rectVW.origin.x = cell.lbl_score2_5.frame.origin.x + cell.lbl_score2_5.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_6.frame = rectVW;
                
                rectVW = cell.lbl_score2_7.frame;
                rectVW.origin.x = cell.lbl_score2_6.frame.origin.x + cell.lbl_score2_6.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_7.frame = rectVW;
                
                rectVW = cell.lbl_score2_8.frame;
                rectVW.origin.x = cell.lbl_score2_7.frame.origin.x + cell.lbl_score2_7.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_8.frame = rectVW;
                
                rectVW = cell.lbl_score2_9.frame;
                rectVW.origin.x = cell.lbl_score2_8.frame.origin.x + cell.lbl_score2_8.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_score2_9.frame = rectVW;
                
                rectVW = cell.lbl_tot_score2.frame;
//                rectVW.origin.x = cell.lbl_score2_9.frame.origin.x + cell.lbl_score2_9.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_tot_score2.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_par2.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = cell.VW_hor5.frame.origin.y + 1;
                rectVW.size.height = FR_originalHT - 1;
                cell.lbl_subTITL_par2.frame = rectVW;
                
                //This is VW
                rectVW = cell.VW_hor7.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT * 7;
                cell.VW_hor7.frame = rectVW;
                
                //This is label Net Score 2
                rectVW = cell.lbl_Netscore2_1.frame;
                rectVW.origin.x = cell.VW_vertical_M1.frame.origin.x + 5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_1.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_2.frame;
                rectVW.origin.x = cell.lbl_Netscore2_1.frame.origin.x + cell.lbl_Netscore2_1.frame.size.width + 7.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_2.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_3.frame;
                rectVW.origin.x = cell.lbl_Netscore2_2.frame.origin.x + cell.lbl_Netscore2_2.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_3.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_4.frame;
                rectVW.origin.x = cell.lbl_Netscore2_3.frame.origin.x + cell.lbl_Netscore2_3.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_4.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_5.frame;
                rectVW.origin.x = cell.lbl_Netscore2_4.frame.origin.x + cell.lbl_Netscore2_4.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_5.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_6.frame;
                rectVW.origin.x = cell.lbl_Netscore2_5.frame.origin.x + cell.lbl_Netscore2_5.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_6.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_7.frame;
                rectVW.origin.x = cell.lbl_Netscore2_6.frame.origin.x + cell.lbl_Netscore2_6.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_7.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_8.frame;
                rectVW.origin.x = cell.lbl_Netscore2_7.frame.origin.x + cell.lbl_Netscore2_7.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_8.frame = rectVW;
                
                rectVW = cell.lbl_Netscore2_9.frame;
                rectVW.origin.x = cell.lbl_Netscore2_8.frame.origin.x + cell.lbl_Netscore2_8.frame.size.width + 6.5;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 4;
                rectVW.size.width = FR_width - 6.5;
                rectVW.size.height = FR_width - 6.5;
                cell.lbl_Netscore2_9.frame = rectVW;
                
                rectVW = cell.lbl_tot_Netscore2.frame;
//                rectVW.origin.x = cell.lbl_Netscore2_9.frame.origin.x + cell.lbl_Netscore2_9.frame.size.width + 1;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 1;
                rectVW.size.height = FR_width - 1;
                cell.lbl_tot_Netscore2.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_score2.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = cell.VW_hor6.frame.origin.y + 1;
                rectVW.size.height = FR_originalHT - 1;
                cell.lbl_subTITL_score2.frame = rectVW;
                
                //This is VW
                rectVW = cell.VW_hor8.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = FR_originalHT * 8;
                cell.VW_hor8.frame = rectVW;
                
                //This is vertical VW main
                rectVW = cell.VW_vertical_M2.frame;
                rectVW.origin.x = cell.VW_vertical_S_1_8.frame.origin.x + FR_width + 1;
                rectVW.origin.y = 5;
                rectVW.size.height = (FR_width * 8) - 5;
                cell.VW_vertical_M2.frame = rectVW;
                
                //This is label
                rectVW = cell.lbl_subTITL_net2.frame;
                rectVW.origin.x = 0;
                rectVW.origin.y = cell.VW_hor7.frame.origin.y + 1;
                rectVW.size.height = FR_originalHT - 1;
                cell.lbl_subTITL_net2.frame = rectVW;
                
                //This is label OUT
                rectVW = cell.lbl_title_OUT.frame;
                rectVW.origin.x = cell.lbl_title_OUT.frame.origin.x + 2;
                rectVW.origin.y = cell.lbl_subTITL_hole1.frame.origin.y;
                rectVW.size.height = FR_originalHT - 1;
                rectVW.size.width = (width_titles/2) - 2;
                cell.lbl_title_OUT.frame = rectVW;
                
                //This is label IN
                rectVW = cell.lbl_title_IN.frame;
                rectVW.origin.y = cell.VW_hor4.frame.origin.y + 2;
                rectVW.size.height = FR_originalHT - 1;
                rectVW.size.width = (width_titles/2) - 2;
                cell.lbl_title_IN.frame = rectVW;
                
                
                //This assign Values
                NSArray *ARR_temp;
                @try {
                    ARR_temp = [dictin_Scores valueForKey:@"hole_array"];
                    
//                    NSSortDescriptor *delay = [NSSortDescriptor sortDescriptorWithKey:@"position.integerValue" ascending:YES];
//                    [ARR_temp sortUsingDescriptors:[NSArray arrayWithObject:delay]];
                    
//                    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"position"
//                                                                                 ascending:YES];
//                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
//                    NSArray *sortedArray = [ARR_temp sortedArrayUsingDescriptors:sortDescriptors];
//                    
//                    ARR_temp = sortedArray;
                    
                    double DBL_totpar = 0,DBL_totSCR = 0,DBL_totNet = 0;
                    NSDictionary *dict_socre;
                    for (int i = 0; i < [ARR_temp count]; i ++) {
                        dict_socre = [ARR_temp objectAtIndex:i];
                        
                        @try {
                            DBL_totpar = DBL_totpar + [[dict_socre valueForKey:@"par"] doubleValue];
                        } @catch (NSException *exception) {
                            NSLog(@"Exception Totl score section 1 %@",exception);
                        }
                        
                        @try {
                            DBL_totSCR = DBL_totSCR + [[dict_socre valueForKey:@"gross_score"] doubleValue];
                        } @catch (NSException *exception) {
                            NSLog(@"Exception Totl score section 1 %@",exception);
                        }
                        
                        @try {
                            DBL_totNet = DBL_totNet + [[dict_socre valueForKey:@"net_score"] doubleValue];
                        } @catch (NSException *exception) {
                            NSLog(@"Exception Totl Net score section 1 %@",exception);
                        }
                    }
                    
                    NSString *STR_title_PAR = @"Par";
                    NSString *STR_disp_PAR;
                    
                    if (DBL_totpar != 0) {
//                        cell.lbl_result_PAR.text = [NSString stringWithFormat:@"Par %.0f",DBL_totpar];
                        STR_disp_PAR = [NSString stringWithFormat:@"%@ %.0f",STR_title_PAR,DBL_totpar];
                    }
                    else
                    {
//                        cell.lbl_result_PAR.text = @"Par 0";
                        STR_disp_PAR = [NSString stringWithFormat:@"%@ 0",STR_title_PAR];
                    }
                    
                    
                    
                    NSDictionary *attribs1 = @{
                                              NSForegroundColorAttributeName: cell.lbl_result_PAR.textColor,
                                              NSFontAttributeName: cell.lbl_result_PAR.font
                                              };
                    NSMutableAttributedString *attributedText1 =
                    [[NSMutableAttributedString alloc] initWithString:STR_disp_PAR
                                                           attributes:attribs1];
                    
                    // Red text attributes
                    //            UIColor *redColor = [UIColor redColor];
                    NSRange cmp = [STR_disp_PAR rangeOfString:STR_title_PAR];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText1 setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:17.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp];
                    }
                    else
                    {
                        [attributedText1 setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp];
                        
                    }
                    cell.lbl_result_PAR.attributedText = attributedText1;
                    
                    
                    NSString *STR_position;
                    NSDictionary *DIC_totals;
                    
                    @try {
                        DIC_totals = [dictin_Scores valueForKey:@"score_details"];
                        @try {
                            STR_position = [DIC_totals valueForKey:@"user_position"];
                            STR_update_handicap = [DIC_totals valueForKey:@"user_handicap"];
                        } @catch (NSException *exception) {
                            STR_position = @"";
                        }
                    } @catch (NSException *exception) {
                        @try {
                            STR_position = [dictin_Scores valueForKey:@"position"];
                        } @catch (NSException *exception) {
                            STR_position = @"";
                        }
                    }
                    
                    
                    NSString *STR_title_Socre = @"Score";
                    NSString *STR_title_Pos = @"Pos";
                    
                    NSString *STR_disp_score = [NSString stringWithFormat:@"%@ %.0f/%.0f",STR_title_Socre,DBL_totSCR,DBL_totNet];
//                    cell.lbl_result_score.text = [NSString stringWithFormat:@"Score %.0f/%.0f",DBL_totSCR,DBL_totNet];
//                    cell.lbl_result_position.text = [NSString stringWithFormat:@"Pos T-%@",STR_position];
                    
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName: cell.lbl_result_score.textColor,
                                              NSFontAttributeName: cell.lbl_result_score.font
                                              };
                    NSMutableAttributedString *attributedText =
                    [[NSMutableAttributedString alloc] initWithString:STR_disp_score
                                                           attributes:attribs];
                    
                    // Red text attributes
                    //            UIColor *redColor = [UIColor redColor];
                    NSRange cmp1 = [STR_disp_score rangeOfString:STR_title_Socre];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:17.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp1];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp1];
                        
                    }
                    cell.lbl_result_score.attributedText = attributedText;
                    
                    
                    NSString *STR_disp_position = [NSString stringWithFormat:@"%@ T - %@",STR_title_Pos,STR_position];
                    attribs = @{
                                NSForegroundColorAttributeName: cell.lbl_result_position.textColor,
                                NSFontAttributeName: cell.lbl_result_position.font
                                };
                    attributedText =
                    [[NSMutableAttributedString alloc] initWithString:STR_disp_position
                                                           attributes:attribs];
                    
                    cmp = [STR_disp_position rangeOfString:STR_title_Pos];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:17.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp];
                        
                    }
                    cell.lbl_result_position.attributedText = attributedText;
                    
                    
                    
                    float handicap = [STR_update_handicap floatValue];
                    if (handicap > 0) {
                        STR_update_handicap = [NSString stringWithFormat:@"+%.0f",handicap];
                    }
                    else if (handicap == 0)
                    {
                        STR_update_handicap = [NSString stringWithFormat:@"%.0f",handicap];
                    }
                    else
                    {
                        STR_update_handicap = [NSString stringWithFormat:@"%.0f",handicap];
                    }
                    
//                    cell.lbl_result_hcp.text = [NSString stringWithFormat:@"HCP %@",STR_update_handicap];
                    
                    NSString *STR_title_HCP = @"HCP";
                    NSString *STR_disp_HCP = [NSString stringWithFormat:@"%@ %@",STR_title_HCP,STR_update_handicap];
                    
                    
                    attribs = @{
                                NSForegroundColorAttributeName: cell.lbl_result_hcp.textColor,
                                NSFontAttributeName: cell.lbl_result_hcp.font
                                };
                    attributedText =
                    [[NSMutableAttributedString alloc] initWithString:STR_disp_HCP
                                                           attributes:attribs];
                    
                    cmp = [STR_disp_HCP rangeOfString:STR_title_HCP];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:17.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                                range:cmp];
                        
                    }
                    cell.lbl_result_hcp.attributedText = attributedText;
                    
//                    if (DBL_totSCR != 0) {
//                        cell.lbl_result_score.text = [NSString stringWithFormat:@"Score %.0f",DBL_totSCR];
//                    }
//                    else
//                    {
//                        cell.lbl_result_score.text = @" Score 0";
//                    }
//                    
//                    if (DBL_totNet != 0) {
//                        cell.lbl_tot_Netscore1.text = [NSString stringWithFormat:@"%.0f",DBL_totNet];
//                    }
//                    else
//                    {
//                        cell.lbl_tot_Netscore1.text = @"0";
//                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"Exception expanding cell %@",exception);
                }
                
                NSDictionary *Dic_tmp;
                if ([ARR_temp count] != 0) {
                    for (int i=0; i<[ARR_temp count]; i++) {
                        switch (i) {
                            case 0:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:0];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_1.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_1.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_1.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_1.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                    
                                    @try {
                                        DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl score section 1 %@",exception);
                                    }
                                    
                                    @try {
                                        DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl score section 1 %@",exception);
                                    }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_1.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_1.layer.cornerRadius = cell.lbl_score1_1.frame.size.width / 2;
                                        cell.lbl_score1_1.layer.masksToBounds = YES;
                                        cell.lbl_score1_1.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_1.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_1.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                
                            case 1:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:1];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_2.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_2.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_2.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_2.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_2.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_2.layer.cornerRadius = cell.lbl_score1_2.frame.size.width / 2;
                                        cell.lbl_score1_2.layer.masksToBounds = YES;
                                        cell.lbl_score1_2.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_2.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_2.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                break;
                                
                            case 2:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:2];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_3.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_3.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_3.text = net;
                                
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_3.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_3.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_3.layer.cornerRadius = cell.lbl_score1_3.frame.size.width / 2;
                                        cell.lbl_score1_3.layer.masksToBounds = YES;
                                        cell.lbl_score1_3.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_3.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_3.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 3:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:3];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_4.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_4.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_4.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_4.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_4.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_4.layer.cornerRadius = cell.lbl_score1_4.frame.size.width / 2;
                                        cell.lbl_score1_4.layer.masksToBounds = YES;
                                        cell.lbl_score1_4.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_4.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_4.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 4:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:4];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_5.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_5.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_5.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_5.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_5.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_5.layer.cornerRadius = cell.lbl_score1_5.frame.size.width / 2;
                                        cell.lbl_score1_5.layer.masksToBounds = YES;
                                        cell.lbl_score1_5.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_5.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_5.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 5:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:5];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_6.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_6.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_6.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_6.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_6.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_6.layer.cornerRadius = cell.lbl_score1_6.frame.size.width / 2;
                                        cell.lbl_score1_6.layer.masksToBounds = YES;
                                        cell.lbl_score1_6.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_6.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_6.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 6:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:6];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_7.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_7.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_7.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_7.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_7.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_7.layer.cornerRadius = cell.lbl_score1_7.frame.size.width / 2;
                                        cell.lbl_score1_7.layer.masksToBounds = YES;
                                        cell.lbl_score1_7.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_7.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_7.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                break;
                                
                            case 7:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:7];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_8.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_8.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_8.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_8.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_8.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_8.layer.cornerRadius = cell.lbl_score1_8.frame.size.width / 2;
                                        cell.lbl_score1_8.layer.masksToBounds = YES;
                                        cell.lbl_score1_8.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_8.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_8.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 8:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:8];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_9.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_9.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_9.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_9.text = posit;
                                
                                double DBL_totpar = 0,DBL_totSCR = 0;
                                
                                @try {
                                    DBL_totpar = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR != DBL_totpar) {
                                    cell.lbl_score1_9.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR < DBL_totpar && DBL_totSCR != 0) {
                                        cell.lbl_score1_9.layer.cornerRadius = cell.lbl_score1_9.frame.size.width / 2;
                                        cell.lbl_score1_9.layer.masksToBounds = YES;
                                        cell.lbl_score1_9.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar + 1 == DBL_totSCR)
                                    {
                                        cell.lbl_score1_9.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR != 0)
                                    {
                                        cell.lbl_score1_9.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                break;
                                
                            case 9:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:9];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_1.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_1.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_1.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_10.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_1.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_1.layer.cornerRadius = cell.lbl_score2_1.frame.size.width / 2;
                                        cell.lbl_score2_1.layer.masksToBounds = YES;
                                        cell.lbl_score2_1.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_1.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_1.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                                
                                double DBL_totpar = 0,DBL_totSCR = 0,DBL_totNet = 0;
                                NSDictionary *dict_socre;
                                for (int i = 0; i < 9; i ++) {
                                    dict_socre = [ARR_temp objectAtIndex:i];
                                    
                                    @try {
                                        DBL_totpar = DBL_totpar + [[dict_socre valueForKey:@"par"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl score section 1 %@",exception);
                                    }
                                    
                                    @try {
                                        DBL_totSCR = DBL_totSCR + [[dict_socre valueForKey:@"gross_score"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl score section 1 %@",exception);
                                    }
                                    
                                    @try {
                                        DBL_totNet = DBL_totNet + [[dict_socre valueForKey:@"net_score"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl Net score section 1 %@",exception);
                                    }
                                }
                                
                                if (DBL_totpar != 0) {
                                    cell.lbl_tot_par1.text = [NSString stringWithFormat:@"%.0f",DBL_totpar];
                                }
                                else
                                {
                                    cell.lbl_tot_par1.text = @"0";
                                }
                                
                                if (DBL_totSCR != 0) {
                                    cell.lbl_tot_score1.text = [NSString stringWithFormat:@"%.0f",DBL_totSCR];
                                }
                                else
                                {
                                    cell.lbl_tot_score1.text = @"0";
                                }
                                
                                if (DBL_totNet != 0) {
                                    cell.lbl_tot_Netscore1.text = [NSString stringWithFormat:@"%.0f",DBL_totNet];
                                }
                                else
                                {
                                    cell.lbl_tot_Netscore1.text = @"0";
                                }
                                
                            }
                                break;
                                
                            case 10:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:10];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_2.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_2.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_2.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_11.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_2.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_2.layer.cornerRadius = cell.lbl_score2_2.frame.size.width / 2;
                                        cell.lbl_score2_2.layer.masksToBounds = YES;
                                        cell.lbl_score2_2.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_2.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_2.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                break;
                                
                            case 11:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:11];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_3.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_3.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_3.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_12.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_3.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_3.layer.cornerRadius = cell.lbl_score2_3.frame.size.width / 2;
                                        cell.lbl_score2_3.layer.masksToBounds = YES;
                                        cell.lbl_score2_3.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_3.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_3.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                break;
                                
                            case 12:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:12];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_4.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_4.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_4.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_13.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_4.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_4.layer.cornerRadius = cell.lbl_score2_4.frame.size.width / 2;
                                        cell.lbl_score2_4.layer.masksToBounds = YES;
                                        cell.lbl_score2_4.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_4.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_4.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 13:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:13];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_5.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_5.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_5.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_14.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_5.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_5.layer.cornerRadius = cell.lbl_score2_5.frame.size.width / 2;
                                        cell.lbl_score2_5.layer.masksToBounds = YES;
                                        cell.lbl_score2_5.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_5.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_5.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 14:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:14];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_6.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_6.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_6.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_15.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_6.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_6.layer.cornerRadius = cell.lbl_score2_6.frame.size.width / 2;
                                        cell.lbl_score2_6.layer.masksToBounds = YES;
                                        cell.lbl_score2_6.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_6.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_6.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                            }
                                break;
                                
                            case 15:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:15];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_7.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_7.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_7.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_16.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_7.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_7.layer.cornerRadius = cell.lbl_score2_7.frame.size.width / 2;
                                        cell.lbl_score2_7.layer.masksToBounds = YES;
                                        cell.lbl_score2_7.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_7.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_7.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                break;
                                
                            case 16:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:16];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_8.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_8.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_8.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_17.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_8.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_8.layer.cornerRadius = cell.lbl_score2_8.frame.size.width / 2;
                                        cell.lbl_score2_8.layer.masksToBounds = YES;
                                        cell.lbl_score2_8.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_8.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_8.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                            }
                                break;
                                
                            case 17:
                            {
                                Dic_tmp = [ARR_temp objectAtIndex:17];
                                NSString *par,*score,*net,*posit;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_9.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_9.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_9.text = net;
                                
                                posit = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"position"]];
                                posit = [posit stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_position_18.text = posit;
                                
                                double DBL_totpar1 = 0,DBL_totSCR1 = 0;
                                
                                @try {
                                    DBL_totpar1 = [[Dic_tmp valueForKey:@"par"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                @try {
                                    DBL_totSCR1 = [[Dic_tmp valueForKey:@"gross_score"] doubleValue];
                                } @catch (NSException *exception) {
                                    NSLog(@"Exception Totl score section 1 %@",exception);
                                }
                                
                                
                                if (DBL_totSCR1 != DBL_totpar1) {
                                    cell.lbl_score2_9.textColor = [UIColor whiteColor];
                                    if (DBL_totSCR1 < DBL_totpar1 && DBL_totSCR1 != 0) {
                                        cell.lbl_score2_9.layer.cornerRadius = cell.lbl_score2_9.frame.size.width / 2;
                                        cell.lbl_score2_9.layer.masksToBounds = YES;
                                        cell.lbl_score2_9.backgroundColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.03 alpha:1.0];
                                    }
                                    else if(DBL_totpar1 + 1 == DBL_totSCR1)
                                    {
                                        cell.lbl_score2_9.backgroundColor = [UIColor colorWithRed:0.23 green:0.48 blue:0.86 alpha:0.7];
                                    }
                                    else if(DBL_totSCR1 != 0)
                                    {
                                        cell.lbl_score2_9.backgroundColor = [UIColor colorWithRed:0.04 green:0.23 blue:0.49 alpha:0.7];
                                    }
                                }
                                
                                double DBL_totpar = 0,DBL_totSCR = 0,DBL_totNet = 0;
                                NSDictionary *dict_socre;
                                for (int i = 9; i < 18; i ++) {
                                    dict_socre = [ARR_temp objectAtIndex:i];
                                    
                                    NSLog(@"I value %d",i);
                                    
                                    @try {
                                        DBL_totpar = DBL_totpar + [[dict_socre valueForKey:@"par"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl score section 1 %@",exception);
                                    }
                                    
                                    @try {
                                        DBL_totSCR = DBL_totSCR + [[dict_socre valueForKey:@"gross_score"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl score section 1 %@",exception);
                                    }
                                    
                                    @try {
                                        DBL_totNet = DBL_totNet + [[dict_socre valueForKey:@"net_score"] doubleValue];
                                    } @catch (NSException *exception) {
                                        NSLog(@"Exception Totl Net score section 1 %@",exception);
                                    }
                                }
                                
                                if (DBL_totpar != 0) {
                                    cell.lbl_tot_par2.text = [NSString stringWithFormat:@"%.0f",DBL_totpar];
                                }
                                else
                                {
                                    cell.lbl_tot_par2.text = @"0";
                                }
                                
                                if (DBL_totSCR != 0) {
                                    cell.lbl_tot_score2.text = [NSString stringWithFormat:@"%.0f",DBL_totSCR];
                                }
                                else
                                {
                                    cell.lbl_tot_score2.text = @"0";
                                }
                                
                                if (DBL_totNet != 0) {
                                    cell.lbl_tot_Netscore2.text = [NSString stringWithFormat:@"%.0f",DBL_totNet];
                                }
                                else
                                {
                                    cell.lbl_tot_Netscore2.text = @"0";
                                }
                        
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                return cell;
            }
            // init expanding cell
            else {
                static NSString *simpleTableIdentifier = @"SimpleTableItem";
                cell_player *cell = (cell_player *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (cell == nil)
                {
                    
                    NSArray *nib;
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        nib = [[NSBundle mainBundle] loadNibNamed:@"cell_player~iPad" owner:self options:nil];
                    }
                    else
                    {
                        nib = [[NSBundle mainBundle] loadNibNamed:@"cell_player" owner:self options:nil];
                    }
                    cell = [nib objectAtIndex:0];
                }
                
                NSIndexPath *theIndexPath = [self actualIndexPathForTappedIndexPath:indexPath];
                NSDictionary *Dictn_contents = [ARR_leaders objectAtIndex:[theIndexPath row]-1];
                NSDictionary *Nextval;
//                float cur_position = [[Dictn_contents valueForKey:@"user_position"] floatValue];
                float next_posi = 0.00;
                float cur_position = 0.00;
                
                NSString *STR_position_val;
                NSString *STR_cur_pos;
                
                @try {
                    STR_cur_pos = [Dictn_contents valueForKey:@"user_position"];
                } @catch (NSException *exception) {
                    STR_cur_pos = STR_psition;
                    STR_psition = nil;
                }
                
                if (!STR_cur_pos) {
                    @try {
                        STR_cur_pos = [Dictn_contents valueForKey:@"position"];
                    } @catch (NSException *exception) {
                        STR_cur_pos = STR_psition;
                        STR_psition = nil;
                    }
                }
                
                cur_position = [STR_cur_pos floatValue];
                
                if ([theIndexPath row] -1 != 0) {
                    if ([ARR_leaders count] > 1) {
//                        Nextval = [ARR_leaders objectAtIndex:[theIndexPath row]];
                        Nextval = [ARR_leaders objectAtIndex:[theIndexPath row]- 2];
                    }
                }
//                else
//                {
//                    
//                }
                
                /*else
                {
                    if ([ARR_leaders count] > 1) {
                        Nextval = [ARR_leaders objectAtIndex:[theIndexPath row]-1];
                    }
                }*/
                
                if (Nextval) {
                    next_posi = [[Nextval valueForKey:@"user_position"] floatValue];
                }
                
                if (cur_position == next_posi) {
                    STR_position_val = @"-";
                }
                else
                {
                    STR_position_val = [NSString stringWithFormat:@"%.0f",cur_position];
                }

                cell.lbl_Position.text = STR_position_val;
                cell.lbl_playerNAme.text = [NSString stringWithFormat:@"  %@",[Dictn_contents valueForKey:@"user_name"]];
                
                NSString *str_01,*STR_02;
                
                STR_02 = [NSString stringWithFormat:@" %@",[Dictn_contents valueForKey:@"total_net_score"]];
                STR_02 = [STR_02 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                cell.lbl_Score.text = [NSString stringWithFormat:@"%@",STR_02];
                
                
                
                
                @try {
                    str_01 = [Dictn_contents valueForKey:@"total_score"];
                    
                    int Temp_val = [str_01 intValue];
                    if (Temp_val == 0) {
                        str_01 = @"E";
                    }
                    else if (Temp_val > 0)
                    {
                        str_01 = [NSString stringWithFormat:@"+%@",[Dictn_contents valueForKey:@"total_score"]];
                    }
                } @catch (NSException *exception) {
                    str_01 = @"E";
                }
             
                
                cell.lbl_Topar.text = [NSString stringWithFormat:@"%@",str_01];
                
                
                cell.lbl_userID.text = [NSString stringWithFormat:@" %@",[Dictn_contents valueForKey:@"user_id"]];
                
                if (indexPath.row == 1)
                {
                    cell.lbl_playerNAme.textColor = [UIColor colorWithRed:0.00 green:0.61 blue:0.02 alpha:1.0];
                    cell.lbl_Topar.textColor = [UIColor colorWithRed:0.00 green:0.61 blue:0.02 alpha:1.0];
                    cell.lbl_Score.textColor = [UIColor colorWithRed:0.00 green:0.61 blue:0.02 alpha:1.0];
                }
                
                
                if ((indexPath.row + 1) % 2 == 0)
                {
                    cell.lbl_Position.backgroundColor = [UIColor colorWithRed:0.01 green:0.69 blue:0.87 alpha:1.0];
                    cell.lbl_playerNAme.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
                    cell.lbl_Score.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
                    cell.lbl_Topar.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
                } else {
                    cell.lbl_Position.backgroundColor = [UIColor colorWithRed:0.01 green:0.58 blue:0.69 alpha:1.0];
                    cell.lbl_playerNAme.backgroundColor = [UIColor colorWithRed:0.89 green:0.90 blue:0.90 alpha:1.0];
                    cell.lbl_Score.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0];
                    cell.lbl_Topar.backgroundColor = [UIColor colorWithRed:0.66 green:0.66 blue:0.66 alpha:1.0];
                }
                
                return cell;
            }
        }
    }
    else
    {
        if (indexPath.row == 0) {
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            Score_cell1 *cell = (Score_cell1 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"Score_cell1~iPad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"Score_cell1" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            NSString *STR_playerName,*STR_team,*STR_HCP,*STR_total;
            
            
            STR_playerName = [DICTIN_PlayerINfo valueForKey:@"STR_playerName"];//@"Bobby\nBradley"
            STR_team = [DICTIN_PlayerINfo valueForKey:@"STR_team"];//@"Team 1"
            STR_HCP = [DICTIN_PlayerINfo valueForKey:@"STR_HCP"]; //@"// HCP - 18";
            STR_total = [DICTIN_PlayerINfo valueForKey:@"Total"];
            
            if (!STR_playerName) {
                STR_playerName = @"";
            }
            
            if (!STR_team) {
                STR_team = @"";
            }
            
            if (!STR_HCP) {
                STR_HCP = @"";
            }
            else{
                NSString *firstLetter = [STR_HCP substringToIndex:1];
                if ([firstLetter isEqualToString:@"-"] || [firstLetter isEqualToString:@"0"])
                {
                    STR_HCP = [NSString stringWithFormat:@"HCP %@",STR_HCP];
                }
                else
                {
                    STR_HCP = [NSString stringWithFormat:@"HCP +%@",STR_HCP];
                }
            }
            
            if (!STR_total) {
                STR_total = @"";
            }
            
            cell.lbl_score.text = STR_total;
            
            
            NSString *text = [NSString stringWithFormat:@"%@\n%@ %@",STR_playerName,STR_team,STR_HCP];
                        
            // If attributed text is supported (iOS6+)
            if ([cell.lbl_playerName respondsToSelector:@selector(setAttributedText:)]) {
                // Define general attributes for the entire text
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: cell.lbl_playerName.textColor,
                                          NSFontAttributeName: cell.lbl_playerName.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                
                // Red text attributes
                //            UIColor *redColor = [UIColor redColor];
                NSRange cmp = [text rangeOfString:STR_team];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                NSRange range_HCP = [text rangeOfString:STR_HCP];
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:16.0]}
                                            range:cmp];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:14.0]}
                                            range:range_HCP];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:14.0]}
                                            range:cmp];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:12.0]}
                                            range:range_HCP];
                }
                cell.lbl_playerName.attributedText = attributedText;
            }
            else
            {
                cell.lbl_playerName.text = text;
            }
            
            cell.lbl_playerName.numberOfLines = 0;
            [cell.lbl_playerName sizeToFit];
            
            CGRect frame_lbl = cell.lbl_hole.frame;
            frame_lbl.origin.x = 0;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            cell.lbl_hole.frame = frame_lbl;
            
            frame_lbl = cell.lbl_distance.frame;
            frame_lbl.origin.x = cell.lbl_hole.frame.origin.x + cell.lbl_hole.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            cell.lbl_distance.frame = frame_lbl;
            
            frame_lbl = cell.lbl_gross_score.frame;
            frame_lbl.origin.x = cell.lbl_distance.frame.origin.x + cell.lbl_distance.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            cell.lbl_gross_score.frame = frame_lbl;
            
            frame_lbl = cell.lbl_net_score.frame;
            frame_lbl.origin.x = cell.lbl_gross_score.frame.origin.x + cell.lbl_gross_score.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            cell.lbl_net_score.frame = frame_lbl;
            
            frame_lbl = cell.lbl_handicap.frame;
            frame_lbl.origin.x = cell.lbl_net_score.frame.origin.x + cell.lbl_net_score.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            cell.lbl_handicap.frame = frame_lbl;
            
            return cell;
        }
        else
        {
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            ScoreCell2 *cell = (ScoreCell2 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"ScoreCell2~iPad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"ScoreCell2" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            NSDictionary *DICTN_info = [ARR_holes objectAtIndex:indexPath.row - 1];
            
            NSString *par_STR = [NSString stringWithFormat:@"Par %@",[DICTN_info valueForKey:@"par"]];
            NSString *text = [NSString stringWithFormat:@"%@\n%@",[DICTN_info valueForKey:@"position"],par_STR];
            
            
            // If attributed text is supported (iOS6+)
            if ([cell.lbl_hole respondsToSelector:@selector(setAttributedText:)]) {
                // Define general attributes for the entire text
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: cell.lbl_hole.textColor,
                                          NSFontAttributeName: cell.lbl_hole.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                
                // Red text attributes
                //            UIColor *redColor = [UIColor redColor];
                NSRange cmp = [text rangeOfString:par_STR];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:12.0]}
                                            range:cmp];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:10.0]}
                                            range:cmp];
                }
                cell.lbl_hole.attributedText = attributedText;
            }
            else
            {
                cell.lbl_hole.text = text;
            }
            
            cell.lbl_hole.numberOfLines = 0;
            [cell.lbl_hole sizeToFit];
            
            CGRect frame_lbl = cell.lbl_hole.frame;
            frame_lbl.origin.x = 0;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_hole.frame = frame_lbl;
            
            UIImage *Image_hole = [UIImage imageNamed:@"Blue"];
            UIGraphicsBeginImageContextWithOptions(cell.lbl_hole.frame.size, NO, 0.f);
            [Image_hole drawInRect:CGRectMake(0.f, 0.f, cell.lbl_hole.frame.size.width, cell.lbl_hole.frame.size.height)];
            UIImage * resultImage_hole = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.lbl_hole.backgroundColor = [UIColor colorWithPatternImage:resultImage_hole];
            
            NSString *STR_yards = [DICTN_info valueForKey:@"yards"];
            if (!STR_yards || [STR_yards isKindOfClass:[NSNull class]]) {
                STR_yards = @"";
            }
            
            cell.lbl_distance.text = [NSString stringWithFormat:@"%@",STR_yards];
            
            frame_lbl = cell.lbl_distance.frame;
            frame_lbl.origin.x = cell.lbl_hole.frame.origin.x + cell.lbl_hole.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_distance.frame = frame_lbl;
            
            UIImage *Image_distance = [UIImage imageNamed:@"Grey"];
            UIGraphicsBeginImageContextWithOptions(cell.lbl_distance.frame.size, NO, 0.f);
            [Image_distance drawInRect:CGRectMake(0.f, 0.f, cell.lbl_distance.frame.size.width, cell.lbl_distance.frame.size.height)];
            UIImage * resultImage_distance = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [cell.lbl_distance setBackgroundColor:[UIColor colorWithPatternImage:resultImage_distance]];
            
            
            frame_lbl = cell.VW_grossScore.frame;
            frame_lbl.origin.x = cell.lbl_distance.frame.origin.x + cell.lbl_distance.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.VW_grossScore.frame = frame_lbl;
            
            if ([[[ARR_color objectAtIndex:indexPath.row-1] valueForKey:@"color"] isEqualToString:@"blue"]) {
                cell.lbl_gross_score.backgroundColor = cell.lbl_hole.backgroundColor;
                cell.lbl_gross_score.textColor = [UIColor whiteColor];
                [cell setSelected:YES animated:YES];
            }

            NSString *STR_grossSCORE = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"gross_score"]];
            
            if ([STR_grossSCORE isEqualToString:@"<null>"]) {
//                @try {
//                    cell.lbl_gross_score.text = [ARR_grossScore objectAtIndex:indexPath.row - 1];
                
//                } @catch (NSException *exception) {
                    cell.lbl_gross_score.text = @"";
//                }
            }
//            else if (INdex_Selected.row == indexPath.row)
//            {
//                @try {
//                    cell.lbl_gross_score.text = [ARR_grossScore objectAtIndex:indexPath.row - 1];
//                    if ([[[ARR_color objectAtIndex:indexPath.row-1] valueForKey:@"color"] isEqualToString:@"blue"]) {
//                        cell.lbl_gross_score.backgroundColor = cell.lbl_hole.backgroundColor;
//                        [cell setSelected:YES animated:YES];
//                    }
                
//                    NSLog(@"The value color %@\nThe value for index %@\n",[[ARR_color objectAtIndex:indexPath.row-1] valueForKey:@"color"],[[ARR_color objectAtIndex:indexPath.row-1] valueForKey:@"index"]);
//                } @catch (NSException *exception) {
//                    cell.lbl_gross_score.text = @"";
//                }
//            }
            else
            {
                cell.lbl_gross_score.text = STR_grossSCORE;
            }
            
            
            
            
            CGRect new_rect = cell.lbl_gross_score.frame;
            new_rect.size.width = 40;
            new_rect.size.height = 40;
            cell.lbl_gross_score.frame = new_rect;
            
            cell.lbl_gross_score.layer.cornerRadius = 20;
            cell.lbl_gross_score.layer.masksToBounds = YES;
            
//            cell.lbl_gross_score.center = cell.VW_grossScore.center;
            
            
//            UIImage *Image_gross_scr = [UIImage imageNamed:@"Grey_1"];
//            UIGraphicsBeginImageContextWithOptions(cell.VW_grossScore.frame.size, NO, 0.f);
//            [Image_gross_scr drawInRect:CGRectMake(0.f, 0.f, cell.VW_grossScore.frame.size.width, cell.VW_grossScore.frame.size.height)];
//            UIImage * resultImage_Gross_scr = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            [cell.VW_grossScore setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
            
            
            NSString *STR_NetSocre = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"net_score"]];
            
            if ([STR_NetSocre isEqualToString:@"<null>"]) {
//                @try {
//                    cell.lbl_net_score.text = [ARR_netScore objectAtIndex:indexPath.row - 1];
//                } @catch (NSException *exception) {
                    cell.lbl_net_score.text = @"";
//                }
            }
//            if (INdex_Selected.row == indexPath.row)
//            {
//                @try {
//                    cell.lbl_net_score.text = [ARR_netScore objectAtIndex:indexPath.row - 1];
//                } @catch (NSException *exception) {
//                    cell.lbl_net_score.text = @"";
//                }
//            }
            else
            {
                cell.lbl_net_score.text = STR_NetSocre;
            }
            
            
            frame_lbl = cell.lbl_net_score.frame;
            frame_lbl.origin.x = cell.VW_grossScore.frame.origin.x + cell.VW_grossScore.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_net_score.frame = frame_lbl;
            
            UIImage *Image_net_SCR = [UIImage imageNamed:@"Grey_2"];
            UIGraphicsBeginImageContextWithOptions(cell.lbl_net_score.frame.size, NO, 0.f);
            [Image_net_SCR drawInRect:CGRectMake(0.f, 0.f, cell.lbl_net_score.frame.size.width, cell.lbl_net_score.frame.size.height)];
            UIImage * resultImage_Net_scr = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [cell.lbl_net_score setBackgroundColor:[UIColor colorWithPatternImage:resultImage_Net_scr]];
            
            NSString *STR_handicap = [DICTN_info valueForKey:@"handicap"];
            if (!STR_handicap || [STR_handicap isKindOfClass:[NSNull class]]) {
                STR_handicap = @"";
            }
            cell.lbl_handicap.text = [NSString stringWithFormat:@"%@",STR_handicap];
            
            frame_lbl = cell.lbl_handicap.frame;
            frame_lbl.origin.x = cell.lbl_net_score.frame.origin.x + cell.lbl_net_score.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_handicap.frame = frame_lbl;
            
            UIImage *Image_Handicap = [UIImage imageNamed:@"Grey_3"];
            UIGraphicsBeginImageContextWithOptions(cell.lbl_handicap.frame.size, NO, 0.f);
            [Image_Handicap drawInRect:CGRectMake(0.f, 0.f, cell.lbl_handicap.frame.size.width, cell.lbl_handicap.frame.size.height)];
            UIImage * resultImage_Handicap = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [cell.lbl_handicap setBackgroundColor:[UIColor colorWithPatternImage:resultImage_Handicap]];
            
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _TBL_leaderboard) {
        if (indexPath.row == 0) {
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                return 30;
            }
            else
            {
                return 25;
            }
        }
        else if ([indexPath isEqual:self.expandedIndexPath]) {
            
            float FR_width = (_TBL_leaderboard.frame.size.width - 114) / 9;
            float FR_height = (FR_width * 8) + 34;
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                return FR_height - 60;
            }
            else
            {
                return FR_height;
            }
            
        }
        else {
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                return 40;
            }
            else
            {
                return 40;
            }
        }
    }
    else
    {
        if (indexPath.row == 0) {
            return 88;
        }
        else{
            return 60;
        }
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _TBL_leaderboard)
    {
        if (indexPath.row == 0)
        {
            NSLog(@"Title Slected");
        }
        else
        {
            INdex_Selected = indexPath;
            
            if ([indexPath isEqual:self.expandedIndexPath]) {
                if (indexPath.row > [self.dataSource count])
                {
                    return;
                }
            }
            else
            {
                [self update_tableView:indexPath];
                
            }
        }
    }
    else
    {
        if (indexPath.row == 0) {
            
            _TXT_Handicap.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"handicap1"];
            VW_overlay.hidden = NO;
            _VW_selectHANDICAP.hidden = NO;
            
            [_TBL_scores beginUpdates];
            NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:INdex_Selected.row inSection:0]];
            [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            [_TBL_scores endUpdates];
        }
        else
        {
            
            INdex_Selected = indexPath;
            [self performSegueWithIdentifier:@"scoreUpdateIdentifier" sender:self];
        }
    }
}


-(void) update_tableView :(NSIndexPath *)indexPath
{
    // deselect row
    [self.TBL_leaderboard deselectRowAtIndexPath:indexPath
                             animated:NO];
    
    // get the actual index path
    indexPath = [self actualIndexPathForTappedIndexPath:indexPath];
    
    // save the expanded cell to delete it later
    NSIndexPath *theExpandedIndexPath = self.expandedIndexPath;
    
    // same row tapped twice - get rid of the expanded cell
    if ([indexPath isEqual:self.expandingIndexPath]) {
        self.expandingIndexPath = nil;
        self.expandedIndexPath = nil;
    }
    // add the expanded cell
    else {
        self.expandingIndexPath = indexPath;
        self.expandedIndexPath = [NSIndexPath indexPathForRow:[indexPath row] + 1
                                                    inSection:[indexPath section]];
    }
    INDX_STR = indexPath;
    INDX_expanded = theExpandedIndexPath;
//    [[NSUserDefaults standardUserDefaults] setObject:indexPath forKey:@"INDX_STR"];
//    [[NSUserDefaults standardUserDefaults] setObject:theExpandedIndexPath forKey:@"INDX_expanded"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [self perform_CellUpdate];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(perform_CellUpdate) withObject:activityIndicatorView afterDelay:0.01];
}

-(void) perform_CellUpdate
{
    NSIndexPath *indexPath = INDX_STR;//[[NSUserDefaults standardUserDefaults] valueForKey:@"INDX_STR"];
    NSIndexPath *theExpandedIndexPath = INDX_expanded;//[[NSUserDefaults standardUserDefaults] valueForKey:@"INDX_expanded"];
    
    [self.TBL_leaderboard beginUpdates];
    
    if (theExpandedIndexPath) {
        [_TBL_leaderboard deleteRowsAtIndexPaths:@[theExpandedIndexPath]
                                withRowAnimation:UITableViewRowAnimationNone];
    }
    if (self.expandedIndexPath) {
        NSLog(@"Index selec1 = %ld",(long)indexPath.row);
        NSDictionary *temp_dictin = [ARR_leaders objectAtIndex:indexPath.row-1];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"user_id"]] forKey:@"Selected_USER"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self LeaderDetail_API];
        [_TBL_leaderboard insertRowsAtIndexPaths:@[self.expandedIndexPath]
                                withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self.TBL_leaderboard endUpdates];
    
    // scroll to the expanded cell
    [self.TBL_leaderboard scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionMiddle
                                        animated:YES];
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"scoreUpdateIdentifier"])
    {
        NSDictionary *DICTN_info = [ARR_holes objectAtIndex:INdex_Selected.row - 1];
        
        
        for (int i = 0; i < [ARR_holes count]; i++) {
            NSDictionary *dictin_TEMP = @{@"color":@"",@"index":@""};
            if ([[[ARR_color objectAtIndex:i] valueForKey:@"color"] isEqualToString:@"blue"]) {
                [ARR_color replaceObjectAtIndex:i withObject:dictin_TEMP];
                
                [_TBL_scores beginUpdates];
                NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
                [_TBL_scores endUpdates];
            }
        }
        
        VC_score_update *vc = segue.destinationViewController;
        vc.STR_parSTR = [DICTN_info valueForKey:@"par"];
        vc.STR_holeSTR = [DICTN_info valueForKey:@"position"];
        vc.STR_playernameSTR = [DICTIN_PlayerINfo valueForKey:@"STR_playerName"];
        vc.STR_HCP = [DICTN_info valueForKey:@"handicap"];
        vc.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"scorebordtomapIdentifier"])
    {
        NSDictionary *DICTN_info;
        if (!INdex_Selected.row) {
            DICTN_info = [ARR_holes objectAtIndex:0];
        }
        else
        {
            DICTN_info = [ARR_holes objectAtIndex:INdex_Selected.row - 1];
        }
        VC_viewCourseonMAP *vc = segue.destinationViewController;
        vc.STR_parSTR = [NSString stringWithFormat:@"Par %@",[DICTN_info valueForKey:@"par"]];
        vc.STR_holeSTR = [NSString stringWithFormat:@"Hole %@",[DICTN_info valueForKey:@"position"]];
        vc.STR_yards = [NSString stringWithFormat:@"%@ Yards",[DICTN_info valueForKey:@"yards"]];
        vc.segmentdelegate = self;
    }
}



#pragma mark - Update score Deligate
-(void) get_SCORE:(NSString *)STR_score get_HCP:(NSString *)ST_HCP
{

    NSLog(@"Value return = %@ Index selected %ld hCP %@",STR_score,(long)INdex_Selected.row,ST_HCP);
    [self get_GRoss_SCORE:STR_score:ST_HCP];
    
    [_TBL_scores beginUpdates];
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:INdex_Selected.row inSection:0]];
    [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    [_TBL_scores endUpdates];
}

#pragma mark - data Segment Deligate
-(void) get_segment_index : (int)i
{
    NSLog(@"Value return data Segment %i",i);
    _segmentedControl4.selectedSegmentIndex = i;
    [self segmentedControlChangedValue:_segmentedControl4];
}
-(void) leave_game_tapped : (NSString *)str
{
    [self.segmentedControl4 setSelectedSegmentIndex:UISegmentedControlNoSegment];
    _BTN_viewonMAP.backgroundColor = self.view.tintColor;
    NSLog(@"Leave Game %@",str);
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Api Integration
-(void) UPDATE_handicap
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    
    NSDictionary *parameters = @{ @"handicap":  [NSString stringWithFormat:@"%@",_TXT_Handicap.text]};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@hole_info/handicap/%@",SERVER_URL,[event valueForKey:@"id"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_TXT_Handicap.text forKey:@"handicap1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        NSLog(@"Json response UPDATE_handicap = %@",dict);
        
        DICTIN_PlayerINfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]],@"STR_playerName",@"",@"STR_team",[NSString stringWithFormat:@"%@",_TXT_Handicap.text],@"STR_HCP",[NSString stringWithFormat:@"%@",[dict valueForKey:@"total_score"]],@"Total", nil];
        
        
//        if ([ARR_grossScore count] == 0) {
//            ARR_grossScore = [[NSMutableArray alloc] init];
//            ARR_netScore = [[NSMutableArray alloc] init];
            ARR_color = [[NSMutableArray alloc] init];
            ARR_holes = [[NSMutableArray alloc] init];
        [self HOLES_API];
            [ARR_holes addObjectsFromArray:[dict valueForKey:@"hole_info"]];
        
//        NSSortDescriptor *delay = [NSSortDescriptor sortDescriptorWithKey:@"position.integerValue" ascending:YES];
//        [ARR_holes sortUsingDescriptors:[NSArray arrayWithObject:delay]];
        
        NSLog(@"Sorted list 2 %@",ARR_holes);
            
            for (int i = 0; i < [ARR_holes count]; i++) {
                NSDictionary *dictin_TEMP = @{@"color":@"",@"index":@""};
//                [ARR_grossScore addObject:@""];
//                [ARR_netScore addObject:@""];
                [ARR_color addObject:dictin_TEMP];
//            }
        }
        [_TBL_scores reloadData];
        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

-(void) HOLES_API
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSLog(@"Dictionary contents VC Scoreboard %@",dict);
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    //    NSError *error;
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@hole_info/select_hole_info/%@",SERVER_URL,[event valueForKey:@"id"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        //        DICTIN_holes *globals = [DICTIN_holes dictionary_VAL];
        //        globals.Dictin_course = dict;
        
//        if ([ARR_grossScore count] == 0) {
//            ARR_grossScore = [[NSMutableArray alloc] init];
//            ARR_netScore = [[NSMutableArray alloc] init];
        
            [ARR_holes removeAllObjects];
            [ARR_holes addObjectsFromArray:[dict valueForKey:@"hole_info"]];
            //        NSLog(@"Json response Hole = %@",dict);
        
//        NSSortDescriptor *delay = [NSSortDescriptor sortDescriptorWithKey:@"position.integerValue" ascending:YES];
//        [ARR_holes sortUsingDescriptors:[NSArray arrayWithObject:delay]];
        
        NSLog(@"Sorted list 1 %@",ARR_holes);
            
//            for (int i = 0; i < [ARR_holes count]; i++) {
//                [ARR_grossScore addObject:@""];
//                [ARR_netScore addObject:@""];
//            }
        [_TBL_scores reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

-(void) get_GRoss_SCORE : (NSString *)STR_scoreVAL :(NSString *)HCP_STR
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    
    NSDictionary *DICTN_info = [ARR_holes objectAtIndex:INdex_Selected.row - 1];
    
    NSDictionary *parameters = @{ @"hole_number":[DICTN_info valueForKey:@"position"],@"gross_score":  STR_scoreVAL,@"handicap":HCP_STR};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@hole_info/gross_score/%@",SERVER_URL,[event valueForKey:@"id"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Json response get net Socre = %@",dict);
        
//        DICTIN_PlayerINfo = @{@"STR_playerName":[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]],@"STR_team":@"Team 1",@"STR_HCP":[NSString stringWithFormat:@"%@",_TXT_Handicap.text],@"Total":[NSString stringWithFormat:@"%@",[dict valueForKey:@"total_score"]]};
        
        if (dict) {
            [DICTIN_PlayerINfo setObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"total_score"]]  forKey:@"Total"];
            
            NSString *STR_netScore = [NSString stringWithFormat:@"%@",[dict valueForKey:@"net_score"]];
            NSString *gross_score = [NSString stringWithFormat:@"%@",[dict valueForKey:@"gross_score"]];
            
            NSLog(@"Index selected = %@",INdex_Selected);
            
            NSDictionary *temp_dictin = [ARR_holes objectAtIndex:INdex_Selected.row-1];
            NSDictionary *sore_val = @{@"gross_score":gross_score,@"handicap":[temp_dictin valueForKey:@"handicap"],@"net_score":STR_netScore,@"par":[temp_dictin valueForKey:@"par"],@"position":[temp_dictin valueForKey:@"position"],@"yards":[temp_dictin valueForKey:@"yards"]};
            
//            [ARR_netScore replaceObjectAtIndex:INdex_Selected.row-1 withObject:STR_netScore];
//            [ARR_grossScore replaceObjectAtIndex:INdex_Selected.row-1 withObject:gross_score];
            
            [ARR_holes replaceObjectAtIndex:INdex_Selected.row-1 withObject:sore_val];
            
            NSDictionary *dictin_TEMP = @{@"color":@"blue",@"index":@"value"};
            [ARR_color replaceObjectAtIndex:INdex_Selected.row-1 withObject:dictin_TEMP];
            
            
            [_TBL_scores beginUpdates];
            NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:INdex_Selected.row inSection:0]];
            NSArray *indexPath0 = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
            [_TBL_scores reloadRowsAtIndexPaths:indexPath0 withRowAnimation:UITableViewRowAnimationFade];
            [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
            [_TBL_scores endUpdates];
        }
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

-(void) Leaders_API
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    
//    NSDictionary *parameters = @{ @"handicap":  [NSString stringWithFormat:@"%@",_TXT_Handicap.text]};
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@hole_info/leader_board/%@",SERVER_URL,[event valueForKey:@"id"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
//    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        NSLog(@"Json response Leaders_API = %@",dict);
        ARR_leaders = [[NSMutableArray alloc] init];
        [ARR_leaders addObjectsFromArray:[dict valueForKey:@"leader_board"]];
        
//        [ARR_leaders sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"total_score" ascending:YES]]];
        
        if ([ARR_leaders count] != 0) {
            [_TBL_leaderboard reloadData];
        }
        
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

-(void) LeaderDetail_API // :(UITableView *)tableView secondindex:(NSIndexPath *)indexPath
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    NSString *STR_userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"Selected_USER"];
    
    //    NSDictionary *parameters = @{ @"handicap":  [NSString stringWithFormat:@"%@",_TXT_Handicap.text]};
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@hole_info/leader_board/%@/%@",SERVER_URL,[event valueForKey:@"id"],STR_userID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    //    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        dictin_Scores = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Dictin score api = %@",dictin_Scores);
        
//        STR_update_handicap = [dictin_Scores valueForKey:@"handicap"];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

#pragma mark - controller methods
- (void)createDataSourceArray
{
    NSMutableArray *dataSourceMutableArray = [NSMutableArray array];
    
    for (int i = 0; i <= 20; i++) {
        NSDictionary *dataSourceString = @{@"Position":[NSString stringWithFormat:@"%u",i],@"PlayerName":[NSString stringWithFormat:@"Player %u",i]};
        //[NSString stringWithFormat:@"Row #%u", i];
        [dataSourceMutableArray addObject:dataSourceString];
    }
    
    self.dataSource = [NSArray arrayWithArray:dataSourceMutableArray];
}
- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)indexPath
{
    if (self.expandedIndexPath && [indexPath row] > [self.expandedIndexPath row]) {
        return [NSIndexPath indexPathForRow:[indexPath row] - 1
                                  inSection:[indexPath section]];
    }
    
    return indexPath;
}



#pragma mark - Alertview deligate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
                
            default:
                break;
        }
    }
    else if (alertView.tag == 2)
    {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Button index 0");
                break;
                
            default:
                break;
        }
    }
    else if (alertView.tag == 3)
    {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Button index 0");
                break;
                
            default:
                break;
        }
    }
    else if (alertView.tag == 4)
    {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Button index 0");
                break;
                
            default:
                break;
        }
    }
}

- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSDictionary *) dictionaryWithPropertiesOfObject_1:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        Class classObject = NSClassFromString([key capitalizedString]);
        
        id object = [obj valueForKey:key];
        
        if (classObject) {
            id subObj = [self dictionaryWithPropertiesOfObject_1:object];
            [dict setObject:subObj forKey:key];
        }
        else if([object isKindOfClass:[NSArray class]])
        {
            NSMutableArray *subObj = [NSMutableArray array];
            for (id o in object) {
                [subObj addObject:[self dictionaryWithPropertiesOfObject_1:o] ];
            }
            [dict setObject:subObj forKey:key];
        }
        else
        {
            if(object) [dict setObject:object forKey:key];
        }
    }
    
    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}

-(void)Sucess :(NSData *)aData
{
    if ([aData isKindOfClass:[NSArray class]]) {
        NSLog(@"its an array!");
        NSArray *jsonArray = (NSArray *)aData;
        NSLog(@"jsonArray - %@",jsonArray);
    }
    else
    {
        //        NSDictionary *jsonDictionary = [self dictionaryWithPropertiesOfObject_1:aData];
        //        NSDictionary *jsonDictionary = (NSDictionary *)aData;
        NSError *error;
        
        NSString *jsonDictionary = (NSString *)aData;
        
//        NSLog(@"Json dictin live %@",jsonDictionary);
        
        NSData *jsonData = [jsonDictionary dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
        
        NSString *STR_type;
        
        @try {
            STR_type = [json valueForKey:@"type"];
        } @catch (NSException *exception) {
            NSLog(@"Type exception %@",exception);
        }
        
        @try {
            STR_psition = [json valueForKey:@"position"];
        } @catch (NSException *exception) {
            STR_psition = nil;
        }
        
        NSDictionary *dictin_message;
        @try {
            dictin_message = [json valueForKey:@"message"];
        } @catch (NSException *exception) {
            NSLog(@"Message exception %@",exception);
        }
        
        if ([dictin_message isKindOfClass:[NSDictionary class]]) {
            NSDictionary *json;
            @try {
                json = [dictin_message valueForKey:@"json"];
                if (json) {
                    
                    if ([[json valueForKey:@"sender_auth_token"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"]])
                    {
                        NSLog(@"Update Not required");
                    }
                    else
                    {
                        NSLog(@"Update Required Json respon %@",json);
                        
                        @try {
                            STR_update_handicap = [json valueForKey:@"handicap"];
                        } @catch (NSException *exception) {
                            STR_update_handicap = _TXT_Handicap.text;
                        }
                        
                        
                        
                        
                        
                        if (_TBL_leaderboard.hidden == NO)
                        {
                            NSArray *TMP_leder;
                            @try {
                                /*TMP_leder = [json valueForKey:@"leader_board"];
                                if ([TMP_leder count] > 0) {
                                    ARR_leaders = [[NSMutableArray alloc] init];
                                    [ARR_leaders addObjectsFromArray:TMP_leder];
                                    
                                    self.expandingIndexPath = nil;
                                    self.expandedIndexPath = nil;
                                    
//                                    [UIView transitionWithView: self.TBL_leaderboard
//                                                      duration: 0.35f
//                                                       options: UIViewAnimationOptionTransitionCrossDissolve
//                                                    animations: ^(void)
//                                     {
                                         [self.TBL_leaderboard reloadData];
//                                     }
//                                                    completion: nil];
                                }*/
                            } @catch (NSException *exception) {
                                NSLog(@"Exception update leaders %@",json);
                            }
                            
                            @try {
                                NSDictionary *DICTIN_playerdetail = [json valueForKey:@"leader_board_details"];
                                [ARR_leaders addObject:DICTIN_playerdetail];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.expandingIndexPath = nil;
                                    self.expandedIndexPath = nil;
                                    [self.TBL_leaderboard reloadData];
                                });
                                
                            }
                            @catch (NSException *exception)
                            {
                                NSLog(@"Exception add new person %@",exception);
//                                @try {
//                                    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//                                    cell_player *cell = (cell_player *)[_TBL_leaderboard dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//                                    if (cell == nil)
//                                    {
//                                        
//                                        NSArray *nib;
//                                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                                        {
//                                            nib = [[NSBundle mainBundle] loadNibNamed:@"cell_player~iPad" owner:self options:nil];
//                                        }
//                                        else
//                                        {
//                                            nib = [[NSBundle mainBundle] loadNibNamed:@"cell_player" owner:self options:nil];
//                                        }
//                                        cell = [nib objectAtIndex:0];
//                                    }
//                                    
//                                    UITableView *tableview = self.TBL_leaderboard;    //set your tableview here
//                                    for(int sectionI=0; sectionI < 1; sectionI++)
//                                    {
//                                        int rowCount = (int)[tableview numberOfRowsInSection:sectionI];
//                                        for (int rowsI=1; rowsI < rowCount; rowsI++)
//                                        {
//                                            NSIndexPath *indxPath = [NSIndexPath indexPathForRow:rowsI inSection:sectionI];
//                                            cell = (cell_player *)[_TBL_leaderboard cellForRowAtIndexPath:indxPath];
//                                            NSString *user_id = cell.lbl_userID.text;
//                                            int usr_id = [user_id intValue];
//                                            
//                                            NSString *STR_jsonUSer = [json valueForKey:@"user_id"];
//                                            int jsonUSer = [STR_jsonUSer intValue];
//                                            
//                                            if (usr_id == jsonUSer) {
//                                                NSInteger i = [self returnIndexFromDateProperty:[json valueForKey:@"user_id"]];
//                                                NSDictionary *temp_dictin = [ARR_leaders objectAtIndex:i];
//                                                NSString *user_id1 = [json valueForKey:@"user_id"];
//                                                NSString *user_name = [temp_dictin valueForKey:@"user_name"];
//                                                NSString *total_score = [json valueForKey:@"total_score"];
//                                                NSString *position = [json valueForKey:@"position"];
//                                                NSString *total_net_score;
//                                                
//                                                @try {
//                                                    total_net_score = [json valueForKey:@"total_net_score"];
//                                                } @catch (NSException *exception) {
//                                                    total_net_score = [json valueForKey:@"total_score"];
//                                                }
//                                                
//                                                NSDictionary *store_dictin = @{@"total_net_score":total_net_score,@"total_score":total_score,@"user_id":user_id1,@"user_name":user_name,@"position":position};
//                                                [ARR_leaders replaceObjectAtIndex:i withObject:store_dictin];
//                                                
//                                                
//                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                    [self.TBL_leaderboard beginUpdates];
//                                                    NSArray *indexPath0 = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:indxPath.row inSection:0]];
//                                                    [self.TBL_leaderboard reloadRowsAtIndexPaths:indexPath0 withRowAnimation:UITableViewRowAnimationNone];
//                                                    [self.TBL_leaderboard endUpdates];
//                                                });
//                                            }
//                                        }
//                                    }
//                                } @catch (NSException *exception) {
//                                    NSLog(@"Exception from update players %@",json);
//                                    NSArray *ARR_tem;
//                                    @try {
//                                        ARR_tem = [json valueForKey:@"hole_array"];
//                                        [dictin_Scores setObject:ARR_tem forKey:@"hole_array"];
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            self.expandingIndexPath = nil;
//                                            self.expandedIndexPath = nil;
//                                            [self.TBL_leaderboard reloadData];
//                                        });
//                                        
//                                        NSDictionary *DICT_leader;
//                                        @try {
//                                            DICT_leader = [json valueForKey:@"score_card"];
//                                            NSInteger i = [self returnIndexFromDateProperty:[json valueForKey:@"user_id"]];
//                                            //                                            NSDictionary *temp_dictin = [ARR_leaders objectAtIndex:i];
//                                            NSString *user_id1 = [json valueForKey:@"user_id"];
//                                            NSString *user_name = [DICT_leader valueForKey:@"user_name"];
//                                            NSString *total_score = [DICT_leader valueForKey:@"total_score"];
//                                            NSString *total_net_score = [DICT_leader valueForKey:@"total_net_score"];
//                                            //                                            NSString *total_gross_score = [DICT_leader valueForKey:@"total_gross_score"];
//                                            //                                        NSString *user_handicap = [DICT_leader valueForKey:@"user_handicap"];
//                                            NSString *user_position = [DICT_leader valueForKey:@"user_position"];
//                                            
//                                            NSDictionary *store_dictin = @{@"total_net_score":total_net_score,@"total_score":total_score,@"user_id":user_id1,@"user_name":user_name,@"user_position":user_position};
//                                            [ARR_leaders replaceObjectAtIndex:i withObject:store_dictin];
//                                            
//                                            
//                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                self.expandingIndexPath = nil;
//                                                self.expandedIndexPath = nil;
//                                                [self.TBL_leaderboard reloadData];
//                                                
//                                            });
//                                            
//                                        }
//                                        @catch (NSException *exception) {
//                                            NSLog(@"Exception from %@",json);
//                                        }
//                                    }
//                                    @catch (NSException *exception) {
//                                        NSLog(@"Exception from %@",json);
//                                    }
                                    NSDictionary *DICT_leader;
                                    @try {
                                        DICT_leader = [json valueForKey:@"score_card"];
                                        NSInteger i = [self returnIndexFromDateProperty:[json valueForKey:@"user_id"]];
                                        //                                            NSDictionary *temp_dictin = [ARR_leaders objectAtIndex:i];
                                        NSString *user_id1 = [json valueForKey:@"user_id"];
                                        NSString *user_name = [DICT_leader valueForKey:@"user_name"];
                                        NSString *total_score = [DICT_leader valueForKey:@"total_score"];
                                        NSString *total_net_score = [DICT_leader valueForKey:@"total_net_score"];
                                        //                                            NSString *total_gross_score = [DICT_leader valueForKey:@"total_gross_score"];
                                        //                                        NSString *user_handicap = [DICT_leader valueForKey:@"user_handicap"];
                                        NSString *user_position = [DICT_leader valueForKey:@"user_position"];
                                        
                                        NSDictionary *store_dictin = @{@"total_net_score":total_net_score,@"total_score":total_score,@"user_id":user_id1,@"user_name":user_name,@"user_position":user_position};
                                        [ARR_leaders replaceObjectAtIndex:i withObject:store_dictin];
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.expandingIndexPath = nil;
                                            self.expandedIndexPath = nil;
                                            [self.TBL_leaderboard reloadData];
                                            
                                        });
                                        
                                    }
                                    @catch (NSException *exception) {
                                        NSLog(@"Exception from %@",json);
                                        
                                        @try {
                                            TMP_leder = [json valueForKey:@"leader_board"];
                                            if ([TMP_leder count] > 0) {
                                                ARR_leaders = [[NSMutableArray alloc] init];
                                                [ARR_leaders addObjectsFromArray:TMP_leder];
                                                
                                                self.expandingIndexPath = nil;
                                                self.expandedIndexPath = nil;
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                [UIView transitionWithView: self.TBL_leaderboard                                                                                                      duration: 0.35f                                                                                                        options: UIViewAnimationOptionTransitionCrossDissolve                                                                                                    animations: ^(void)
                                                 {
                                                     [self.TBL_leaderboard reloadData];
                                                 }                                                                                                  completion: nil];
                                                    });
                                            }
                                                               
                                        } @catch (NSException *exception) {
                                            NSLog(@"Exception update leaders 1 %@",json);
                                        }
                                        
                                    }
                                    
//                                }
                            }
                            
//                            @try {
//                                TMP_leder = [json valueForKey:@"leader_board"];
//                                if ([TMP_leder count] > 0) {
//                                    ARR_leaders = [[NSMutableArray alloc] init];
//                                    [ARR_leaders addObjectsFromArray:TMP_leder];
//                                    
//                                    self.expandingIndexPath = nil;
//                                    self.expandedIndexPath = nil;
//                                    
//                                    [UIView transitionWithView: self.TBL_leaderboard
//                                                      duration: 0.35f
//                                                       options: UIViewAnimationOptionTransitionCrossDissolve
//                                                    animations: ^(void)
//                                     {
//                                         [self.TBL_leaderboard reloadData];
//                                     }
//                                                    completion: nil];
                            
                                 /*   dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if (!self.expandingIndexPath && !self.expandedIndexPath) {
//                                            [self.TBL_leaderboard reloadData];
                                            
                                        }
                                        else
                                        {
                                            NSString *STR_userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"Selected_USER"];
                                            int usr_id = [STR_userID intValue];
                                            
                                            NSString *STR_jsonUSer = [json valueForKey:@"user_id"];
                                            int jsonUSer = [STR_jsonUSer intValue];
                                            
                                            NSMutableArray *ARR_tem = [[NSMutableArray alloc] init];
                                            NSMutableArray *hole_array = [[NSMutableArray alloc] init];
                                            if (usr_id == jsonUSer) //(dictin_Scores) //
                                            {
                                                NSLog(@"Score update");
                                                
                                                
                                                NSString *STR_index = [json valueForKey:@"hole_number"];
                                                int index = [STR_index intValue];
                                                
                                                @try {
//                                                    ARR_tem = [json valueForKey:@"hole_array"];
//                                                    NSDictionary *Dictin_score = @{@"gross_score":@"",@"handicap":@"",@"net_score":@"",@"par":@"",@"position":@"",@"yards":@""};
//                                                    [dictin_Scores setObject:ARR_tem forKey:@"hole_array"];
//                                                    STR_update_handicap = [json valueForKey:@"handicap"];
                                                } @catch (NSException *exception) {
                                                    NSString *STR_position;
                                                    
                                                    @try {
                                                        STR_position = [json valueForKey:@"position"];
                                                    } @catch (NSException *exception) {
                                                        STR_position = @"0";
                                                    }
                                                    
                                                    [hole_array addObjectsFromArray:[dictin_Scores valueForKey:@"hole_array"]];
                                                    
                                                    NSString *gross_score = [json valueForKey:@"gross_score"];
                                                    NSString *handicap = [[hole_array objectAtIndex:index-1] valueForKey:@"handicap"];
                                                    NSString *net_score = [json valueForKey:@"net_score"];
                                                    NSString *par = [[hole_array objectAtIndex:index-1] valueForKey:@"par"];
                                                    NSString *position = [NSString stringWithFormat:@"%d",index];
                                                    NSString *yards = [[hole_array objectAtIndex:index-1] valueForKey:@"yards"];
                                                    
                                                    NSDictionary *dictin_temp = @{@"gross_score":gross_score,@"handicap":handicap,@"net_score":net_score,@"par":par,@"position":position,@"yards":yards};
                                                    [hole_array replaceObjectAtIndex:index-1 withObject:dictin_temp];
                                                    [dictin_Scores setObject:hole_array forKey:@"hole_array"];
                                                    [dictin_Scores setObject:STR_position forKey:@"position"];
                                                }
                                                
                                                [UIView transitionWithView: self.TBL_leaderboard
                                                                  duration: 0.35f
                                                                   options: UIViewAnimationOptionTransitionCrossDissolve
                                                                animations: ^(void)
                                                 {
                                                     [self.TBL_leaderboard reloadData];
                                                 }
                                                                completion: nil];
//                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                    [self.TBL_leaderboard beginUpdates];
//                                                    NSArray *indexPath0 = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.expandedIndexPath.row inSection:0]];
//                                                    [self.TBL_leaderboard reloadRowsAtIndexPaths:indexPath0 withRowAnimation:UITableViewRowAnimationNone];
//                                                    [self.TBL_leaderboard endUpdates];
//                                                });
                                            }
                                        }
                                        NSLog(@"The expanding index path %@\nExpanded index path %@",self.expandingIndexPath,self.expandedIndexPath);
                                        
                                    });*/
                                    
//                                }
//                            } @catch (NSException *exception) {
//                                NSLog(@"Exception update leaders %@",exception);
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    
//                                    NSString *STR_usr_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"Selected_USER"];
//                                    int usr_id = [STR_usr_id intValue];
//                                    
//                                    NSString *STR_jsonUSer = [json valueForKey:@"user_id"];
//                                    int jsonUSer = [STR_jsonUSer intValue];
//                                    
//                                    NSArray *ARR_tem;
//                                    NSMutableArray *hole_array = [[NSMutableArray alloc] init];
//                                    if (dictin_Scores) {
//                                        if (usr_id == jsonUSer) //(dictin_Scores) //
//                                        {
//                                            NSLog(@"Score update");
//                                            
//                                            
//                                            NSString *STR_index = [json valueForKey:@"hole_number"];
//                                            int index = [STR_index intValue];
//                                            
//                                            @try {
//                                                ARR_tem = [json valueForKey:@"hole_array"];
//                                                [dictin_Scores setObject:ARR_tem forKey:@"hole_array"];
//                                                STR_update_handicap = [json valueForKey:@"handicap"];
//                                            } @catch (NSException *exception) {
//                                                NSString *STR_position;
//                                                
//                                                @try {
//                                                    STR_position = [json valueForKey:@"position"];
//                                                } @catch (NSException *exception) {
//                                                    STR_position = @"0";
//                                                }
//                                                
//                                                [hole_array addObjectsFromArray:[dictin_Scores valueForKey:@"hole_array"]];
//                                                
//                                                NSString *gross_score = [json valueForKey:@"gross_score"];
//                                                NSString *handicap = [[hole_array objectAtIndex:index-1] valueForKey:@"handicap"];
//                                                NSString *net_score = [json valueForKey:@"net_score"];
//                                                NSString *par = [[hole_array objectAtIndex:index-1] valueForKey:@"par"];
//                                                NSString *position = [NSString stringWithFormat:@"%d",index];
//                                                NSString *yards = [[hole_array objectAtIndex:index-1] valueForKey:@"yards"];
//                                                
//                                                NSDictionary *dictin_temp = @{@"gross_score":gross_score,@"handicap":handicap,@"net_score":net_score,@"par":par,@"position":position,@"yards":yards};
//                                                [hole_array replaceObjectAtIndex:index-1 withObject:dictin_temp];
//                                                [dictin_Scores setObject:hole_array forKey:@"hole_array"];
//                                                [dictin_Scores setObject:STR_position forKey:@"position"];
//                                            }
//                                            
//                                            dispatch_async(dispatch_get_main_queue(), ^{
//                                                [self.TBL_leaderboard beginUpdates];
//                                                NSArray *indexPath0 = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.expandedIndexPath.row inSection:0]];
//                                                [self.TBL_leaderboard reloadRowsAtIndexPaths:indexPath0 withRowAnimation:UITableViewRowAnimationNone];
//                                                [self.TBL_leaderboard endUpdates];
//                                            });
//                                        }
//                                    }
//                                });
//                                
//                            }
                        }
                    }
                }
            }
            @catch (NSException *exception)
            {
                NSLog(@"Exception json response%@",exception);
            }
        }
    }
}

-(NSInteger)returnIndexFromDateProperty:(NSString *)property{
    NSInteger iIndex = 0;
    int property1 = [property intValue];
    for (int i = 0; i < [ARR_leaders count]; i++){
        NSString *STR_userid = [[ARR_leaders objectAtIndex:i]valueForKey:@"user_id"];
        int user_id = [STR_userid intValue];
        if(property1 == user_id){
            iIndex = i;
        }
    }
    return iIndex;
}


#pragma mark - KSJActionSocket Deligate Methord
- (void)actionSocketOpened:(KSJActionSocket *)socket
{
    NSLog(@"Connected success");
    [self.actionSocket joinChannelWithName:@"LiveScoringsChannel" andPayload:@{}];
}
- (void)actionSocket:(KSJActionSocket *)socket recievedData:(NSData *)data
{
    [self Sucess:data];
}
- (void)actionSocket:(KSJActionSocket *)socket failedWithError:(NSError *)error
{
    NSLog(@"Socket Closed %@",error);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Socket closed condition" message:[NSString stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",@"Reconnect", nil];
//    alert.tag = 2;
//    [alert show];
    
    [self.actionSocket close];
    self.actionSocket.delegate = Nil;
    
    NSString *STR_url = [NSString stringWithFormat:@"ws://%@",ACTION_CABLE];
    self.actionSocket = [KSJActionSocket socketWithURL:[NSURL URLWithString:STR_url]];
    self.actionSocket.delegate = self;
    [self.actionSocket open];
    
}
- (void)actionSocket:(KSJActionSocket *)socket closedWithCode:(NSInteger)code reason:(NSString *)reason
{
    NSLog(@"Error response %@",reason);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Socket closed condition" message:[NSString stringWithFormat:@"%@",reason] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",@"Reconnect", nil];
//    alert.tag = 3;
//    [alert show];
    
    [self.actionSocket close];
    self.actionSocket.delegate = Nil;
    
    NSString *STR_url = [NSString stringWithFormat:@"ws://%@",ACTION_CABLE];
    self.actionSocket = [KSJActionSocket socketWithURL:[NSURL URLWithString:STR_url]];
    self.actionSocket.delegate = self;
    [self.actionSocket open];
    
}
-(void)actionSocket:(KSJActionSocket *)socket closedWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Socket cloased response %@",reason);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Socket closed condition" message:[NSString stringWithFormat:@"%@",reason] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close",@"Reconnect", nil];
//    alert.tag = 4;
//    [alert show];
    [self.actionSocket close];
    self.actionSocket.delegate = Nil;
    
    NSString *STR_url = [NSString stringWithFormat:@"ws://%@",ACTION_CABLE];
    self.actionSocket = [KSJActionSocket socketWithURL:[NSURL URLWithString:STR_url]];
    self.actionSocket.delegate = self;
    [self.actionSocket open];
}
@end
