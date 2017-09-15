//
//  VC_affiliate_HOME.m
//  WinningTicket
//
//  Created by Test User on 19/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_affiliate_HOME.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"
#import "UITableView+NewCategory.h"

#import "WinningTicket_Universal-Swift.h"

@class FrameObservingViewAffiliate_home;

@protocol FrameObservingViewDelegate1 <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_home *)view;
@end

@interface FrameObservingViewAffiliate_home : UIView
@property (nonatomic,assign) id<FrameObservingViewDelegate1>delegate;
@end

@interface VC_affiliate_HOME ()<FrameObservingViewDelegate1, UITableViewDragLoadDelegate,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray *ARR_sec_one;
@property(nonatomic,strong)NSArray *ARR_search;
@end

@implementation FrameObservingViewAffiliate_home
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end
@implementation VC_affiliate_HOME


{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *temp_dict;
    int k;
    UILabel *search_label;//*loadingLabel;
    CGRect old_frame;
}
- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_home *)view
{
    _tbl_referal.frame = self.view.bounds;
}

-(void)viewWillAppear:(BOOL)animated
{
    _tbl_referal.estimatedRowHeight = 50.0;
    _tbl_referal.rowHeight = UITableViewAutomaticDimension;
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
//    VW_overlay.layer.cornerRadius = 50.0;
    
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
    if(_search_bar.text.length != 0)
    {
        [self.search_bar becomeFirstResponder];
        [self performSelector:@selector(searcH_API) withObject:activityIndicatorView afterDelay:0.01];
    }
    else
    {
        [self performSelector:@selector(API_AffiliateHome) withObject:activityIndicatorView afterDelay:0.01];
    }
    
    [_tbl_referal setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tbl_referal.showLoadMoreView = YES;
    k = 0;
    
    [_tbl_referal reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_BTN_logOUT addTarget:self action:@selector(logout_ACTION) forControlEvents:UIControlEventTouchUpInside];
    old_frame = _search_bar.frame;
}

-(void) logout_ACTION
{
    NSLog(@"Log out Action Tapped");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginSTAT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"affiliatehometoinitialpage" sender:self];
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

#pragma mark - View cutomisation
-(void) setup_VIEW
{
    _search_bar.delegate=self;
    [_search_bar setBarStyle:UIBarStyleBlack];

//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];

    
    search_label = [[UILabel alloc]init];
 [_search_bar setSearchBarStyle:UISearchBarStyleMinimal];
//    search_label.frame = CGRectMake(_search_bar.frame.origin.x,_search_bar.frame.size.height+_search_bar.frame.origin.y , _search_bar.frame.size.width, _VW_title.frame.size.height);
//    search_label.backgroundColor = [UIColor clearColor];
//    search_label.text = [NSString stringWithFormat:@"%lu Results for" ,(unsigned long)_ARR_sec_one.count];
   
    search_label.hidden = YES;
    _vw_LINE.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"affiliate" forKey:@"LoginSTAT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//-(void)buttonClick
//{
//    [self.search_bar resignFirstResponder];
//}

#pragma mark - Uitableview Datasource/Deligate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_ARR_sec_one count] == 0) {
        return 1;
    }
    return _ARR_sec_one.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    referal_cell *cell=[tableView dequeueReusableCellWithIdentifier:c forIndexPath:indexPath];
   if ([_ARR_sec_one count] == 0)
   {
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
       referal_cell *cell = (referal_cell *)[tableView dequeueReusableCellWithIdentifier:@"referal_cell"];
       if (cell == nil)
       {
           NSArray *nib;
           if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
           {
               nib = [[NSBundle mainBundle] loadNibNamed:@"referal_cell_ipad" owner:self options:nil];
           }
           else
           {
               nib = [[NSBundle mainBundle] loadNibNamed:@"referal_cell" owner:self options:nil];
           }
           cell = [nib objectAtIndex:0];
       }
       NSDictionary *dictdata=[_ARR_sec_one objectAtIndex:indexPath.row];
       NSDictionary *role = [dictdata valueForKey:@"role"];
       
       cell.description_lbl.text = [[dictdata objectForKey:@"first_name"] capitalizedString];
       cell.description_lbl.numberOfLines=0;
       [cell.description_lbl sizeToFit];
       
       NSString *role_name = [NSString stringWithFormat:@"%@",[role valueForKey:@"name"]];
       role_name = [role_name stringByReplacingOccurrencesOfString:@"organizer" withString:@"event organizer"];
       role_name = [role_name stringByReplacingOccurrencesOfString:@"contributor" withString:@"participant"];
       cell.date_time_lbl.text = [role_name capitalizedString];
       cell.date_time_lbl.numberOfLines = 0;
       [cell.date_time_lbl sizeToFit];
       [cell.BTN_referalDETAIL setTag:indexPath.row];
       [cell.BTN_referalDETAIL addTarget:self action:@selector(BTN_referalDETAIL:) forControlEvents:
        UIControlEventTouchUpInside];
       
       return cell;
   }
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[_ARR_sec_one objectAtIndex:indexPath.row];
    NSString *str = [dict objectForKey:@"key1"];
    CGSize labelWidth;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        labelWidth = CGSizeMake(_tbl_referal.frame.size.width - 140, CGFLOAT_MAX);
    }
    else
    {
        labelWidth = CGSizeMake(_tbl_referal.frame.size.width - 420, CGFLOAT_MAX);
    }
    
    CGRect textRect = [str boundingRectWithSize:labelWidth options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:19.0]} context:nil];
    int calculatedHeight = textRect.size.height;
    if(calculatedHeight+10 < 75)
    {
        return 75;
    }
    else
    {
        return calculatedHeight;
    }
}
*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1.0];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *titleName = @"";
    if (section == 0) {
        if(_ARR_search.count==0)
        {
            titleName=@"";
        }else{
            titleName = [NSString stringWithFormat:@"%lu Results for %@",(unsigned long)_ARR_search.count,self.search_bar.text];
        }
    }
    else
    {
        titleName = @"Items Related To your Search";
    }
    return  titleName;
    
}



