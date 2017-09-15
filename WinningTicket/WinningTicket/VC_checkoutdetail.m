//
//  VC_checkoutdetail.m
//  WinningTicket
//
//  Created by Test User on 28/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_checkoutdetail.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"

#import "ViewController.h"

#pragma mark - Image Cache
#import "SDWebImage/UIImageView+WebCache.h"

@interface VC_checkoutdetail ()

@end

@implementation VC_checkoutdetail
{
    NSMutableDictionary *states,*countryS;
    NSString *cntry_name,*conty_code;
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_VIEW];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:32.0f]
       } forState:UIControlStateNormal];
    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
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
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton ] animated:NO];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]}];
    self.navigationItem.title = @"Order Preview";
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PurchaseRESPONSE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _VW_contents.frame.size.height + 20);
}

-(void) setup_VIEW
{
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
    
    NSError *error;
    NSMutableDictionary *temp_resp = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"CHKOUTDETAIL"] options:NSASCIIStringEncoding error:&error];
    
    @try
    {
        NSString *STR_error = [temp_resp valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            NSDictionary *address_dictin = [temp_resp valueForKey:@"billing_address"];
            
            NSLog(@"Image Url Vc checkout detail %@",[NSString stringWithFormat:@"%@%@",IMAGE_URL,[temp_resp valueForKey:@"avatar_url"]]);
            [_img_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[temp_resp valueForKey:@"avatar_url"]]]
                         placeholderImage:[UIImage imageNamed:@"Logo_WT.png"]];
            _img_icon.contentMode = UIViewContentModeScaleAspectFit;
            
            NSLog(@"The response from checkout detail VC \n%@",temp_resp);
            
            _lbl_datasubtotal.text = [NSString stringWithFormat:@"$%.2f",[[temp_resp valueForKey:@"price"] floatValue] * [[temp_resp valueForKey:@"quantity"] floatValue]];
            _lbl_datatotal.text = _lbl_datasubtotal.text;
            
            [_BTN_order2 addTarget:self action:@selector(BTN_order2action) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect rect_content,frame_rect;
            rect_content = _VW_contents.frame;
            rect_content.size.width = self.navigationController.navigationBar.frame.size.width;
            
            _lbl_email.text = [temp_resp valueForKey:@"email"];
            
            [self Country_api];
            conty_code  = [address_dictin valueForKey:@"country"];
            NSArray *temp = [countryS allKeysForObject:conty_code];
            cntry_name = [temp lastObject];
            
            [self State_api];
            NSString *state_code = [address_dictin valueForKey:@"state"];
            NSArray *temp_arr = [states allKeysForObject:state_code];
            NSString *state_name = [temp_arr lastObject];
            
            NSString *zip_code = [address_dictin valueForKey:@"zip_code"];
            
            //    NSString *address_str = [NSString stringWithFormat:@"%@ %@\n%@,%@\n%@,%@\n%@,%@.\nPhone:%@",[address_dictin valueForKey:@"first_name"],[address_dictin valueForKey:@"last_name"],[address_dictin valueForKey:@"address_line1"],[address_dictin valueForKey:@"address_line2"],[address_dictin valueForKey:@"city"],state_name,cntry_name,zip_code,[address_dictin valueForKey:@"phone"]];
            //
            //    _lbl_address.text = [NSString stringWithFormat:@"%@",address_str];
            //    _lbl_address.numberOfLines = 0;
            //    [_lbl_address sizeToFit];
            
            NSString *STR_fname = [NSString stringWithFormat:@"%@",[[address_dictin valueForKey:@"first_name"] capitalizedString]];
            STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_lname = [NSString stringWithFormat:@"%@",[[address_dictin valueForKey:@"last_name"] capitalizedString]];
            STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_addr1 = [NSString stringWithFormat:@"%@",[[address_dictin valueForKey:@"address_line1"] capitalizedString]];
            STR_addr1 = [STR_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_addr1 = [STR_addr1 stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_addr2 = [NSString stringWithFormat:@"%@",[[address_dictin valueForKey:@"address_line2"] capitalizedString]];
            STR_addr2 = [STR_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_addr2 = [STR_addr2 stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_city = [NSString stringWithFormat:@"%@",[[address_dictin valueForKey:@"city"] capitalizedString]];
            STR_city = [STR_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_city = [STR_city stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_state = [NSString stringWithFormat:@"%@",[state_name capitalizedString]];
            STR_state = [STR_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_state = [STR_state stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_cntry = [NSString stringWithFormat:@"%@",[cntry_name capitalizedString]];
            STR_cntry = [STR_cntry stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_cntry = [STR_cntry stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_zip = [NSString stringWithFormat:@"%@",[zip_code capitalizedString]];
            STR_zip = [STR_zip stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_zip = [STR_zip stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            NSString *STR_phone = [NSString stringWithFormat:@"%@",[[address_dictin valueForKey:@"phone"] capitalizedString]];
            STR_phone = [STR_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            STR_phone = [STR_phone stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            
            NSString *name;
            if (STR_lname.length == 0)
            {
                name = [NSString stringWithFormat:@"%@,\n",STR_fname];
            }
            else
            {
                name = [NSString stringWithFormat:@"%@ %@,\n",STR_fname,STR_lname];
            }
            
            NSString *addr;
            if (STR_addr2.length == 0)
            {
                addr = [NSString stringWithFormat:@"%@,\n",STR_addr1];
            }
            else
            {
                addr = [NSString stringWithFormat:@"%@, %@,\n",STR_addr1,STR_addr2];
            }
            if ([addr isEqualToString:@",\n"]) {
                addr = @"";
            }
            
            NSString *city = [NSString stringWithFormat:@"%@",STR_city];
            NSString *state = [NSString stringWithFormat:@"%@",STR_state];
            NSString *zip = [NSString stringWithFormat:@"%@",STR_zip];
            NSString *cntry;
            if (STR_zip.length == 0)
            {
                cntry = [NSString stringWithFormat:@"%@, %@, \n",city,state];
            }
            else
            {
                if (STR_state.length == 0)
                {
                    cntry = [NSString stringWithFormat:@"%@, %@,\n",city,zip];
                }
                else
                {
                    cntry = [NSString stringWithFormat:@"%@, %@, %@,\n",city,state,zip];
                }
            }
            NSString *country;
            if(STR_cntry.length == 0)
            {
                country = [NSString stringWithFormat:@"Phone : %@.",STR_phone];
            }
            else
            {
                country = [NSString stringWithFormat:@"%@ \nPhone : %@.",STR_cntry,STR_phone];
                
            }
            NSMutableArray *final_ADDR = [[NSMutableArray alloc] init];
            if (name.length != 0) {
                [final_ADDR addObject:[name capitalizedString]];
            }
            
            if (addr.length != 0) {
                [final_ADDR addObject:addr];
            }
            
            if (city.length != 0 && state.length != 0 && zip.length != 0) {
                [final_ADDR addObject:cntry];
            }
            
            
            if (country.length != 0){
                [final_ADDR addObject:country];
            }
            
            
            //    NSString *address_str=[NSString stringWithFormat:@"%@ %@\n%@,%@\n%@,%@\n%@,%@.\nPhone : %@",,,,,,,,,];
            
            NSMutableString *str_TST = [[NSMutableString alloc]init];
            for (int i = 0; i<[final_ADDR count]; i++) {
                [str_TST appendString:[final_ADDR objectAtIndex:i]];
            }
            
            NSLog(@"Testing Addr = \n%@",str_TST);
            
            
            _lbl_address.text = str_TST;
            _lbl_address.numberOfLines = 0;
            [_lbl_address sizeToFit];
            
            frame_rect = _lbl_address.frame;
            frame_rect.size.height = _lbl_address.frame.size.height;
            _lbl_address.frame = frame_rect;
            
            frame_rect = _lbl_titl_payment_info.frame;
            frame_rect.origin.y = _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
            _lbl_titl_payment_info.frame = frame_rect;
            
            
            _lbl_data_payment_info.text = @"Credit / Debit Card";
            frame_rect = _lbl_data_payment_info.frame;
            frame_rect.origin.y = _lbl_titl_payment_info.frame.origin.y + _lbl_titl_payment_info.frame.size.height + 10;
            _lbl_data_payment_info.frame = frame_rect;
            
            frame_rect = _VW_line1.frame;
            frame_rect.origin.y = _lbl_data_payment_info.frame.origin.y + _lbl_data_payment_info.frame.size.height + 10;
            _VW_line1.frame = frame_rect;
            
            float orginal_width = _lbl_ticketDetail.frame.size.width;
            
            NSString *show = @"Winning Ticket";
            //    NSString *place = @"Make A Wish Foundation of Central Florida’s 4th Annual Golf Event";
            NSString *ticketnumber = [temp_resp valueForKey:@"code"];
            NSString *club_name = [[temp_resp valueForKey:@"event_name"] capitalizedString];
            NSString *org_name = [[temp_resp valueForKey:@"organization_name"] capitalizedString];
            NSString *qty = [NSString stringWithFormat:@"Qty : %@",[temp_resp valueForKey:@"quantity"]];
            
            NSString *text = [NSString stringWithFormat:@"%@\n%@\n%@ - %@\n%@",show,org_name,ticketnumber,club_name,qty];
            
            text = [text stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
            text = [text stringByReplacingOccurrencesOfString:@"(null)" withString:@"Not Mentioned"];
            
            // If attributed text is supported (iOS6+)
            if ([self.lbl_ticketDetail respondsToSelector:@selector(setAttributedText:)]) {
                
                // Define general attributes for the entire text
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: self.lbl_ticketDetail.textColor,
                                          NSFontAttributeName: self.lbl_ticketDetail.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                
                // Red text attributes
                //            UIColor *redColor = [UIColor redColor];
                NSRange cmp = [text rangeOfString:show];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:17.0]}
                                        range:cmp];
                
                NSRange org = [text rangeOfString:org_name];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15.0]}
                                        range:org];
                
                NSRange qt = [text rangeOfString:club_name];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                [attributedText setAttributes:@{NSFontAttributeName:_lbl_address.font}
                                        range:qt];
                
                NSRange tkt_num = [text rangeOfString:ticketnumber];
                [attributedText setAttributes:@{NSFontAttributeName:_lbl_address.font}
                                        range:tkt_num];
                
                NSRange qty_range = [text rangeOfString:qty];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15.0]}
                                        range:qty_range];
                
                self.lbl_ticketDetail.attributedText = attributedText;
            }
            else
            {
                self.lbl_ticketDetail.text = [text capitalizedString];
            }
            
            self.lbl_ticketDetail.numberOfLines = 0;
            [self.lbl_ticketDetail sizeToFit];
            
            frame_rect = _lbl_ticketDetail.frame;
            frame_rect.origin.y = _VW_line1.frame.origin.y + _VW_line1.frame.size.height + 5;
            frame_rect.size.width = orginal_width;
            _lbl_ticketDetail.frame = frame_rect;
            
            frame_rect = _img_icon.frame;
            frame_rect.origin.y = _lbl_ticketDetail.frame.origin.y + 10;
            _img_icon.frame = frame_rect;
            
            float chk_ht = _lbl_ticketDetail.frame.size.height;
            frame_rect = _VW_line2.frame;
            frame_rect.origin.y = _lbl_ticketDetail.frame.origin.y + _lbl_ticketDetail.frame.size.height + 10;
            //    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            //    {
            if (chk_ht < _img_icon.frame.size.height)
            {
                frame_rect.origin.y = _img_icon.frame.origin.y + _img_icon.frame.size.height + 10;
                
                CGRect temp_frame = _lbl_ticketDetail.frame;
                temp_frame.origin.y = _img_icon.frame.origin.y;
                temp_frame.size.height = _img_icon.frame.size.height;
                _lbl_ticketDetail.frame = temp_frame;
            }
            else
            {
                frame_rect.origin.y = _lbl_ticketDetail.frame.origin.y + _lbl_ticketDetail.frame.size.height + 10;
                
                CGRect temp_frame = _img_icon.frame;
                temp_frame.origin.y = _lbl_ticketDetail.frame.origin.y;
                temp_frame.size.height = _lbl_ticketDetail.frame.size.height;
                _img_icon.frame = temp_frame;
            }
            //    }
            
            _VW_line2.frame = frame_rect;
            
            //    frame_rect = _img_icon.frame;
            //    frame_rect.origin.y = _lbl_ticketDetail.frame.origin.y;
            //    _img_icon.frame = frame_rect;
            
            frame_rect = _lbl_titleSubtotal.frame;
            frame_rect.origin.y = _VW_line2.frame.origin.y + _VW_line2.frame.size.height + 10;
            _lbl_titleSubtotal.frame = frame_rect;
            
            
            
            frame_rect = _lbl_datasubtotal.frame;
            frame_rect.origin.y = _VW_line2.frame.origin.y + _VW_line2.frame.size.height + 10;
            _lbl_datasubtotal.frame = frame_rect;
            
            frame_rect = _VW_line3.frame;
            frame_rect.origin.y = _lbl_datasubtotal.frame.origin.y + _lbl_datasubtotal.frame.size.height + 10;
            _VW_line3.frame = frame_rect;
            
            frame_rect = _lbl_titletotal.frame;
            frame_rect.origin.y = _VW_line3.frame.origin.y + _VW_line3.frame.size.height + 10;
            _lbl_titletotal.frame = frame_rect;
            
            frame_rect = _lbl_datatotal.frame;
            frame_rect.origin.y = _VW_line3.frame.origin.y + _VW_line3.frame.size.height + 10;
            _lbl_datatotal.frame = frame_rect;
            
            frame_rect = _BTN_order2.frame;
            frame_rect.origin.y = _lbl_datatotal.frame.origin.y + _lbl_datatotal.frame.size.height + 10;
            _BTN_order2.frame = frame_rect;
            
            frame_rect = _lbl_norms.frame;
            frame_rect.origin.y = _BTN_order2.frame.origin.y + _BTN_order2.frame.size.height + 10;
            _lbl_norms.frame = frame_rect;
            
            rect_content.size.height = _lbl_norms.frame.origin.y + _lbl_norms.frame.size.height + 20;
            
            _VW_contents.frame = rect_content;
            
            [_scroll_contents addSubview:_VW_contents];
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
    
}

-(void) backAction
{
//    [self.navigationController popViewControllerAnimated:NO];
//    checkoutTohome
    NSError *error;
    NSMutableDictionary *dict;
    @try {
        dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"PurchaseRESPONSE"] options:NSJSONReadingAllowFragments error:&error];
        
        
        @try
        {
            NSString *STR_error = [dict valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                NSLog(@"Response from purchase controller :%@",dict);
            }
        }
        @catch (NSException *exception)
        {
            [self sessionOUT];
        }
        
    }
    @catch (NSException *exception)
    {
//        [self performSegueWithIdentifier:@"checkoutTohome" sender:self];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if (dict)
    {
        [self performSegueWithIdentifier:@"checkoutTohome" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"checkoutTohome" sender:self];
    }
    
}

#pragma mark - UIButton Actions
//-(void) BTN_order1action
//{
//    NSLog(@"BTN_order1action tapped");
//    [self performSegueWithIdentifier:@"orderdetailidentifier" sender:self];
//}
-(void) BTN_order2action
{
    NSLog(@"BTN_order2action tapped");
//    [self pay_AMOUNT];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(pay_AMOUNT) withObject:activityIndicatorView afterDelay:0.01];
}

#pragma mark - States and Country
-(void)Country_api
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@city_states/countries",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        countryS = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",countryS);
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
    }
    
    
}
-(void)State_api
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@city_states/states?country=%@",SERVER_URL,conty_code];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData) {
        states = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",states);
    }
}


