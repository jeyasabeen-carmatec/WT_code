//
//  VC_affiliate_sighnUP.m
//  WinningTicket
//
//  Created by Test User on 17/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_affiliate_sighnUP.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"

@interface VC_affiliate_sighnUP ()<UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableDictionary *states,*countryS;
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
    NSArray *sorted_STAES,*sorted_Contry;
}
@property (nonatomic, strong) NSArray *countrypicker,*statepicker;


@end

@implementation VC_affiliate_sighnUP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setup_VIEW];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:32.0f]
       } forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
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
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton ] animated:NO];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _VW_contents.frame.size.height + 10 + _IMG_logo_WT.frame.origin.y + _IMG_logo_WT.frame.size.height + 20);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Customise View
-(void) setup_VIEW
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
    
    CGRect frame = _VW_contents.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width - 20;
    _VW_contents.frame = frame;
    frame.origin.x = 10.0f;
    frame.origin.y = self.navigationController.navigationBar.frame.size.height;
    CGRect new_frame = [UIScreen mainScreen].bounds;
    frame.size.height = new_frame.origin.y + new_frame.size.height - self.navigationController.navigationBar.frame.size.height;
    _scroll_contents.frame = frame;
    
    new_frame = _IMG_logo_WT.frame;
    new_frame.origin.y = 15;
    new_frame.origin.x = _scroll_contents.frame.size.width/2 - _IMG_logo_WT.frame.size.width/2;
    _IMG_logo_WT.frame = new_frame;
    
    [_scroll_contents addSubview:_IMG_logo_WT];
    
    new_frame = _VW_contents.frame;
    new_frame.origin.y = _IMG_logo_WT.frame.origin.y + _IMG_logo_WT.frame.size.height + 20;
    _VW_contents.frame = new_frame;
    
    [_scroll_contents addSubview:_VW_contents];
    
//    _TXT_phone_num.layer.cornerRadius = 5.0f;
//    _TXT_phone_num.layer.masksToBounds = YES;
//    _TXT_phone_num.layer.borderWidth = 1.0f;
//    _TXT_phone_num.layer.borderColor = [UIColor whiteColor].CGColor;
//
    
    _VW_back.layer.borderWidth = 1.0f;
    _VW_back.layer.cornerRadius = 5;
    _VW_back.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _TXT_golfcoursename.layer.cornerRadius = 5.0f;
    _TXT_golfcoursename.layer.masksToBounds = YES;
    _TXT_golfcoursename.layer.borderWidth = 1.0f;
    _TXT_golfcoursename.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_golfcoursename.tag=1;
    _TXT_golfcoursename.delegate=self;
    
    _TXT_F_name.layer.cornerRadius = 5.0f;
    _TXT_F_name.layer.masksToBounds = YES;
    _TXT_F_name.layer.borderWidth = 1.0f;
    _TXT_F_name.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_F_name.tag=2;
    _TXT_F_name.delegate=self;
//    _TXT_F_name.enabled=NO;


    _TXT_L_name.layer.cornerRadius = 5.0f;
    _TXT_L_name.layer.masksToBounds = YES;
    _TXT_L_name.layer.borderWidth = 1.0f;
    _TXT_L_name.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_L_name.tag=3;
    _TXT_L_name.delegate=self;
//    _TXT_L_name.enabled=NO;


    _TXT_titl.layer.cornerRadius = 5.0f;
    _TXT_titl.layer.masksToBounds = YES;
    _TXT_titl.layer.borderWidth = 1.0f;
    _TXT_titl.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_titl.tag=4;
    _TXT_titl.delegate=self;
//    _TXT_titl.enabled=NO;


    _TXT_addr1.layer.cornerRadius = 5.0f;
    _TXT_addr1.layer.masksToBounds = YES;
    _TXT_addr1.layer.borderWidth = 1.0f;
    _TXT_addr1.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_addr1.tag=5;
    _TXT_addr1.delegate=self;
//    _TXT_addr1.enabled=NO;

    
    _TXT_addr2.layer.cornerRadius = 5.0f;
    _TXT_addr2.layer.masksToBounds = YES;
    _TXT_addr2.layer.borderWidth = 1.0f;
    _TXT_addr2.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_addr2.tag=6;
    _TXT_addr2.delegate=self;