#pragma mark - IBActions
- (IBAction)BTN_editReferrel:(id)sender
{
    [self performSegueWithIdentifier:@"afiliatehmetoedtreferlidentifier" sender:self];
}

- (IBAction)BTN_addReferrel:(id)sender
{
    [self performSegueWithIdentifier:@"afilhometoadrefidentifier" sender:self];
}
- (IBAction)BTN_filter:(id)sender
{
    NSLog(@"BTNFilter");
    
    [self performSegueWithIdentifier:@"affilate_filter_identifier" sender:nil];

}

#pragma mark - Button Action
-(void) BTN_referalDETAIL : (UIButton *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSDictionary *ref_dict = [_ARR_sec_one objectAtIndex:buttonIndexPath.row];
    
    
    NSLog(@"Affiliate home selected cell %@",ref_dict);
    
    [[NSUserDefaults standardUserDefaults] setObject:ref_dict forKey:@"referral_dict"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [self performSegueWithIdentifier:@"affliatehmetorefdetailidentifier" sender:self];
}

#pragma mark - API Calling
-(void) get_DATA
{
    NSError *error;
    NSData *aData = [[NSUserDefaults standardUserDefaults] valueForKey:@"AffiliateReferrel"];
    temp_dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
    
    if (!error)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSLog(@"The response VC affiliate Home %@",temp_dict);
        _ARR_sec_one = [temp_dict valueForKey:@"referrals"];
        search_label.text = [NSString stringWithFormat:@" %lu Results for' '",(unsigned long)[_ARR_sec_one count]];
        [_tbl_referal reloadData];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}


#pragma mark - Affiliate Home API
-(void) API_AffiliateHome
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@referrals?per_page=10",SERVER_URL];
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
        [self setup_VIEW];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}
#pragma mark - Search View Animations
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _navigation_titlebar.backgroundColor = [UIColor whiteColor];
    _title_lbl.hidden = YES;

    _VW_hldBTN.hidden = YES;
    _BTN_logOUT.hidden = YES;
    
   // [_search_bar setTranslucent:YES];
    _search_bar.barTintColor = [UIColor lightGrayColor];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{

        /*Frame Change*/
        _navigation_titlebar.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        _vw_LINE.hidden = NO;
       
        _search_bar.frame = CGRectMake(_search_bar.frame.origin.x, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height + 20,_search_bar.frame.size.width, _search_bar.frame.size.height);
        _search_bar.backgroundColor = [UIColor clearColor];
        _search_bar.showsCancelButton = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

        _search_bar.tintColor = [UIColor clearColor];
        [_search_bar setSearchBarStyle:UISearchBarStyleMinimal];
        [_search_bar setBarStyle:UIBarStyleBlack];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        [_search_bar setTintColor:[UIColor blackColor]];

        search_label.hidden = NO;
        search_label.frame = CGRectMake(_search_bar.frame.origin.x,_search_bar.frame.size.height+_search_bar.frame.origin.y , _search_bar.frame.size.width, _VW_title.frame.size.height);
         [self.view addSubview:search_label];
        search_label.textColor = [UIColor blackColor];


//        NSString *str = _search_bar.text;
        search_label.text = @"Searching ' '";//[NSString stringWithFormat:@" %lu Results for' %@ '",(unsigned long)[_ARR_sec_one count],str];
        
        _VW_title.frame = CGRectMake(_VW_title.frame.origin.x, search_label.frame.origin.y + search_label.frame.size.height + 5 , _VW_title.frame.size.width, _VW_title.frame.size.height);
        _tbl_referal.frame = CGRectMake(_tbl_referal.frame.origin.x, _VW_title.frame.origin.y + _VW_title.frame.size.height , _tbl_referal.frame.size.width, _tbl_referal.frame.size.height);
       
    }];
    [UIView commitAnimations];
