//
//  VC_transDeatail.m
//  WinningTicket
//
//  Created by Test User on 02/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_transDeatail.h"

@interface VC_transDeatail ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation VC_transDeatail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_VIew];
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
-(void) setup_VIew
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
    
//    VW_overlay.hidden = YES;
    
    _lbl_trans_TKT.clipsToBounds = YES;
    _lbl_trans_TKT.layer.cornerRadius = _lbl_trans_TKT.frame.size.width/2;
//    _lbl_trans_TKT.layer.borderWidth = 8.0f;
//    _lbl_trans_TKT.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _VW_hold_lbl.layer.masksToBounds = YES;
    _VW_hold_lbl.layer.cornerRadius = _VW_hold_lbl.frame.size.width/2;
    
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_transactionDetail) withObject:activityIndicatorView afterDelay:0.01];
}


#pragma mark - IBactions
-(IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) API_transactionDetail
{
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *trans_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"transID"];
    NSString *url_STR = [NSString stringWithFormat:@"%@payments/transaction_details?id=%@",SERVER_URL,trans_id];
    NSURL *urlProducts=[NSURL URLWithString:url_STR];
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
        [self addvalues:json_DATA];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }

}

#pragma mak - Apply values in view
-(void) addvalues :(NSDictionary *)content_dictin
{
    NSLog(@"Vc transaction detail :%@",content_dictin);
    NSDictionary *dictin_transaction = [content_dictin valueForKey:@"transaction"];
    
    UIColor *selected_color;
    UIFont *small_text_font = [UIFont fontWithName:@"GothamBold" size:4.0];
    
    NSDictionary *Dictin_order;
    
    
    NSString *purpose = [dictin_transaction valueForKey:@"transaction_type"];
    if ([purpose isEqualToString:@"add_funds"]) {
        purpose = @"Add Funds";
    }
    
    if ([purpose isEqualToString:@"purchase"]) {
        purpose = @"Ticket Purchase";
    }
    
    if([purpose isEqualToString:@"donation"] || [purpose isEqualToString:@"Ticket Purchase"] || [purpose isEqualToString:@"withdrawal"])
    {
        selected_color = [UIColor colorWithRed:0.98 green:0.00 blue:0.04 alpha:1.0];
    }
    else
    {
        selected_color = [UIColor colorWithRed:0.03 green:0.65 blue:0.32 alpha:1.0];
    }
    
    if ([purpose isEqualToString:@"donation"] || [purpose isEqualToString:@"Ticket Purchase"])
    {
        Dictin_order = [dictin_transaction valueForKey:@"order"];
        [self display_OrderDetail:Dictin_order:purpose];
    }
    else if ([purpose isEqualToString:@"Add Funds"])
    {
        Dictin_order = [dictin_transaction valueForKey:@"order"];
        [self display_addFund:Dictin_order];
    }
    
    _lbl_ticketDetail.numberOfLines = 0;
    [_lbl_ticketDetail sizeToFit];
    
    _lbl_trans_TKT.backgroundColor = selected_color;
    
    NSString *order_id = [NSString stringWithFormat:@"#%@",[dictin_transaction valueForKey:@"id"]];
//    if ([purpose isEqualToString:@"withdrawal"])
//    {
//        order_id = [NSString stringWithFormat:@"#%@",[dictin_transaction valueForKey:@"id"]];
//    }
    
    NSString *empty_txt = @"sampleText";
    NSString *STR_statstr = @"TRANSACTION";
    NSString *text = [NSString stringWithFormat:@"%@\n%@\n%@",STR_statstr,empty_txt,order_id];
    NSRange range_one_empty = [text rangeOfString:empty_txt];
    
    // If attributed text is supported (iOS6+)
    if ([_lbl_trans_TKT respondsToSelector:@selector(setAttributedText:)]) {
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: _lbl_trans_TKT.textColor,
                                  NSFontAttributeName: _lbl_trans_TKT.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
        NSRange cmp = [text rangeOfString:order_id];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:22.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                    range:cmp];
        }
        
        [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: selected_color,NSForegroundColorAttributeName : selected_color} range:range_one_empty];
        
        _lbl_trans_TKT.attributedText = attributedText;
    }
    else
    {
        _lbl_trans_TKT.text = text;
    }
    _lbl_trans_TKT.numberOfLines = 3;
    
    NSString *empty_txt1 = @"sampleText";
    NSString *STR_amount = [NSString stringWithFormat:@"$%.02f",[[dictin_transaction valueForKey:@"amount"] floatValue]];
    NSString *trans_typ = [NSString stringWithFormat:@"%@\n%@\n%@",STR_amount,empty_txt1,[purpose capitalizedString]];
    
    // If attributed text is supported (iOS6+)
    if ([_lbl_transtype respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: _lbl_transtype.textColor,
                                  NSFontAttributeName: _lbl_transtype.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:trans_typ
                                               attributes:attribs];
        
        
        
        NSRange cmp = [trans_typ rangeOfString:STR_amount];
        NSRange range_2_empty = [trans_typ rangeOfString:empty_txt1];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:32.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:30.0]}
                                    range:cmp];
        }
        
        [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_2_empty];
        
        _lbl_transtype.attributedText = attributedText;
    }
    else
    {
        _lbl_transtype.text = trans_typ;
    }
    
    _lbl_transtype.numberOfLines = 3;
    
    _lbl_ticketDetail.numberOfLines = 0;
    [_lbl_ticketDetail sizeToFit];
    
    _lbl_time.text = [self getLocalDateTimeFromUTC:[dictin_transaction valueForKey:@"created_at"]];
    
    CGRect frameVW = _VW_hold_lbl.frame;
    frameVW.origin.x = 0;
    frameVW.origin.y = 0;
    frameVW.size.width = _scroll_contents.frame.size.width;
    frameVW.size.height = _lbl_ticketDetail.frame.origin.y + _lbl_ticketDetail.frame.size.height;
    _VW_contents.frame = frameVW;
    
    [_scroll_contents addSubview:_VW_contents];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _VW_contents.frame.size.height);
}

