//
//  VC_editRefferel.m
//  WinningTicket
//
//  Created by Test User on 21/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_editRefferel.h"
#import "edit_referal_Cell.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"
#import "UITableView+NewCategory.h"

#import "WinningTicket_Universal-Swift.h"



@class FrameObservingViewAffiliate_edit_referal;

@protocol FrameObservingViewDelegate1 <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_edit_referal *)view;
@end

@interface FrameObservingViewAffiliate_edit_referal : UIView
@property (nonatomic,assign) id<FrameObservingViewDelegate1>delegate;
@end



@interface VC_editRefferel ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FrameObservingViewDelegate1, UITableViewDragLoadDelegate>
{
    
        UIView *VW_overlay;
        UIActivityIndicatorView *activityIndicatorView;
        NSMutableDictionary *temp_dict;
        int k;
    UILabel *search_label;//,*loadingLabel;
    CGRect old_frame;
}
@property(nonatomic,strong)NSMutableArray *ARR_sec_one;
@property(nonatomic,strong)NSArray *ARR_search_arr;

@end
@implementation FrameObservingViewAffiliate_edit_referal
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end


@implementation VC_editRefferel
- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_edit_referal *)view
{
    _tbl_edit_referral.frame = self.view.bounds;
}
-(void)viewWillAppear:(BOOL)animated
{
    _tbl_edit_referral.estimatedRowHeight = 10.0;
    _tbl_edit_referral.rowHeight = UITableViewAutomaticDimension;
    
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
    if(_search_bar.text.length != 0)
    {
        [self.search_bar becomeFirstResponder];
        
        [self performSelector:@selector(searcH_API) withObject:activityIndicatorView afterDelay:0.01];
    }
    else
    {
        [self performSelector:@selector(getdata) withObject:activityIndicatorView afterDelay:0.01];
    }

    

    
    //    [self performSelector:@selector(API_AffiliateHome) withObject:activityIndicatorView afterDelay:0.01];
    
    [_tbl_edit_referral setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tbl_edit_referral.showLoadMoreView = YES;
    k = 0;
    
    
    
    
    
}
-(void)getdata
{
    NSError *error;
    NSData *aData = [[NSUserDefaults standardUserDefaults] valueForKey:@"AffiliateReferrel"];
    NSMutableDictionary *temp_dictin = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
    if(!error)
    {
        NSLog(@"The response VC affiliate Home %@",temp_dict);
        _ARR_sec_one = [temp_dictin valueForKey:@"referrals"];
        search_label.text = [NSString stringWithFormat:@" %lu Results for' '",(unsigned long)[_ARR_sec_one count]];
        [_tbl_edit_referral reloadData];
        
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Uiview Customisation
-(void) setupView
{
    self.search_bar.delegate=self;
    [_search_bar setBarStyle:UIBarStyleBlack];

    old_frame = _search_bar.frame;
    
    _search_bar.delegate=self;
    search_label = [[UILabel alloc]init];
    [_search_bar setSearchBarStyle:UISearchBarStyleMinimal];
    search_label.hidden = YES;
    _vw_LINe.hidden = YES;
    
//    NSDate *date= [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd,HH:MM:SS"];
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    NSLog(@"Current date is %@",dateString);
//    _ARR_sec_one=[[NSMutableArray alloc]init];
//    
//    NSDictionary *temp_dictin;
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Golf ball with cerficate of authenticityJordanspeith Auographed Golf ball with cerficate of authenticityJordanspeith Auographed Golf ball with cerficate of authenticity",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Tiltlelist",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Towel From the mastersJordanspeith Auographed Golf ball with cerficate of authenticity   Jordanspeith Auographed Golf ball with cerficate of authenticity Jordanspeith Auographed Golf ball with cerficate of ",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Under Armor GolfShoes",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"TigerWoods Auographed Towel From the masters",@"key1",dateString,@"key2",nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"TigerWoods Auographed Under Armor GolfShoes",@"key1",dateString,@"key2", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//    [numberToolbar sizeToFit];
//    
//    UIButton *close=[[UIButton alloc]init];
//    close.frame=CGRectMake(numberToolbar.frame.size.width - 100, 0, 100, numberToolbar.frame.size.height);
//    [close setTitle:@"close" forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [numberToolbar addSubview:close];
//    _search_bar.inputAccessoryView = numberToolbar;
}

#pragma mark - Custom Methords
-(void)buttonClick
{
    [self.search_bar resignFirstResponder];
}

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
        edit_referal_Cell *cell = (edit_referal_Cell *)[tableView dequeueReusableCellWithIdentifier:@"eidtrefcell"];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_edit_referral~ipad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_edit_referral" owner:self options:nil];
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
        cell.dete_time_lbl.text = [role_name capitalizedString];
        cell.dete_time_lbl.numberOfLines=0;
        [cell.dete_time_lbl sizeToFit];
        [cell.delete_button setTag:indexPath.row];
        [cell.delete_button addTarget:self action:@selector(BTN_referalDETAIL:) forControlEvents:
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
        labelWidth = CGSizeMake(_tbl_edit_referral.frame.size.width - 140, CGFLOAT_MAX);
    }
    else
    {
        labelWidth = CGSizeMake(_tbl_edit_referral.frame.size.width - 420, CGFLOAT_MAX);
    }
    CGRect textRect = [str boundingRectWithSize:labelWidth options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:19.0]} context:nil];
    int calculatedHeight = textRect.size.height;
    if(calculatedHeight+10 < 70)
    {
        return 70;
        
    }
    else{
        return calculatedHeight;
    }
}
*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
        
        
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1.0];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *titleName = @"";
    if (section == 0) {
        if(_ARR_search_arr.count==0)
        {
            titleName=@"";
        }else{
            titleName = [NSString stringWithFormat:@"%lu Results for %@",(unsigned long)_ARR_search_arr.count,self.search_bar.text];
        }
    }else{
        titleName = @"Items Related To your Search";
    }
    return  titleName;
    
}
#pragma mark - Button Action
-(void) BTN_referalDETAIL : (UIButton *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"From Delete Skill %ld",(long)buttonIndexPath.row);
    NSDictionary *ref_dict = [_ARR_sec_one objectAtIndex:buttonIndexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:ref_dict forKey:@"referral_dict"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString *index_str = [NSString stringWithFormat:@"%ld",(long)buttonIndexPath.row];
    
    NSLog(@"Index path of All Event %@",index_str);
  [self performSegueWithIdentifier:@"update_identifier" sender:self];
}



