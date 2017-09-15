//
//  VC_referralDETAIL.m
//  WinningTicket
//
//  Created by Test User on 25/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_referralDETAIL.h"
#import "add_referal_detail_cell.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"
#import "UITableView+NewCategory.h"

#import "WinningTicket_Universal-Swift.h"

@class FrameObservingViewAffiliate_referal_detail;

@protocol FrameObservingViewDelegate1 <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_referal_detail *)view;
@end

@interface FrameObservingViewAffiliate_referal_detail : UIView
@property (nonatomic,assign) id<FrameObservingViewDelegate1>delegate;
@end



@interface VC_referralDETAIL ()<UITableViewDelegate,UITableViewDataSource,FrameObservingViewDelegate1, UITableViewDragLoadDelegate>
{
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *temp_dict;
    NSDictionary *referal_detail_dict;
    int k;
    
//    UILabel *loadingLabel;
}
@property(nonatomic,strong)NSMutableArray *ARR_sec_one;
@property (weak, nonatomic) IBOutlet UITableView *TBL_referal;
@end
@implementation FrameObservingViewAffiliate_referal_detail
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end


@implementation VC_referralDETAIL

- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_referal_detail *)view
{
    _TBL_referal.frame = self.view.bounds;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    _TBL_referal.estimatedRowHeight = 10.0;
    _TBL_referal.rowHeight = UITableViewAutomaticDimension;
    
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
    [self performSelector:@selector(API_AffiliateHome) withObject:activityIndicatorView afterDelay:0.01];
    
    
    
    //    [self performSelector:@selector(API_AffiliateHome) withObject:activityIndicatorView afterDelay:0.01];
    
    [_TBL_referal setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _TBL_referal.showLoadMoreView = YES;
    k = 0;
 
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIView Customisation
-(void) setupView
{
//    NSDate *date= [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd,HH:MM:SS"];
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    NSLog(@"Current date is %@",dateString);
//    _ARR_sec_one=[[NSMutableArray alloc]init];
//    
//    NSDictionary *temp_dictin;
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Golf ball with cerficate of authenticity   Jordanspeith Auographed Golf ball with cerficate of authenticity Jordanspeith Auographed Golf ball with cerficate of authenticity",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Tiltlelist",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Towel From the masters Jordanspeith Auographed Golf ball with cerficate of authenticity   Jordanspeith Auographed Golf ball with cerficate of authenticity Jordanspeith Auographed Golf ball with cerficate of ",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Under Armor GolfShoes",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"TigerWoods Auographed Towel From the masters",@"key1",dateString,@"key2",nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"TigerWoods Auographed Under Armor GolfShoes",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    
//    _TXT_phone.layer.cornerRadius = 2.0f;
    _TXT_phone.layer.borderWidth = 2.0f;
    _TXT_phone.layer.borderColor = [UIColor blackColor].CGColor;
//    _TXT_email.layer.cornerRadius = 2.0f;
    _TXT_email.layer.borderWidth = 2.0f;
    _TXT_email.layer.borderColor = [UIColor blackColor].CGColor;

    
    
    referal_detail_dict=[[NSUserDefaults standardUserDefaults] valueForKey:@"referral_dict"];
    
    NSString *des = [[referal_detail_dict valueForKey:@"first_name"] capitalizedString];

    NSDictionary *temp_dictin = [referal_detail_dict valueForKey:@"role"];
    _TXT_phone.text = [referal_detail_dict valueForKey:@"phone"];
    _TXT_email.text = [referal_detail_dict valueForKey:@"email"];
    
   
    NSString *role =  [temp_dictin valueForKey:@"name"];
    role = [role stringByReplacingOccurrencesOfString:@"organizer" withString:@"event organizer"];
    role = [role stringByReplacingOccurrencesOfString:@"contributor" withString:@"participant"];
//     _TXT_detils.text = role;
//    _TXT_detils.textColor = [UIColor grayColor];
//    _TXT_detils.placeholder = des;
    
    _lbl_sub_TITL.text = [NSString stringWithFormat:@"All %@ Donations",[role capitalizedString]];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@",des,[role capitalizedString]];
    // Define general attributes for the entire text
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSFontAttributeName: [UIFont fontWithName:@"Gotham-LightItalic" size:17]
                              };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
    
    
    UIFont *boldFont = [UIFont fontWithName:@"GothamBook" size:25];
    NSRange range = [text rangeOfString:des];
    [attributedText setAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                    NSFontAttributeName:boldFont} range:range];

    
   UIFont *unboldFont = [UIFont fontWithName:@"Gotham-LightItalic" size:17]; //
    NSRange greenTextRange = [text rangeOfString:role];
    [attributedText setAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                    NSFontAttributeName:unboldFont} range:greenTextRange];
    
    self.lbl_title.attributedText = attributedText;
}

