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

#import <QuartzCore/QuartzCore.h>

@interface VC_scoreBoard ()<UIAlertViewDelegate>
{
    NSArray *ARR_holes;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSArray *ARR_displayScore;
    
    NSIndexPath *INdex_Selected,*INDX_STR,*INDX_expanded;
    NSMutableArray *ARR_netScore;
    NSMutableArray *ARR_grossScore;
    
    NSMutableDictionary *DICTIN_PlayerINfo;
    
    NSArray *ARR_leaders;
    
    NSMutableDictionary *dictin_Scores;
}

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
}
#pragma mark - Segment Button IBACTION
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged) aaa", (long)segmentedControl4.selectedSegmentIndex);
    switch (segmentedControl4.selectedSegmentIndex) {
        case 0:
            NSLog(@"Index 0");
            _lbl_Nav_mainTitl.text = @"Your Scorecard";
            _TBL_leaderboard.hidden = YES;
            _TBL_scores.hidden = NO;
            break;
            
        case 1:
            
//            if (VW_overlay.hidden == NO) {
//                NSLog(@"Index 1");
            
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(Leaders_API) withObject:activityIndicatorView afterDelay:0.01];
                
                _lbl_Nav_mainTitl.text = @"Live Leaderboard";
                _TBL_scores.hidden = YES;
                _TBL_leaderboard.hidden = NO;
//            }
//            else
//            {
//                _segmentedControl4.selectedSegmentIndex = 0;
//            }
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Leave Game" message:@"Are you sure to leave the game" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",@"Cancel", nil];
    alert.tag = 1;
    [alert show];
}
-(void) ACTN_viewONMAP
{
    NSLog(@"Btn view on map tapped");
}
-(void) ACTN_btnPLUS
{
    NSLog(@"Btn Plus tapped");
    
    double VAL_STR = [_TXT_Handicap.text doubleValue];
    if (VAL_STR != 36) {
        VAL_STR = VAL_STR + 1;
        _TXT_Handicap.text = [NSString stringWithFormat:@"%.0f",VAL_STR];
    }
    
}
-(void) ACTN_btnMiNUS
{
    NSLog(@"Btn Minus tapped");
    
    double VAL_STR = [_TXT_Handicap.text doubleValue];
    
    if (VAL_STR != -36) {
        VAL_STR = VAL_STR - 1;
        _TXT_Handicap.text = [NSString stringWithFormat:@"%.0f",VAL_STR];
    }
    
}
-(void) ACTN_continueHandicap
{
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
                    
                    if (DBL_totpar != 0) {
                        cell.lbl_result_PAR.text = [NSString stringWithFormat:@"Par %.0f",DBL_totpar];
                    }
                    else
                    {
                        cell.lbl_result_PAR.text = @"Par 0";
                    }
                    
                    cell.lbl_result_score.text = [NSString stringWithFormat:@"Score %.0f/%.0f",DBL_totSCR,DBL_totNet];
                    cell.lbl_result_position.text = [NSString stringWithFormat:@"Pos T-%d",indexPath.row -1];
                    cell.lbl_result_hcp.text = [NSString stringWithFormat:@"HCP - %@",_TXT_Handicap.text];
                    
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_1.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_1.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_1.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_2.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_2.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_2.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_3.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_3.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_3.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_4.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_4.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_4.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_5.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_5.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_5.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_6.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_6.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_6.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_7.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_7.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_7.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_8.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_8.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_8.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par1_9.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score1_9.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore1_9.text = net;
                                
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_1.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_1.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_1.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_2.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_2.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_2.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_3.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_3.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_3.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_4.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_4.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_4.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_5.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_5.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_5.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_6.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_6.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_6.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_7.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_7.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_7.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_8.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_8.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_8.text = net;
                                
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
                                NSString *par,*score,*net;
                                
                                par = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"par"]];
                                par = [par stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_par2_9.text = par;
                                
                                score = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"gross_score"]];
                                score = [score stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_score2_9.text = score;
                                
                                net = [NSString stringWithFormat:@"%@",[Dic_tmp valueForKey:@"net_score"]];
                                net = [net stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                                cell.lbl_Netscore2_9.text = net;
                                
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

                cell.lbl_Position.text = [NSString stringWithFormat:@" %ld",(long)[theIndexPath row]];
                cell.lbl_playerNAme.text = [NSString stringWithFormat:@"  %@",[Dictn_contents valueForKey:@"user_name"]];
                
                NSString *str_01,*STR_02;
                
                str_01 = [NSString stringWithFormat:@" %@",[Dictn_contents valueForKey:@"total_net_score"]];
                str_01 = [str_01 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                cell.lbl_Score.text = str_01;
                
                STR_02 = [NSString stringWithFormat:@" %@",[Dictn_contents valueForKey:@"total_score"]];
                STR_02 = [STR_02 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                cell.lbl_Topar.text = STR_02;
                
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
                        
            cell.lbl_distance.text = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"yards"]];
            
            frame_lbl = cell.lbl_distance.frame;
            frame_lbl.origin.x = cell.lbl_hole.frame.origin.x + cell.lbl_hole.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_distance.frame = frame_lbl;
            
            
            NSString *STR_grossSCORE = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"gross_score"]];
            
            if ([STR_grossSCORE isEqualToString:@"<null>"]) {
                @try {
                    cell.lbl_gross_score.text = [ARR_grossScore objectAtIndex:indexPath.row - 1];
                } @catch (NSException *exception) {
                    cell.lbl_gross_score.text = @"";
                }
            }
            else if (INdex_Selected.row == indexPath.row)
            {
                @try {
                    cell.lbl_gross_score.text = [ARR_grossScore objectAtIndex:indexPath.row - 1];
                } @catch (NSException *exception) {
                    cell.lbl_gross_score.text = @"";
                }
            }
            else
            {
                cell.lbl_gross_score.text = STR_grossSCORE;
            }
            
            
            frame_lbl = cell.VW_grossScore.frame;
            frame_lbl.origin.x = cell.lbl_distance.frame.origin.x + cell.lbl_distance.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.VW_grossScore.frame = frame_lbl;
            
            
            NSString *STR_NetSocre = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"net_score"]];
            
            if ([STR_NetSocre isEqualToString:@"<null>"]) {
                @try {
                    cell.lbl_net_score.text = [ARR_netScore objectAtIndex:indexPath.row - 1];
                } @catch (NSException *exception) {
                    cell.lbl_net_score.text = @"";
                }
            }
            else if (INdex_Selected.row == indexPath.row)
            {
                @try {
                    cell.lbl_net_score.text = [ARR_netScore objectAtIndex:indexPath.row - 1];
                } @catch (NSException *exception) {
                    cell.lbl_net_score.text = @"";
                }
            }
            else
            {
                cell.lbl_net_score.text = STR_NetSocre;
            }
            
            
            frame_lbl = cell.lbl_net_score.frame;
            frame_lbl.origin.x = cell.VW_grossScore.frame.origin.x + cell.VW_grossScore.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_net_score.frame = frame_lbl;
            
            cell.lbl_handicap.text = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"handicap"]];
            
            frame_lbl = cell.lbl_handicap.frame;
            frame_lbl.origin.x = cell.lbl_net_score.frame.origin.x + cell.lbl_net_score.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_handicap.frame = frame_lbl;
            
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
            
