//
//  VC_accounts.m
//  WinningTicket
//
//  Created by Test User on 02/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_accounts.h"
#import "cellACCOUNTS.h"
//#import "DGActivityIndicatorView.h"

#import "ViewController.h"

#pragma mark - Image Cache
#import "SDWebImage/UIImageView+WebCache.h"

@interface VC_accounts () <UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray *section1,*section2;
    UIView *VW_overlay,*profile_view;
    UIActivityIndicatorView *activityIndicatorView;
    NSDictionary *tempdict;
//    UILabel *loadingLabel;
}

@end

@implementation VC_accounts

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
//    [_TBL_contents reloadData];
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
-(void)viewWillAppear:(BOOL)animated
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
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(myaccount_API_calling) withObject:activityIndicatorView afterDelay:0.01];
    [self setup_VIEW];
    
    
}

-(void) setup_VIEW
{
    

    [_segment_bottom setSelectedSegmentIndex:2];
    [_tab_HOME setSelectedItem:[_tab_HOME.items objectAtIndex:2]];
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
    section1 = [[NSArray alloc]initWithObjects:@"Add Funds",@"Donate",@"Withdrawl",@"Transaction History", nil];
    section2 = [[NSArray alloc]initWithObjects:@"Notification Settings",@"How It Works",@"About Us",@"Contact Us",@"Terms of Use",@"Privacy Policy",@"Edit Account Information",@"Change Password",@"Log Out", nil];
    
    _img_profile .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_profile)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    
    [_img_profile addGestureRecognizer:tapGesture1];

}
-(void)tapGesture_profile
{
    
    
    
    CGRect profile_frame;
    profile_frame = _VW_img_BG.frame;
   
    profile_frame.size.width = self.view.frame.size.width - 40;
    profile_frame.size.height = self.view.frame.size.width - 40;
    _VW_img_BG.frame = profile_frame;
  _VW_img_BG.center = self.view.center;
  //  profile.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_VW_img_BG];
    
    
    @try {
        [_IMG_profile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[tempdict valueForKey:@"avatar_url"]]]
                        placeholderImage:[UIImage imageNamed:@"profile_pic.png"]];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception");
    }

    
  
    VW_overlay.hidden = NO;
    _VW_img_BG.hidden = NO;
    
}
- (IBAction)BTN_close:(id)sender {
    
    VW_overlay.hidden = YES;
    
    _VW_img_BG.hidden = YES;
}

-(void)hidde_VW
{
    profile_view.hidden = YES;
  
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
        [self performSegueWithIdentifier:@"event2identifier" sender:self];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(parse_listEvents_api) withObject:activityIndicatorView afterDelay:0.01];
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
        [self performSegueWithIdentifier:@"course2identifier" sender:self];
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
    }
}

#pragma mark - UITableview Datasource/Deligate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [section1 count];
    }
    else
    {
        return [section2 count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    cellACCOUNTS *cell = (cellACCOUNTS *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"cellACCOUNTS~iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"cellACCOUNTS" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 0) {
        NSString *icon_name = [NSString stringWithFormat:@"sec0_%ld",(long)indexPath.row];
        cell.img_icon.image = [UIImage imageNamed:icon_name];
        cell.lbl_title.text = [section1 objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *icon_name = [NSString stringWithFormat:@"sec1_%ld",(long)indexPath.row];
        cell.img_icon.image = [UIImage imageNamed:icon_name];
        cell.lbl_title.text = [section2 objectAtIndex:indexPath.row];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    
            view.tintColor = [UIColor clearColor];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 56;
    }
    else
    {
        return 56;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(get_Denominations) withObject:activityIndicatorView afterDelay:0.01];
                   
                });
            }
                break;
                
            case 1:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(get_EVENTS) withObject:activityIndicatorView afterDelay:0.01];
                });
            }
                
                break;
                
            case 2:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(withdrawl) withObject:activityIndicatorView afterDelay:0.01];
                    
                });
            }
                break;
                
            case 3:
            {
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(transaction_history) withObject:activityIndicatorView afterDelay:0.01];
               
                
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(notification_settings) withObject:activityIndicatorView afterDelay:0.01];
                    
                });
            }
                break;
                
            case 1:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(how_it_works) withObject:activityIndicatorView afterDelay:0.01];
                    
                });
            }
                break;
                
            case 2:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(about_us) withObject:activityIndicatorView afterDelay:0.01];
                    
                });
            }
                break;
                
            case 3:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(contactus_page) withObject:activityIndicatorView afterDelay:0.01];
                });
            }
                break;
                
            case 4:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(terms_of_use) withObject:activityIndicatorView afterDelay:0.01];
                    
                });
            }
                break;
                
            case 5:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(privay_policy) withObject:activityIndicatorView afterDelay:0.01];
                    
                });
            }
                break;
                
            case 6:
            {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(myprofiledit) withObject:activityIndicatorView afterDelay:0.01];

                    
                    
                    
                });
            }
                break;
                
            case 7:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VW_overlay.hidden = NO;
                    [activityIndicatorView startAnimating];
                    [self performSelector:@selector(changepassword) withObject:activityIndicatorView afterDelay:0.01];
                    
                });
            }
                break;
                
            case 8:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self performSegueWithIdentifier:@"accounttowelcomescreen" sender:self];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log out" message:@"Please confirm" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Ok", nil];
                    alert.tag = 1;
                    [alert show];
                    
                });
            }
                break;
                
            default:
                break;
        }
    }
}
-(void)withdrawl
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;

    [self performSegueWithIdentifier:@"accounttowithdrawalidentifier" sender:self];

    
}