//    _TXT_addr2.enabled=NO;

    
    _TXT_city.layer.cornerRadius = 5.0f;
    _TXT_city.layer.masksToBounds = YES;
    _TXT_city.layer.borderWidth = 1.0f;
    _TXT_city.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_city.tag=7;
    _TXT_city.delegate=self;
//    _TXT_city.enabled=NO;


    
    _TXT_phone_num.layer.cornerRadius = 5.0f;
    _TXT_phone_num.layer.masksToBounds = YES;
    _TXT_phone_num.layer.borderWidth = 1.0f;
    _TXT_phone_num.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_phone_num.tag=8;
    _TXT_phone_num.delegate=self;
//    _TXT_phone_num.enabled=NO;


    _TXT_country.layer.cornerRadius = 5.0f;
    _TXT_country.layer.masksToBounds = YES;
    _TXT_country.layer.borderWidth = 1.0f;
    _TXT_country.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_country.tag=9;
    _TXT_country.delegate=self;
//    _TXT_country.enabled=NO;


    
    _TXT_state.layer.cornerRadius = 5.0f;
    _TXT_state.layer.masksToBounds = YES;
    _TXT_state.layer.borderWidth = 1.0f;
    _TXT_state.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_state.tag=10;
    _TXT_state.delegate=self;
//    _TXT_state.enabled=NO;


    _TXT_zip.layer.cornerRadius = 5.0f;
    _TXT_zip.layer.masksToBounds = YES;
    _TXT_zip.layer.borderWidth = 1.0f;
    _TXT_zip.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_zip.tag=11;
    _TXT_zip.delegate=self;
//    _TXT_zip.enabled=NO;


    _TXT_email.layer.cornerRadius = 5.0f;
    _TXT_email.layer.masksToBounds = YES;
    _TXT_email.layer.borderWidth = 1.0f;
    _TXT_email.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_email.tag=12;
    _TXT_email.delegate=self;
//    _TXT_email.enabled=NO;

    
    [_BTN_sighnUP addTarget:self action:@selector(btn_sign_up) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _contry_pickerView = [[UIPickerView alloc] init];
    _contry_pickerView.delegate = self;
    _contry_pickerView.dataSource = self;
    _state_pickerView = [[UIPickerView alloc] init];
    _state_pickerView.delegate = self;
    _state_pickerView.dataSource = self;
    
    
    
    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_contry_pickerView addGestureRecognizer:tapToSelect];
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
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    //    [numberToolbar setItems:[NSArray arrayWithObjects:close, nil]];
    [conutry_close addSubview:close];
    _TXT_country.inputAccessoryView=conutry_close;
    _TXT_state.inputAccessoryView=conutry_close;

    
    self.TXT_country.inputView = _contry_pickerView;
    self.TXT_state.inputView=_state_pickerView;
   


    _TXT_country.tintColor=[UIColor clearColor];
    _TXT_state.tintColor=[UIColor clearColor];
    
//    self.pickerNames = @[ @"Objective-C", @"Swift", @"Java", @"C", @"C++", @"Other"];
    [self Country_api];
//    [self State_api];
    
}

-(void)countrybuttonClick
{
    [self.TXT_country resignFirstResponder];
    [self.TXT_state resignFirstResponder];
}