//            NSLog(@"Leader board frame = %@",NSStringFromCGRect(_TBL_leaderboard.frame));
            float FR_width = (_TBL_leaderboard.frame.size.width - 114) / 9;
            float FR_height = (FR_width * 8) + 34;
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                return FR_height - 30;
            }
            else
            {
                return FR_height;
            }
            
        }
        else {
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                return 45;
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
             /*   // disable touch on expanded cell
                //            UITableViewCell *cell = [self.TBL_leaderboard cellForRowAtIndexPath:indexPath];
                //            if ([[cell reuseIdentifier] isEqualToString:@"ExpandedCellIdentifier"]) {
                //                return;
                //            }
                
                // deselect row
                [tableView deselectRowAtIndexPath:indexPath
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
                
                
               
                if (theExpandedIndexPath) {
                    
                    if (self.expandedIndexPath) {
                    }
                    else
                    {
                        [tableView beginUpdates];
                        [_TBL_leaderboard deleteRowsAtIndexPaths:@[theExpandedIndexPath]
                                                withRowAnimation:UITableViewRowAnimationNone];
                        [tableView endUpdates];
                    }
                    [self.TBL_leaderboard scrollToRowAtIndexPath:indexPath
                                                atScrollPosition:UITableViewScrollPositionMiddle
                                                        animated:YES];
                }
                
                
                // scroll to the expanded cell
                
                if (self.expandedIndexPath) {
                    
              
                    
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(LeaderDetail_API) withObject:activityIndicatorView afterDelay:0.01];
                    
//                    [_TBL_leaderboard insertRowsAtIndexPaths:@[self.expandedIndexPath]
//                                            withRowAnimation:UITableViewRowAnimationNone];
                
                }
                */
            
//                VW_overlay.hidden = NO;
//                [activityIndicatorView startAnimating];
//                [self performSelector:@selector(update_tableView:) withObject:activityIndicatorView withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>]
                [self update_tableView:indexPath];
                
            }
        }
            
    }
    else
    {
        if (indexPath.row == 0) {
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

/*-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _TBL_leaderboard) {
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = [UIColor lightGrayColor];
        } else {
            cell.backgroundColor =[UIColor whiteColor];
        }
    }
}*/
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
    NSDictionary *DICTN_info = [ARR_holes objectAtIndex:INdex_Selected.row - 1];
    
    VC_score_update *vc = segue.destinationViewController;
    vc.STR_parSTR = [DICTN_info valueForKey:@"par"];
    vc.delegate = self;
}



#pragma mark - Update score Deligate
-(void)get_SCORE:(NSString *)STR_score
{
    //    NSLog(@"received data %@",ARR_scores);
    //    if ([ARR_scores count] > [ARR_displayScore count]) {
    //
    //        [_TBL_scores beginUpdates];
    //        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[ARR_scores count] inSection:0]];
    //
    //        [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    //        [_TBL_scores endUpdates];
    //    }
    
    NSLog(@"Value return = %@ Index selected %ld",STR_score,(long)INdex_Selected.row);
    
    //    -(void) get_GRoss_SCORE : (NSString *)STR_scoreVAL
    [self get_GRoss_SCORE:STR_score];
    
//    [ARR_grossScore insertObject:STR_score atIndex:INdex_Selected.row-1];
    
    [_TBL_scores beginUpdates];
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:INdex_Selected.row inSection:0]];
    [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    [_TBL_scores endUpdates];
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
        NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        NSLog(@"Json response UPDATE_handicap = %@",dict);
        
        DICTIN_PlayerINfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]],@"STR_playerName",@"",@"STR_team",[NSString stringWithFormat:@"%@",_TXT_Handicap.text],@"STR_HCP",[NSString stringWithFormat:@"%@",[dict valueForKey:@"total_score"]],@"Total", nil];
        
        
        if ([ARR_grossScore count] == 0) {
            ARR_grossScore = [[NSMutableArray alloc] init];
            ARR_netScore = [[NSMutableArray alloc] init];
            
            ARR_holes = [dict valueForKey:@"hole_info"];
            
            for (int i = 0; i < [ARR_holes count]; i++) {
                [ARR_grossScore addObject:@""];
                [ARR_netScore addObject:@""];
            }
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
    
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@/hole_info/%@",SERVER_URL,[event valueForKey:@"id"]]];
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
        
        if ([ARR_grossScore count] == 0) {
            ARR_grossScore = [[NSMutableArray alloc] init];
            ARR_netScore = [[NSMutableArray alloc] init];
            
            ARR_holes = [dict valueForKey:@"hole_info"];
            //        NSLog(@"Json response Hole = %@",dict);
            
            for (int i = 0; i < [ARR_holes count]; i++) {
                [ARR_grossScore addObject:@""];
                [ARR_netScore addObject:@""];
            }
        }
        
        
        
        
        
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

-(void) get_GRoss_SCORE : (NSString *)STR_scoreVAL
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    
    NSDictionary *DICTN_info = [ARR_holes objectAtIndex:INdex_Selected.row - 1];
    
    NSDictionary *parameters = @{ @"hole_number":[DICTN_info valueForKey:@"position"],@"gross_score":  STR_scoreVAL};
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
        
        [DICTIN_PlayerINfo setObject:[NSString stringWithFormat:@"%@",[dict valueForKey:@"total_score"]]  forKey:@"Total"];
        
        NSString *STR_netScore = [NSString stringWithFormat:@"%@",[dict valueForKey:@"net_score"]];
        NSString *gross_score = [NSString stringWithFormat:@"%@",[dict valueForKey:@"gross_score"]];
        
        [ARR_netScore insertObject:STR_netScore atIndex:INdex_Selected.row-1];
        [ARR_grossScore insertObject:gross_score atIndex:INdex_Selected.row-1];
        
        [_TBL_scores beginUpdates];
        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:INdex_Selected.row inSection:0]];
        NSArray *indexPath0 = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [_TBL_scores reloadRowsAtIndexPaths:indexPath0 withRowAnimation:UITableViewRowAnimationFade];
        [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [_TBL_scores endUpdates];
        
        
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
        ARR_leaders = [dict valueForKey:@"leader_board"];
        
        if ([ARR_leaders count] != 0) {
            [_TBL_leaderboard reloadData];
        }
        
        
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
}




@end
