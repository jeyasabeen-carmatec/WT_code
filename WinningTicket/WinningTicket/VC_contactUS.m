//
//  VC_contactUS.m
//  WinningTicket
//
//  Created by Test User on 04/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_contactUS.h"
//#import "DGActivityIndicatorView.h"

#import "ViewController.h"


@interface VC_contactUS ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
}

@end

@implementation VC_contactUS

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_VIEW];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _VW_contents.frame.size.height);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIview customisation
-(void) setup_VIEW
{
    CGRect frame_rect = _VW_contents.frame;
    frame_rect.size.width = _scroll_contents.frame.size.width;
    _VW_contents.frame = frame_rect;
    
    [_scroll_contents addSubview:_VW_contents];
    
    _TXT_fname.layer.cornerRadius = 5.0f;
    _TXT_fname.layer.masksToBounds = YES;
    _TXT_fname.layer.borderWidth = 2.0f;
    _TXT_fname.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_fname.backgroundColor = [UIColor whiteColor];
    _TXT_fname.delegate=self;
    _TXT_fname.tag=1;
    
    _TXT_lname.layer.cornerRadius = 5.0f;
    _TXT_lname.layer.masksToBounds = YES;
    _TXT_lname.layer.borderWidth = 2.0f;
    _TXT_lname.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_lname.backgroundColor = [UIColor whiteColor];
    _TXT_lname.delegate=self;
    _TXT_lname.tag=2;
    
    _TXT_email.layer.cornerRadius = 5.0f;
    _TXT_email.layer.masksToBounds = YES;
    _TXT_email.layer.borderWidth = 2.0f;
    _TXT_email.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_email.backgroundColor = [UIColor whiteColor];
    _TXT_email.delegate=self;
    _TXT_email.tag=3;
    
    _TXT_phone.layer.cornerRadius = 5.0f;
    _TXT_phone.layer.masksToBounds = YES;
    _TXT_phone.layer.borderWidth = 2.0f;
    _TXT_phone.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_phone.backgroundColor = [UIColor whiteColor];
    _TXT_phone.delegate=self;
    _TXT_phone.tag=4;
    
    _TXT_subject.layer.cornerRadius = 5.0f;
    _TXT_subject.layer.masksToBounds = YES;
    _TXT_subject.layer.borderWidth = 2.0f;
    _TXT_subject.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_subject.backgroundColor = [UIColor whiteColor];
    _TXT_subject.delegate=self;
    _TXT_subject.tag=5;
    
    _TXT_VW_message.layer.cornerRadius = 5.0f;
    _TXT_VW_message.layer.masksToBounds = YES;
    _TXT_VW_message.layer.borderWidth = 2.0f;
    _TXT_VW_message.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_VW_message.backgroundColor = [UIColor whiteColor];
    _TXT_VW_message.delegate=self;
    [_BTn_send addTarget:self action:@selector(send_Clicked) forControlEvents:UIControlEventTouchUpInside];
    
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
#pragma TextField_delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _TXT_VW_message.text=@"";
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==3)
    {
        NSString *text_to_compare = _TXT_email.text;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:text_to_compare] == NO)
        {
            _TXT_email.text = @"";
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email ID!" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
            
            //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            //{
            //keyboard will hide
            [UIView beginAnimations:nil context:NULL];
            // [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
            // }
            //{
            //    self.submit_action.enabled = NO;
            //}
            
            // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            // {
            //keyboard will hide
            [UIView beginAnimations:nil context:NULL];
            // [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
            
            // }
        }
        else{
            
            
            //            [_TXT_password becomeFirstResponder];
            
            
        }
        
    }
    [UIView beginAnimations:nil context:NULL];
    // [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    // }
    //{
    //    self.submit_action.enabled = NO;
    //}
    
    // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    // {
    //keyboard will hide
    [UIView beginAnimations:nil context:NULL];
    // [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _TXT_fname)
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
        return YES;
    }
    if(textField == _TXT_subject)
       
    {
        NSInteger inte = textField.text.length;
        if(inte >= 255)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        return YES;
    }
    if(textField == _TXT_phone)
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


#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)send_Clicked
{
    NSString *text_to_compare_email = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    NSLog(@"Sighn UP");
   
    if([_TXT_fname.text isEqualToString:@""])
    {
        [_TXT_fname becomeFirstResponder];
        [_TXT_fname showError];
        [_TXT_fname showErrorWithText:@" Plese Enter First name "];
    }
    
    else if(_TXT_fname.text.length < 2)
    {
        [_TXT_fname becomeFirstResponder];
        [_TXT_fname showError];
        [_TXT_fname showErrorWithText:@" First name minimum 2 Character"];
    }
    else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_email becomeFirstResponder];
        [_TXT_email showError];
        [_TXT_email showErrorWithText:@" Please Enter a valid Email address"];
    }

    else if([_TXT_phone.text isEqualToString:@""])
    {
        [_TXT_phone becomeFirstResponder];
        [_TXT_phone showError];
        [_TXT_phone showErrorWithText:@" Please enter phone number"];
    }
    
    else if (_TXT_phone.text.length < 5)
    {
        [_TXT_phone becomeFirstResponder];
        [_TXT_phone showError];
        [_TXT_phone showErrorWithText:@" Phone number minimum 5 Numbers"];
    }
    else if([_TXT_subject.text isEqualToString:@""])
    {
        [_TXT_subject becomeFirstResponder];
        [_TXT_subject showError];
        [_TXT_subject showErrorWithText:@" Please Enter Subject"];

    }
    else if([_TXT_VW_message.text isEqualToString:@""] || [_TXT_VW_message.text isEqualToString:@"Your Message"])
    {
        [_TXT_VW_message becomeFirstResponder];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter any Message" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

    }

    else
    {
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(save_api) withObject:activityIndicatorView afterDelay:0.01];
    }
}

-(void)save_api
{

    NSString *fname = _TXT_fname.text;
//    NSString *lname = _TXT_lname.text;
    //      NSString *email = _TXT_email.text;
    //
    //      NSString *username=_TXT_username.text;
       NSString *phone_num = _TXT_phone.text;
    NSString *email=_TXT_email.text;
    NSString *subject=_TXT_subject.text;
    NSString *mesage=_TXT_VW_message.text;

    
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSDictionary *parameters = @{ @"first_name": fname,
                                  @"email": email,
                                  @"subject": subject,
                                  @"message": mesage,
                                  @"phone": phone_num };
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@home/contact_us",SERVER_URL];
    
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
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",json_DATA);
        
        @try
        {
            NSString *STR_error = [json_DATA valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                NSString *status=[json_DATA valueForKey:@"status"];
                if([status isEqualToString:@"Success"])
                {
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden = YES;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you. We aim to respond to your request within 48 hours." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
                else
                {
                    
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden = YES;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Check the Details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    
    }
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == [alertView firstOtherButtonIndex])
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }
//}

#pragma mark - Session OUT
- (void) sessionOUT
{
    ViewController *tncView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [tncView setModalInPopover:YES];
    [tncView setModalPresentationStyle:UIModalPresentationFormSheet];
    [tncView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:tncView animated:YES completion:NULL];
}


@end
