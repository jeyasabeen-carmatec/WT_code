//
//  Vc_Filter_affliate.m
//  WinningTicket
//
//  Created by Test User on 09/06/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Vc_Filter_affliate.h"
#import "filter_cell.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"
#import "UITableView+NewCategory.h"
#import "WinningTicket_Universal-Swift.h"

@class FrameObservingViewAffiliate_filter;

@protocol FrameObservingViewDelegate1 <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_filter *)view;
@end

@interface FrameObservingViewAffiliate_filter : UIView
@property (nonatomic,assign) id<FrameObservingViewDelegate1>delegate;
@end


@interface Vc_Filter_affliate ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,FrameObservingViewDelegate1, UITableViewDragLoadDelegate>
{
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    int k;
    NSMutableDictionary *temp_dict;
//    UILabel *loadingLabel;

}
@property(nonatomic,strong)NSMutableArray *sec_one_ARR,*roles_ARR;

@end

@implementation FrameObservingViewAffiliate_filter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end


@implementation Vc_Filter_affliate

-(void)viewWillAppear:(BOOL)animated{
    
    _filter_tab.estimatedRowHeight = 10.0;
    _filter_tab.rowHeight = UITableViewAutomaticDimension;
    
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
    //        activityIndicatorView.center=myview.center;
    
    
    [_filter_tab setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _filter_tab.showLoadMoreView = YES;
    
    VW_overlay.hidden = YES;
    activityIndicatorView.hidden = YES;
    
    
    [_filter_tab reloadData];


}

- (void)frameObservingViewFrameChanged:(FrameObservingViewAffiliate_filter *)view
{
    _filter_tab.frame = self.view.bounds;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSError *error;
    NSData *aData = [[NSUserDefaults standardUserDefaults] valueForKey:@"AffiliateReferrel"];
    NSMutableDictionary *temp_dictin = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
    NSLog(@"The response VC affiliate Home %@",temp_dict);
    _sec_one_ARR = [temp_dictin valueForKey:@"referrals"];
    

    
//    _sec_one_ARR=[[NSMutableArray alloc]init];
//    
//    NSDictionary *temp_dictin;
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Golf ball with cerficate of authenticity   Jordanspeith Auographed Golf ball with cerficate of authenticity Jordanspeith Auographed Golf ball with cerficate of authenticity",@"key1",@"sponsor",@"key2", nil];
//    [_sec_one_ARR addObject:temp_dictin];
//    
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Tiltlelist",@"key1",@"sponsor",@"key2", nil];
//    [_sec_one_ARR addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Towel From the masters Jordanspeith Auographed Golf ball with cerficate of authenticity   Jordanspeith Auographed Golf ball with cerficate of authenticity Jordanspeith Auographed Golf ball with cerficate of ",@"key1",@"Contributor",@"key2", nil];
//    [_sec_one_ARR addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Jordanspeith Auographed Under Armor GolfShoes",@"key1",@"Contributor",@"key2", nil];
//    [_sec_one_ARR addObject:temp_dictin];temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"TigerWoods Auographed Towel From the masters",@"key1",@"Contributor",@"key2",nil];
//    [_sec_one_ARR addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"TigerWoods Auographed Under Armor GolfShoes",@"key1",@"Contributor",@"key2", nil];
//    [_sec_one_ARR addObject:temp_dictin];
//    
     _roles_ARR=[NSMutableArray arrayWithObjects:@"organizer",@"contributor",@"affiliate",@"sponsor", nil];
    
    _role_picker = [[UIPickerView alloc]init];
    _role_picker.dataSource=self;
    _role_picker.delegate=self;
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_role_picker addGestureRecognizer:tapToSelect];

    _role_textfield.inputView = _role_picker;
    _role_textfield.layer.cornerRadius = 4.0f;
    _role_textfield.layer.borderWidth = 1.2f;
    _role_textfield.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _role_textfield.frame.size.height)];
    leftView.backgroundColor = _role_textfield.backgroundColor;
    _role_textfield.leftView = leftView;
    _role_textfield.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    [numberToolbar sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(numberToolbar.frame.size.width - 100, 0, 100, numberToolbar.frame.size.height);
    [close setTitle:@"close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [numberToolbar addSubview:close];
    _role_textfield.inputAccessoryView = numberToolbar;
    
    [_filter_tab setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _filter_tab.showLoadMoreView = YES;
    

    
    [_filter_tab reloadData];
    
   
    
}
-(void)buttonClick
{
    [_role_textfield resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview Deligates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_sec_one_ARR count] == 0) {
        return 1;
    }
    return _sec_one_ARR.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_sec_one_ARR count] == 0)
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
        filter_cell *cell=(filter_cell *)[tableView dequeueReusableCellWithIdentifier:@"refcell"];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"affiliate_filter_cell_ipad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"affiliate_filter_cell" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        NSDictionary *dictdata=[_sec_one_ARR objectAtIndex:indexPath.row];
        NSDictionary *role = [dictdata valueForKey:@"role"];
        
        cell.description_lbl.text = [[dictdata objectForKey:@"first_name"] capitalizedString];
        cell.description_lbl.numberOfLines=0;
        [cell.description_lbl sizeToFit];
        
        
        NSString *role_name = [NSString stringWithFormat:@"%@",[role valueForKey:@"name"]];
        role_name = [role_name stringByReplacingOccurrencesOfString:@"organizer" withString:@"event organizer"];
        role_name = [role_name stringByReplacingOccurrencesOfString:@"contributor" withString:@"participant"];
        cell.date_time_lbl.text = [role_name capitalizedString];
        cell.date_time_lbl.numberOfLines=0;
        [cell.date_time_lbl sizeToFit];
        [cell.BTN_view setTag:indexPath.row];
        [cell.BTN_view addTarget:self action:@selector(BTN_referalDETAIL:) forControlEvents:
             UIControlEventTouchUpInside];
        
        
        
        
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
    NSDictionary *ref_dict = [_sec_one_ARR objectAtIndex:buttonIndexPath.row];
    
    
    NSLog(@"Affiliate home selected cell %@",ref_dict);
    
    [[NSUserDefaults standardUserDefaults] setObject:ref_dict forKey:@"referral_dict"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [self performSegueWithIdentifier:@"filtertoaffiliatedetail" sender:self];
}


