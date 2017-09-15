//
//  VC_editAccount.m
//  WinningTicket
//
//  Created by Test User on 05/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_editAccount.h"
//#import "DGActivityIndicatorView.h"
#import "ViewController.h"

@interface VC_editAccount ()<UITextFieldDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *states,*countryS;
    NSArray *sorted_STAES,*sorted_Contry;
//    UILabel *loadingLabel;
}
@property (nonatomic, strong) NSArray *countrypicker,*statepicker;
@property(nonatomic,strong)NSMutableDictionary *json_DATA;/*for getting the JSON data  */


@end

@implementation VC_editAccount

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap_DTECt:)];
    [tap setCancelsTouchesInView:NO];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
//    NSError *error;
//    NSMutableDictionary *json_DAT = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"state_response"] options:NSASCIIStringEncoding error:&error];
//    NSLog(@"The response %@",json_DAT);
//    self.ARR_states=[json_DAT allKeys];
    
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
    
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _VW_contents.frame.size.height + 50);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIView Customize
-(void) setup_VIEW
{
   NSError *error;
   
   NSMutableDictionary *temp_dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"User_data"] options:NSASCIIStringEncoding error:&error];
    
    @try
    {
        NSString *STR_error = [temp_dict valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            NSDictionary *user_data=[temp_dict valueForKey:@"user"];
            NSLog(@"the user data is:%@",temp_dict);
            
            CGRect content_frame = _VW_contents.frame;
            content_frame.size.width = _scroll_contents.frame.size.width;
            _VW_contents.frame = content_frame;
            
            [_scroll_contents addSubview:_VW_contents];
            
            _TXT_fname.layer.cornerRadius = 5.0f;
            _TXT_fname.layer.masksToBounds = YES;
            _TXT_fname.layer.borderWidth = 2.0f;
            _TXT_fname.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_fname.text=[user_data valueForKey:@"first_name"];
            _TXT_fname.tag=1;
            _TXT_fname.delegate = self;
            
            _TXT_lname.layer.cornerRadius = 5.0f;
            _TXT_lname.layer.masksToBounds = YES;
            _TXT_lname.layer.borderWidth = 2.0f;
            _TXT_lname.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_lname.text=[user_data valueForKey:@"last_name"];
            _TXT_lname.tag=2;
            _TXT_lname.delegate = self;
            
            _TXT_email.layer.cornerRadius = 5.0f;
            _TXT_email.layer.masksToBounds = YES;
            _TXT_email.layer.borderWidth = 2.0f;
            _TXT_email.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_email.text=[user_data valueForKey:@"email"];
            _TXT_email.delegate = self;
            
            _TXT_username.layer.cornerRadius = 5.0f;
            _TXT_username.layer.masksToBounds = YES;
            _TXT_username.layer.borderWidth = 2.0f;
            _TXT_username.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_username.text=[user_data valueForKey:@"email"];
            _TXT_username.delegate = self;
            _TXT_username.tag = 3;
            _TXT_username.enabled = YES;
            
            
            
            _TXT_addr1.layer.cornerRadius = 5.0f;
            _TXT_addr1.layer.masksToBounds = YES;
            _TXT_addr1.layer.borderWidth = 2.0f;
            _TXT_addr1.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_addr1.text=[user_data valueForKey:@"address1"];
            _TXT_addr1.tag=4;
            _TXT_addr1.delegate = self;
            
            _TXT_addr2.layer.cornerRadius = 5.0f;
            _TXT_addr2.layer.masksToBounds = YES;
            _TXT_addr2.layer.borderWidth = 2.0f;
            _TXT_addr2.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_addr2.text=[user_data valueForKey:@"address2"];
            _TXT_addr2.tag=5;
            _TXT_addr2.delegate = self;
            
            
            _TXT_city.layer.cornerRadius = 5.0f;
            _TXT_city.layer.masksToBounds = YES;
            _TXT_city.layer.borderWidth = 2.0f;
            _TXT_city.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_city.text=[user_data valueForKey:@"city"];
            _TXT_city.tag=6;
            _TXT_city.delegate = self;
            
            _TXT_country.layer.cornerRadius = 5.0f;
            _TXT_country.layer.masksToBounds = YES;
            _TXT_country.layer.borderWidth = 2.0f;
            _TXT_country.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_country.backgroundColor = [UIColor whiteColor];
            _TXT_country.text=[user_data valueForKey:@"country"];
            _TXT_country.delegate = self;
            //    _TXT_country.delegate=self;
            
            _TXT_state.layer.cornerRadius = 5.0f;
            _TXT_state.layer.masksToBounds = YES;
            _TXT_state.layer.borderWidth = 2.0f;
            _TXT_state.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_state.text=[user_data valueForKey:@"state"];
            _TXT_state.delegate = self;
            
            _TXT_zip.layer.cornerRadius = 5.0f;
            _TXT_zip.layer.masksToBounds = YES;
            _TXT_zip.layer.borderWidth = 2.0f;
            _TXT_zip.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_zip.text=[user_data valueForKey:@"zipcode"];
            _TXT_zip.tag=7;
            _TXT_zip.delegate = self;
            
            _TXT_phone.layer.cornerRadius = 5.0f;
            _TXT_phone.layer.masksToBounds = YES;
            _TXT_phone.layer.borderWidth = 2.0f;
            _TXT_phone.layer.borderColor = [UIColor grayColor].CGColor;
            _TXT_phone.text=[user_data valueForKey:@"phone"];
            _TXT_phone.tag = 8;
            _TXT_phone.delegate = self;
            
            _state_pickerView=[[UIPickerView alloc]init];
            _state_pickerView.dataSource=self;
            _state_pickerView.delegate=self;
            
            
            
            _contry_pickerView = [[UIPickerView alloc] init];
            _contry_pickerView.delegate = self;
            _contry_pickerView.dataSource = self;
            UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(tappedToSelectRow:)];
            tapToSelect.delegate = self;
            [_contry_pickerView addGestureRecognizer:tapToSelect];
            _state_pickerView = [[UIPickerView alloc] init];
            _state_pickerView.delegate = self;
            _state_pickerView.dataSource = self;
            UITapGestureRecognizer *satetap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                     action:@selector(tappedToSelectRowstate:)];
            satetap.delegate = self;
            [_state_pickerView addGestureRecognizer:satetap];
            
            
            UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            conutry_close.barStyle = UIBarStyleBlackTranslucent;
            [conutry_close sizeToFit];
            
            UIButton *close=[[UIButton alloc]init];
            close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
            [close setTitle:@"close" forState:UIControlStateNormal];
            [close addTarget:self action:@selector(closebuttonClick) forControlEvents:UIControlEventTouchUpInside];
            //    [numberToolbar setItems:[NSArray arrayWithObjects:close, nil]];
            [conutry_close addSubview:close];
            _TXT_country.inputAccessoryView=conutry_close;
            _TXT_state.inputAccessoryView=conutry_close;
            self.TXT_country.inputView = _contry_pickerView;
            self.TXT_state.inputView=_state_pickerView;
            _TXT_country.tintColor=[UIColor clearColor];
            _TXT_state.tintColor=[UIColor clearColor];
            
            [self Country_api];
            [self State_api];
            [_BTN_save addTarget:self action:@selector(save_clikced) forControlEvents:UIControlEventTouchUpInside];
            
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
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
    
}
-(void)closebuttonClick
{
    [_TXT_state resignFirstResponder];
    [_TXT_country resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==1)
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
    if(textField.tag==2)
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
    if(textField.tag==3)
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
    if(textField.tag==4)
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
    if(textField.tag==5)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 60)
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
    
    if(textField.tag==8)
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
    if(textField.tag==6)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 60)
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
    if(textField.tag==7)
    {
    NSInteger inte = textField.text.length;
    if(inte >= 8)
    {
    if ([string isEqualToString:@""])
    {
    return YES;
    }
    else
    {
    return NO;
    }
    }
    return YES;
    }
    return YES;
    
    
}