#pragma mark-TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [_TXT_addr1 resignFirstResponder];
//    [_TXT_addr2 resignFirstResponder];
//    [_TXT_zip resignFirstResponder];
//    [_TXT_city resignFirstResponder];
//    [_TXT_phone_num resignFirstResponder];
//    [_TXT_country resignFirstResponder];
//    [_TXT_state resignFirstResponder];
//    [_TXT_email resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag==3)
    {
        [textField setTintColor:[UIColor whiteColor]];
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        // {
        //Keyboard becomes visible
        [UIView beginAnimations:nil context:NULL];
        // [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        //}
    }
    if(textField.tag==11)
    {
        [textField setTintColor:[UIColor whiteColor]];
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        // {
        //Keyboard becomes visible
        [UIView beginAnimations:nil context:NULL];
        // [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        //}

        
    }
    if(textField.tag==12)
    {
        [textField setTintColor:[UIColor whiteColor]];
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        // {
        //Keyboard becomes visible
        [UIView beginAnimations:nil context:NULL];
        // [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,-140,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        //}
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==1)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 150)
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
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    if(textField.tag==3)
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
    if(textField.tag==6)
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
    if(textField.tag==7)
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
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
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
//    if(textField.tag==9)
//    {
//        NSInteger inte = textField.text.length;
//        if(inte >= 30)
//        {
//            if ([string isEqualToString:@""]) {
//                return YES;
//            }
//            else
//            {
//                return NO;
//            }
//        }
//        return YES;
//    }
//    if(textField.tag==10)
//    {
//        NSInteger inte = textField.text.length;
//        if(inte >= 30)
//        {
//            if ([string isEqualToString:@""]) {
//                return YES;
//            }
//            else
//            {
//                return NO;
//            }
//        }
//        return YES;
//    }
    if(textField.tag == 11)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 8)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==12)
    {
        NSString *text_to_compare = _TXT_email.text;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:text_to_compare] == NO)
        {
            _TXT_email.text = @"";
            [UIView beginAnimations:nil context:NULL];
            // [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
        }
    }
    [UIView beginAnimations:nil context:NULL];
    // [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark - Button Actions