-(void)notification_settings
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self performSegueWithIdentifier:@"accnttonotificationidentifier" sender:self];
    
}
-(void)how_it_works
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self performSegueWithIdentifier:@"accnttohowitworksidentifier" sender:self];
    
}
-(void)about_us
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self performSegueWithIdentifier:@"accounttoaboutusidentifier" sender:self];
    
}
-(void)contactus_page
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self performSegueWithIdentifier:@"accounttocontactusIdentifier" sender:self];
    
}
-(void)terms_of_use
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self performSegueWithIdentifier:@"accounttotermsofuseidentifier" sender:self];
    
}
-(void)privay_policy
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self performSegueWithIdentifier:@"accounttoprivacyidentifier" sender:self];
    
}
-(void)myprofiledit
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    
    [self performSegueWithIdentifier:@"accountstoeditprofileidentifier" sender:self];
}

-(void)changepassword
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self performSegueWithIdentifier:@"accounttochangepwdidentifier" sender:self];
}


-(void)transaction_history
{
        NSError *error;
        NSHTTPURLResponse *response = nil;
        
        NSString *urlGetuser ;
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
//        if ([UIScreen mainScreen].bounds.size.height > 667)
//        {
//            urlGetuser = [NSString stringWithFormat:@"%@payments/transaction_history",SERVER_URL];
//        }
//        else
//        {
//            urlGetuser =[NSString stringWithFormat:@"%@payments/transaction_history?page=10",SERVER_URL];
//        }
//        }
//       else
//       {
        urlGetuser =[NSString stringWithFormat:@"%@payments/transaction_history",SERVER_URL];
           
//        }
    

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
            [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"transaction_data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:urlGetuser forKey:@"URL_SAVED_tran"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            
            //        NSLog(@" THe user data is :%@",[[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"]);
            [self performSegueWithIdentifier:@"acounttotransactionidentifier" sender:self];
            
            
        }
        else
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }

}

-(void) get_Denominations
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@contributors/denominations",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        @try
        {
            NSString *STR_error = [json_DATA valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:json_DATA forKey:@"denom_collection"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"The response get_Denominations VC Accounts %@",json_DATA);
                [self performSegueWithIdentifier:@"accountstofundsidentifier" sender:self];
            }
        }
        @catch (NSException *exception)
        {
            [self sessionOUT];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

-(void)get_EVENTS
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@contributors/events",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSMutableDictionary *json_DICTIn = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"oraganisations dictionary is:%@",json_DICTIn);
        
        
        @try
        {
            NSString *STR_error = [json_DICTIn valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:json_DICTIn forKey:@"eventsStored"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self performSegueWithIdentifier:@"accountstodateidentifier" sender:self];
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
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Check Connction" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"" , nil];
        [alert show];
    }
}

-(void) log_OUTAPI
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@users/sign_out",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        NSMutableDictionary *json_DICTIn = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The log out response %@",json_DICTIn);
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginSTAT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"accounttowelcomescreen" sender:self];
}

-(void)myaccount_API_calling
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@my_account",SERVER_USR];
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
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"Account_data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        NSLog(@" THe user data is :%@",[[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"]);
        //        [self performSegueWithIdentifier:@"accountstoeditprofileidentifier" sender:self];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(myprofileapicalling) withObject:activityIndicatorView afterDelay:0.01];
        //        [self myprofileapicalling];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}
-(void)myprofileapicalling
{
    NSData *PFData=[[NSUserDefaults standardUserDefaults]valueForKey:@"Account_data"] ;
    NSError *error;
    if(PFData)
    {
        NSMutableDictionary *account_data=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:PFData options:NSASCIIStringEncoding error:&error];
        NSLog(@"the user data is:%@",account_data);
        
        @try
        {
            NSString *STR_error = [account_data valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
               tempdict=[account_data valueForKey:@"user"];
                NSString *name_STR = [NSString stringWithFormat:@"%@ %@",[tempdict valueForKey:@"first_name"],[tempdict valueForKey:@"last_name"]];
                name_STR = [name_STR stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                name_STR = [name_STR stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                self.first_name.text = name_STR;
//                [self.first_name sizeToFit];
                self.last_name.text=[tempdict valueForKey:@"email"];
//                [self.last_name sizeToFit];
                NSString *amount=[NSString stringWithFormat:@"%.2f",[[account_data valueForKey:@"wallet"] floatValue]];
                self.amount.text =[NSString stringWithFormat:@"$%@",amount];
                
                NSLog(@"Image Url is %@",[NSString stringWithFormat:@"%@%@",IMAGE_URL,[tempdict valueForKey:@"avatar_url"]]);
                
                @try {
                    [_img_profile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[tempdict valueForKey:@"avatar_url"]]]
                                    placeholderImage:[UIImage imageNamed:@"profile_pic.png"]];
                
                    
                } @catch (NSException *exception) {
                    NSLog(@"Exception");
                }
            }
        }
        @catch (NSException *exception)
        {
            [self sessionOUT];
        }
    }
    
    _img_profile.layer.cornerRadius = _img_profile.frame.size.width / 2;
    _img_profile.clipsToBounds = YES;
    

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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        NSLog(@" THe user data is :%@",[[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"]);
        //        [self performSegueWithIdentifier:@"accountstoeditprofileidentifier" sender:self];
//        [self parse_listEvents_api];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}
-(void) parse_listEvents_api
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
        
        //        [self performSegueWithIdentifier:@"logintohomeidentifier" sender:self];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0)
        {
            NSLog(@"Cancel tapped");
        }
        else
        {
            VW_overlay.hidden = NO;
            [activityIndicatorView startAnimating];
            [self performSelector:@selector(log_OUTAPI) withObject:activityIndicatorView afterDelay:0.01];
        }
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
