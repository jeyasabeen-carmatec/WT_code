//
//  VC_transactionhistory.m
//  WinningTicket
//
//  Created by Test User on 03/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_transactionhistory.h"
#import "CELL_trans_hstry.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"
//#import "WinningTicket_Universal-Swift.h"
#import "UITableView+NewCategory.h"

#import "ViewController.h"

@class FrameObservingViewTransactions;

@protocol FrameObservingViewDelegate1 <NSObject>
- (void)frameObservingViewFrameChanged:(FrameObservingViewTransactions *)view;
@end

@interface FrameObservingViewTransactions : UIView
@property (nonatomic,assign) id<FrameObservingViewDelegate1>delegate;
@end

@implementation FrameObservingViewTransactions
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.delegate frameObservingViewFrameChanged:self];
}
@end

@interface VC_transactionhistory ()<FrameObservingViewDelegate1, UITableViewDragLoadDelegate>

{
    NSMutableArray *transaction_history;
    NSMutableArray *ARR_contents;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
    NSMutableDictionary *temp_dict;
    int k;
}

@end


@implementation VC_transactionhistory

- (void)frameObservingViewFrameChanged:(FrameObservingViewTransactions *)view
{
    _tbl_contents.frame = self.view.bounds;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_VIEW];
    k=0;
    
    
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

#pragma mark - View customisation
-(void) setup_VIEW
{
    NSError *error;
    temp_dict =(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"transaction_data"] options:NSASCIIStringEncoding error:&error];
    NSLog(@"the trasactiontotal data is:%@",temp_dict);
    
    @try
    {
        NSString *STR_error = [temp_dict valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            transaction_history=[temp_dict valueForKey:@"transactions"];
            NSLog(@"the user Transaction data is:%@",transaction_history);
          
            [_tbl_contents setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
            _tbl_contents.showLoadMoreView = YES;
            
            
            [_tbl_contents reloadData];
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
}

#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transaction_history count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    CELL_trans_hstry *cell = (CELL_trans_hstry *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSMutableDictionary *temp_dictin = [transaction_history objectAtIndex:indexPath.row];
    
    
    NSLog(@"the data count is:%lu",(unsigned long)temp_dictin.count);
    
    if (cell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CELL_trans_hstry~iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CELL_trans_hstry" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
//    [NSDictionary dictionaryWithObjectsAndKeys:@"#0003125",@"ticket_number",@"Nov 29, 2016 5:12pm EST",@"date",@"Donation",@"purpose",@"-200.00",@"amount", nil];
    
    
    NSString *ticket_number = [NSString stringWithFormat:@"#%@",[temp_dictin valueForKey:@"id"]];
    NSString *date = [self getLocalDateTimeFromUTC:[temp_dictin valueForKey:@"created_at"]];
    NSString *purpose = [temp_dictin valueForKey:@"transaction_type"];
    
//    if ([purpose isEqualToString:@"donation"]) {
//        purpose = @"Donation";
//    }
    
    if ([purpose isEqualToString:@"add_funds"]) {
        purpose = @"Add Funds";
    }
    
    if ([purpose isEqualToString:@"purchase"]) {
        purpose = @"Ticket Purchase";
    }
    
    NSString *amount = [NSString stringWithFormat:@"%.02f",[[temp_dictin valueForKey:@"amount"] floatValue]];
    if([purpose isEqualToString:@"donation"] || [purpose isEqualToString:@"Ticket Purchase"] || [purpose isEqualToString:@"withdrawal"])
    {
        cell.lbl_amount.textColor = [UIColor colorWithRed:0.98 green:0.00 blue:0.04 alpha:1.0];
        cell.lbl_amount.text = [NSString stringWithFormat:@"$%@",amount];
        
    }
    else
    {
        cell.lbl_amount.textColor = [UIColor colorWithRed:0.03 green:0.65 blue:0.32 alpha:1.0];
        cell.lbl_amount.text = [NSString stringWithFormat:@"$%@",amount];
    }
    
//    if ([purpose isEqualToString:@"withdrawal"])
//    {
//        ticket_number = [NSString stringWithFormat:@"#%@",[temp_dictin valueForKey:@"id"]];
//    }
    
    ticket_number = [ticket_number stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
    date = [date stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
    purpose = [purpose stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
    amount = [amount stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];

    cell.lbl_ticket_ID.text = ticket_number;
    cell.lbl_datetime.text = date;
    cell.lbl_ticketreson.text = [purpose capitalizedString];
//    NSString *credit=[temp_dictin valueForKey:@"credit"];
//    NSString *debit=[temp_dictin valueForKey:@"debit"];
    if(temp_dictin[@"value" ] !=(id)[NSNull null])
    {
        NSLog(@"dict is having null");
    }
    else{
        NSLog(@"Not NUll");
    }
    
//    if([credit isEqualToString:@"<null>"])
//    {
//        credit=@"No amount";
//    }
//    if([debit isEqualToString:@"<null>"])
//    {
//        debit=@"-you are debited";
//    }
    
//    float new_val = [amount floatValue];
//    if (new_val < 0) {
//        cell.lbl_amount.textColor = [UIColor redColor];
//        NSArray *arr = [amount componentsSeparatedByString:@"-"];
//        cell.lbl_amount.text = [arr objectAtIndex:1];
//        cell.lbl_amount.text = [NSString stringWithFormat:@"-%@$%@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
//    }
//    else
//    {
//        cell.lbl_amount.textColor = [UIColor greenColor];
//        cell.lbl_amount.text = [NSString stringWithFormat:@"$%@",amount];
//    }
    
    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return 116;
    }
    else
    {
        return 95;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *temp_dictn = [transaction_history objectAtIndex:indexPath.row];
    NSString *STR_id = [temp_dictn valueForKey:@"id"];
    
    [[NSUserDefaults standardUserDefaults] setObject:STR_id forKey:@"transID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"transactionDeatail" sender:self];
}

-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{
    
    NSLog(@"Date Input tbl %@",strDate);
    //
    //    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    //    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    //
    //    NSLog(@"CurrentDate:%@", currentDate);
    //
    //    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    //    [newFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]]; //MMM dd, yyyy HH:mm a
    //    [newFormat setDateFormat:@"MMM dd, yyyy HH:mm a"];
    //
    //    return [NSString stringWithFormat:@"%@ EST",[newFormat stringFromDate:currentDate]];
    
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
    [_tbl_contents finishRefresh];
}
- (void)finishLoadMore
{
    [_tbl_contents finishLoadMore];
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

    NSString *url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"URL_SAVED_tran"],[metadict valueForKey:@"prev_page"]];
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
        url_STR = [NSString stringWithFormat:@"%@?page=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"URL_SAVED_tran"],nextPAGE];
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