#pragma mark PickerView DataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(pickerView==_role_picker)
    {
        return 1;
    }
    
    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == _role_picker) {
        return [_roles_ARR count];
    }
    
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == _role_picker) {
        NSString *role_name = _roles_ARR[row];
        role_name = [role_name stringByReplacingOccurrencesOfString:@"organizer" withString:@"event organizer"];
        role_name = [role_name stringByReplacingOccurrencesOfString:@"contributor" withString:@"participant"];
        return [role_name capitalizedString];
    }
    
    return nil;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _role_picker) {
        
        NSString *role_name = _roles_ARR[row];
        
        role_name = [role_name stringByReplacingOccurrencesOfString:@"organizer" withString:@"event organizer"];
        role_name = [role_name stringByReplacingOccurrencesOfString:@"contributor" withString:@"participant"];
        
        self.role_textfield.text = [role_name capitalizedString];
        [self.role_textfield resignFirstResponder];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(roles_api_called) withObject:activityIndicatorView afterDelay:0.01];

        
        
        
        
    }
}

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_role_picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_role_picker.bounds, 0.0, (CGRectGetHeight(_role_picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_role_picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_role_picker selectedRowInComponent:0];
            [self pickerView:_role_picker didSelectRow:selectedRow inComponent:0];
        }
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}
-(void)roles_api_called
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *role = self.role_textfield.text;
    
    role = [role stringByReplacingOccurrencesOfString:@"Event Organizer" withString:@"organizer"];
    role = [role stringByReplacingOccurrencesOfString:@"Participant" withString:@"contributor"];
    
    NSString *urlGetuser ;
    urlGetuser =[NSString stringWithFormat:@"%@referrals?role=%@",SERVER_URL,role];
    
    NSLog(@"Post url to server vc affiliate filter %@ ",urlGetuser);
    
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
        
       NSMutableDictionary *temp_dictinry=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        if(temp_dictinry)
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:urlGetuser forKey:@"URL_SAVED_af_filter"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        NSMutableArray *temp_arr = [temp_dictinry valueForKey:@"referrals"];
            NSLog(@"The  filter Data is: %@" , temp_arr);
        [_sec_one_ARR removeAllObjects];
        [_sec_one_ARR addObjectsFromArray:temp_arr];
        [_filter_tab reloadData];
        }
        
        else
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];

        }
        
        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }

}

- (IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - Control datasource

- (void)finishRefresh
{
    [_filter_tab finishRefresh];
}

- (void)finishLoadMore
{
    [_filter_tab finishLoadMore];
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
        
        NSString *url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"URL_SAVED_af_home"],[metadict valueForKey:@"prev_page"]];
        [[NSUserDefaults standardUserDefaults] setValue:url_STR forKey:@"URL_SAVED_tranprev"];
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
        url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_af_filter"],nextPAGE];
        [[NSUserDefaults standardUserDefaults] setValue:url_STR forKey:@"URL_SAVED_trannext"];
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
    
    NSLog(@"Url posted filter next next page %@",urlProducts);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSMutableDictionary *dict;
    if (aData)
    {
        
        NSLog(@"Response filter %@",response);
        
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"From filter response  Next Pagination testing :%@",dict);
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
                [_sec_one_ARR addObjectsFromArray:ARR_tmp];
                
                [_filter_tab reloadData];
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
        NSLog(@"From filter response  prev Pagination testing :%@",json_DATA);
        [_sec_one_ARR removeAllObjects];
        NSArray *ARR_tmp = [json_DATA valueForKey:@"referrals"];
        [_sec_one_ARR addObjectsFromArray:ARR_tmp];
        
        [_filter_tab reloadData];
        
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
