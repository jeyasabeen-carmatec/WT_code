//
//  VC_orderdetail.m
//  WinningTicket
//
//  Created by Test User on 29/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_orderdetail.h"
#import "ViewController.h"

#pragma mark - Image Cache
#import "SDWebImage/UIImageView+WebCache.h"

@interface VC_orderdetail ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation VC_orderdetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_VIEW];
    
    /* for (int i=0; i<[self.segment_bottom.subviews count]; i++)
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
     }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    [_scroll_contents setContentSize:CGSizeMake(_scroll_contents.frame.size.width, _BTN_liveAUCTN.frame.origin.y + _BTN_liveAUCTN.frame.size.height + 30)];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
    //                                                  forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
    //     @{NSForegroundColorAttributeName:[UIColor whiteColor],
    //       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:32.0f]
    //       } forState:UIControlStateNormal];
    //
    //    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
    //                                                                     target:self action:@selector(backAction)];
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //
    //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    //    {
    //        CGSize result = [[UIScreen mainScreen] bounds].size;
    //        if(result.height <= 480)
    //        {
    //            // iPhone Classic
    //            negativeSpacer.width = 0;
    //        }
    //        else if(result.height <= 568)
    //        {
    //            // iPhone 5
    //            negativeSpacer.width = -12;
    //        }
    //        else
    //        {
    //            negativeSpacer.width = -16;
    //        }
    //    }
    //    else
    //    {
    //        negativeSpacer.width = -12;
    //    }
    //
    //    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    //
    //
    //    [self.navigationController.navigationBar setTitleTextAttributes:
    //     @{NSForegroundColorAttributeName:[UIColor whiteColor],
    //       NSFontAttributeName:_lbl_nav_font.font}];
    //
    [_BTN_back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = @"EVENT DETAIL";
}

-(void) backAction
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


-(void) setup_VIEW
{
    //    [_tab_HOME setSelectedItem:[_tab_HOME.items objectAtIndex:0]];
    //    [_segment_bottom setSelectedSegmentIndex:0];
    CGRect content_frame;
    content_frame = _VW_contents.frame;
    content_frame.size.width = _scroll_contents.frame.size.width;
    //    content_frame.size.height = _BTN_liveAUCTN.frame.origin.y + _BTN_liveAUCTN.frame.size.height + 20;
    _VW_contents.frame = content_frame;
    
    [_scroll_contents addSubview:_VW_contents];
    
    [self set_FRAME];
    
    //    CGRect content_frame;
    content_frame = _VW_contents.frame;
    //    content_frame.size.width = _scroll_contents.frame.size.width;
    content_frame.size.height = _BTN_liveAUCTN.frame.origin.y + _BTN_liveAUCTN.frame.size.height + 20;
    _VW_contents.frame = content_frame;
    
    [_scroll_contents addSubview:_VW_contents];
    
    [_BTN_liveSCR addTarget:self action:@selector(live_score_page) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_liveAUCTN addTarget:self action:@selector(Btn_liveAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void) set_FRAME
{
    NSError *error;
    NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    @try
    {
        NSString *STR_error = [dict valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            NSDictionary *temp_dict = [dict valueForKey:@"event"];
            
            CGRect old_frame = _lbl_eventname.frame;
            
            _lbl_eventname.text = [[temp_dict valueForKey:@"name"] capitalizedString];
            [[NSUserDefaults standardUserDefaults] setValue:_lbl_eventname.text forKey:@"event_name"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            _lbl_eventname.numberOfLines = 0;
            [_lbl_eventname sizeToFit];
            
            NSLog(@"Image Url is %@",[NSString stringWithFormat:@"%@%@",IMAGE_URL,[temp_dict valueForKey:@"avatar_url"]]);
            
            [_img_event sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[temp_dict valueForKey:@"avatar_url"]]]
                          placeholderImage:[UIImage imageNamed:@"square-2"]];
            //    _img_event.contentMode = UIViewContentModeScaleAspectFit;
            
            float image_height = _img_event.frame.size.height;
            float lbl_event_name_ht = _lbl_eventname.frame.size.height;
            
            _lbl_code.text=[temp_dict valueForKey:@"code"];
            NSString *location = [NSString stringWithFormat:@"%@",[temp_dict valueForKey:@"organization_name"]];// @"Grand Cypress Country Club";
            NSString *address = [NSString stringWithFormat:@"%@",[temp_dict valueForKey:@"get_golf_location"]];//@"1 N Jacaranda ST, Orlando, FL 32836";
            address = [address stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
            NSString *date = [self getLocalDateFromUTC:[temp_dict valueForKey:@"start_date"]];
            NSString *time = [self getLocalTimeFromUTC:[temp_dict valueForKey:@"start_date"]];
            
            NSLog(@"Date format %@",date);
            NSLog(@"Time format %@",time);
            
            _lbl_date.text=date;
            _lbl_time.text=time;
            
            NSString *text = [NSString stringWithFormat:@"%@\n%@",location,address];
            
            text = [text stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
            text = [text stringByReplacingOccurrencesOfString:@"(null)" withString:@"Not Mentioned"];
            
            // If attributed text is supported (iOS6+)
            if ([self.lbl_eventdetail respondsToSelector:@selector(setAttributedText:)]) {
                
                // Define general attributes for the entire text
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: self.lbl_eventdetail.textColor,
                                          NSFontAttributeName: self.lbl_eventdetail.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                
                // Red text attributes
                //            UIColor *redColor = [UIColor redColor];
                NSRange cmp = [text rangeOfString:location];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:18.0]}
                                        range:cmp];
                
                
                self.lbl_eventdetail.attributedText = attributedText;
            }
            else
            {
                self.lbl_eventdetail.text = text;
            }
            
            self.lbl_eventdetail.numberOfLines = 0;
            [self.lbl_eventdetail sizeToFit];
            
            [[NSUserDefaults standardUserDefaults] setValue:_lbl_eventdetail.text forKey:@"event_address"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            float difference;
            
            if (image_height < lbl_event_name_ht)
            {
                difference = lbl_event_name_ht - image_height;
                
                CGRect frame_NN = _VW_dateandtime.frame;
                frame_NN.origin.y = frame_NN.origin.y + difference;
                _VW_dateandtime.frame = frame_NN;
                
                frame_NN = _img_cstmlbl.frame;
                frame_NN.origin.y = _img_cstmlbl.frame.origin.y + difference;
                _img_cstmlbl.frame = frame_NN;
                
                frame_NN = _lbl_code.frame;
                frame_NN.origin.y = _lbl_code.frame.origin.y + difference;
                _lbl_code.frame = frame_NN;
                
                frame_NN = _lbl_eventdetail.frame;
                frame_NN.origin.y = _lbl_eventdetail.frame.origin.y + difference;
                _lbl_eventdetail.frame = frame_NN;
                
                CGRect frame_IMGE = _img_event.frame;
                frame_IMGE.size.height = _lbl_eventname.frame.size.height;
                _img_event.frame = frame_IMGE;
            }
            else
            {
                _lbl_eventname.frame = old_frame;
            }
            
            CGRect frame_HT = _VW_eventcontent.frame;
            frame_HT.size.height = _lbl_eventdetail.frame.origin.y + _lbl_eventdetail.frame.size.height + 20;
            frame_HT.size.width = _scroll_contents.frame.size.width;
            _VW_eventcontent.frame = frame_HT;
            
            float diff_frame = _lbl_eventdetail.frame.size.height / 2;
            float locframe_mid = _lbl_location.frame.size.height / 2;
            
            float final_Y = diff_frame - locframe_mid;
            
            CGRect frame_NN = _lbl_location.frame;
            frame_NN.origin.y = _lbl_eventdetail.frame.origin.y + final_Y;
            _lbl_location.frame = frame_NN;
            
            [_BTN_viewTKT addTarget:self action:@selector(view_ticket) forControlEvents:UIControlEventTouchUpInside];
            
            frame_HT = _BTN_viewTKT.frame;
            frame_HT.origin.y = _VW_eventcontent.frame.origin.y + _VW_eventcontent.frame.size.height + 10;
            _BTN_viewTKT.frame = frame_HT;
            
            [_BTN_giftBAG addTarget:self action:@selector(View_virtualBAg) forControlEvents:UIControlEventTouchUpInside];
            
            frame_HT = _BTN_giftBAG.frame;
            frame_HT.origin.y = _BTN_viewTKT.frame.origin.y + _BTN_viewTKT.frame.size.height + 10;
            _BTN_giftBAG.frame = frame_HT;
            
            frame_HT = _BTN_liveSCR.frame;
            frame_HT.origin.y = _BTN_giftBAG.frame.origin.y + _BTN_giftBAG.frame.size.height + 10;
            _BTN_liveSCR.frame = frame_HT;
            
            frame_HT = _BTN_liveAUCTN.frame;
            frame_HT.origin.y = _BTN_liveSCR.frame.origin.y + _BTN_liveSCR.frame.size.height + 10;
            _BTN_liveAUCTN.frame = frame_HT;
            
            UIImage *newImage = [_img_cstmlbl.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIGraphicsBeginImageContextWithOptions(_img_cstmlbl.image.size, NO, newImage.scale);
            [_VW_dateandtime.backgroundColor set];
            [newImage drawInRect:CGRectMake(0, 0, _img_cstmlbl.image.size.width, newImage.size.height)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            _img_cstmlbl.image = newImage;
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
    
}

/*#pragma mark - Tabbar deligate
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
 [self performSegueWithIdentifier:@"ordertocourseidentifier" sender:self];
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
 [self performSegueWithIdentifier:@"orderdetailtoaccountidentifier" sender:self];
 }
 }*/