#pragma mark - IBActions
- (IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - Search View Animations
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    _VW_nav_top.backgroundColor = [UIColor whiteColor];
    _tilte_label.hidden = YES;
    
    
    
    // [_search_bar setTranslucent:YES];
    _search_bar.barTintColor = [UIColor lightGrayColor];
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        
        /*Frame Change*/
        _VW_nav_top.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        _BTN_back.hidden = YES;
        _vw_LINe.hidden = NO;
        
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
        search_label.frame = CGRectMake(6,_search_bar.frame.size.height+_search_bar.frame.origin.y + 3, _search_bar.frame.size.width - 6, _VW_title.frame.size.height);
        [self.view addSubview:search_label];
        search_label.textColor = [UIColor blackColor];
        
        
//        NSString *str = _search_bar.text;
        search_label.text = @"Searching ' '";//[NSString stringWithFormat:@" %lu Results for' %@ '",(unsigned long)[_ARR_sec_one count],str];
        
        _VW_title.frame = CGRectMake(_VW_title.frame.origin.x, search_label.frame.origin.y + search_label.frame.size.height + 5, _VW_title.frame.size.width, _VW_title.frame.size.height);
        _tbl_edit_referral.frame = CGRectMake(_tbl_edit_referral.frame.origin.x, _VW_title.frame.origin.y + _VW_title.frame.size.height , _tbl_edit_referral.frame.size.width, _tbl_edit_referral.frame.size.height);
        
    }];
    [UIView commitAnimations];
    //    [self viewDidLayoutSubviews];
    
    return YES;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    
    _VW_nav_top.backgroundColor = [UIColor blackColor];
    _tilte_label.hidden = NO;
       _search_bar.text = @"";
    _vw_LINe.hidden = YES;
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        
        /*Frame Change*/
        [self.navigationItem.leftBarButtonItem.customView setAlpha:1.0];
        _BTN_back.hidden = NO;
        search_label.textColor = [UIColor whiteColor];
        search_label.text = @"";
        search_label.hidden = YES;
        [_search_bar resignFirstResponder];
        _search_bar.frame =  old_frame;
        [searchBar setShowsCancelButton:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [_search_bar setSearchBarStyle:UISearchBarStyleMinimal];        
        
        _VW_title.frame = CGRectMake(_VW_title.frame.origin.x, _search_bar.frame.origin.y + _search_bar.frame.size.height, _VW_title.frame.size.width, _VW_title.frame.size.height);
        _tbl_edit_referral.frame = CGRectMake(_tbl_edit_referral.frame.origin.x, _VW_title.frame.origin.y + _VW_title.frame.size.height , _tbl_edit_referral.frame.size.width, _tbl_edit_referral.frame.size.height);
        [self getdata];
        
        
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
    search_label.text = [NSString stringWithFormat:@" %lu Results for' %@ '",(unsigned long)[_ARR_sec_one count],str];
    NSLog(@"Updated Text working %@",str);
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    if([str isEqualToString:@""])
    {
        [self performSelector:@selector(getdata) withObject:activityIndicatorView afterDelay:0.01];
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
        [_tbl_edit_referral reloadData];
        
        
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
    [_tbl_edit_referral finishRefresh];
}

- (void)finishLoadMore
{
    [_tbl_edit_referral finishLoadMore];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //Pull up go to First Page
  /*  NSDictionary *metadict=[temp_dict valueForKey:@"meta"];
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
    }*/
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.01];
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
                
                [_tbl_edit_referral reloadData];
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
        
        [_tbl_edit_referral reloadData];
        
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
