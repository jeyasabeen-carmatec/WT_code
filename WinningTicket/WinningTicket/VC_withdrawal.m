//
//  VC_withdrawal.m
//  WinningTicket
//
//  Created by Test User on 03/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_withdrawal.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"
#import "ViewController.h"

@interface VC_withdrawal ()<UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    float scroll_View_HT;
    UIView *VW_overlay,*BTN_bg;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
}

@end

@implementation VC_withdrawal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap_DTECt:)];
    [tap setCancelsTouchesInView:NO];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
  /*  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil]; */

    [self setup_View];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(self.scroll_contents.frame.size.width, scroll_View_HT);
}
-(void)viewWillAppear:(BOOL)animated
{
    NSData *aData=[[NSUserDefaults standardUserDefaults]valueForKey:@"Account_data"] ;
    NSError *error;
    if(aData)
    {
        NSMutableDictionary *account_data=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"Account_data"] options:NSASCIIStringEncoding error:&error];
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
                //        NSDictionary *temp_dict=[account_data valueForKey:@"user"];
                NSString *pricee_STR = [NSString stringWithFormat:@"%.2f",[[account_data valueForKey:@"wallet"] floatValue]];
                NSString *text = [NSString stringWithFormat:@"Available balance: $%@",pricee_STR];
                
                if ([self.lbl_availableBAL respondsToSelector:@selector(setAttributedText:)]) {
                    
                    // Define general attributes for the entire text
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName: self.lbl_availableBAL.textColor,
                                              NSFontAttributeName: self.lbl_availableBAL.font
                                              };
                    NSMutableAttributedString *attributedText =
                    [[NSMutableAttributedString alloc] initWithString:text
                                                           attributes:attribs];
                    
                    // Red text attributes
                    //            UIColor *redColor = [UIColor redColor];
                    NSRange cmp = [text rangeOfString:pricee_STR];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:17.0]}
                                            range:cmp];
                    
                    
                    self.lbl_availableBAL.attributedText = attributedText;
                }
                else
                {
                    self.lbl_availableBAL.text = text;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Customise UIView
-(void) setup_View
{
    _TXT_amtbank.layer.cornerRadius = 5.0f;
    _TXT_amtbank.layer.masksToBounds = YES;
    _TXT_amtbank.layer.borderWidth = 2.0f;
    _TXT_amtbank.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    _TXT_amtbank.delegate = self;

    
    _TXT_amtpaypal.layer.cornerRadius = 5.0f;
    _TXT_amtpaypal.layer.masksToBounds = YES;
    _TXT_amtpaypal.layer.borderWidth = 2.0f;
    _TXT_amtpaypal.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    _TXT_amtpaypal.delegate = self;

    
    _TXT_accholdername.layer.cornerRadius = 5.0f;
    _TXT_accholdername.layer.masksToBounds = YES;
    _TXT_accholdername.layer.borderWidth = 2.0f;
    _TXT_accholdername.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    _TXT_accholdername.delegate = self;
    
    
    _TXT_acconroutingnumber.layer.cornerRadius = 5.0f;
    _TXT_acconroutingnumber.layer.masksToBounds = YES;
    _TXT_acconroutingnumber.layer.borderWidth = 2.0f;
    _TXT_acconroutingnumber.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    _TXT_acconroutingnumber.delegate = self;
    
    
    _TXT_accountnumber.layer.cornerRadius = 5.0f;
    _TXT_accountnumber.layer.masksToBounds = YES;
    _TXT_accountnumber.layer.borderWidth = 2.0f;
    _TXT_accountnumber.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    _TXT_accountnumber.delegate = self;
    
    _TXT_email.layer.cornerRadius = 5.0f;
    _TXT_email.layer.masksToBounds = YES;
    _TXT_email.layer.borderWidth = 2.0f;
    _TXT_email.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    _TXT_email.delegate = self;
    
    
       NSString *cur = @"$";
    NSString *print_TXT = [NSString stringWithFormat:@"Amount  %@",cur];
    
    if ([self.lbl_titleAMT respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: self.lbl_titleAMT.textColor,
                                  NSFontAttributeName: self.lbl_titleAMT.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:print_TXT
                                               attributes:attribs];
        
        // Red text attributes
        //            UIColor *redColor = [UIColor redColor];
        NSRange cmp = [print_TXT rangeOfString:cur];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:21.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0.42 green:0.45 blue:0.49 alpha:1.0]}
                                range:cmp];
        
        
        self.lbl_titleAMT.attributedText = attributedText;
    }
    else
    {
        self.lbl_titleAMT.text = print_TXT;
    }
    
    if ([self.lbl_titleAMT1 respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: self.lbl_titleAMT1.textColor,
                                  NSFontAttributeName: self.lbl_titleAMT1.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:print_TXT
                                               attributes:attribs];
        
        // Red text attributes
        //            UIColor *redColor = [UIColor redColor];
        NSRange cmp = [print_TXT rangeOfString:cur];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:21.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:0.42 green:0.45 blue:0.49 alpha:1.0]}
                                range:cmp];
        
        
        self.lbl_titleAMT1.attributedText = attributedText;
    }
    else
    {
        self.lbl_titleAMT1.text = print_TXT;
    }
    
    [_BTN_banktransfer addTarget:self action:@selector(action_Banktransfer) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_paypal addTarget:self action:@selector(action_Paypal) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frameRECt;
    frameRECt = _VW_banktransfer.frame;
    frameRECt.origin.y = _VW_holdBTN.frame.origin.y + _VW_holdBTN.frame.size.height ;
    _VW_banktransfer.frame = frameRECt;
    
    [_VW_Contents addSubview:_VW_banktransfer];
    _VW_banktransfer.hidden = YES;
    
    frameRECt = _VW_paypal.frame;
    frameRECt.origin.y = _VW_holdBTN.frame.origin.y + _VW_holdBTN.frame.size.height ;
    _VW_paypal.frame = frameRECt;
    
    scroll_View_HT = _VW_holdBTN.frame.origin.y + _VW_holdBTN.frame.size.height +  _VW_banktransfer.frame.size.height;
    
    [_VW_Contents addSubview:_VW_paypal];
    _VW_paypal.hidden = YES;
    
    frameRECt = _VW_Contents.frame;
    frameRECt.size.width = _scroll_contents.frame.size.width;
    frameRECt.size.height = scroll_View_HT;
    _VW_Contents.frame = frameRECt;
    
    [_scroll_contents addSubview:_VW_Contents];
    [_BTN_submit_paypal addTarget:self action:@selector(submitClicked_paypal) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_submit_account addTarget:self action:@selector(submitClicked_account) forControlEvents:UIControlEventTouchUpInside];
    
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
    [_BTN_paypal setBackgroundImage:[UIImage imageNamed:@"hh"] forState:UIControlStateHighlighted];
   
    
}