#pragma mark - Date Convert
-(NSString *)getLocalDateFromUTC:(NSString *)strDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    NSLog(@"CurrentDate:%@", currentDate);
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"EEEE, MMMM dd, yyyy"];
    return [newFormat stringFromDate:currentDate];
}
-(NSString *)getLocalTimeFromUTC:(NSString *)strDate
{
    NSLog(@"Input Date %@",strDate);
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    NSLog(@"CurrentDate:%@", currentDate);
    
    NSDateFormatter *userFormatter = [[NSDateFormatter alloc] init];
    [userFormatter setDateFormat:@"h:mm a"];
    [userFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    
    return [userFormatter stringFromDate:currentDate];
}

#pragma mark - Session OUT
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

#pragma mark - Button Methods
-(void) View_virtualBAg
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(goto_VCvirtualBAG) withObject:activityIndicatorView afterDelay:0.01];
}
-(void) goto_VCvirtualBAG
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    [self performSegueWithIdentifier:@"orderdetailtoVirtualbaglist" sender:self];
}

-(void) view_ticket
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(goto_ticketDetail) withObject:activityIndicatorView afterDelay:0.01];
}
-(void) goto_ticketDetail
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    [self performSegueWithIdentifier:@"ordertoTicketdetail" sender:self];
}
-(void)live_score_page
{
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(get_EVENT_STAT) withObject:activityIndicatorView afterDelay:0.01];
    
}

