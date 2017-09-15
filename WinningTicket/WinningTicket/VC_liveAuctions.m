//
//  VC_liveAuctions.m
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_liveAuctions.h"
#import <Foundation/Foundation.h>
#import "auction_CellTableViewCell.h"
#import "ViewController.h"

#pragma mark - Pagination
#import "UITableView+NewCategory.h"

#pragma mark - Image Cache
#import "SDWebImage/UIImageView+WebCache.h"

#import "WinningTicket_Universal-Swift.h"

@class FrameObservingViewAuctions;

@protocol FrameObservingDelegateAuctions <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingViewAuctions *)view;
@end

@interface FrameObservingViewAuctions : UIView
@property (nonatomic,assign) id<FrameObservingDelegateAuctions>delegate;
@end

@implementation FrameObservingViewAuctions
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end


@interface VC_liveAuctions () <FrameObservingDelegateAuctions, UITableViewDragLoadDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    UIBarButtonItem *anotherButton;
//    NSString *titleName;
    NSMutableDictionary *json_DATA;
    NSArray *ARR_search;
    NSMutableArray *sec_one_ARR;
    int tag;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *liveauction;
@property (retain, nonatomic) IBOutlet UIView *navigation_titlebar;
@property(nonatomic,strong)NSArray *search_arr,*reverse_order;
//@property(nonatomic,strong)NSDictionary *cpy_dict;
@property (retain, nonatomic) IBOutlet UISearchBar *search_bar;


@end

@implementation VC_liveAuctions

- (void)frameObservingViewFrameChanged:(FrameObservingViewAuctions *)view
{
    _auctiontab.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.auctiontab.tableFooterView = [UIView new];
    _tbl_search.tableFooterView = [UIView new];
    
    [self setup_VIEW];
    
    _lbl_NoData.hidden = YES;
    _tbl_search.hidden = YES;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.title = nil;
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    sec_one_ARR = [[NSMutableArray alloc] init];
    
    [_auctiontab setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _auctiontab.showLoadMoreView = YES;
    
    NSError *error;
    NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    NSDictionary *Dictin_event = [dict valueForKey:@"event"];
    NSString *STR_sent_TXT = [NSString stringWithFormat:@"auction/list/%@",[Dictin_event valueForKey:@"id"]];
    
    [[NSUserDefaults standardUserDefaults] setValue:STR_sent_TXT forKey:@"URL_SENT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSelector:@selector(API_liveAuctions) withObject:activityIndicatorView afterDelay:0.01];
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
-(void) setup_VIEW
{
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:32.0f]
       } forState:UIControlStateNormal];
    
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
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
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]}];
    self.navigationItem.title = @"Silent Auctions";
    
//    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
//                                                                     target:self action:@selector(more_ACTION)];
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton ] animated:NO];

    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    [numberToolbar sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(numberToolbar.frame.size.width - 100, 0, 100, numberToolbar.frame.size.height);
    [close setTitle:@"close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [numberToolbar addSubview:close];
    _search_bar.inputAccessoryView = numberToolbar;
    
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
}

-(void)buttonClick
{
    [self.search_bar resignFirstResponder];
}

#pragma mark - Back Action
-(void) backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void) more_ACTION
{
    NSLog(@"More actions tapped");
}