-(void)save_clikced
{
    if([_TXT_fname.text isEqualToString:@""])
    {
        [_TXT_fname becomeFirstResponder];
        [_TXT_fname showError];
        [_TXT_fname showErrorWithText:@" Plese enter first name "];
    }
    
    else if(_TXT_fname.text.length < 2)
    {
        [_TXT_fname becomeFirstResponder];
        [_TXT_fname showError];
        [_TXT_fname showErrorWithText:@" First name minimum 2 characters"];
    }
    else if([_TXT_username.text isEqualToString:@""])
    {
        [_TXT_username becomeFirstResponder];
        [_TXT_username showError];
        [_TXT_username showErrorWithText:@" Please enter address line 1"];
    }
    else if (_TXT_username.text.length < 2)
    {
        [_TXT_username becomeFirstResponder];
        [_TXT_username showError];
        [_TXT_username showErrorWithText:@" Address line 1 minimum 2 characters"];
    }

    else if([_TXT_addr1.text isEqualToString:@""])
    {
        [_TXT_addr1 becomeFirstResponder];
        [_TXT_addr1 showError];
        [_TXT_addr1 showErrorWithText:@" Please enter address line 2"];
    }
    else if (_TXT_addr1.text.length < 2)
    {
        [_TXT_addr1 becomeFirstResponder];
        [_TXT_addr1 showError];
        [_TXT_addr1 showErrorWithText:@" Address line 2 minimum 2 characters"];
    }
       else if([_TXT_city.text isEqualToString:@""])
    {
        [_TXT_city becomeFirstResponder];
        [_TXT_city showError];
        [_TXT_city showErrorWithText:@" Please enter city"];
    }
    else if(_TXT_city.text.length < 2)
    {
        [_TXT_city becomeFirstResponder];
        [_TXT_city showError];
        [_TXT_city showErrorWithText:@" City minimum 2 characters"];
    }
      else if([_TXT_zip.text isEqualToString:@""])
    {
        [_TXT_zip becomeFirstResponder];
        [_TXT_zip showError];
        [_TXT_zip showErrorWithText:@" Please enter zipcode"];
    }
    else if(_TXT_zip.text.length < 4)
    {
        [_TXT_zip becomeFirstResponder];
        [_TXT_zip showError];
        [_TXT_zip showErrorWithText:@" Zipcode minimum 3 characters"];
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
        [_TXT_phone showErrorWithText:@" Phone number minimum 5 numbers"];
    }
    else if([_TXT_country.text isEqualToString:@""])
    {
        [_TXT_country becomeFirstResponder];
        [_TXT_country showError];
        [_TXT_country showErrorWithText:@" Please select country"];
    }

    else
    {
        //        [self api_integration];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(save_api) withObject:activityIndicatorView afterDelay:0.01];
    }
   }

