//
//  VC_home.m
//  WinningTicket
//
//  Created by Test User on 27/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_home.h"
#import "TBL_VW_Cell_EVENTS.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"

#import "ViewController.h"

#import "WinningTicket_Universal-Swift.h"

@interface VC_home ()<UIGestureRecognizerDelegate>
{
    NSArray *ARR_allevent,*ARR_upcommingevent;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
    
    CGRect frame_IMAGE,frame_VIEW;
    float diff;
}

@end

@implementation VC_home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scroll_content.delegate = self;
    
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
-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    _tbl_all_event.estimatedRowHeight = 10.0;
    _tbl_all_event.rowHeight = UITableViewAutomaticDimension;
    _tbl_all_event.allowsSelection = NO;
    
    _tbl_upcomming_event.estimatedRowHeight = 10.0;
    _tbl_upcomming_event.rowHeight = UITableViewAutomaticDimension;
    _tbl_upcomming_event.allowsSelection = NO;
    
    [self get_Data];
    [self setup_VIEW];
    [self setup_VIEW];
    [self myprofileapicalling];
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
//    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    
//    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 200, 22)];
//    loadingLabel.backgroundColor = [UIColor clearColor];
//    loadingLabel.textColor = [UIColor whiteColor];
//    loadingLabel.adjustsFontSizeToFitWidth = YES;
//    loadingLabel.textAlignment = NSTextAlignmentCenter;
//    loadingLabel.text = @"Loading...";
//    
//    [VW_overlay addSubview:loadingLabel];
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
    
    for (int i=0; i<[self.segment_bottom.subviews count]; i++)
    {
        [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
        if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
        {
            UIColor *tintcolor=[UIColor clearColor];
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
//            UIColor *tintcolor=[UIColor blueColor];
//            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
    }
    
}

-(void) backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Customise view
-(void) setup_VIEW
{
    [_tab_HOME setSelectedItem:[_tab_HOME.items objectAtIndex:0]];
    [_segment_bottom setSelectedSegmentIndex:0];

    
    _lbl_titl_event_code.hidden = YES;
    _VW_hold_code.hidden = YES;
    _BTN_cancel.hidden = YES;
    _BTN_enter_event_code.hidden = YES;
    _BTN_enter_event_code.enabled = NO;
//    _BTN_enter_event_code.alpha = 0.5;
    [_BTN_view_all_event addTarget:self action:@selector(BTN_enter_event_code:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_cancel addTarget:self action:@selector(BTN_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_enter_event_code addTarget:self action:@selector(BTN_enter_code:) forControlEvents:UIControlEventTouchUpInside];
    
    _TXT_0.tag = 0;
    _TXT_1.tag = 1;
    _TXT_2.tag = 2;
    _TXT_3.tag = 3;
    _TXT_4.tag = 4;
    _TXT_5.tag = 5;
    

    if (_BTN_view_all_event.hidden == YES) {
    
        _TXT_0.text = @"";
        _TXT_1.text = @"";
        _TXT_2.text = @"";
        _TXT_3.text = @"";
        _TXT_4.text = @"";
        _TXT_5.text = @"";
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.8];
        _BTN_view_all_event.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_BTN_view_all_event cache:YES];
        [UIView commitAnimations];
        
        _lbl_titl_event_code.hidden = YES;
        
        [UIView transitionWithView:_VW_hold_code
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:NULL
                        completion:NULL];
        [self.VW_hold_code  setHidden:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
            _lbl_upcoming_event.frame = CGRectMake(_lbl_upcoming_event.frame.origin.x, _lbl_upcoming_event.frame.origin.y - 85, _lbl_upcoming_event.frame.size.width, _lbl_upcoming_event.frame.size.height);
            _scroll_content.frame = CGRectMake(_scroll_content.frame.origin.x, _scroll_content.frame.origin.y - 85, _scroll_content.frame.size.width, _scroll_content.frame.size.height + 85);
            _VW_hold_BTN.frame = CGRectMake(_VW_hold_BTN.frame.origin.x, _VW_hold_BTN.frame.origin.y, _VW_hold_BTN.frame.size.width, _VW_hold_BTN.frame.size.height - 85);
        }];
        [UIView commitAnimations];
        
        [UIView transitionWithView:_BTN_cancel
                          duration:0.1
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:NULL
                        completion:NULL];
        [self.BTN_cancel  setHidden:YES];
        
        [UIView transitionWithView:_BTN_enter_event_code
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:NULL
                        completion:NULL];
        [self.BTN_enter_event_code  setHidden:YES];
    }
    
    CGRect new_frame = _tbl_upcomming_event.frame;
    new_frame.size.height = [self upcommingEvent_height];
    _tbl_upcomming_event.frame = new_frame;
    
    new_frame = _lbl_titleallevents.frame;
    new_frame.origin.y = _tbl_upcomming_event.frame.origin.y + [self upcommingEvent_height] + 15;
    _lbl_titleallevents.frame = new_frame;
    
    new_frame = _VW_allevent_HEAD.frame;
    new_frame.origin.y = _lbl_titleallevents.frame.origin.y + _lbl_titleallevents.frame.size.height + 5;
    _VW_allevent_HEAD.frame = new_frame;
    
    new_frame = _tbl_all_event.frame;
    new_frame.origin.y = _VW_allevent_HEAD.frame.origin.y + _VW_allevent_HEAD.frame.size.height;
    new_frame.size.height = [self allEvent_height];
    _tbl_all_event.frame = new_frame;
    
    new_frame = _BTN_all_event.frame;
    new_frame.origin.y = _tbl_all_event.frame.origin.y + [self allEvent_height] + 15;
    new_frame.size.height = _BTN_all_event.frame.size.height;
    _BTN_all_event.frame = new_frame;
    
    [_BTN_all_event addTarget:self action:@selector(get_ALLevents) forControlEvents:UIControlEventTouchUpInside];
//    [_VW_Scroll_CONTENT addSubview:_BTN_all_event];
    
    CGRect frame = _scroll_content.frame;
    frame.origin.y = 0.0f;
    frame.origin.x = 0.0f;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = _BTN_all_event.frame.origin.y + _BTN_all_event.frame.size.height + 20;
    _VW_Scroll_CONTENT.frame = frame;
    
    [_scroll_content addSubview:_VW_Scroll_CONTENT];
//    CGRect new_frame = _scroll_content.frame;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"contributor" forKey:@"LoginSTAT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}

#pragma mark - Tabbar deligate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"EVENTS"])
    {
        NSLog(@"Events selected");
        [_segment_bottom setSelectedSegmentIndex:0];
        for (int i=0; i<[self.segment_bottom.subviews count]; i++)
        {
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
            if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
            {
                UIColor *tintcolor=[UIColor clearColor];
                [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
            else
            {
                //            UIColor *tintcolor=[UIColor blueColor];
                //            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
        }
    }
    else if ([item.title isEqualToString:@"COURSES"])
    {
        NSLog(@"COURSES selected");
        [_segment_bottom setSelectedSegmentIndex:1];
        for (int i=0; i<[self.segment_bottom.subviews count]; i++)
        {
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
            if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
            {
                UIColor *tintcolor=[UIColor clearColor];
                [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
            else
            {
                //            UIColor *tintcolor=[UIColor blueColor];
                //            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
        }
        [self performSegueWithIdentifier:@"courseviewcontroller" sender:self];
    }
    else
    {
        NSLog(@"ACCOUNT selected");
        [_segment_bottom setSelectedSegmentIndex:2];
        for (int i=0; i<[self.segment_bottom.subviews count]; i++)
        {
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
            if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
            {
                UIColor *tintcolor=[UIColor clearColor];
                [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
            else
            {
                //            UIColor *tintcolor=[UIColor blueColor];
                //            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
        }
        [self performSegueWithIdentifier:@"accountsviewcontroller" sender:self];
    }
}


#pragma mark - Scroll view
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scroll_content layoutIfNeeded];
    [_tbl_upcomming_event layoutIfNeeded];
    [_tbl_all_event layoutIfNeeded];
    _scroll_content.contentSize = CGSizeMake(_scroll_content.frame.size.width, _VW_Scroll_CONTENT.frame.size.height);
}

#pragma mark - Determine Height
- (CGFloat)upcommingEvent_height
{
    [_tbl_upcomming_event layoutIfNeeded];
    
    NSLog(@"Upcomming event Height = %f",[_tbl_upcomming_event contentSize].height);
    
    return [_tbl_upcomming_event contentSize].height;
    
}
- (CGFloat)allEvent_height
{
    [_tbl_all_event layoutIfNeeded];
    
    NSLog(@"All event Height = %f",[_tbl_all_event contentSize].height);
    
    return [_tbl_all_event contentSize].height;
    
}

#pragma Mark - UITableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbl_all_event)
    {
        if ([ARR_allevent count] == 0) {
            return 1;
        }
        else
        {
            return [ARR_allevent count];
        }
    }
    if (tableView == _tbl_upcomming_event)
    {
        if ([ARR_upcommingevent count] == 0) {
            return 1;
        }
        else
        {
            return [ARR_upcommingevent count];
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    if (tableView == _tbl_upcomming_event)
    {
        if ([ARR_upcommingevent count] == 0) {
            cell_EMPTY_val *cell = (cell_EMPTY_val *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"cell_EMPTY_val~iPad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"cell_EMPTY_val" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            cell.lbl_emptycell.text = @"No Upcoming Events";
            cell.lbl_emptycell.numberOfLines = 0;
            [cell.lbl_emptycell sizeToFit];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        else
        {
            TBL_VW_Cell_EVENTS *cell = (TBL_VW_Cell_EVENTS *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TBL_VW_Cell_EVENTS~iPad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TBL_VW_Cell_EVENTS" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            NSDictionary *temp_DICN = [ARR_upcommingevent objectAtIndex:indexPath.row];
            cell.lbl_event_name.text = [[temp_DICN valueForKey:@"name"] capitalizedString];
            cell.lbl_event_name.numberOfLines = 0;
            [cell.lbl_event_name sizeToFit];
            
            
            cell.lbl_event_time.text = [self getLocalDateTimeFromUTC:[temp_DICN valueForKey:@"start_date"]];
            
            [cell.BTN_View_detail setTag:indexPath.row];
            [cell.BTN_View_detail addTarget:self action:@selector(BTN_UP_COMNG_EVENT:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
    }
    else
    {
        if ([ARR_allevent count] == 0)
        {
            cell_EMPTY_val *cell = (cell_EMPTY_val *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"cell_EMPTY_val~iPad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"cell_EMPTY_val" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            cell.lbl_emptycell.text = @"No Events Found";
            cell.lbl_emptycell.numberOfLines = 0;
            [cell.lbl_emptycell sizeToFit];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        else
        {
            TBL_VW_Cell_EVENTS *cell = (TBL_VW_Cell_EVENTS *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TBL_VW_Cell_EVENTS~iPad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"TBL_VW_Cell_EVENTS" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            NSDictionary *temp_DICN = [ARR_allevent objectAtIndex:indexPath.row];
            cell.lbl_event_name.text = [[temp_DICN valueForKey:@"name"] capitalizedString];
            cell.lbl_event_name.numberOfLines = 0;
            [cell.lbl_event_name sizeToFit];
            
            cell.lbl_event_time.text = [self getLocalDateTimeFromUTC:[temp_DICN valueForKey:@"start_date"]];
            
            [cell.BTN_View_detail setTag:indexPath.row];
            [cell.BTN_View_detail addTarget:self action:@selector(BTN_ALL_EVENT:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1.0];
    } else {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    }
}

#pragma mark - Button Events

-(void) BTN_UP_COMNG_EVENT : (UIButton *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"From Delete Skill %ld",(long)buttonIndexPath.row);
    NSString *index_str = [NSString stringWithFormat:@"%ld",(long)buttonIndexPath.row];
    NSLog(@"Index path of Upcomming Event %@",index_str);
    NSLog(@"thedata:%@",[ARR_upcommingevent objectAtIndex:[index_str intValue]]);
    NSDictionary *dictdat =[ARR_upcommingevent objectAtIndex:[index_str intValue]];
    [[NSUserDefaults standardUserDefaults] setValue:[dictdat valueForKey:@"id"] forKey:@"event_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"event_id"]);
    
//    [self geteventcode];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(geteventcode) withObject:activityIndicatorView afterDelay:0.01];
}
-(void) BTN_ALL_EVENT : (UIButton *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"From Delete Skill %ld",(long)buttonIndexPath.row);
    
    NSString *index_str = [NSString stringWithFormat:@"%ld",(long)buttonIndexPath.row];
    
    NSLog(@"Index path of All Event %@",index_str);
    
    NSDictionary *dictdat =[ARR_allevent objectAtIndex:[index_str intValue]];
    [[NSUserDefaults standardUserDefaults] setValue:[dictdat valueForKey:@"id"] forKey:@"event_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [self performSegueWithIdentifier:@"hometoeventdetail" sender:self];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(geteventcode) withObject:activityIndicatorView afterDelay:0.01];
}

#pragma mark - Button Actions
-(void)BTN_enter_event_code:(id)sender
{
    [UIView transitionWithView:_BTN_view_all_event
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:NULL
                    completion:NULL];
    [self.BTN_view_all_event  setHidden:YES];
    
    _lbl_titl_event_code.hidden = NO;
    
    [UIView beginAnimations:@"LeftFlip" context:nil];
    [UIView setAnimationDuration:0.8];
    _VW_hold_code.hidden = NO;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_hold_code cache:YES];
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.5 animations:^{
        _lbl_upcoming_event.frame = CGRectMake(_lbl_upcoming_event.frame.origin.x, _lbl_upcoming_event.frame.origin.y + 85, _lbl_upcoming_event.frame.size.width, _lbl_upcoming_event.frame.size.height);
        _scroll_content.frame = CGRectMake(_scroll_content.frame.origin.x, _scroll_content.frame.origin.y + 85, _scroll_content.frame.size.width, _scroll_content.frame.size.height - 85);
        _VW_hold_BTN.frame = CGRectMake(_VW_hold_BTN.frame.origin.x, _VW_hold_BTN.frame.origin.y, _VW_hold_BTN.frame.size.width, _VW_hold_BTN.frame.size.height + 85);
    }];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"LeftFlip" context:nil];
    [UIView setAnimationDuration:0.4];
    _BTN_cancel.hidden=NO;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_BTN_cancel cache:YES];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"LeftFlip" context:nil];
    [UIView setAnimationDuration:0.8];
    _BTN_enter_event_code.hidden = NO;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_BTN_enter_event_code cache:YES];
    [UIView commitAnimations];
}

-(void) BTN_cancel :(id)sender
{
    _TXT_0.text = @"";
    _TXT_1.text = @"";
    _TXT_2.text = @"";
    _TXT_3.text = @"";
    _TXT_4.text = @"";
    _TXT_5.text = @"";
    
    
    [UIView beginAnimations:@"LeftFlip" context:nil];
    [UIView setAnimationDuration:0.8];
    _BTN_view_all_event.hidden = NO;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_BTN_view_all_event cache:YES];
    [UIView commitAnimations];
    
    _lbl_titl_event_code.hidden = YES;
    
    [UIView transitionWithView:_VW_hold_code
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:NULL
                    completion:NULL];
    [self.VW_hold_code  setHidden:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        _lbl_upcoming_event.frame = CGRectMake(_lbl_upcoming_event.frame.origin.x, _lbl_upcoming_event.frame.origin.y - 85, _lbl_upcoming_event.frame.size.width, _lbl_upcoming_event.frame.size.height);
        _scroll_content.frame = CGRectMake(_scroll_content.frame.origin.x, _scroll_content.frame.origin.y - 85, _scroll_content.frame.size.width, _scroll_content.frame.size.height + 85);
        _VW_hold_BTN.frame = CGRectMake(_VW_hold_BTN.frame.origin.x, _VW_hold_BTN.frame.origin.y, _VW_hold_BTN.frame.size.width, _VW_hold_BTN.frame.size.height - 85);
    }];
    [UIView commitAnimations];
    
    [UIView transitionWithView:_BTN_cancel
                      duration:0.1
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:NULL
                    completion:NULL];
    [self.BTN_cancel  setHidden:YES];
    
    [UIView transitionWithView:_BTN_enter_event_code
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:NULL
                    completion:NULL];
    [self.BTN_enter_event_code  setHidden:YES];
//    [self sessionOUT];
}
-(void)BTN_enter_code:(id)sender
{
    NSLog(@"Enter Code Tapped");
    
    [self.view endEditing:TRUE];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(get_EVENTDETAIL) withObject:activityIndicatorView afterDelay:0.01];
}

#pragma mark - Textfield editing
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str_0,*str_1,*str_2,*str_3,*str_4,*str_5;
    str_0 = _TXT_0.text;
    str_1 = _TXT_1.text;
    str_2 = _TXT_2.text;
    str_3 = _TXT_3.text;
    str_4 = _TXT_4.text;
    str_5 = _TXT_5.text;
    if (string.length > 0)
    {
        NSInteger nextTag = textField.tag + 1;
        UIResponder* nextResponder;
        
        if (textField == _TXT_1 && str_0.length == 0) {
            nextResponder = [textField.superview viewWithTag:0];
            textField.text = @"";
            [_TXT_0 becomeFirstResponder];
        }
        else if ((textField == _TXT_2 && str_0.length == 0) || (textField == _TXT_2 && str_1.length == 0))
        {
            nextResponder = [textField.superview viewWithTag:0];
            textField.text = @"";
            [_TXT_0 becomeFirstResponder];
        }
        else if ((textField == _TXT_3 && str_0.length == 0) || (textField == _TXT_3 && str_1.length == 0) || (textField == _TXT_3 && str_2.length == 0))
        {
            nextResponder = [textField.superview viewWithTag:0];
            textField.text = @"";
            [_TXT_0 becomeFirstResponder];
        }
        else if ((textField == _TXT_4 && str_0.length == 0) || (textField == _TXT_4 && str_1.length == 0) || (textField == _TXT_4 && str_2.length == 0) || (textField == _TXT_4 && str_3.length == 0))
        {
            nextResponder = [textField.superview viewWithTag:0];
            textField.text = @"";
            [_TXT_0 becomeFirstResponder];
        }
        else if ((textField == _TXT_5 && str_0.length == 0) || (textField == _TXT_5 && str_1.length == 0) || (textField == _TXT_5 && str_2.length == 0) || (textField == _TXT_5 && str_3.length == 0) || (textField == _TXT_5 && str_4.length == 0))
        {
            nextResponder = [textField.superview viewWithTag:0];
            textField.text = @"";
            [_TXT_0 becomeFirstResponder];
        }
        else
        {
            nextResponder= [textField.superview viewWithTag:nextTag];
            
            
            
            if (! nextResponder)
                nextResponder = [textField.superview viewWithTag:0];
            
            if (nextResponder)
            {
                textField.text = string;
                [nextResponder becomeFirstResponder];
//                if (textField == _TXT_1) {
//                    _TXT_0.secureTextEntry = YES;
//                }
//                else if(textField == _TXT_2)
//                {
//                    _TXT_1.secureTextEntry = YES;
//                }
//                else if(textField == _TXT_3)
//                {
//                    _TXT_2.secureTextEntry = YES;
//                }
//                else if(textField == _TXT_4)
//                {
//                    _TXT_3.secureTextEntry = YES;
//                }
//                else
                if(textField == _TXT_5)
                {
                    _BTN_enter_event_code.enabled = YES;
                    _BTN_enter_event_code.alpha = 1.0;
//                    _TXT_4.secureTextEntry = YES;
                }
            }
        }
        return NO;
    }
    else
    {
        _BTN_enter_event_code.enabled = NO;
//        _BTN_enter_event_code.alpha = 0.5;
        NSInteger prevTag = textField.tag - 1;
        UIResponder* prev = [textField.superview viewWithTag:prevTag];
        if (! prev)
        {
            prev = [textField.superview viewWithTag:0];
        }
        else
        {
            textField.text = @"";
            if (textField == _TXT_1) {
                _TXT_0.secureTextEntry = NO;
            }
            else if(textField == _TXT_2)
            {
                _TXT_1.secureTextEntry = NO;
            }
            else if(textField == _TXT_3)
            {
                _TXT_2.secureTextEntry = NO;
            }
            else if(textField == _TXT_4)
            {
                _TXT_3.secureTextEntry = NO;
            }
            else if(textField == _TXT_5)
            {
                _TXT_4.secureTextEntry = NO;
            }
        }
        
        if (prevTag == 0)
        {
            _TXT_0.text = @"";
            _TXT_0.secureTextEntry = NO;
            [_TXT_0 becomeFirstResponder];
        }
        else
        {
            [prev becomeFirstResponder];
        }
        return NO;
    }
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) get_Data
{
    NSError *error;
    NSData *aData = [[NSUserDefaults standardUserDefaults] valueForKey:@"JsonEventlist"];
    NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
    NSLog(@"The response VC Home dsfdf %@",json_DATA);
    
    @try
    {
        NSString *STR_error = [json_DATA valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            ARR_allevent = [json_DATA valueForKey:@"all_events"];
            ARR_upcommingevent = [json_DATA valueForKey:@"upcoming_events"];
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
}

#pragma mark - Date Convert
-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{

    NSLog(@"Date Input tbl %@",strDate);
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    NSLog(@"CurrentDate:%@", currentDate);
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"MMM dd, yyyy h:mm a"];
    [newFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    return [NSString stringWithFormat:@"%@ EST",[newFormat stringFromDate:currentDate]];
}

#pragma mark - Api Integration
-(void)geteventcode
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *event_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"event_id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@events/event_detail/?id=%@",SERVER_URL,event_id];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"upcoming_events"];
        [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [self performSegueWithIdentifier:@"hometoeventdetail" sender:self];
        [self performSegueWithIdentifier:@"hometoEvent_detail" sender:self];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void) get_ALLevents
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(allevents_VC_model) withObject:activityIndicatorView afterDelay:0.01];
}

-(void) allevents_VC_model
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    
    NSString *urlGetuser;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height > 667)
        {
            urlGetuser = [NSString stringWithFormat:@"%@events/all_events?per_page=13",SERVER_URL];
        }
        else
        {
            urlGetuser = [NSString stringWithFormat:@"%@events/all_events?per_page=10",SERVER_URL];
        }
    }
    else
    {
        urlGetuser = [NSString stringWithFormat:@"%@events/all_events?per_page=20",SERVER_URL];
    }
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    //    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"ALLEvents"];
        [[NSUserDefaults standardUserDefaults] setObject:urlGetuser forKey:@"URL_SAVED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"alleventsidentifier" sender:self];
        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void) get_EVENTDETAIL
{
    NSError *error;
    NSError *err;
    NSHTTPURLResponse *response = nil;
    NSString *code = [NSString stringWithFormat:@"%@%@%@%@%@%@",_TXT_0.text,_TXT_1.text,_TXT_2.text,_TXT_3.text,_TXT_4.text,_TXT_5.text];
    NSDictionary *parameters = @{ @"code":  code};
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
    NSString *urlGetuser = [NSString stringWithFormat:@"%@events/event_code",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSError *error;
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"VC home enter event code :%@",dict);
        
        @try
        {
            NSString *STR_error = [dict valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                if (![[dict valueForKey:@"status"] isEqualToString:@"Success"])
                {
                    [_TXT_0 becomeFirstResponder];
                    _TXT_0.text = @"";
                    _TXT_1.text = @"";
                    _TXT_2.text = @"";
                    _TXT_3.text = @"";
                    _TXT_4.text = @"";
                    _TXT_5.text = @"";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"upcoming_events"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"from enter code" forKey:@"VCSTAT"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self performSegueWithIdentifier:@"hometoeventdetail" sender:self];
                    //            [self performSegueWithIdentifier:@"hometoEvent_detail" sender:self];
                }
            }
        }
        @catch (NSException *exception)
        {
            [self sessionOUT];
        }
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

#pragma mark - Scroll view deligate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    NSLog(@"Scroll view called");
    CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    if (yVelocity < 0)
    {
        NSLog(@"Up");
        if (_VW_IMG_BG.frame.size.height > 80)
        {
            frame_VIEW = _VW_IMG_BG.frame;
            frame_IMAGE = _IMG_logo_WT.frame;
            
            diff = _VW_IMG_BG.frame.size.height - 80;
            
            CGRect frame_VW;
            frame_VW = _VW_IMG_BG.frame;
            frame_VW.size.height = 80;
            
            CGRect frame_IMG = _IMG_logo_WT.frame;
            frame_IMG.origin.x = _VW_IMG_BG.frame.size.width/2 - 70/2;
            frame_IMG.origin.y = 20;
            frame_IMG.size.height = 55;
            frame_IMG.size.width = 70;
            
            CGRect frame_hold_VW = _VW_hold_BTN.frame;
            frame_hold_VW.origin.y = frame_VW.size.height;
            
            CGRect frame_scroll = _scroll_content.frame;
            frame_scroll.origin.y = _scroll_content.frame.origin.y - diff;
            frame_scroll.size.height = _scroll_content.frame.size.height + diff;
            
            //            [UIView beginAnimations:@"bucketsOff" context:nil];
            [UIView beginAnimations:@"bucketsOff" context:NULL];
            // [UIView setAnimationDuration:0.25];
            _VW_IMG_BG.frame = frame_VW;
            _IMG_logo_WT.frame = frame_IMG;
            _VW_hold_BTN.frame = frame_hold_VW;
            _scroll_content.frame = frame_scroll;
            [UIView commitAnimations];
        }
    }
    else if (yVelocity > 0)
    {
        NSLog(@"Down");
        if (_VW_IMG_BG.frame.size.height <= 80)
        {
            //            diff = diff + 80;
            
            CGRect frame_hold_VW = _VW_hold_BTN.frame;
            frame_hold_VW.origin.y = frame_VIEW.origin.y + frame_VIEW.size.height;
            
            CGRect frame_scroll = _scroll_content.frame;
            frame_scroll.origin.y = _scroll_content.frame.origin.y + diff;
            frame_scroll.size.height = _scroll_content.frame.size.height - diff;
            
            //            [UIView beginAnimations:@"bucketsOff" context:nil];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            // [UIView setAnimationDuration:0.25];
            _VW_IMG_BG.frame = frame_VIEW;
            _IMG_logo_WT.frame = frame_IMAGE;
            _VW_hold_BTN.frame = frame_hold_VW;
            _scroll_content.frame = frame_scroll;
            [UIView commitAnimations];
        }
    }
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"Swipe Up");
        if (_VW_IMG_BG.frame.size.height > 80)
        {
            frame_VIEW = _VW_IMG_BG.frame;
            frame_IMAGE = _IMG_logo_WT.frame;
            
            diff = _VW_IMG_BG.frame.size.height - 80;
            
            CGRect frame_VW;
            frame_VW = _VW_IMG_BG.frame;
            frame_VW.size.height = 80;
            
            CGRect frame_IMG = _IMG_logo_WT.frame;
            frame_IMG.origin.x = _VW_IMG_BG.frame.size.width/2 - 70/2;
            frame_IMG.origin.y = 20;
            frame_IMG.size.height = 55;
            frame_IMG.size.width = 70;
            
            CGRect frame_hold_VW = _VW_hold_BTN.frame;
            frame_hold_VW.origin.y = frame_VW.size.height;
            
            CGRect frame_scroll = _scroll_content.frame;
            frame_scroll.origin.y = _scroll_content.frame.origin.y - diff;
            frame_scroll.size.height = _scroll_content.frame.size.height + diff;
            
//            [UIView beginAnimations:@"bucketsOff" context:nil];
            [UIView beginAnimations:@"bucketsOff" context:NULL];
            // [UIView setAnimationDuration:0.25];
            _VW_IMG_BG.frame = frame_VW;
            _IMG_logo_WT.frame = frame_IMG;
            _VW_hold_BTN.frame = frame_hold_VW;
            _scroll_content.frame = frame_scroll;
            [UIView commitAnimations];
        }
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"Swipe Down");
        if (_VW_IMG_BG.frame.size.height <= 80)
        {
//            diff = diff + 80;
            
            CGRect frame_hold_VW = _VW_hold_BTN.frame;
            frame_hold_VW.origin.y = frame_VIEW.origin.y + frame_VIEW.size.height;
            
            CGRect frame_scroll = _scroll_content.frame;
            frame_scroll.origin.y = _scroll_content.frame.origin.y + diff;
            frame_scroll.size.height = _scroll_content.frame.size.height - diff;
            
            //            [UIView beginAnimations:@"bucketsOff" context:nil];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            // [UIView setAnimationDuration:0.25];
            _VW_IMG_BG.frame = frame_VIEW;
            _IMG_logo_WT.frame = frame_IMAGE;
             _VW_hold_BTN.frame = frame_hold_VW;
            _scroll_content.frame = frame_scroll;
            [UIView commitAnimations];
        }
    }
}

#pragma mark - MAnage session
- (void) sessionOUT
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session out" message:@"In some other device same user logged in. Please login again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
    ViewController *tncView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [tncView setModalInPopover:YES];
    [tncView setModalPresentationStyle:UIModalPresentationFormSheet];
    [tncView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:tncView animated:YES completion:NULL];
}
-(void)myprofileapicalling
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@view_profile",SERVER_USR];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
//        [activityIndicatorView stopAnimating];
//        VW_overlay.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        NSLog(@" THe user data is :%@",[[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"]);
        //        [self performSegueWithIdentifier:@"accountstoeditprofileidentifier" sender:self];
        //        [self parse_listEvents_api];
//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
//        [self performSelector:@selector(parse_listEvents_api) withObject:activityIndicatorView afterDelay:0.01];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

@end