-(void) get_EVENT_STAT
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    
    //    NSDictionary *parameters = @{ @"handicap":  [NSString stringWithFormat:@"%@",_TXT_Handicap.text]};
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@hole_info/check_event_live/%@",SERVER_URL,[event valueForKey:@"id"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    //    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth-token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSMutableDictionary *dict1;
    if(aData)
    {
        dict1 = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Json response event is live = %@",dict1);
        
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        @try {
            if ([[dict1 valueForKey:@"event_status"] isEqualToString:@"live"]) {
                [self get_EVENT_holes];
            }
            else if ([[dict1 valueForKey:@"event_status"] isEqualToString:@"upcoming"]) {
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Event is Upcoming" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            }
            else if ([[dict1 valueForKey:@"event_status"] isEqualToString:@"closed"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Event is Closed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            }
            
        } @catch (NSException *exception) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection error" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}
-(void) get_EVENT_holes
{
    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    NSDictionary *event = [dict valueForKey:@"event"];
    
    NSHTTPURLResponse *response = nil;
    
    //    NSDictionary *parameters = @{ @"handicap":  [NSString stringWithFormat:@"%@",_TXT_Handicap.text]};
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@hole_info/check_hole_info/%@",SERVER_URL,[event valueForKey:@"id"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    //    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth-token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSMutableDictionary *dict1;
    if(aData)
    {
        dict1 = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Json response check Game stat VC Order detail = %@",dict1);
        
        NSString *STR_handicap = [NSString stringWithFormat:@"%@",[dict1 valueForKey:@"handicap"]];
        STR_handicap = [STR_handicap stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        STR_handicap = [STR_handicap stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
        
        //        @try {
        [[NSUserDefaults standardUserDefaults] setObject:STR_handicap forKey:@"handicap1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        } @catch (NSException *exception) {
        //            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"handicap1"];
        //            [[NSUserDefaults standardUserDefaults] synchronize];
        //        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection error" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    @try {
        if ([[dict1 valueForKey:@"status"]isEqualToString:@"Success"]) {
            [self performSegueWithIdentifier:@"live_scrore_identifier" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There is no course information available for this event" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception = %@",exception);
    }
    
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

-(void) Btn_liveAction
{
    [self performSegueWithIdentifier:@"liveauctionIdentifier" sender:self];
}

@end

