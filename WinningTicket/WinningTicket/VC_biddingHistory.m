//
//  VC_biddingHistory.m
//  WinningTicket
//
//  Created by Test User on 24/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_biddingHistory.h"
#import "bidding_Cell.h"
#import "ViewController.h"

@interface VC_biddingHistory ()
@property(nonatomic,strong)NSMutableArray *ARR_sec_one;
@end

@implementation VC_biddingHistory
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *jsonReponse;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self add_overlay];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(GETAuction_Item_details) withObject:activityIndicatorView afterDelay:0.01];
    
    
}

-(void) add_overlay
{
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
    
}

    // Do any additional setup after loading the view.



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
-(void) setupVIew
{
  
    
    _ARR_sec_one=[[NSMutableArray alloc]init];
    _ARR_sec_one = [jsonReponse valueForKey:@"biddings"];
    [_tbl_bidding reloadData];
    if(_ARR_sec_one.count == 0)
    {
        _VW_top.hidden = YES;
    }
    _LBL_amount_start.text = [NSString stringWithFormat:@"$%.2f",[[jsonReponse valueForKey:@"starting_bid"] floatValue]];
    
    
    
//    NSDictionary *temp_dictin;
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"B******7",@"key1",dateString,@"key2",@"-$200.00",@"key3", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"B******7",@"key1",dateString,@"key2",@"-$200.00",@"key3", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"B******7 ",@"key1",dateString,@"key2",@"-$200.00",@"key3", nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"B******7",@"key1",dateString,@"key2",@"-$200.00",@"key3", nil];
//    [_ARR_sec_one addObject:temp_dictin];temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"B******7",@"key1",dateString,@"key2",@"-$200.00",@"key3",nil];
//    [_ARR_sec_one addObject:temp_dictin];
//    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"B******7",@"key1",dateString,@"key2",@"-$200.00",@"key3", nil];
//    [_ARR_sec_one addObject:temp_dictin];
   
    
}

#pragma mark - Uitableview Datasource/Deligate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ARR_sec_one.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    bidding_Cell *bidcell=[tableView dequeueReusableCellWithIdentifier:@"bidcell"];
    NSDictionary *bidcit=[_ARR_sec_one objectAtIndex:indexPath.row];
    if (bidcell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Bidding _history~ipad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Bidding _history" owner:self options:nil];
        }
        bidcell = [nib objectAtIndex:0];
    }
    
    @try
    {
        NSString *bidder_name = [bidcit valueForKey:@"bidder_name"];
        bidder_name = [bidder_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
        NSString *date = [bidcit valueForKey:@"created_at"];
        date = [date stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
        NSString *bid_amount = [NSString stringWithFormat:@"%.2f",[[bidcit valueForKey:@"current_bid"] floatValue]];
        bid_amount = [bid_amount stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
        
        NSString *bid = [NSString stringWithFormat:@"%@",[bidcit valueForKey:@"user_id"]];
        NSString *current_user_id = [NSString stringWithFormat:@"%@",[jsonReponse valueForKey:@"current_user_id"]];
        
        char c = '\0';
        NSMutableString *final_bidder_name = [NSMutableString string];
        for (int i = 0 ; i< bidder_name.length; i++)
        {
            if( i == 0)
            {
                c = [bidder_name characterAtIndex:i];
                
            }
            else if( i == bidder_name.length - 1)
            {
                c = [bidder_name characterAtIndex:i];
            }
            else{
                c = '*';
            }
            [final_bidder_name appendFormat:@"%c",c];
            
        }
        
        NSLog(@"the string is%@",final_bidder_name);
        
        
        
        if([bid isEqualToString:current_user_id])
        {
            bidcell.AC_no.text =  @"Your Bid" ;
        }
        else
        {
            
            bidcell.AC_no.text =  final_bidder_name;
            
        }
        
        NSString *status_lbl,*date_lbl;
        bidcell.date.textColor= [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.0];
        bidcell.amount.text=[NSString stringWithFormat:@"$%.2f",[bid_amount floatValue]];
        NSString *date_TXT =[self getLocalDateTimeFromUTC:date];
        
        NSString *status = [jsonReponse valueForKey:@"status"];
        NSString *winner_status = [NSString stringWithFormat:@"%@",[jsonReponse valueForKey:@"winner_status"]];
       
        NSString *winning_bid_amount;
        @try
        {
            
         winning_bid_amount = [NSString stringWithFormat:@"%.2f",[[jsonReponse valueForKey:@"winning_bid_amount"] floatValue]];
        }
       @catch(NSException *exception)
        {
            winning_bid_amount = @"";
        }
        
        if([status isEqualToString:@"Success"] && [winner_status isEqualToString:@"1"] && [bid isEqualToString:current_user_id] && [bid_amount isEqualToString:winning_bid_amount])
        {
            bidcell.amount.textColor = [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0];
            [bidcell.AC_no setFont:[UIFont fontWithName:@"GothamMedium" size:bidcell.AC_no.font.pointSize]];

            status_lbl = @"wininng bid";
            date_lbl = [NSString stringWithFormat:@"%@\n%@",date_TXT,status_lbl];
            
        }
        else
        {
            bidcell.amount.textColor = [UIColor blackColor];
            status_lbl = @"";
            date_lbl = [NSString stringWithFormat:@"%@%@",date_TXT,status_lbl];
        }
        
        
        
        
        // NSString *date_lbl = [NSString stringWithFormat:@"%@\n\n%@",date_TXT,status_lbl];
        // bidcell.date.text= [self getLocalDateTimeFromUTC:date];
        if ([bidcell.date respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: bidcell.date.textColor,
                                      NSFontAttributeName: bidcell.date.font
                                      };
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:date_lbl
                                                   attributes:attribs];
            
            // Red text attributes
            //            UIColor *redColor = [UIColor redColor];
            NSRange cmp = [date_lbl rangeOfString:status_lbl];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:20.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:17.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                        range:cmp];
                
                
            }
            bidcell.date.attributedText = attributedText;
            
            
        }
        else
        {
            bidcell.date.text = date_lbl;
        }
        
        
        
        bidcell.separatorInset = UIEdgeInsetsZero;
        bidcell.layoutMargins = UIEdgeInsetsZero;
        
    }
    @catch (NSException *exception)
    {
//        [self sessionOUT];
        NSLog(@"Exception bidding history %@",exception);
    }
    
    return  bidcell;
}
//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    [_tbl_bidding reloadData];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return 98;
    }
    else
    {
        return 78;
    }

}
- (IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Place bid API
-(void)GETAuction_Item_details
{
    @try
    {
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
  
   NSString *item_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"auction_item_id"];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/bidding_history/%@",SERVER_URL,item_id];
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    
    
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        //        self->activityIndicatorView.hidden=YES;
       jsonReponse = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",jsonReponse);
       
        @try
        {
            NSString *STR_error1 = [jsonReponse valueForKey:@"error"];
            if (STR_error1)
            {
                [self sessionOUT];
            }
            else
            {
                NSString *status=[jsonReponse valueForKey:@"status"];
                NSString *error=[jsonReponse valueForKey:@"errors"];
                NSString *message=[jsonReponse valueForKey:@"message"];
                
                if([status isEqualToString:@"Success"])
                {
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden=YES;
                   [self setupVIew];
                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:status delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                    [alert show];
                    //                    [self GETAuction_Item_details];
                    //                    [self setup_Values];
                    
                    
                    
                    
                }
                else if(error)
                {
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden=YES;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                else
                {
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden=YES;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden=YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
@catch (NSException *exception)
{
    [self sessionOUT];
}



}
#pragma mark time_conversion
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
