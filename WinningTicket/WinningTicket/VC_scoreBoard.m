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
#import "HMSegmentedControl.h"
#import "DICTIN_holes.h"
//#import "ARR_grossScore.h"
#import "VC_score_update.h"

#import <QuartzCore/QuartzCore.h>

@interface VC_scoreBoard ()
{
    NSArray *ARR_holes;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSArray *ARR_displayScore;
    
    NSIndexPath *INdex_Selected;
    NSMutableArray *ARR_netScore;
    NSMutableArray *ARR_grossScore;
    
    NSDictionary *DICTIN_PlayerINfo;
}

@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;

@end

@implementation VC_scoreBoard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [ARR_grossScore Clear_ARR];
    
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
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
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
                NSLog(@"Index 1");
                _lbl_Nav_mainTitl.text = @"Live Leaderboard";
                _TBL_scores.hidden = YES;
                _TBL_leaderboard.hidden = NO;
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
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
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
        return 1;//Leaderboard value
    }
    return [ARR_holes count] + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _TBL_leaderboard) {
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
        
        NSString *STR_playerName,*STR_team,*STR_HCP;
        
        
        STR_playerName = [DICTIN_PlayerINfo valueForKey:@"STR_playerName"];//@"Bobby\nBradley"
        STR_team = [DICTIN_PlayerINfo valueForKey:@"STR_team"];//@"Team 1"
        STR_HCP = [DICTIN_PlayerINfo valueForKey:@"STR_HCP"]; //@"// HCP - 18";
        
        if (!STR_playerName) {
            STR_playerName = @"";
        }
        
        if (!STR_team) {
            STR_team = @"";
        }
        
        if (!STR_HCP) {
            STR_HCP = @"";
        }
        
        
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
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:12.0]}
                                        range:cmp];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:14.0]}
                                        range:range_HCP];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:10.0]}
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
        
        cell.lbl_score.text = @"";
        
        
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
            
            NSString *STR_playerName,*STR_team,*STR_HCP;
            
            
            STR_playerName = [DICTIN_PlayerINfo valueForKey:@"STR_playerName"];//@"Bobby\nBradley"
            STR_team = [DICTIN_PlayerINfo valueForKey:@"STR_team"];//@"Team 1"
            STR_HCP = [DICTIN_PlayerINfo valueForKey:@"STR_HCP"]; //@"// HCP - 18";
            
            if (!STR_playerName) {
                STR_playerName = @"";
            }
            
            if (!STR_team) {
                STR_team = @"";
            }
            
            if (!STR_HCP) {
                STR_HCP = @"";
            }
            
            
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
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:12.0]}
                                            range:cmp];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:14.0]}
                                            range:range_HCP];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:10.0]}
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
            
            cell.lbl_score.text = @"";
            
            
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
            
            
            //        cell.lbl_hole.layer.shadowColor = [[UIColor blackColor] CGColor];
            //        cell.lbl_hole.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
            //        cell.lbl_hole.layer.shadowOpacity = 0.7f;
            //        cell.lbl_hole.layer.shadowRadius = 4.0f;
            //        CGRect shadowRect = CGRectInset(cell.lbl_hole.bounds, 0, 4);  // inset top/bottom
            //        cell.lbl_hole.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
            
            cell.lbl_distance.text = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"yards"]];
            
            frame_lbl = cell.lbl_distance.frame;
            frame_lbl.origin.x = cell.lbl_hole.frame.origin.x + cell.lbl_hole.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_distance.frame = frame_lbl;
            
            //        cell.lbl_distance.layer.shadowColor = [[UIColor blackColor] CGColor];
            //        cell.lbl_distance.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
            //        cell.lbl_distance.layer.shadowOpacity = 0.7f;
            //        cell.lbl_distance.layer.shadowRadius = 4.0f;
            //        shadowRect = CGRectInset(cell.lbl_distance.bounds, 0, 4);  // inset top/bottom
            //        cell.lbl_distance.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
            
            @try {
                cell.lbl_gross_score.text = [ARR_grossScore objectAtIndex:indexPath.row - 1];
            } @catch (NSException *exception) {
                cell.lbl_gross_score.text = @"";
            }
            
            
            frame_lbl = cell.VW_grossScore.frame;
            frame_lbl.origin.x = cell.lbl_distance.frame.origin.x + cell.lbl_distance.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.VW_grossScore.frame = frame_lbl;
            
            //        cell.VW_grossScore.layer.shadowColor = [[UIColor blackColor] CGColor];
            //        cell.VW_grossScore.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
            //        cell.VW_grossScore.layer.shadowOpacity = 0.7f;
            //        cell.VW_grossScore.layer.shadowRadius = 4.0f;
            //        shadowRect = CGRectInset(cell.VW_grossScore.bounds, 0, 4);  // inset top/bottom
            //        cell.VW_grossScore.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
            
            //        frame_lbl = cell.lbl_gross_score.frame;
            //        frame_lbl.origin.x = cell.lbl_distance.frame.origin.x + cell.lbl_distance.frame.size.width;
            //        frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            //        cell.lbl_gross_score.frame = frame_lbl;
            
            @try {
                cell.lbl_net_score.text = [ARR_netScore objectAtIndex:indexPath.row - 1];
            } @catch (NSException *exception) {
                cell.lbl_net_score.text = @"";
            }
            
            frame_lbl = cell.lbl_net_score.frame;
            frame_lbl.origin.x = cell.VW_grossScore.frame.origin.x + cell.VW_grossScore.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_net_score.frame = frame_lbl;
            
            //        cell.lbl_net_score.layer.shadowColor = [[UIColor blackColor] CGColor];
            //        cell.lbl_net_score.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
            //        cell.lbl_net_score.layer.shadowOpacity = 0.7f;
            //        cell.lbl_net_score.layer.shadowRadius = 4.0f;
            //        shadowRect = CGRectInset(cell.lbl_net_score.bounds, 0, 4);  // inset top/bottom
            //        cell.lbl_net_score.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
            
            cell.lbl_handicap.text = [NSString stringWithFormat:@"%@",[DICTN_info valueForKey:@"handicap"]];
            
            frame_lbl = cell.lbl_handicap.frame;
            frame_lbl.origin.x = cell.lbl_net_score.frame.origin.x + cell.lbl_net_score.frame.size.width;
            frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
            frame_lbl.size.height = 60;
            cell.lbl_handicap.frame = frame_lbl;
            
            //        cell.lbl_handicap.layer.shadowColor = [[UIColor blackColor] CGColor];
            //        cell.lbl_handicap.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
            //        cell.lbl_handicap.layer.shadowOpacity = 0.7f;
            //        cell.lbl_handicap.layer.shadowRadius = 4.0f;
            //        shadowRect = CGRectInset(cell.lbl_net_score.bounds, 0, 4);  // inset top/bottom
            //        cell.lbl_handicap.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
            
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 88;
    }
    else{
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INdex_Selected = indexPath;
    
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
        [self performSegueWithIdentifier:@"scoreUpdateIdentifier" sender:self];
    }
//    NSLog(@"Did select row tapped");
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VC_score_update *vc = segue.destinationViewController;
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
    
    [ARR_grossScore insertObject:STR_score atIndex:INdex_Selected.row-1];
    
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
        
        //        VW_overlay.hidden = YES;
        
        //        NSString *STR_playerName = @"Bobby\nBradley";
        //        NSString *STR_team = @"Team 1";
        //        NSString *STR_HCP = @"// HCP - 18";
        DICTIN_PlayerINfo = @{@"STR_playerName":@"Bobby\nBradley",@"STR_team":@"Team 1",@"STR_HCP":[NSString stringWithFormat:@"%@",_TXT_Handicap.text]};
        
        
        [self HOLES_API];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
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
        
        NSString *STR_netScore = [NSString stringWithFormat:@"%@",[dict valueForKey:@"net_score"]];
        [ARR_netScore insertObject:STR_netScore atIndex:INdex_Selected.row-1];
        
//        [_TBL_scores beginUpdates];
//        NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:INdex_Selected.row inSection:0]];
//        [_TBL_scores reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
//        [_TBL_scores endUpdates];
        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

@end
