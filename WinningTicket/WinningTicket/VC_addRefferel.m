//
//  VC_addRefferel.m
//  WinningTicket
//
//  Created by Test User on 21/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_addRefferel.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"

@interface VC_addRefferel ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
}

@end

@implementation VC_addRefferel

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_view layoutIfNeeded];
    _scroll_view.contentSize = CGSizeMake(_scroll_view.frame.size.width, _VW_content.frame.size.height);
    
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
    CGRect new_frame;
    new_frame = _VW_content.frame;
    new_frame.origin.y = 0;
    new_frame.origin.x = 0;
    new_frame.size.width = _scroll_view.frame.size.width;
    _VW_content.frame = new_frame;
    [self.scroll_view addSubview:_VW_content];
    
    [self componentsize];
}
-(void)componentsize
{
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
    
    _TXT_referal_name.layer.cornerRadius=5;
    _TXT_referal_name.layer.borderWidth=1;
    _TXT_referal_email.layer.cornerRadius=5;
    _TXT_referal_email.layer.borderWidth=1;
    _TXT_referal_phone.layer.cornerRadius=5;
    _TXT_referal_phone.layer.borderWidth=1;
    
    _BTN_sponsor.layer.cornerRadius=5;
    _BTN_sponsor.layer.borderWidth=1;
    _BTN_sponsor.backgroundColor = [UIColor clearColor];
    
    _BTN_affiliate.layer.cornerRadius=5;
    _BTN_affiliate.layer.borderWidth=1;
    _BTN_affiliate.backgroundColor = [UIColor clearColor];
    
    _BTN_organizer.layer.cornerRadius=5;
    _BTN_organizer.layer.borderWidth=1;
    _BTN_organizer.backgroundColor = [UIColor clearColor];
    
    _BTN_contributer.layer.cornerRadius=5;
    _BTN_contributer.layer.borderWidth=1;
    _BTN_contributer.backgroundColor = [UIColor clearColor];
    
    [_BTN_sponsor addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_affiliate addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_organizer addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_contributer addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_addRefeerel addTarget:self action:@selector(add_referel_TAP) forControlEvents:UIControlEventTouchUpInside];
}

-(void)changeButtonBackGroundColor:(UIButton *) sender
{
    if(sender.tag == 1)
    {
        [_BTN_sponsor setBackgroundColor:[UIColor lightGrayColor]];
        
        [_BTN_contributer setBackgroundColor:[UIColor clearColor]];
        [_BTN_organizer setBackgroundColor:[UIColor clearColor]];
        [_BTN_affiliate setBackgroundColor:[UIColor clearColor]];
        
    }
    if(sender.tag == 2)
    {
        [_BTN_contributer setBackgroundColor:[UIColor lightGrayColor]];
        
        [_BTN_sponsor setBackgroundColor:[UIColor clearColor]];
        [_BTN_organizer setBackgroundColor:[UIColor clearColor]];
        [_BTN_affiliate setBackgroundColor:[UIColor clearColor]];
        
    }
    if(sender.tag == 3)
    {
        [_BTN_organizer setBackgroundColor:[UIColor lightGrayColor]];
        
        [_BTN_sponsor setBackgroundColor:[UIColor clearColor]];
        [_BTN_contributer setBackgroundColor:[UIColor clearColor]];
        [_BTN_affiliate setBackgroundColor:[UIColor clearColor]];
    }
    if (sender.tag == 4)
    {
        [_BTN_affiliate setBackgroundColor:[UIColor lightGrayColor]];
        
        [_BTN_sponsor setBackgroundColor:[UIColor clearColor]];
        [_BTN_contributer setBackgroundColor:[UIColor clearColor]];
        [_BTN_organizer setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - UItextfield Deligate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _TXT_referal_name)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 30)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    if (textField == _TXT_referal_phone)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 15)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789()+- "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

#pragma mark - IBActions
- (IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void) add_referel_TAP
{
    NSString *text_to_compare = _TXT_referal_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([_TXT_referal_name.text isEqualToString:@""])
    {
        [_TXT_referal_name becomeFirstResponder];
        [_TXT_referal_name showError];
        [_TXT_referal_name showErrorWithText:@" Please enter referral name"];
    }
    else if (_TXT_referal_name.text.length < 2)
    {
        [_TXT_referal_name becomeFirstResponder];
        [_TXT_referal_name showError];
        [_TXT_referal_name showErrorWithText:@" Referral name minimum 2 characters"];
    }
    else if ([emailTest evaluateWithObject:text_to_compare] == NO)
    {
        [_TXT_referal_email becomeFirstResponder]; //Please enter valid email address
        [_TXT_referal_email showError];
        [_TXT_referal_email showErrorWithText:@" Please enter valid email address"];
    }
    else if ([_TXT_referal_phone.text isEqualToString:@""])
    {
        [_TXT_referal_phone becomeFirstResponder];
        [_TXT_referal_phone showError];
        [_TXT_referal_phone showErrorWithText:@" Please enter phone number"];
    }
    else if (_TXT_referal_phone.text.length < 5)
    {
        [_TXT_referal_phone becomeFirstResponder];
        [_TXT_referal_phone showError];
        [_TXT_referal_phone showErrorWithText:@" Phone number minimum 5 numbers"];
    }
    else if (_BTN_sponsor.backgroundColor == [UIColor clearColor] && _BTN_contributer.backgroundColor == [UIColor clearColor] && _BTN_organizer.backgroundColor == [UIColor clearColor] && _BTN_affiliate.backgroundColor == [UIColor clearColor])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select any role" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    else
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(create_AFFILIATE) withObject:activityIndicatorView afterDelay:0.01];
    }
}


#pragma mark - API Calling
-(void) create_AFFILIATE
{
    NSString *referalName = _TXT_referal_name.text;
    NSString *email = _TXT_referal_email.text;
    NSString *phone = _TXT_referal_phone.text;
    NSString *role;
    
    if (_BTN_sponsor.backgroundColor != [UIColor clearColor])
    {
        role = @"sponsor";
    }
    else if (_BTN_contributer.backgroundColor != [UIColor clearColor])
    {
        role = @"contributor";
    }
    else if (_BTN_organizer.backgroundColor != [UIColor clearColor])
    {
        role = @"organizer";
    }
    else if (_BTN_affiliate.backgroundColor != [UIColor clearColor])
    {
        role = @"affiliate";
    }
    
    NSError *error;
    NSError *err;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSHTTPURLResponse *response = nil;
    NSDictionary *parameters = @{ @"referral": @{ @"first_name":referalName, @"email":email, @"phone":phone, @"role":role } };
    
    NSLog(@"Parameters %@",parameters);
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
    NSString *urlGetuser = [NSString stringWithFormat:@"%@referrals/create",SERVER_URL];
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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response add referrel %@",json_DATA);
        if(json_DATA)
        {
            if([[json_DATA valueForKey:@"status"] isEqualToString:@"Failure"])
               {
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                   [alert show];

               }
            else
            {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
                                                                          message:[json_DATA valueForKey:@"message"]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action)
                                        {
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }];
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            }

        }
        if(!json_DATA)
           {
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
               [alert show];
           }
        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}
@end