#pragma mark - UTC date
-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    NSLog(@"CurrentDate:%@", currentDate);
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"MMMM dd, yyyy - h:mma"];
    [newFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    return [NSString stringWithFormat:@"%@ EST",[newFormat stringFromDate:currentDate]];
}

#pragma mark - Display Order detail
-(void) display_OrderDetail :(NSDictionary *)dictin_orderdetail :(NSString *)trans_type
{
    //[purpose isEqualToString:@"donation"] || [purpose isEqualToString:@"Ticket Purchase"]
    UIFont *small_text_font = [UIFont fontWithName:@"GothamBold" size:4.0];
    NSString *braintree_payment_type = [dictin_orderdetail valueForKey:@"braintree_payment_type"];
    NSString *STR_paymentTYPE = @"Payment type";
    NSString *STR_paymntDetail;
    NSString *empty_txt_line = @"sampleText";
    NSString *recipt_name;
    NSString *title_event = @"Event name";
    NSString *empty_txt_line1 = @"sampleText1";
    NSString *empty_txt_line2 = @"sampleText2";
    NSString *event_name = [dictin_orderdetail valueForKey:@"event_name"];
    
    NSString *organisation_name = [dictin_orderdetail valueForKey:@"organization_name"];
    
    if ([trans_type isEqualToString:@"donation"]) {
        recipt_name = @"Donation recipient";
    }
    else
    {
        recipt_name = @"Purchase recipient";
    }
    
    @try {
        if ([braintree_payment_type isEqualToString:@"PayPalAccount"]) {
            STR_paymntDetail = [NSString stringWithFormat:@"PayPal - %@",[dictin_orderdetail valueForKey:@"paypal_email"]];
            NSString *STR_detailLBL = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n%@\n%@\n\n%@\n%@\n%@",STR_paymentTYPE,empty_txt_line,STR_paymntDetail,recipt_name,empty_txt_line1,organisation_name,title_event,empty_txt_line2,event_name];
            NSRange range_empty_line = [STR_detailLBL rangeOfString:empty_txt_line];
            NSRange range_empty_line1 = [STR_detailLBL rangeOfString:empty_txt_line1];
            NSRange range_empty_line2 = [STR_detailLBL rangeOfString:empty_txt_line2];
            
            NSRange event_range = [STR_detailLBL rangeOfString:event_name];
            NSRange org_range = [STR_detailLBL rangeOfString:organisation_name];
            
            if ([_lbl_ticketDetail respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: _lbl_ticketDetail.textColor,
                                          NSFontAttributeName: _lbl_ticketDetail.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:STR_detailLBL
                                                       attributes:attribs];
                
                NSRange cmp = [STR_detailLBL rangeOfString:STR_paymntDetail];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                            range:cmp];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                            range:event_range];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                            range:org_range];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                            range:cmp];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                            range:event_range];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                            range:org_range];
                }
                
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line];
                
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line2];
                
                _lbl_ticketDetail.attributedText = attributedText;
            }
            else
            {
                _lbl_ticketDetail.text = STR_detailLBL;
            }
        }
        else if ([braintree_payment_type isEqualToString:@"CreditCard"])
        {
            STR_paymntDetail = [NSString stringWithFormat:@"CreditCard - %@ **** **** **** **%@",[dictin_orderdetail valueForKey:@"card_type"],[dictin_orderdetail valueForKey:@"card_last_two"]];
            
            NSString *STR_detailLBL = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n%@\n%@\n\n%@\n%@\n%@",STR_paymentTYPE,empty_txt_line,STR_paymntDetail,recipt_name,empty_txt_line1,organisation_name,title_event,empty_txt_line2,event_name];
            NSRange range_empty_line = [STR_detailLBL rangeOfString:empty_txt_line];
            NSRange range_empty_line1 = [STR_detailLBL rangeOfString:empty_txt_line1];
            NSRange range_empty_line2 = [STR_detailLBL rangeOfString:empty_txt_line2];
            
            NSRange event_range = [STR_detailLBL rangeOfString:event_name];
            NSRange org_range = [STR_detailLBL rangeOfString:organisation_name];
            
            if ([_lbl_ticketDetail respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: _lbl_ticketDetail.textColor,
                                          NSFontAttributeName: _lbl_ticketDetail.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:STR_detailLBL
                                                       attributes:attribs];
                
                NSRange cmp = [STR_detailLBL rangeOfString:STR_paymntDetail];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                            range:cmp];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                            range:event_range];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                            range:org_range];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                            range:cmp];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                            range:event_range];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                            range:org_range];
                }
                
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line];
                
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line2];
                
                _lbl_ticketDetail.attributedText = attributedText;
            }
            else
            {
                _lbl_ticketDetail.text = STR_detailLBL;
            }
        }
    } @catch (NSException *exception) {
        STR_paymntDetail = @"Paid through wallet";
        _lbl_ticketDetail.text = STR_paymntDetail;
    }
    
}
-(void) display_addFund :(NSDictionary *)dictin_orderdetail
{
    UIFont *small_text_font = [UIFont fontWithName:@"GothamBold" size:4.0];
    NSString *braintree_payment_type = [dictin_orderdetail valueForKey:@"braintree_payment_type"];
    NSString *STR_paymentTYPE = @"Payment type";
    NSString *STR_paymntDetail;
    NSString *empty_txt_line = @"sampleText";
    
    if ([braintree_payment_type isEqualToString:@"PayPalAccount"]) {
        STR_paymntDetail = [NSString stringWithFormat:@"PayPal - %@",[dictin_orderdetail valueForKey:@"paypal_email"]];
        
        NSString *STR_detailLBL = [NSString stringWithFormat:@"%@\n%@\n%@",STR_paymentTYPE,empty_txt_line,STR_paymntDetail];
        NSRange range_empty_line = [STR_detailLBL rangeOfString:empty_txt_line];
        if ([_lbl_ticketDetail respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: _lbl_ticketDetail.textColor,
                                      NSFontAttributeName: _lbl_ticketDetail.font
                                      };
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:STR_detailLBL
                                                   attributes:attribs];
            
            NSRange cmp = [STR_detailLBL rangeOfString:STR_paymntDetail];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                        range:cmp];
            }
            
            [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line];
            
            _lbl_ticketDetail.attributedText = attributedText;
        }
        else
        {
            _lbl_ticketDetail.text = STR_detailLBL;
        }
    }
    else if ([braintree_payment_type isEqualToString:@"CreditCard"])
    {
        STR_paymntDetail = [NSString stringWithFormat:@"CreditCard - %@ **** **** **** **%@",[dictin_orderdetail valueForKey:@"card_type"],[dictin_orderdetail valueForKey:@"card_last_two"]];
        
        NSString *STR_detailLBL = [NSString stringWithFormat:@"%@\n%@\n%@",STR_paymentTYPE,empty_txt_line,STR_paymntDetail];
        NSRange range_empty_line = [STR_detailLBL rangeOfString:empty_txt_line];
        if ([_lbl_ticketDetail respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: _lbl_ticketDetail.textColor,
                                      NSFontAttributeName: _lbl_ticketDetail.font
                                      };
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:STR_detailLBL
                                                   attributes:attribs];
            
            NSRange cmp = [STR_detailLBL rangeOfString:STR_paymntDetail];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:20.0]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                        range:cmp];
            }
            
            [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_empty_line];
            
            _lbl_ticketDetail.attributedText = attributedText;
        }
        else
        {
            _lbl_ticketDetail.text = STR_detailLBL;
        }
    }
}

@end