-(void) btn_sign_up
{
    NSString *text_to_compare_email = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    NSLog(@"Sighn UP");
    
//    NSString *text_to_compare=_TXT_phone_num.text;
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    NSString *L_name_STR = _TXT_L_name.text;
    NSString *addr_line_two = _TXT_addr2.text;
    
    if([_TXT_golfcoursename.text isEqualToString:@""])
    {
        [_TXT_golfcoursename becomeFirstResponder];
        [_TXT_golfcoursename showError];
        [_TXT_golfcoursename showErrorWithText:@" Please enter course name"];
    }
    else if(_TXT_golfcoursename.text.length < 2)
    {
        [_TXT_golfcoursename becomeFirstResponder];
        [_TXT_golfcoursename showError];
        [_TXT_golfcoursename showErrorWithText:@" Course name minimum 2 characters"];
    }
    else if([_TXT_F_name.text isEqualToString:@""])
    {
        [_TXT_F_name becomeFirstResponder];
        [_TXT_F_name showError];
        [_TXT_F_name showErrorWithText:@" Please enter first name"];
    }
    else if(_TXT_F_name.text.length < 2)
    {
        [_TXT_F_name becomeFirstResponder];
        [_TXT_F_name showError];
        [_TXT_F_name showErrorWithText:@" First name minimum 2 characters"];
    }
    else  if(L_name_STR.length != 0 && _TXT_L_name.text.length < 2)
    {
        [_TXT_L_name becomeFirstResponder];
        [_TXT_L_name showError];
        [_TXT_L_name showErrorWithText:@" Last name minimum 2 characters"];
    }
    else if([_TXT_titl.text isEqualToString:@""])
    {
        [_TXT_titl becomeFirstResponder];
        [_TXT_titl showError];
        [_TXT_titl showErrorWithText:@" Please enter contact title"];
    }
    else if(_TXT_titl.text.length < 2)
    {
        [_TXT_titl becomeFirstResponder];
        [_TXT_titl showError];
        [_TXT_titl showErrorWithText:@" Contact title minimum 2 characters"];
    }
    else if([_TXT_addr1.text isEqualToString:@""])
    {
        [_TXT_addr1 becomeFirstResponder];
        [_TXT_addr1 showError];
        [_TXT_addr1 showErrorWithText:@" Please enter address line 1"];
    }
    else  if(_TXT_addr1.text.length < 2)
    {
        [_TXT_addr1 becomeFirstResponder];
        [_TXT_addr1 showError];
        [_TXT_addr1 showErrorWithText:@" Address line 1 minimum 2 characters"];
    }
    else  if(addr_line_two.length != 0 && _TXT_addr2.text.length < 2)
    {
        [_TXT_addr2 becomeFirstResponder];
        [_TXT_addr2 showError];
        [_TXT_addr2 showErrorWithText:@" Address line 2 minimum 2 characters"];
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
    else if([_TXT_phone_num.text isEqualToString:@""])
    {
        [_TXT_phone_num becomeFirstResponder];
        [_TXT_phone_num showError];
        [_TXT_phone_num showErrorWithText:@" Please enter phone number"];
    }
    else if (_TXT_phone_num.text.length < 5)
    {
        [_TXT_phone_num becomeFirstResponder];
        [_TXT_phone_num showError];
        [_TXT_phone_num showErrorWithText:@" Phone number minimum 5 numbers"];
    }
    else if([_TXT_country.text isEqualToString:@""])
    {
        [_TXT_country becomeFirstResponder];
        [_TXT_country showError];
        [_TXT_country showErrorWithText:@" Please select country"];
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
        [_TXT_zip showErrorWithText:@" Zipcode minimum 4 characters"];
    }
    else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_email becomeFirstResponder];
        [_TXT_email showError];
        [_TXT_email showErrorWithText:@" Please enter valid email address"];
    }
    else
    {
        [self.view endEditing:TRUE];
        NSLog(@"Validation are aperfect:");
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(affiliate_SignUP) withObject:activityIndicatorView afterDelay:0.01];
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
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        
        countryS = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",countryS);
        sorted_Contry = [[countryS allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.countrypicker = sorted_Contry;
        if ([[countryS allKeys] count] == 1)
        {
            _TXT_country.text = [[countryS allKeys]objectAtIndex:0];
            VW_overlay.hidden = NO;
            [activityIndicatorView startAnimating];
            [self performSelector:@selector(State_api) withObject:activityIndicatorView afterDelay:0.01];
        }
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
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        states = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",states);
        sorted_STAES = [[states allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.statepicker = sorted_STAES;
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
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
        self.TXT_country.text = self.countrypicker[row];
        [self State_api];
        self.TXT_state.enabled=YES;
        
    }
    if (pickerView == _state_pickerView) {
        
        self.TXT_state.text=self.statepicker[row];
        self.TXT_zip.enabled=YES;
    }
}
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
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}


-(void) affiliate_SignUP
{
    NSString *fname = _TXT_F_name.text;
    NSString *lname = _TXT_L_name.text;
    NSString *addressone = _TXT_addr1.text;
    NSString *addresstwo = _TXT_addr2.text;
    NSString *city = _TXT_city.text;
    NSString *phone_num = _TXT_phone_num.text;
    NSString *state = _TXT_state.text;
    NSString *country = _TXT_country.text;
    NSString *email = _TXT_email.text;
    
    NSString *contry_Code = [countryS valueForKey:country];
    NSString *state_code = [states valueForKey:state];
    if (!state_code) {
        state_code = @"";
    }
    
    NSError *error;
    NSError *err;
    NSHTTPURLResponse *response = nil;
    NSDictionary *parameters = @{ @"user": @{ @"first_name":fname, @"last_name": lname, @"address1": addressone, @"address2": addresstwo, @"city": city, @"phone":phone_num, @"state": state_code, @"country": contry_Code, @"email": email },@"user_type": @"affiliate" };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
    NSLog(@"the posted data is:%@",parameters);
    NSString *urlGetuser =[NSString stringWithFormat:@"%@users",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
       if (aData)
          {
              
              [activityIndicatorView stopAnimating];
              VW_overlay.hidden = YES;

            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response %@",json_DATA);
            NSString *status = [json_DATA valueForKey:@"status"];
            NSString *msg = [json_DATA valueForKey:@"message"];
              if([status isEqualToString:@"Success"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you for your submission. Check your email for login credentials. Please allow 24-48 hours for your account to be verified" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    [self performSegueWithIdentifier:@"affiliatetologin" sender:self];
                }
              else
                {
                    if ([msg isEqualToString:@"User already exists"])
                    {
                        msg = @"Email address already in use, Please try with different email.";
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
          }
       else
       {
           [activityIndicatorView stopAnimating];
           VW_overlay.hidden = YES;
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Check your Connection." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
           [alert show];
       }
}
@end
