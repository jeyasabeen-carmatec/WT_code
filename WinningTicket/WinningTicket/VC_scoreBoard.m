//
//  VC_scoreBoard.m
//  WinningTicket
//
//  Created by Test User on 20/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_scoreBoard.h"
#import "HMSegmentedControl.h"

#import <QuartzCore/QuartzCore.h>

@interface VC_scoreBoard ()

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
    NSString *STR_title = @"VIEW\nCOURSE\nMAP";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:STR_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.0;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [STR_title length])];
    
    _BTN_viewonMAP.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _BTN_viewonMAP.titleLabel.textAlignment = NSTextAlignmentCenter;
    _BTN_viewonMAP.titleLabel.attributedText = attributedString;
//    [_BTN_viewonMAP setTitle:@"VIEW\nCOURSE\nMAP" forState:UIControlStateNormal];
    
    _BTN_viewonMAP.layer.cornerRadius = _BTN_viewonMAP.frame.size.width/2;
    _BTN_viewonMAP.layer.masksToBounds = YES;
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
    
    
//    self.segmentedControl4 
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl4];
    _BTN_viewonMAP.center = _VW_segment.center;
    
    CGRect rect_BTN = _BTN_viewonMAP.frame;
    rect_BTN.origin.y = _BTN_viewonMAP.frame.origin.y - 7;
    _BTN_viewonMAP.frame = rect_BTN;
    
//    _BTN_viewonMAP.layer.shadowColor = [UIColor blackColor].CGColor;
//    _BTN_viewonMAP.layer.shadowOffset = CGSizeMake(3, 3);
//    _BTN_viewonMAP.layer.shadowOpacity = 0.7;
//    _BTN_viewonMAP.layer.shadowRadius = 10.0;
    
    
    UIView* roundedView = [[UIView alloc] initWithFrame: rect_BTN];
    roundedView.layer.cornerRadius = 5.0;
    roundedView.layer.masksToBounds = YES;
    
    UIView* shadowView = [[UIView alloc] initWithFrame: rect_BTN];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowRadius = 1.0;
    shadowView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    shadowView.layer.shadowOpacity = 1.0;
    [shadowView addSubview: roundedView];
    
    [_BTN_viewonMAP addSubview:shadowView];
    
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

@end