-(void) pay_AMOUNT
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSMutableDictionary *temp_resp = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"CHKOUTDETAIL"] options:NSASCIIStringEncoding error:&error];
    
    float total = [[temp_resp valueForKey:@"price"] floatValue] * [[temp_resp valueForKey:@"quantity"] floatValue];
    NSString *a = [NSString stringWithFormat:@"%.2f", total];
    
    NSString *nanunce = [[NSUserDefaults standardUserDefaults] valueForKey:@"NAUNCETOK"];
     float total_amount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"total_balance"] floatValue];
    
    NSString *switch_STAT = [[NSUserDefaults standardUserDefaults] valueForKey:@"SWITCHSTAT"];
    NSDictionary *parameters;   
    if([switch_STAT isEqualToString:@"SWITCH_ON"] && total_amount == 0.00)
    {
        parameters = @{ @"transaction_type":@"purchase", @"price":[NSNumber numberWithFloat:[a floatValue]]};
    }
    else
    {
        parameters = @{@"nonce":nanunce, @"transaction_type":@"purchase", @"price":[NSNumber numberWithFloat:[a floatValue]]};
    }
   NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@payments/create",SERVER_URL];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"PurchaseRESPONSE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSError *error;
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"PurchaseRESPONSE"] options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"Response from purchase controller :%@",dict);
        
        if (dict)
        {
            @try
            {
                NSString *STR_error = [dict valueForKey:@"error"];
                if (STR_error)
                {
//                    [self sessionOUT];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction failed" message:@"Please retry later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
                else
                {
                    if ([[dict valueForKey:@"status"] isEqualToString:@"Failure"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                    }
                    else
                    {
                        [self performSegueWithIdentifier:@"purchaseidentifier" sender:self];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
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
@end
