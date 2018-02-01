//
//  LIve_scoring_VC.m
//  WinningTicket
//
//  Created by Test User on 04/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "LIve_scoring_VC.h"
#import  <CoreLocation/CoreLocation.h>
#import "VC_score_collection.h"

@interface LIve_scoring_VC () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation LIve_scoring_VC

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _location_view.hidden =YES;
    _BG_vw.layer.borderWidth = 1.0f;
    _BG_vw.layer.borderColor = [UIColor whiteColor].CGColor;
    _event_dtl_lbl.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_name"];
    _event_addr_lbl .text = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_address"];
//    _event_addr_lbl .text = [NSString stringWithFormat:@"Grand central Cypress Club\n1 N Jacaranda Street\nOrlando ,FL32836"];
    [_event_dtl_lbl sizeToFit];
    [_event_addr_lbl sizeToFit];
    CGRect newframe = _main_img.frame;
    newframe.origin.y =[UIScreen mainScreen].bounds.size.height / 4 - 10;
    _main_img.frame = newframe;
    
    newframe = _live_score_lbl.frame;
    newframe.origin.y = _main_img.frame.origin.y + _main_img.frame.size.height + 10;
    _live_score_lbl.frame = newframe;
    
    newframe = _scorecard.frame;
    newframe.origin.y = _live_score_lbl.frame.origin.y + _live_score_lbl.frame.size.height;
    _scorecard.frame = newframe;
    
    newframe = _BG_vw.frame;
    newframe.origin.y = _scorecard.frame.origin.y + _scorecard.frame.size.height + 10;
    _BG_vw.frame = newframe;
    
    newframe = _event_dtl_lbl.frame;
    newframe.origin.y = _vw_line1.frame.origin.y + _vw_line1.frame.size.height + 10;
    _event_dtl_lbl.frame = newframe;
    
    newframe = _vw_line2.frame;
    newframe.origin.y =  _event_dtl_lbl.frame.origin.y+_event_dtl_lbl.frame.size.height + 10;
    _vw_line2.frame = newframe;
    
    newframe = _event_addr_lbl.frame;
    newframe.origin.y = _vw_line2.frame.origin.y + _vw_line2.frame.size.height + 10;
    _event_addr_lbl.frame = newframe;
    
    newframe = _BG_vw.frame;
    newframe.size.height = _event_addr_lbl.frame.origin.y + _event_addr_lbl.frame.size.height + 10;
    _BG_vw.frame = newframe;
    
    newframe = _live_score.frame;
    newframe.origin.y = _BG_vw.frame.origin.y + _BG_vw.frame.size.height + 20;
    _live_score.frame = newframe;
    _BTN_not_now.layer.borderWidth = 2.0f;
    _BTN_not_now.layer.borderColor = [UIColor blackColor].CGColor;
    _location_description.text = [NSString stringWithFormat:@"To find by near by courses and utilize the\nWinning Ticket GPS tracker.You must\n       enbale your location services"];
    [_location_description sizeToFit];
    [_live_score addTarget:self action:@selector(show_view) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_enable addTarget:self action:@selector(open_location) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_not_now addTarget:self action:@selector(dismiss_view) forControlEvents:UIControlEventTouchUpInside];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height <= 480)
        {
            // iPhone Classic
          [_location_description setFont:[UIFont systemFontOfSize:11]];
           
        }
        else if(result.height <= 568)
        {
            // iPhone 5
             [_location_description setFont:[UIFont systemFontOfSize:11]];
           
        }
    }

    [self setup_VIEW];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scroll_content layoutIfNeeded];
    _scroll_content.contentSize = CGSizeMake(_scroll_content.frame.size.width, _live_score.frame.size.height + _live_score.frame.origin.y);
    
    [_SCRL_contents layoutIfNeeded];
    [_SCRL_contents setContentSize:CGSizeMake(_SCRL_contents.frame.size.width, _VW_contents.frame.origin.y + _VW_contents.frame.size.height)];
}
#pragma Button Actions
-(void)show_view
{
    
        CGRect viewframe = _location_view.frame;
        viewframe.origin.x = _BG_vw.frame.origin.x;
        viewframe.origin.y = _main_img.frame.origin.y ;
        viewframe.size.width = _BG_vw.frame.size.width;
        viewframe.size.height = _location_view.frame.size.height;
        _location_view.frame = viewframe;
        [self.view addSubview:_location_view];
        self.location_view.layer.cornerRadius = 4.0f;
    
    //[self checkLocationServicesTurnedOn];
    [self checkApplicationHasLocationServicesPermission];

}
-(void)dismiss_view
{
     _location_view.hidden = YES;
}
-(void)open_location
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
     _location_view.hidden = YES;

}
- (void) checkLocationServicesTurnedOn {
    if (![CLLocationManager locationServicesEnabled]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"== Opps! =="
//                                                        message:@"'Location Services' need to be on."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
      //  [alert show];
        
    }     
}
-(void) checkApplicationHasLocationServicesPermission {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
         self.location_view.hidden = NO;
        
    }
    else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                                message:@"Already turned on"
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//        [self performSegueWithIdentifier:@"start_score_segue" sender:self];
        
        _VW_mainCont.hidden = NO;

    }
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

#pragma mark - Button Actions
-(IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Uiview customisation
-(void) setup_VIEW
{
    _VW_mainCont.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:_VW_mainCont];
    
    _VW_mainCont.hidden = YES;
    
    _collec_contents.dataSource = self;
    _collec_contents.delegate = self;
    [_collec_contents reloadData];
    [_collec_contents layoutIfNeeded];
    
    CGRect frame_rect = _collec_contents.frame;
    frame_rect.size.height = _collec_contents.contentSize.height;
    _collec_contents.frame = frame_rect;
    
    frame_rect = _BTN_continue.frame;
    frame_rect.origin.y = _collec_contents.frame.origin.y + _collec_contents.frame.size.height + 10;
    _BTN_continue.frame = frame_rect;
    
    CGRect frame_VW = _VW_contents.frame;
    frame_VW.size.height = _BTN_continue.frame.origin.y + _BTN_continue.frame.size.height + 10;
    frame_VW.size.width = self.view.frame.size.width;
    _VW_contents.frame = frame_VW;
    
    [_SCRL_contents addSubview:_VW_contents];
    
    [_BTN_continue addTarget:self action:@selector(ACTIN_continue) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - COllection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 25;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VC_score_collection *cell = (VC_score_collection *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.num_label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    cell.des_lbl.text = @"Eagle";
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return CGSizeMake(self.view.frame.size.width/3 -14 , 120);
    }
    else
    {
        return CGSizeMake(self.view.frame.size.width/3 -14 , 80);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 3.0f;
    cell.layer.borderColor = self.view.tintColor.CGColor;
    
    NSLog(@"Selected index = %ld",(long)indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.0];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
}

#pragma mark - Uibutton Actions
-(void) ACTIN_continue
{
//    [self performSegueWithIdentifier:@"enter_GAME" sender:self];
    _VW_mainCont.hidden = YES;
    [self performSegueWithIdentifier:@"select_hole" sender:self];
}

@end