#pragma mark - UITableviewDatasource/Deligate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_ARR_sec_one count] == 0) {
        return 1;
    }
    return _ARR_sec_one.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_ARR_sec_one count] == 0) {
        cell_EMPTY_val *cell = (cell_EMPTY_val *)[tableView dequeueReusableCellWithIdentifier:@"cell_EMPTY_val"];
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
        
        cell.lbl_emptycell.text = @"No records found";
        cell.lbl_emptycell.numberOfLines = 0;
        [cell.lbl_emptycell sizeToFit];
        
        return cell;
    }
    else
    {
        add_referal_detail_cell *cell = (add_referal_detail_cell *)[tableView dequeueReusableCellWithIdentifier:@"addrefcell"];
        
        
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_add_referral~ipad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_add_referral" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
        
        
        
        NSDictionary *dictdata=[_ARR_sec_one objectAtIndex:indexPath.row];
        if(!dictdata)
        {
            cell.description_lbl.text = @"NO data Found";
        }
        else
        {
            
            cell.description_lbl.text = [[dictdata valueForKey:@"name"] capitalizedString];
            cell.description_lbl.numberOfLines=0;
            [cell.description_lbl sizeToFit];
            
            cell.date_time_lbl.text = [self getLocalDateTimeFromUTC:[dictdata valueForKey:@"start_date"]];
            cell.date_time_lbl.numberOfLines=0;
            [cell.date_time_lbl sizeToFit];
            [cell.BTN_referalDETAIL setTag:indexPath.row];
            [cell.BTN_referalDETAIL addTarget:self action:@selector(BTN_referalDETAIL:) forControlEvents:
             UIControlEventTouchUpInside];
        }
        
        
        if(indexPath.row % 2 == 0){
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
            
            
        }else{
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1.0];
        }
        return cell;
    }
}

#pragma mark - Button Action
-(void) BTN_referalDETAIL : (UIButton *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"From Delete Skill %ld",(long)buttonIndexPath.row);
    
    NSString *index_str = [NSString stringWithFormat:@"%ld",(long)buttonIndexPath.row];
    
    NSLog(@"Index path of All Event %@",index_str);
    
   // [self performSegueWithIdentifier:@"affliatehmetorefdetailidentifier" sender:self];
}



#pragma mark - API Calling
-(void) get_DATA
{
    NSError *error;
    NSData *aData = [[NSUserDefaults standardUserDefaults] valueForKey:@"AffiliateReferrel"];
    temp_dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
    
    NSLog(@"The response VC affiliate Home %@",temp_dict);
    _ARR_sec_one = [temp_dict valueForKey:@"events"];
    if(!_ARR_sec_one)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No data Found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
        [_TBL_referal reloadData];
    }
    [_TBL_referal reloadData];
}

#pragma mark - IBActions
- (IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void) API_AffiliateHome
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@referrals/show/%@",SERVER_URL,[referal_detail_dict valueForKey:@"id"]];
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
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"AffiliateReferrel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:urlGetuser forKey:@"URL_SAVED_af_home"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        [self get_DATA];
//        [self setup_VIEW];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
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

#pragma mark - Control datasource

- (void)finishRefresh
{
    [_TBL_referal finishRefresh];
}

- (void)finishLoadMore
{
    [_TBL_referal finishLoadMore];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //Pull up go to First Page
    NSDictionary *metadict=[temp_dict valueForKey:@"meta"];
    NSString *prev_PAGE = [NSString stringWithFormat:@"%@?page=",[metadict valueForKey:@"prev_page"]];
    if ([prev_PAGE isEqualToString:@"0"])
    {
        //        [activityIndicatorView stopAnimating];
        //        VW_overlay.hidden = YES;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Already in First Page" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        //        [alert show];
        [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.01];
    }
    else{
        
        NSString *url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"URL_SAVED_af_home"],[metadict valueForKey:@"prev_page"]];
        [[NSUserDefaults standardUserDefaults] setObject:url_STR forKey:@"URL_SAVED_tranprev"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(firstpage_API) withObject:nil afterDelay:0.01];
    }
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //Pull up go to NextPage
    //    NSLog(@"The response ALLEvents Pagination Method %@",json_DATA);
    NSString *url_STR;
    
    NSDictionary *temp_dictinry = [temp_dict valueForKey:@"meta"];
    int i=[[temp_dictinry valueForKey:@"next_page"] intValue];
    NSString *nextPAGE = [NSString stringWithFormat:@"%i",i];
    if ([nextPAGE isEqualToString:@"0"])
    {
        //        [activityIndicatorView stopAnimating];
        //        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Already in Last Page" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
    }
    else
    {
        url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_af_home"],nextPAGE];
        [[NSUserDefaults standardUserDefaults] setObject:url_STR forKey:@"URL_SAVED_trannext"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(nextpage_API) withObject:nil afterDelay:0.01];
    }
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

-(void) nextpage_API
{
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_trannext"]]];
    
    NSLog(@"Url posted affilate list next page %@",urlProducts);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSMutableDictionary *dict;
    if (aData)
    {
        
        NSLog(@"Response Affiliate  %@",response);
        
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"From Affilate page Next Pagination testing :%@",dict);
        NSDictionary *temp=[dict valueForKey:@"meta"];
        int i=[[temp valueForKey:@"total_pages"] intValue];
        int j=[[temp valueForKey:@"current_page"]intValue];
        
        
        if(i >= j)
        {
            
            k++;
            if(k >= i)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Already in Last Page" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
                
                
            }
            else{
                
                NSArray *ARR_tmp = [dict valueForKey:@"events"];
                [_ARR_sec_one addObjectsFromArray:ARR_tmp];
                
                [_TBL_referal reloadData];
            }
            
        }
        
        
    }
    
    
    
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:0.01];
}

-(void) firstpage_API
{
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_tranprev"]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSMutableDictionary *json_DATA=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"From Affiliate  prev Pagination testing :%@",json_DATA);
        [_ARR_sec_one removeAllObjects];
        NSArray *ARR_tmp = [json_DATA valueForKey:@"referrals"];
        [_ARR_sec_one addObjectsFromArray:ARR_tmp];
        
        [_TBL_referal reloadData];
        
    }
    
    
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.01];
}



@end
