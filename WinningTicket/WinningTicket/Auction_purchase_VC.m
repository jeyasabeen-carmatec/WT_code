//
//  Auction_purchase_VC.m
//  WinningTicket
//
//  Created by Test User on 12/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Auction_purchase_VC.h"
#import "ViewController.h"


@interface Auction_purchase_VC ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    
}


@end

@implementation Auction_purchase_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self.view addSubview:self.scroll];
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
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
    
    [self set_UP_VW];
}

-(void)set_UP_VW
{
    NSError *error;
    NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"PurchaseRESPONSE"] options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"Response from purchase controller :%@",dict);
    
    NSLog(@"Error %@",error);
    
    @try
    {
        NSString *STR_error = [dict valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            if (dict)
            {
                CGRect frame_rect;
                float orginal_width = _status_Label.frame.size.width;
                
                self.status_Label.text = @"Thank You For Purchase";
                frame_rect = _status_Label.frame;
                frame_rect.size.width = orginal_width;
                frame_rect.size.height = _status_Label.frame.size.height;
                _status_Label.frame = frame_rect;
                
                frame_rect = _confirm_mail.frame;
                orginal_width = _confirm_mail.frame.size.width;
                
                self.confirm_mail.text = [NSString stringWithFormat:@"A confirmation email has been sent to %@",[dict valueForKey:@"email"]];
                [self.confirm_mail sizeToFit];
                
                frame_rect.origin.y = _status_Label.frame.origin.y + _status_Label.frame.size.height + 2;
                frame_rect.size.width = orginal_width;
                frame_rect.size.height = _confirm_mail.frame.size.height;
                _confirm_mail.frame = frame_rect;
                
                self.order.text = [NSString stringWithFormat:@"Order #%@",[dict valueForKey:@"order_id"]];
                frame_rect = _order.frame;
                frame_rect.origin.y = _confirm_mail.frame.origin.y + _confirm_mail.frame.size.height + 2;
                _order.frame = frame_rect;
                
                CGRect VW_frame;
                
                VW_frame = _VW_head.frame;
                VW_frame.size.height = _order.frame.origin.y + _order.frame.size.height + 10;
                VW_frame.size.width = _scroll.frame.size.width;
                _VW_head.frame = VW_frame;
                
                
                self.order_summary.text = @"Order Summary";
                frame_rect = _order_summary.frame;
                frame_rect.origin.y = _VW_head.frame.origin.y + _VW_head.frame.size.height + 5;
                _order_summary.frame = frame_rect;
                
                VW_frame = _first_VW.frame;
                VW_frame.origin.y = _order_summary.frame.origin.y + _order_summary.frame.size.height + 10;
                _first_VW.frame = VW_frame;
                
                frame_rect = _name_ticket.frame;
                frame_rect.origin.y = _first_VW.frame.origin.y + _first_VW.frame.size.height + 10;
                _name_ticket.frame = frame_rect;
                
//                self.qty.text=[NSString stringWithFormat:@"Qty:%@",[dict valueForKey:@"quantity"]];
//                frame_rect = _qty.frame;
//                frame_rect.origin.y = _first_VW.frame.origin.y + _first_VW.frame.size.height + 10;
//                _qty.frame = frame_rect;
                
                
                
                NSString *des = [[dict valueForKey:@"name"] capitalizedString];
                NSString *code = [NSString stringWithFormat:@"%@",[dict valueForKey:@"code"]];
                NSString *text = [NSString stringWithFormat:@"%@\n%@",code,des];
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                          NSFontAttributeName: [UIFont fontWithName:@"Gotham-Book" size:17]
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                
                
                //        UIFont *boldFont = [UIFont fontWithName:@"Gotham-Book" size:17];
                NSRange range = [text rangeOfString:des];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:14.0]}
                                        range:range];
                
                //        UIColor *greenColor = [UIColor lightGrayColor];
                NSRange greenTextRange = [text rangeOfString:code];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:17.0]}
                                        range:greenTextRange];
                
                orginal_width = _des_cription.frame.size.width;
                
                self.des_cription.attributedText = attributedText;
                _des_cription.numberOfLines = 0;
                [self.des_cription sizeToFit];
                
                frame_rect = _des_cription.frame;
                
                
                frame_rect.origin.y = _name_ticket.frame.origin.y + _name_ticket.frame.size.height + 5;
                frame_rect.size.width = orginal_width;
                _des_cription.frame = frame_rect;
                
                _amount.text = [NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"] floatValue]];
                
                frame_rect = _amount.frame;
                frame_rect.origin.y = _name_ticket.frame.origin.y + _name_ticket.frame.size.height + 10;
                _amount.frame = frame_rect;
                
                frame_rect = _pur_view.frame;
                frame_rect.origin.y = _des_cription.frame.origin.y + _des_cription.frame.size.height + 10;
                _pur_view.frame = frame_rect;
                
                frame_rect = _sub_total.frame;
                frame_rect.origin.y = _pur_view.frame.origin.y + _pur_view.frame.size.height + 5;
                _sub_total.frame = frame_rect;
                
                _sub_amount.text = [NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"] floatValue]];
                frame_rect = _sub_amount.frame;
                frame_rect.origin.y = _pur_view.frame.origin.y + _pur_view.frame.size.height + 5;
                _sub_amount.frame = frame_rect;
                
                frame_rect = _sec_vw.frame;
                frame_rect.origin.y = _sub_amount.frame.origin.y + _sub_amount.frame.size.height + 5;
                _sec_vw.frame = frame_rect;
                
                frame_rect = _total.frame;
                frame_rect.origin.y = _sec_vw.frame.origin.y + _sec_vw.frame.size.height + 5;
                _total.frame = frame_rect;
                
                _total_amount.text = [NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"] floatValue]];
                frame_rect = _total_amount.frame;
                frame_rect.origin.y = _sec_vw.frame.origin.y + _sec_vw.frame.size.height + 5;
                _total_amount.frame = frame_rect;
                
                frame_rect = __BTN_Ok.frame;
                frame_rect.origin.y = _total.frame.origin.y + _total.frame.size.height + 5;
                __BTN_Ok.frame = frame_rect;
                
                VW_frame = _start_View.frame;
                VW_frame.size.height = __BTN_Ok.frame.origin.y + __BTN_Ok.frame.size.height + 10;
                VW_frame.size.width = _scroll.frame.size.width;
                _start_View.frame = VW_frame;
            }
            
            [__BTN_Ok addTarget:self action:@selector(Ok_Clicked) forControlEvents:UIControlEventTouchUpInside];
            [_scroll addSubview:_start_View];
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
}
-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    [_scroll layoutIfNeeded];
    _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, _start_View.frame.size.height + 10);
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:24.0f]
       } forState:UIControlStateNormal];
    
    //    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    /*   UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
     target:self action:@selector(backAction)];
     UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
     
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
     {
     CGSize result = [[UIScreen mainScreen] bounds].size;
     if(result.height <= 480)
     {
     // iPhone Classic
     negativeSpacer.width = 0;
     }
     else if(result.height <= 568)
     {
     // iPhone 5
     negativeSpacer.width = -12;
     }
     else
     {
     negativeSpacer.width = -16;
     }
     }
     else
     {
     negativeSpacer.width = -12;
     }
     
     [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton ] animated:NO];*/
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]}];
    self.navigationItem.title = @"Order Confirmed";
    
    self.navigationItem.hidesBackButton = YES;
}
-(void) backAction
{
    //    [self.navigationController popViewControllerAnimated:NO];
    //[self performSegueWithIdentifier:@"orderdetailidentifier" sender:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)Ok_Clicked
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(api_HOME) withObject:activityIndicatorView afterDelay:0.01];
}

- (void) api_HOME
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@events",SERVER_URL];
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
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"JsonEventlist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"auction_home_identifier" sender:self];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