//    [self viewDidLayoutSubviews];
    
    return YES;
    
 }
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
  
    _navigation_titlebar.backgroundColor = [UIColor blackColor];
    _title_lbl.hidden = NO;
//    _BTN_edit.hidden=NO;
//    _BTN_filter.hidden=NO;
//    _BTN_new_refral.hidden=NO;
    _BTN_logOUT.hidden = NO;
    _VW_hldBTN.hidden = NO;
    _search_bar.text = @"";
    _vw_LINE.hidden = YES;

    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        
        /*Frame Change*/
        search_label.textColor = [UIColor whiteColor];
        search_label.text = @"";
        search_label.hidden = YES;
        [_search_bar resignFirstResponder];
         _search_bar.frame =  old_frame;
        [searchBar setShowsCancelButton:NO animated:YES];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
         [_search_bar setSearchBarStyle:UISearchBarStyleMinimal];
       
       
        _VW_title.frame = CGRectMake(_VW_title.frame.origin.x, _search_bar.frame.origin.y + _search_bar.frame.size.height, _VW_title.frame.size.width, _VW_title.frame.size.height);
        _tbl_referal.frame = CGRectMake(_tbl_referal.frame.origin.x, _VW_title.frame.origin.y + _VW_title.frame.size.height , _tbl_referal.frame.size.width, _tbl_referal.frame.size.height);
        [self API_AffiliateHome];
        
        
    }];
    [UIView commitAnimations];
    
    NSLog(@"the text is :%@",_search_bar.text);

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    NSString *search_text = _search_bar.text;
    search_label.text = @"";//[NSString stringWithFormat:@"%@",search_text];
    
    UITextField *searchBarTextField = [self findTextFieldFromControl:_search_bar];
    [searchBarTextField addTarget:self action:@selector(getSearch_TXT) forControlEvents:UIControlEventEditingChanged];
    
    
    if([searchText length] != 0)
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(searcH_API) withObject:activityIndicatorView afterDelay:0.01];
    }
}

-(void) getSearch_TXT
{
    NSString *str = _search_bar.text;
    NSLog(@"Updated Text working %@",str);
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    if([str isEqualToString:@""])
    {
        [self performSelector:@selector(get_DATA) withObject:activityIndicatorView afterDelay:0.01];
    }
    
    if([str length] != 0)
    {
        [self performSelector:@selector(searcH_API) withObject:activityIndicatorView afterDelay:0.01];
    }
}

- (UITextField *) findTextFieldFromControl:(UIView *) view
{
    for (UIView *subview in view.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            return (UITextField *)subview;
        }
        else if ([subview.subviews count] > 0)
        {
            UIView *view = [self findTextFieldFromControl:subview];
            if (view) {
                return (UITextField *)view;
            }
        }
    }
    return nil;
}

#pragma mark - Search API
-(void) searcH_API
{
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *search_char = _search_bar.text;
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@referrals?name=%@",SERVER_URL,search_char];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setHTTPShouldHandleCookies:NO];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSMutableDictionary *json_DATA;
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        NSLog(@"The response %@",json_DATA);
        NSMutableArray *temp_ARR = [json_DATA valueForKey:@"referrals"];
        [_ARR_sec_one removeAllObjects];
        [_ARR_sec_one addObjectsFromArray:temp_ARR];
        NSString *str = _search_bar.text;
        search_label.text = [NSString stringWithFormat:@" %lu Results for' %@ '",(unsigned long)[_ARR_sec_one count],str];
        [_tbl_referal reloadData];
        
        
        if(!json_DATA)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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


    


#pragma mark - Control datasource

- (void)finishRefresh
{
    [_tbl_referal finishRefresh];
}

- (void)finishLoadMore
{
    [_tbl_referal finishLoadMore];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //Pull up go to First Page
    NSDictionary *metadict=[temp_dict valueForKey:@"meta"];
    NSString *prev_PAGE = [NSString stringWithFormat:@"%@",[metadict valueForKey:@"prev_page"]];
    if ([prev_PAGE isEqualToString:@"0"])
    {
        //        [activityIndicatorView stopAnimating];
        //        VW_overlay.hidden = YES;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Already in First Page" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        //        [alert show];
        [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.01];
    }
    else{
        
        NSString *url_STR = [NSString stringWithFormat:@"%@&page=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"URL_SAVED_af_home"],[metadict valueForKey:@"prev_page"]];
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
        url_STR = [NSString stringWithFormat:@"%@&page=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_af_home"],nextPAGE];
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
                
                NSArray *ARR_tmp = [dict valueForKey:@"referrals"];
                [_ARR_sec_one addObjectsFromArray:ARR_tmp];
                
                [_tbl_referal reloadData];
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
        
        [_tbl_referal reloadData];
        
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