//-(void)textChanged
//{
//    NSString *str = _TXT_amtpaypal.text;
//    _TXT_amtpaypal.text = [NSString stringWithFormat:@"%.02f",[str floatValue]];
//}
#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark -Textfield delagates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIButton Actions
-(void) action_Banktransfer
{
    //    if (_VW_banktransfer.hidden == YES)
    //    {
    _VW_banktransfer.hidden = NO;
    //    }
    _VW_paypal.hidden = YES;
    
    
    [[_bank_transfer_BG layer] setBorderWidth:2.0f];
    [[_bank_transfer_BG layer] setBorderColor:[UIColor greenColor].CGColor];
    [[_pay_pal_BG layer] setBorderWidth:2.0f];
    [[_pay_pal_BG layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    
    
    
//    CALayer *rightBorder = [CALayer layer];
//    rightBorder.borderColor = [UIColor greenColor].CGColor;
//    rightBorder.borderWidth = 1;
//    rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(_BTN_banktransfer.frame) , CGRectGetHeight(_BTN_banktransfer.frame));

//    [_BTN_banktransfer.layer addSublayer:rightBorder];
    
   //   [[_BTN_paypal layer] setBorderWidth:0.0f];
//    _BTN_paypal.layer.sublayers = nil;
}

-(void) action_Paypal
{
    _VW_banktransfer.hidden = YES;
    //    if (_VW_paypal.hidden == YES)
    //    {
    _VW_paypal.hidden = NO;
    
    //    }
    
    [[_pay_pal_BG layer] setBorderWidth:2.0f];
    [[_pay_pal_BG layer] setBorderColor:[UIColor greenColor].CGColor];
    [[_bank_transfer_BG layer] setBorderWidth:2.0f];
    [[_bank_transfer_BG layer] setBorderColor:[UIColor whiteColor].CGColor];

    
    
//    CALayer *rightBorder = [CALayer layer];
//    rightBorder.borderColor = [UIColor greenColor].CGColor;
//    rightBorder.borderWidth = 1;
//    rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(_BTN_paypal.frame), CGRectGetHeight(_BTN_paypal.frame));
//    
//    [_BTN_paypal.layer addSublayer:rightBorder];
    
//    _BTN_banktransfer.layer.sublayers = nil;
}
-(void)submitClicked_paypal
{
    NSString *text_to_compare = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:text_to_compare] == NO)
    {
        _TXT_email.text = @"";
        [_TXT_email becomeFirstResponder];
        [_TXT_email showError];
        [_TXT_email showErrorWithText:@" Please enter Correct Mail"];
        
    }
else if ([_TXT_amtpaypal.text isEqualToString:@"0.00"] || [_TXT_amtpaypal.text isEqualToString:@" 0.00"]) 
        {
            [_TXT_amtpaypal becomeFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    
    else
        {
            VW_overlay.hidden = NO;
            [activityIndicatorView startAnimating];
            [self performSelector:@selector(api_amount_paypal) withObject:activityIndicatorView afterDelay:0.01];

        }
      
}

-(void)api_amount_paypal
{

    
    NSString *amount_paypal = _TXT_amtpaypal.text;
    amount_paypal = [amount_paypal stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:amount_paypal];
    NSLog(@"the number is:%@",myNumber);
    
    NSString *email = _TXT_email.text;
    
    
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSDictionary *parameters = @{ @"email": email,
                                  @"amount": myNumber};
    //    self->activityIndicatorView.hidden=NO;
    //    [self->activityIndicatorView startAnimating];
    //    [self.view addSubview:activityIndicatorView];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@withdrawal/paypal_funds",SERVER_URL];
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setHTTPBody:postData];
    
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        //        self->activityIndicatorView.hidden=YES;
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",json_DATA);
        
        
        
        @try
        {
            NSString *STR_error1 = [json_DATA valueForKey:@"error"];
            if (STR_error1)
            {
                [self sessionOUT];
            }
            else
            {
                NSString *status=[json_DATA valueForKey:@"status"];
                NSString *error=[json_DATA valueForKey:@"errors"];
                NSString *message=[json_DATA valueForKey:@"message"];
                
                if([status isEqualToString:@"Success"])
                {
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden=YES;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    
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
#pragma Alertview Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        [self myaccount_API_calling];
    }
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
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"Account_data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}
-(void) Tap_DTECt :(UITapGestureRecognizer *)sender
{
}
#pragma mark - Tap Gesture
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [_TXT_amtpaypal resignFirstResponder];
    
    if ([touch.view isDescendantOfView:_BTN_paypal]) {
        return NO;
    }
    else if ([touch.view isDescendantOfView:_BTN_submit_paypal]) {
        return NO;
    }
    
    return YES;
}

-(void)submitClicked_account
{
    NSLog(@"Tappd order detail");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This option will be available in next version" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
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

/*#pragma mark - Keyboard handling
- (void)keyboardDidShow: (NSNotification *) notif{
    //Keyboard becomes visible
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                  self.view.frame.origin.y - 220,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);   //move up
}

- (void)keyboardDidHide: (NSNotification *) notif{
    //keyboard will hide
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                  self.view.frame.origin.y + 220,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);   //move down
}*/

@end
