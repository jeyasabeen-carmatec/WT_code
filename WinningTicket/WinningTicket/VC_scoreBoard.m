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

#import <QuartzCore/QuartzCore.h>

@interface VC_scoreBoard ()
{
    NSArray *ARR_holes;
}

@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;

@end

@implementation VC_scoreBoard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
                break;
    
            case 1:
                NSLog(@"Index 1");
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
#pragma mark - Tableview Datasource/Deligate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;//[ARR_holes count] + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        
        NSString *STR_playerName = @"Bobby\nBradley";
        NSString *STR_team = @"Team 1";
        NSString *STR_HCP = @"// HCP - 18";
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
        
        CGRect frame_lbl = cell.lbl_hole.frame;
        frame_lbl.origin.x = 0;
        frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
        cell.lbl_hole.frame = frame_lbl;
        
        
//        cell.lbl_hole.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell.lbl_hole.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
//        cell.lbl_hole.layer.shadowOpacity = 0.7f;
//        cell.lbl_hole.layer.shadowRadius = 4.0f;
//        CGRect shadowRect = CGRectInset(cell.lbl_hole.bounds, 0, 4);  // inset top/bottom
//        cell.lbl_hole.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        
        frame_lbl = cell.lbl_distance.frame;
        frame_lbl.origin.x = cell.lbl_hole.frame.origin.x + cell.lbl_hole.frame.size.width;
        frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
        cell.lbl_distance.frame = frame_lbl;
       
//        cell.lbl_distance.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell.lbl_distance.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
//        cell.lbl_distance.layer.shadowOpacity = 0.7f;
//        cell.lbl_distance.layer.shadowRadius = 4.0f;
//        shadowRect = CGRectInset(cell.lbl_distance.bounds, 0, 4);  // inset top/bottom
//        cell.lbl_distance.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        
        frame_lbl = cell.VW_grossScore.frame;
        frame_lbl.origin.x = cell.lbl_distance.frame.origin.x + cell.lbl_distance.frame.size.width;
        frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
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
        
        frame_lbl = cell.lbl_net_score.frame;
        frame_lbl.origin.x = cell.VW_grossScore.frame.origin.x + cell.VW_grossScore.frame.size.width;
        frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
        cell.lbl_net_score.frame = frame_lbl;
        
//        cell.lbl_net_score.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell.lbl_net_score.layer.shadowOffset = CGSizeMake(0.0f,-8.0f);
//        cell.lbl_net_score.layer.shadowOpacity = 0.7f;
//        cell.lbl_net_score.layer.shadowRadius = 4.0f;
//        shadowRect = CGRectInset(cell.lbl_net_score.bounds, 0, 4);  // inset top/bottom
//        cell.lbl_net_score.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        
        frame_lbl = cell.lbl_handicap.frame;
        frame_lbl.origin.x = cell.lbl_net_score.frame.origin.x + cell.lbl_net_score.frame.size.width;
        frame_lbl.size.width = _TBL_scores.frame.size.width / 5;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 88;
    }
    else{
        return 44;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Did select row tapped");
}

@end