#pragma mark - UITableview Data/deligate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbl_search) {
        return [ARR_search count];
    }
    return [sec_one_ARR count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbl_search) {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        Search_cell *cell = (Search_cell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"Search_cell~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"Search_cell" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
//        NSDictionary *Dictin_temp = 
        cell.lbl_item_name.text = [ARR_search objectAtIndex:indexPath.row];;
        return cell;
    }
    else
    {
        auction_CellTableViewCell *auc_cell=[tableView dequeueReusableCellWithIdentifier:@"auc_cell"];
        //    if(indexPath.section==0)
        //    {
        
        @try {
            NSDictionary *cpy_dict = [sec_one_ARR objectAtIndex:indexPath.row];
            //        auc_cell.image_display.image =[UIImage imageNamed:[_cpy_dict objectForKey:@"key4"]];
            NSString *url_str = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[cpy_dict valueForKey:@"item_image"]];
            [auc_cell.image_display sd_setImageWithURL:[NSURL URLWithString:url_str]
                                      placeholderImage:[UIImage imageNamed:@"Logo_WT.png"]];
            auc_cell.name_lbl.text = [cpy_dict objectForKey:@"name"];
            
            //[_cpy_dict objectForKey:@"key3"]; @"Startingbid"
            
            
            NSString *STR_Expired = [NSString stringWithFormat:@"%@",[cpy_dict valueForKey:@"is_expired?"]];
            NSString *STR_live = [NSString stringWithFormat:@"%@",[cpy_dict valueForKey:@"is_live?"]];
            
            if ([STR_live isEqualToString:@"0"] && [STR_Expired isEqualToString:@"0"]) {
                auc_cell.bid_Lbl.text = @"Starting Bid";
                auc_cell.currency_lbl.text = [NSString stringWithFormat:@"US $%.2f",[[cpy_dict valueForKey:@"starting_bid"] floatValue]];
            }
            else if ([STR_live isEqualToString:@"1"])
            {
                auc_cell.bid_Lbl.text = @"Current Bid";
                @try {
                    auc_cell.currency_lbl.text = [NSString stringWithFormat:@"US $%.2f",[[cpy_dict valueForKey:@"current_bid_amount"] floatValue]];
                } @catch (NSException *exception) {
                    auc_cell.currency_lbl.text = [NSString stringWithFormat:@"US $%.2f",[[cpy_dict valueForKey:@"starting_bid"] floatValue]];
                }
            }
            else
            {
                auc_cell.bid_Lbl.textColor = [UIColor redColor];
                auc_cell.bid_Lbl.text = @"Sold";
                
                @try {
                    auc_cell.currency_lbl.text = [NSString stringWithFormat:@"US $%.2f",[[cpy_dict valueForKey:@"current_bid_amount"] floatValue]];
                } @catch (NSException *exception) {
                    auc_cell.currency_lbl.text = [NSString stringWithFormat:@"US $%.2f",[[cpy_dict valueForKey:@"starting_bid"] floatValue]];
                }
            }
            
            NSString *tmp_bid = [cpy_dict valueForKey:@"current_bid_amount"];
            if (!tmp_bid) {
                auc_cell.bid_Lbl.text = @"Starting Bid";
            }
            
            
        } @catch (NSException *exception) {
            NSLog(@"Exception %@",exception);
        }
        
        
        
        // return auc_cell;
        //
        //    }
        //
        //    NSDictionary *remain = [_sec_one_ARR objectAtIndex:indexPath.row];
        //    NSString *url_str = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[remain valueForKey:@"item_image"]];
        //    [auc_cell.image_display sd_setImageWithURL:[NSURL URLWithString:url_str]
        //                              placeholderImage:[UIImage imageNamed:@"Logo_WT.png"]];
        //    auc_cell.name_lbl.text = [remain objectForKey:@"name"];
        //    auc_cell.currency_lbl.text = [NSString stringWithFormat:@"US $%.2f",[[remain objectForKey:@"starting_bid"] floatValue]];
        //    auc_cell.bid_Lbl.text = @"Startingbid";//[remain objectForKey:@"key3"];
        return auc_cell;
    }
}
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [self.auctiontab reloadData];
//    
//}
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbl_search) {
        return [NSString stringWithFormat:@"%lu results For %@",(unsigned long)ARR_search.count,_search_bar.text];;
    }
    
   // titleName = @"";
//    if (section == 0) {
        titleName = [NSString stringWithFormat:@"%lu results For %@",(unsigned long)_sec_one_ARR.count,_search_bar.text];
   // }