#pragma mark - UIPickerViewDataSource

// #3
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _contry_pickerView) {
        return 1;
    }if(pickerView==_state_pickerView)
    {
        return 1;
    }
    
    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _contry_pickerView) {
        return [self.countrypicker count];
    }
    if (pickerView == _state_pickerView) {
        return [self.statepicker count];
    }
    
    
    return 0;
}
#pragma Textfield Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 3 || textField.tag == 8 || textField.tag == 9)
    {
        [textField setTintColor:[UIColor whiteColor]];
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        // {
        //Keyboard becomes visible
        [UIView beginAnimations:nil context:NULL];
        // [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,-150,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        //}
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //        if(textField.tag==9)
    //        {
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    // }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDataSource

-(void)Country_api
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@city_states/countries",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData) {
        
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        countryS = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",countryS);
        sorted_Contry = [[countryS allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.countrypicker = sorted_Contry;
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    

    
    
}
-(void)State_api
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@city_states/states?country=%@",SERVER_URL,[countryS valueForKey:_TXT_country.text]];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData) {
        states = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",states);
        sorted_STAES = [[states allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.statepicker = sorted_STAES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

#pragma mark - UIPickerViewDelegate


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _contry_pickerView) {
        return self.countrypicker[row];
    }
    if (pickerView == _state_pickerView) {
        return self.statepicker[row];
    }
    
    return nil;
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _contry_pickerView) {
        
//        [self handleRowBeingViewed:[pickerView selectedRowInComponent:component]];
        
        self.TXT_country.text = self.countrypicker[row];
        [self State_api];
        self.TXT_state.enabled=YES;
    }
    if (pickerView == _state_pickerView) {
        
        self.TXT_state.text=self.statepicker[row];
        //        self.TXT_email.enabled=YES;
    }
}

//- (void) handleRowBeingViewed:(NSInteger)rowBeingViewed
//{
//    // Printing for debugging.
//    NSLog(@"String Being Viewed: %@", self.countrypicker[rowBeingViewed]);
//    
//    // DO YOUR STUFF HERE
//    // ...
//}




#pragma mark - BTN Actions
-(void)save_api
    {
        NSString *fname = _TXT_fname.text;
        NSString *lname = _TXT_lname.text;
       
        NSString *addressone = _TXT_addr1.text;
        NSString *addresstwo = _TXT_addr2.text;
        NSString *city = _TXT_city.text;
        NSString *country=_TXT_country.text;
        NSString *state = _TXT_state.text;
        
        NSString *phone_num = _TXT_phone.text;
        NSString *Zip_code=_TXT_zip.text;
        
        
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSDictionary *parameters = @{ @"user": @{ @"first_name":fname , @"last_name":lname , @"phone":phone_num, @"address1":addressone , @"address2":addresstwo ,@"country":country ,@"state":state, @"city":city , @"zipcode": Zip_code } };
    

   
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@users/edit_profile",SERVER_URL];
    
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
        self->activityIndicatorView.hidden=YES;
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
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
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Details Successfully Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
                else
                {
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please Check The Details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
            VW_overlay.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please Check your Connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        
          }
                      
}
        
    

    




-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark PickerView DataSource
#pragma mark - Actions

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_contry_pickerView rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_contry_pickerView.bounds, 0.0, (CGRectGetHeight(_contry_pickerView.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_contry_pickerView]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_contry_pickerView selectedRowInComponent:0];
            [self pickerView:_contry_pickerView didSelectRow:selectedRow inComponent:0];
        }
    }
}
- (IBAction)tappedToSelectRowstate:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_state_pickerView rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_state_pickerView.bounds, 0.0, (CGRectGetHeight(_state_pickerView.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_state_pickerView]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_state_pickerView selectedRowInComponent:0];
            [self pickerView:_state_pickerView didSelectRow:selectedRow inComponent:0];
        }
    }
}

-(void) Tap_DTECt :(UITapGestureRecognizer *)sender
{
}
#pragma mark - Tap Gesture
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [_TXT_phone resignFirstResponder];
    
    if ([touch.view isDescendantOfView:_BTN_save]) {
        return NO;
    }
    return YES;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
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
