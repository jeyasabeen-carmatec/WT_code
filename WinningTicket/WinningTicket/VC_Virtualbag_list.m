//
//  VC_Virtualbag_list.m
//  WinningTicket
//
//  Created by Test User on 22/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_Virtualbag_list.h"
#import "CELL_virtualBAG.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface VC_Virtualbag_list ()
{
    NSArray *ARR_virtual_gift_bags;
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation VC_Virtualbag_list

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self API_getVirtualBAG_list];
    // Do any additional setup after loading the view.
    
    //    _TBL_listGIFTS.estimatedRowHeight = 109.0f;
    //    _TBL_listGIFTS.rowHeight = UITableViewAutomaticDimension;
    
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
    [self performSelector:@selector(API_getVirtualBAG_list) withObject:activityIndicatorView afterDelay:0.01];
    [_BTN_back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setup_VIEW];
    
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

#pragma mark - Uiview Customisation
-(void) setup_VIEW
{
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:32.0f]
       } forState:UIControlStateNormal];
    
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
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:_lbl_nav_font.font}];
    self.navigationItem.title = @"VIRTUAL GIFT BAG";
}

#pragma mark - Back Action
-(void) backAction
{
    NSLog(@"Back tapped");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UItableview Datasource/Deligate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ARR_virtual_gift_bags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    CELL_virtualBAG *cell = (CELL_virtualBAG *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CELL_virtualBAG~iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CELL_virtualBAG" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *DICTIN_celldata = [ARR_virtual_gift_bags objectAtIndex:indexPath.row];
    cell.lbl_offername.text = [[DICTIN_celldata valueForKey:@"item_name"] capitalizedString];
    
    NSString *STR_expire_STAT = [NSString stringWithFormat:@"%@",[DICTIN_celldata valueForKey:@"offer_does_not_expire"]];
    if ([STR_expire_STAT isEqualToString:@"0"]) {
        NSString *STR_expire_at = @"Offer expires:";
        NSString *date_STR = [self getLocalDateTimeFromUTC:[DICTIN_celldata valueForKey:@"offer_expires_date"]];
        
        NSString *text = [NSString stringWithFormat:@"%@ %@",STR_expire_at,date_STR];
        
        if ([cell.lbl_status respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: cell.lbl_status.textColor,
                                      NSFontAttributeName: cell.lbl_status.font
                                      };
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:attribs];
            
            // Red text attributes
            //            UIColor *redColor = [UIColor redColor];
            NSRange cmp = [text rangeOfString:STR_expire_at];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:14.0]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:12.0]}
                                        range:cmp];
            }
            
            
            cell.lbl_status.attributedText = attributedText;
        }
        else
        {
            cell.lbl_status.text = text;
        }
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            cell.lbl_status.font = [UIFont fontWithName:@"Montserrat-Bold" size:14.0];
        }
        else
        {
            cell.lbl_status.font = [UIFont fontWithName:@"Montserrat-Bold" size:12.0];
        }
        cell.lbl_status.text = @"This offer does not expire";
    }
    
    NSString *STR_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[DICTIN_celldata valueForKey:@"image"]];
    [cell.IMG_giftIcon sd_setImageWithURL:[NSURL URLWithString:STR_url]
                         placeholderImage:[UIImage imageNamed:@"square-2"]];
    
    //    cell.IMG_giftIcon.layer.borderWidth = 1.0f;
    //    cell.IMG_giftIcon.layer.borderColor = [UIColor blackColor].CGColor;
    
    [cell.BTN_viewOffer setTag:indexPath.row];
    [cell.BTN_viewOffer addTarget:self action:@selector(viewoffer:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void) viewoffer :(UIButton *)sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"Selected index path = %@",buttonIndexPath);
    
    NSDictionary *DICTIN_celldata = [ARR_virtual_gift_bags objectAtIndex:buttonIndexPath.row];
    NSString *STR_gift_ID = [DICTIN_celldata valueForKey:@"id"];
    
    [[NSUserDefaults standardUserDefaults] setObject:STR_gift_ID forKey:@"GIFTID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_getGift_Detail) withObject:activityIndicatorView afterDelay:0.01];
}

-(void) API_getGift_Detail
{
    NSString *STR_gift_ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"GIFTID"];
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@virtual_gift_bag/details",SERVER_URL];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *event_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"event_id"]];
    NSDictionary *parameters = @{ @"event_id":  event_id,@"virtual_gift_bag_id":STR_gift_ID};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth-token"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData) {
        NSMutableDictionary *jsonRESP = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The json response gift detail %@",jsonRESP); //ARR_virtual_gift_bags
        
        if ([[jsonRESP valueForKey:@"status"] isEqualToString:@"Success"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"GIFTDET"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"giftbagtogiftbagdetail" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No response" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{
    //    NSLog(@"Date Input tbl %@",strDate);
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    //    NSLog(@"CurrentDate:%@", currentDate);
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"MM/dd/yyyy"];
    [newFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    return [NSString stringWithFormat:@"%@",[newFormat stringFromDate:currentDate]];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - API Integration
-(void) API_getVirtualBAG_list
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@virtual_gift_bag/list",SERVER_URL];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *event_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"event_id"]];
    NSDictionary *parameters = @{ @"event_id":  event_id};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth-token"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData) {
        NSMutableDictionary *jsonRESP = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The json response %@",jsonRESP); //ARR_virtual_gift_bags
        
        if ([[jsonRESP valueForKey:@"status"] isEqualToString:@"Success"]) {
            ARR_virtual_gift_bags = [jsonRESP valueForKey:@"virtual_gift_bags"];
            
            if ([ARR_virtual_gift_bags count] != 0) {
                [_TBL_listGIFTS reloadData];
                _lbl_nogift.hidden = YES;
            }
            else
            {
                _TBL_listGIFTS.hidden = YES;
                _lbl_nogift.hidden = NO;
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

@end