//    }else{
//        titleName = @"Items Related To your Search";
//    }
    return  titleName;
    
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbl_search)
    {
//        [ARR_singleTON_Content clearData];
        [sec_one_ARR removeAllObjects];
        [sec_one_ARR dealloc];
        sec_one_ARR = [[NSMutableArray alloc] init];
        _auctiontab.hidden = YES;
        
        NSLog(@"selected Item %@",[ARR_search objectAtIndex:indexPath.row]);
        [_search_bar resignFirstResponder];
        _tbl_search.hidden = YES;
        NSError *error;
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
        NSDictionary *Dictin_event = [dict valueForKey:@"event"];
        NSString *STR_sent_TXT = [NSString stringWithFormat:@"auction/list/%@?query=%@",[Dictin_event valueForKey:@"id"],[ARR_search objectAtIndex:indexPath.row]];
//        STR_sent_TXT = [STR_sent_TXT stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        tag = 0;
        
        [[NSUserDefaults standardUserDefaults] setValue:STR_sent_TXT forKey:@"URL_SENT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(API_liveAuctions) withObject:activityIndicatorView afterDelay:0.01];
    }
    else
    {
        NSDictionary *cpy_dict = [sec_one_ARR objectAtIndex:indexPath.row];
        NSString *STR_Expired = [NSString stringWithFormat:@"%@",[cpy_dict objectForKey:@"is_expired?"]];
        NSString *STR_live = [NSString stringWithFormat:@"%@",[cpy_dict objectForKey:@"is_live?"]];
        NSString *STR_bidSTAT;
        
        if ([STR_live isEqualToString:@"0"] && [STR_Expired isEqualToString:@"0"]) {
            STR_bidSTAT = @"Starting Bid";
        }
        else if ([STR_live isEqualToString:@"1"])
        {
            STR_bidSTAT = @"Current Bid";
        }
        else
        {
            STR_bidSTAT = @"Closed";
        }
        
//        NSString *tmp_bid = [_cpy_dict valueForKey:@"current_bid_amount"];
//        if (!tmp_bid) {
//            auc_cell.bid_Lbl.text = @"Starting Bid";
//        }
        
        NSDictionary *temp_DICTIN = [sec_one_ARR objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setValue:STR_bidSTAT forKey:@"STR_bidSTAT"];
        [[NSUserDefaults standardUserDefaults] setValue:[temp_DICTIN valueForKey:@"id"] forKey:@"prev_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"auctionstoitemdetailidentifier" sender:self];
    }
}-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.auctiontab respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.auctiontab setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.auctiontab respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.auctiontab setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([_tbl_search respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tbl_search setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tbl_search respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tbl_search setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - API implementation
-(void) API_liveAuctions
{
    
    NSString *url_STR = [[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SENT"];
    
    _tbl_search.hidden = YES;
    _auctiontab.hidden = YES;
    NSHTTPURLResponse *response = nil;
    NSError *error;
    
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@%@",SERVER_URL,url_STR];//@"309"
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
        
        NSMutableDictionary *jsonReponse = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSDictionary *dict_META = [jsonReponse valueForKey:@"meta"];
        
        [[NSUserDefaults standardUserDefaults] setObject:dict_META forKey:@"META"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"The response Live auctions %@",jsonReponse);
        
    
        @try {
//             initWithArray:[jsonReponse valueForKey:@"auction_items"]];
            
            NSLog(@"the arrayelemts are first:%@",sec_one_ARR);
            if(tag == 0)
            {
            [sec_one_ARR removeAllObjects];
            
            [sec_one_ARR addObjectsFromArray:[jsonReponse valueForKey:@"auction_items"]];
            [_auctiontab reloadData];
            
             NSLog(@"the arrayelemts are last:%@",sec_one_ARR);
            }
            else if(tag == 1)
            {
                // [sec_one_ARR removeAllObjects];
                
                [sec_one_ARR addObjectsFromArray:[jsonReponse valueForKey:@"auction_items"]];
                [_auctiontab reloadData];
                
                NSLog(@"the arrayelemts are last:%@",sec_one_ARR);
            }
           
        } @catch (NSException *exception) {
            _auctiontab.hidden = YES;
            _lbl_NoData.hidden = NO;
        }
        
        
        if ([sec_one_ARR count] == 0) {
            _auctiontab.hidden = YES;
            _lbl_NoData.hidden = NO;
        }
        else{
            _lbl_NoData.hidden = YES;
            _auctiontab.hidden = NO;
            [self.auctiontab reloadData];
        }
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}
#pragma search action
- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    [self performSelector:@selector(searcH_Qurey) withObject:activityIndicatorView afterDelay:0.01];
    
    UITextField *searchBarTextField = [self findTextFieldFromControl:_search_bar];
    [searchBarTextField addTarget:self action:@selector(getSearch_TXT) forControlEvents:UIControlEventEditingChanged];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        NSError *error;
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
        NSDictionary *Dictin_event = [dict valueForKey:@"event"];
        NSString *STR_sent_TXT = [NSString stringWithFormat:@"auction/list/%@",[Dictin_event valueForKey:@"id"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:STR_sent_TXT forKey:@"URL_SENT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(API_liveAuctions) withObject:activityIndicatorView afterDelay:0.01];
    }
}

//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    UITextField *searchBarTextField = [self findTextFieldFromControl:_search_bar];
//    [searchBarTextField addTarget:self action:@selector(getSearch_TXT) forControlEvents:UIControlEventEditingChanged];
//}

-(void) getSearch_TXT
{
    NSString *str = _search_bar.text;
    NSLog(@"Updated Text working %@",str);
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    if([str isEqualToString:@""])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"auction/list/" forKey:@"URL_SENT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(searcH_Qurey) withObject:activityIndicatorView afterDelay:0.01];
//        VW_overlay.hidden = YES;
//        [activityIndicatorView stopAnimating];
    }
    else
    {
        [self performSelector:@selector(searcH_Qurey) withObject:activityIndicatorView afterDelay:0.01];
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

/*#pragma mark - Search API
-(void) searcH_API
{
    @try {
        
        NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
        NSString *search_char = _search_bar.text;
        NSHTTPURLResponse *response = nil;
        NSError *error;
        
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
        NSDictionary *Dictin_event = [dict valueForKey:@"event"];
        
    
        NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/list/%@?query=%@",SERVER_URL,[Dictin_event valueForKey:@"id"],search_char];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
        [request setHTTPShouldHandleCookies:NO];
        
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
   
        
        if (aData)
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
//            [self get_DATA];
            NSLog(@"The response %@",json_DATA);
            
            if(!json_DATA)
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
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
    @catch (NSException *exception) {
        [self sessionOUT];
    }
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}*/

-(void) searcH_Qurey
{
    @try {
        
        NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
        NSString *search_char;
        
        @try {
            search_char = _search_bar.text;
        } @catch (NSException *exception) {
            search_char = @"";
        }
        
        NSHTTPURLResponse *response = nil;
        NSError *error;
        
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
        NSDictionary *Dictin_event = [dict valueForKey:@"event"];
        
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/autocomplete/%@?query=%@",SERVER_URL,[Dictin_event valueForKey:@"id"],search_char];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
        [request setHTTPShouldHandleCookies:NO];
        
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        if (aData)
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            NSMutableDictionary *temp_dictin = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response %@",temp_dictin);
            
            if(!temp_dictin)
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                
            }
            else
            {
                
                
//                NSDictionary *ORiginal_dictin = [temp_dictin valueForKey:@"auction_items"];
                
//                NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithCapacity:[ORiginal_dictin count]];
//                for(id item in [ORiginal_dictin allValues]){
//                    NSArray * keys = [dict allKeysForObject:item];
//                    [newDict setObject:item forKey:[keys objectAtIndex:0]];
//                }
                NSArray *values = [[temp_dictin valueForKey:@"auction_items"] valueForKeyPath: @"@unionOfArrays.@allValues"];
                
                NSCountedSet *namesSet = [[NSCountedSet alloc] initWithArray:values];
                NSMutableArray *namesArray = [[NSMutableArray alloc] initWithCapacity:[values count]];
                
                [namesSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop){
                    if ([namesSet countForObject:obj] == 1) {
                        [namesArray addObject:obj];
                    }
                }];
                
                ARR_search = [namesArray mutableCopy];
            }
            
            if ([ARR_search count] == 0)
            {
                _tbl_search.hidden = YES;
            }
            else
            {
                _tbl_search.hidden = NO;
                [_tbl_search reloadData];
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
    @catch (NSException *exception) {
        [self sessionOUT];
    }
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
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
/*-(void)get_DATA
{
    NSMutableArray *temp_ARR = [json_DATA valueForKey:@"auction_items"];
    [sec_one_ARR removeAllObjects];
    [sec_one_ARR dealloc];
    sec_one_ARR = [[NSMutableArray alloc] init];
    [sec_one_ARR addObjectsFromArray:temp_ARR];
//    NSString *str = _search_bar.text;
//    titleName = [NSString stringWithFormat:@" %lu Results for' %@ '",(unsigned long)[_sec_one_ARR count],str];
    [_auctiontab reloadData];
}*/

#pragma mark - Pagination
#pragma mark - Control datasource
- (void)finishRefresh
{
    [_auctiontab finishRefresh];
}
- (void)finishLoadMore
{
    [_auctiontab finishLoadMore];
}

#pragma mark - Drag delegate methods
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //Pull up go to First Page
    NSDictionary *metadict = [[NSUserDefaults standardUserDefaults] objectForKey:@"META"];
    NSString *prev_PAGE = [NSString stringWithFormat:@"%@",[metadict valueForKey:@"prev_page"]];
    if ([prev_PAGE isEqualToString:@"0"])
    {
        //        [activityIndicatorView stopAnimating];
        //        VW_overlay.hidden = YES;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Already in First Page" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        //        [alert show];
        [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.01];
    }
    else
    {
        
        [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.01];
//        NSError *error;
//        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
//        NSDictionary *Dictin_event = [dict valueForKey:@"event"];
//        NSString *STR_sent_TXT = [NSString stringWithFormat:@"auction/list/%@/?page=%@",[Dictin_event valueForKey:@"id"],[metadict valueForKey:@"prev_page"]];
//        
//        [self performSelector:@selector(API_liveAuctions:) withObject:STR_sent_TXT afterDelay:0.01];
        
       /* NSString *url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"URL_SAVED_tran"],[metadict valueForKey:@"prev_page"]];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:url_STR forKey:@"URL_SAVED_tranprev"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(firstpage_API) withObject:nil afterDelay:0.01];*/
    }
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:0.01];
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
//    NSString *url_STR;
    
    NSDictionary *temp_dictinry = [[NSUserDefaults standardUserDefaults] objectForKey:@"META"];
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
//        url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_tran"],nextPAGE];
//        [[NSUserDefaults standardUserDefaults] setValue:url_STR forKey:@"URL_SAVED_trannext"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self performSelector:@selector(nextpage_API) withObject:nil afterDelay:0.01];
        
        NSError *error;
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
        NSDictionary *Dictin_event = [dict valueForKey:@"event"];
        NSString *STR_sent_TXT = [NSString stringWithFormat:@"auction/list/%@/?page=%@",[Dictin_event valueForKey:@"id"],nextPAGE];
        tag = 1;
        [[NSUserDefaults standardUserDefaults] setValue:STR_sent_TXT forKey:@"URL_SENT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(API_liveAuctions) withObject:activityIndicatorView afterDelay:0.01];
    }
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:0.01];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

/*-(void) nextpage_API
{
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_trannext"]]];
    
    NSLog(@"Url posted transaction History next page %@",urlProducts);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSMutableDictionary *dict;
    if (aData)
    {
        
        NSLog(@"Response Transaction History %@",response);
        
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"From Transaction_History Next Pagination testing :%@",dict);
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
                
                NSArray *ARR_tmp = [dict valueForKey:@"transactions"];
                [transaction_history addObjectsFromArray:ARR_tmp];
                
                [_tbl_contents reloadData];
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
        NSLog(@"From VC_all_events  prev Pagination testing :%@",json_DATA);
        [transaction_history removeAllObjects];
        NSArray *ARR_tmp = [json_DATA valueForKey:@"transactions"];
        [transaction_history addObjectsFromArray:ARR_tmp];
        
        [_tbl_contents reloadData];
        
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
*/
@end
