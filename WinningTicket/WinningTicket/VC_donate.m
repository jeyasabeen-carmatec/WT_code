//
//  VC_donate.m
//  WinningTicket
//
//  Created by Test User on 31/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_donate.h"
#import "BraintreeCore.h"
#import "BraintreeDropIn.h"
//#import "DGActivityIndicatorView.h"
//#import "DejalActivityView.h"

#import "ViewController.h"

@interface VC_donate ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate,BTViewControllerPresentingDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
    NSMutableDictionary *states,*countryS;
    NSArray *sorted_STAES,*sorted_Contry,*sorted_Events;
}
@property (nonatomic, strong) NSArray *countrypicker,*statepicker,*oraganisationpicker,*arr;

@end

@implementation VC_donate
{
    float content_height;
    float original_height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap_DTECt:)];
    [tap setCancelsTouchesInView:NO];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self setup_view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_Contents layoutIfNeeded];
    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
        _scroll_Contents.contentSize = CGSizeMake(_scroll_Contents.frame.size.width, original_height);
//    }
//    else
//    {
//        _scroll_Contents.contentSize = CGSizeMake(_scroll_Contents.frame.size.width, 653);
//    }
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
-(void) setup_view
{
    _LBLwallet_balence.hidden = YES;
    _VW_wallet.hidden = YES;
    
    CGRect final_frame = _TXTVW_organisationname.frame;
    final_frame.size.height = _TXTVW_organisationname.contentSize.height;
    _TXTVW_organisationname.frame = final_frame;
    
    final_frame = _lbl_titledonationAMT.frame;
    final_frame.origin.y = _TXTVW_organisationname.frame.origin.y + _TXTVW_organisationname.frame.size.height + 10;
    _lbl_titledonationAMT.frame = final_frame;
    
    final_frame = _lbl_currencyTYP.frame;
    final_frame.origin.y = _lbl_titledonationAMT.frame.origin.y + _lbl_titledonationAMT.frame.size.height + 10;
    _lbl_currencyTYP.frame = final_frame;
    
    final_frame = _TXT_getamount.frame;
    final_frame.origin.y = _lbl_currencyTYP.frame.origin.y;
    _TXT_getamount.frame = final_frame;
    
    final_frame = _BTN_deduct_wallet.frame;
    final_frame.origin.y = _TXT_getamount.frame.origin.y + _TXT_getamount.frame.size.height + 10;
    _BTN_deduct_wallet.frame = final_frame;
    
    [_BTN_deduct_wallet addTarget:self action:@selector(BTN_walletTAPPED) forControlEvents:UIControlEventTouchUpInside];
    
    final_frame = _LBL_arrow_wallet.frame;
    final_frame.origin.y = _BTN_deduct_wallet.frame.origin.y;
    _LBL_arrow_wallet.frame = final_frame;
    
    CGRect VW_frame = _VW_organisationdetail.frame;
    VW_frame.size.height = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height;
    VW_frame.size.width = _scroll_Contents.frame.size.width;
    _VW_organisationdetail.frame = VW_frame;
    
    [self.scroll_Contents addSubview:_VW_organisationdetail];

    VW_frame = _VW_titladdress.frame;
    VW_frame.origin.y = _VW_organisationdetail.frame.origin.y + _VW_organisationdetail.frame.size.height+10;
    VW_frame.size.width = _scroll_Contents.frame.size.width;
    _VW_titladdress.frame = VW_frame;
    
    [self.scroll_Contents addSubview:_VW_titladdress];
      [_BTN_edit addTarget:self action:@selector(edit_BTN_action:) forControlEvents:UIControlEventTouchUpInside];
    
    _TXTVW_organisationname.layer.cornerRadius=3.0f;
    _TXTVW_organisationname.layer.borderWidth=2.0f;
    _TXTVW_organisationname.layer.borderColor=[UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    
    
    _TXT_getamount.layer.cornerRadius = 5.0f;
    _TXT_getamount.layer.masksToBounds = YES;
    _TXT_getamount.layer.borderWidth = 2.0f;
    _TXT_getamount.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
    
    /*apr code*/
    _organisation_list = [[UIPickerView alloc] init];
    _organisation_list.delegate = self;
    _organisation_list.dataSource = self;
    /*setting the frames for address label and button in old*/
    CGRect frame_old;
    frame_old = _lbl_address.frame;
     frame_old.origin.y= _VW_titladdress.frame.size.height+_VW_titladdress.frame.origin.y+10;
    _lbl_address.frame=frame_old;
    [self get_EVENTS];
    NSData *aData=[[NSUserDefaults standardUserDefaults]valueForKey:@"User_data"] ;
    NSError *error;

    if(aData)
    {
        NSMutableDictionary *user_DICTIN = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        @try
        {
            NSString *STR_error = [user_DICTIN valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                NSDictionary *user_data = [user_DICTIN valueForKey:@"user"];
                NSLog(@"VC donate display Address:%@",user_data);
                
                
                NSString *STR_fname = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"first_name"]];
                STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_fname = [STR_fname capitalizedString];
                NSString *STR_lname = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"last_name"]];
                STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_lname = [STR_lname capitalizedString];
                NSString *STR_addr1 = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"address1"]];
                STR_addr1 = [STR_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_addr1 = [STR_addr1 stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_addr1 = [STR_addr1 capitalizedString];
                NSString *STR_addr2 = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"address2"]];
                STR_addr2 = [STR_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_addr2 = [STR_addr2 stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_addr2 = [STR_addr2 capitalizedString];
                NSString *STR_city = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"city"]];
                STR_city = [STR_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_city = [STR_city stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_city = [STR_city capitalizedString];
                NSString *STR_state = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"state"]];
                STR_state = [STR_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_state = [STR_state stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_state = [STR_state capitalizedString];
                NSString *STR_cntry = [NSString stringWithFormat:@"%@",[user_DICTIN valueForKey:@"country"]];
                STR_cntry = [STR_cntry stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_cntry = [STR_cntry stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_cntry = [STR_cntry capitalizedString];
                NSString *STR_zip = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"zipcode"]];
                STR_zip = [STR_zip stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_zip = [STR_zip stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_zip = [STR_zip capitalizedString];
                NSString *STR_phone = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"phone"]];
                STR_phone = [STR_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                STR_phone = [STR_phone stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                STR_phone = [STR_phone capitalizedString];
                
                NSString *name;
                if (STR_lname.length == 0)
                {
                    name = [NSString stringWithFormat:@"%@,\n",STR_fname];
                }
                else
                {
                    name = [NSString stringWithFormat:@"%@ %@,\n",STR_fname,STR_lname];
                }
                
                NSString *addr;
                if (STR_addr2.length == 0)
                {
                    addr = [NSString stringWithFormat:@"%@,\n",STR_addr1];
                }
                else
                {
                    addr = [NSString stringWithFormat:@"%@, %@,\n",STR_addr1,STR_addr2];
                }
                if ([addr isEqualToString:@",\n"]) {
                    addr = @"";
                }
                
                NSString *city = [NSString stringWithFormat:@"%@",STR_city];
                NSString *state = [NSString stringWithFormat:@"%@",STR_state];
                NSString *zip = [NSString stringWithFormat:@"%@",STR_zip];
                NSString *cntry;
                if (STR_zip.length == 0)
                {
                    cntry = [NSString stringWithFormat:@"%@, %@, \n",city,state];
                }
                else
                {
                    if (STR_state.length == 0)
                    {
                        cntry = [NSString stringWithFormat:@"%@, %@,\n",city,zip];
                    }
                    else
                    {
                        cntry = [NSString stringWithFormat:@"%@, %@, %@,\n",city,state,zip];
                    }
                }
                NSString *country;
                if(STR_cntry.length == 0)
                {
                    country = [NSString stringWithFormat:@"Phone : %@.",STR_phone];
                }
                else
                {
                    country = [NSString stringWithFormat:@"%@ \nPhone : %@.",STR_cntry,STR_phone];
                    
                }
                NSMutableArray *final_ADDR = [[NSMutableArray alloc] init];
                if (name.length != 0) {
                    [final_ADDR addObject:[name capitalizedString]];
                }
                
                if (addr.length != 0) {
                    [final_ADDR addObject:addr];
                }
                
                if (city.length != 0 && state.length != 0 && zip.length != 0) {
                    [final_ADDR addObject:cntry];
                }
                
                if (country.length != 0){
                    [final_ADDR addObject:country];
                }
                
                //    NSString *address_str=[NSString stringWithFormat:@"%@ %@\n%@,%@\n%@,%@\n%@,%@.\nPhone : %@",,,,,,,,,];
                
                NSMutableString *str_TST = [[NSMutableString alloc]init];
                for (int i = 0; i<[final_ADDR count]; i++) {
                    [str_TST appendString:[final_ADDR objectAtIndex:i]];
                }
                
                NSLog(@"Testing Addr = %@",str_TST);
                
                _TXT_firstname.text = STR_fname;// [user_data valueForKey:@"first_name"];
                _TXT_lastname.text = STR_lname;//[user_data valueForKey:@"last_name"];
                _TXT_address1.text = STR_addr1;//[user_data valueForKey:@"address1"];
                _TXT_address2.text = STR_addr2;//[user_data valueForKey:@"address2"];
                _TXT_city.text = STR_city;//[user_data valueForKey:@"city"];
                _TXT_country.text = STR_cntry;//[user valueForKey:@"country"];
                _TXT_zip.text = STR_zip;//[user_data valueForKey:@"zipcode"];
                _TXT_state.text = STR_state;//[user valueForKey:@"state"];
                _TXT_phonenumber.text = STR_phone;//[user_data valueForKey:@"phone"];
                
                _lbl_address.text = str_TST;
                [_lbl_address sizeToFit];
                
                _TXT_firstname.text = [user_data valueForKey:@"first_name"];
                _TXT_lastname.text = [user_data valueForKey:@"last_name"];
                _TXT_address1.text = [user_data valueForKey:@"address1"];
                _TXT_address2.text = [user_data valueForKey:@"address2"];
                _TXT_city.text = [user_data valueForKey:@"city"];
                _TXT_country.text = [user_DICTIN valueForKey:@"country"];
                _TXT_zip.text = [user_data valueForKey:@"zipcode"];
                _TXT_state.text = [user_DICTIN valueForKey:@"state"];
                _TXT_phonenumber.text = [user_data valueForKey:@"phone"];
                
                [_SWITCH_wallet setOn:NO animated:YES];
                NSString *chk_btn = [NSString stringWithFormat:@"%@",[user_DICTIN valueForKey:@"wallet"]];
                if ([chk_btn isEqualToString:@"0"]) {
//                    [_SWITCH_wallet setOn:NO animated:YES];
                    _SWITCH_wallet.enabled = NO;
                }
                
                NSString *STR_curBalance = [NSString stringWithFormat:@"$%.2f",[[user_DICTIN valueForKey:@"wallet"] floatValue]];
                NSString *STR_to_display = [NSString stringWithFormat:@"Current Balance: %@",STR_curBalance];
                
                if ([_LBLwallet_balence respondsToSelector:@selector(setAttributedText:)]) {
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName: _LBLwallet_balence.textColor,
                                              NSFontAttributeName: _LBLwallet_balence.font
                                              };
                    NSMutableAttributedString *attributedText =
                    [[NSMutableAttributedString alloc] initWithString:STR_to_display
                                                           attributes:attribs];
                    
                    NSRange cmp = [STR_to_display rangeOfString:STR_curBalance];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:18.0]}
                                            range:cmp];
                    
                    _LBLwallet_balence.attributedText = attributedText;
                }
                else
                {
                    _LBLwallet_balence.text = STR_to_display;
                }
            }
        }
        @catch (NSException *exception)
        {
//            [self sessionOUT];
            NSLog(@"Exception VC donate %@",exception);
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    
    frame_old = _BTN_deposit.frame;
    frame_old.origin.y =  _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
    _BTN_deposit.frame=frame_old;
    /*setting the frames for address label and button in old*/
    
    UITapGestureRecognizer *tapToorganisation = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                       action:@selector(tappedToSelectOrganisation:)];
    tapToorganisation.delegate = self;
    [_organisation_list addGestureRecognizer:tapToorganisation];
    
    
    
        _VW_address.frame=CGRectMake(0, self.self.VW_titladdress.frame.origin.y+self.VW_titladdress.frame.size.height+10, self.scroll_Contents.frame.size.width, self.VW_address.frame.size.height);
        [self.scroll_Contents addSubview:_VW_address];
    _VW_address.hidden=YES;
    
    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [close setTitle:@"close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closebuttonClick) forControlEvents:UIControlEventTouchUpInside];
    //    [numberToolbar setItems:[NSArray arrayWithObjects:close, nil]];
    [conutry_close addSubview:close];
    _TXTVW_organisationname.inputAccessoryView=conutry_close;
    self.TXTVW_organisationname.inputView=_organisation_list;
    
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
    
    
    _TXT_country.inputAccessoryView=conutry_close;
    _TXT_state.inputAccessoryView=conutry_close;
    self.TXT_country.inputView = _contry_pickerView;
    self.TXT_state.inputView=_state_pickerView;
    _TXT_country.tintColor=[UIColor clearColor];
    _TXT_state.tintColor=[UIColor clearColor];
    [self Country_api];
    [self State_api];
    
    _TXT_firstname.layer.cornerRadius = 5.0f;
    _TXT_firstname.layer.masksToBounds = YES;
    _TXT_firstname.layer.borderWidth = 2.0f;
    _TXT_firstname.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_firstname.backgroundColor = [UIColor whiteColor];
    _TXT_firstname.tag=1;
    _TXT_firstname.delegate=self;
    
    
    _TXT_lastname.layer.cornerRadius = 5.0f;
    _TXT_lastname.layer.masksToBounds = YES;
    _TXT_lastname.layer.borderWidth = 2.0f;
    _TXT_lastname.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_lastname.backgroundColor = [UIColor whiteColor];
    _TXT_lastname.tag=2;
    _TXT_lastname.delegate=self;
    
    _TXT_address1.layer.cornerRadius = 5.0f;
    _TXT_address1.layer.masksToBounds = YES;
    _TXT_address1.layer.borderWidth = 2.0f;
    _TXT_address1.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_address1.backgroundColor = [UIColor whiteColor];
    _TXT_address1.tag=3;
    _TXT_address1.delegate=self;
    
    _TXT_address2.layer.cornerRadius = 5.0f;
    _TXT_address2.layer.masksToBounds = YES;
    _TXT_address2.layer.borderWidth = 2.0f;
    _TXT_address2.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_address2.backgroundColor = [UIColor whiteColor];
    _TXT_address2.tag=4;
    _TXT_address2.delegate=self;
    
    _TXT_city.layer.cornerRadius = 5.0f;
    _TXT_city.layer.masksToBounds = YES;
    _TXT_city.layer.borderWidth = 2.0f;
    _TXT_city.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_city.backgroundColor = [UIColor whiteColor];
    _TXT_city.tag=5;
    _TXT_city.delegate=self;
    
    _TXT_country.layer.cornerRadius = 5.0f;
    _TXT_country.layer.masksToBounds = YES;
    _TXT_country.layer.borderWidth = 2.0f;
    _TXT_country.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_country.backgroundColor = [UIColor whiteColor];
    _TXT_country.tag=6;
    _TXT_country.delegate=self;
    
    
    _TXT_state.layer.cornerRadius = 5.0f;
    _TXT_state.layer.masksToBounds = YES;
    _TXT_state.layer.borderWidth = 2.0f;
    _TXT_state.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_state.backgroundColor = [UIColor whiteColor];
    _TXT_state.tag=7;
    _TXT_state.delegate=self;
    
    _TXT_zip.layer.cornerRadius = 5.0f;
    _TXT_zip.layer.masksToBounds = YES;
    _TXT_zip.layer.borderWidth = 2.0f;
    _TXT_zip.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_zip.backgroundColor = [UIColor whiteColor];
    _TXT_zip.tag=8;
    _TXT_zip.delegate=self;
    
    _TXT_phonenumber.layer.cornerRadius = 5.0f;
    _TXT_phonenumber.layer.masksToBounds = YES;
    _TXT_phonenumber.layer.borderWidth = 2.0f;
    _TXT_phonenumber.layer.borderColor = [UIColor grayColor].CGColor;
    _TXT_phonenumber.backgroundColor = [UIColor whiteColor];
    _TXT_phonenumber.tag=9;
    _TXT_phonenumber.delegate=self;

    [_BTN_deposit addTarget:self action:@selector(Deposit_Pressed) forControlEvents:UIControlEventTouchUpInside];
    [_SWITCH_wallet addTarget:self action:@selector(Switch_ACtion:) forControlEvents:UIControlEventValueChanged];
    
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
-(void)closebuttonClick
{
    [_TXT_state resignFirstResponder];
    [_TXT_country resignFirstResponder];
    [_TXTVW_organisationname resignFirstResponder];
}
-(void)amount_Changed
{
    NSString *str = _TXT_getamount.text;
    _TXT_getamount.text = [NSString stringWithFormat:@"%.02f",[str floatValue]];
    
//       NSString *str = _TXT_getamount.text;
//       str =[NSString stringWithFormat:@"%0.02f",[str floatValue]];
//
//     NSArray *arr = [str componentsSeparatedByString:@"."];
//    _TXT_getamount.text = [NSString stringWithFormat:@"%@.00",[arr objectAtIndex:0]];
//    NSString *str1 = [arr objectAtIndex:0];
//    _TXT_getamount.selectedTextRange = str1.length;

    
}
#pragma mark - Edit button Clicked 

-(void) edit_BTN_action : (id) sender
{
    [self VIEWaddress];

}
-(void)VIEWaddress
{
    if(_VW_address.hidden==YES)
    {
        original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
        
        
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.5];
        _VW_address.frame=CGRectMake(_VW_titladdress.frame.origin.x,_VW_titladdress.frame.origin.y+40,self.scroll_Contents.frame.size.width,_VW_address.frame.size.height);
        [self.scroll_Contents addSubview:_VW_address];
        _VW_address.hidden=NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
        [UIView commitAnimations];
        [UIView animateWithDuration:0.5 animations:^{
            
            /*Frame Change*/
            _lbl_address.hidden=YES;
            
            //            _proceed_TOPAY.frame=CGRectMake(_proceed_TOPAY.frame.origin.x
            //                                            ,  _VW_address.frame.origin.y+_VW_address.frame.size.height+10, _proceed_TOPAY.frame.size.width, _proceed_TOPAY.frame.size.height);
            
            _BTN_deposit.frame = CGRectMake(_BTN_deposit.frame.origin.x, _VW_address.frame.origin.y + _VW_address.frame.size.height + 15, _BTN_deposit.frame.size.width, _BTN_deposit.frame.size.height);
            
        }];
        [UIView commitAnimations];
        
        _BTN_edit.enabled=NO;
        
        original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
        [self viewDidLayoutSubviews];
    }
    

}


#pragma mark - Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

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
        self.view.frame = CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        //}
    }
    
    if (textField == _TXT_getamount) {
        NSString *new_STR= _TXT_getamount.text;
        NSArray *ARR_str = [new_STR componentsSeparatedByString:@"."];
        if (ARR_str.count == 1)
        {
            //        self.lbl.text = [NSString stringWithFormat:@"%@.00",new_STR];
            //        _txtfld.text = self.lbl.text;
            _TXT_getamount.text = [NSString stringWithFormat:@"%@.00",new_STR];
        }
        else
        {
            NSString *temp_STR = [ARR_str objectAtIndex:1];
            if (temp_STR.length == 1) {
                //            self.lbl.text = [NSString stringWithFormat:@"%@0",new_STR];
                //            _txtfld.text = self.lbl.text;
                _TXT_getamount.text = [NSString stringWithFormat:@"%@0",new_STR];
            }
            else
            {
                //            self.lbl.text = new_STR;
                //            _txtfld.text = self.lbl.text;
                _TXT_getamount.text = new_STR;
            }
        }
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _TXT_phonenumber) {
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
    if (textField == _TXT_firstname)
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
    if (textField == _TXT_lastname)
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
    if (textField == _TXT_address1) {
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
    if (textField == _TXT_address2) {
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
    if (textField ==_TXT_city)
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
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    if (textField == _TXT_zip)
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
//- (void)textViewDidChange:(UITextView *)textView
//{
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    textView.frame = newFrame;
//}

#pragma mark - UIPickerViewDataSource

// #3
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _contry_pickerView) {
        return 1;
    }if(pickerView==_state_pickerView)
    {
        return 1;
    }
    if(pickerView==_organisation_list)
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
    if (pickerView == _organisation_list) {
        return [self.oraganisationpicker count];
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
    if (aData) {
        countryS = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response %@",countryS);
        sorted_Contry = [[countryS allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.countrypicker = sorted_Contry;
    }
    else
    {
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
    if (pickerView == _organisation_list) {
        _arr=[_oraganisationpicker objectAtIndex:row];
        
        return [_arr objectAtIndex:1];
//        NSLog(@"the temp arr:%@",arr);
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
        //        self.TXT_email.enabled=YES;
    }
    if (pickerView == _organisation_list) {
        if(_VW_address.hidden == NO)
        {
            CGRect final_frame = _TXTVW_organisationname.frame;
            final_frame.size.height = _TXTVW_organisationname.contentSize.height;
            _TXTVW_organisationname.frame = final_frame;
            
            final_frame = _lbl_titledonationAMT.frame;
            final_frame.origin.y = _TXTVW_organisationname.frame.origin.y + _TXTVW_organisationname.frame.size.height + 10;
            _lbl_titledonationAMT.frame = final_frame;
            
            final_frame = _lbl_currencyTYP.frame;
            final_frame.origin.y = _lbl_titledonationAMT.frame.origin.y + _lbl_titledonationAMT.frame.size.height + 10;
            _lbl_currencyTYP.frame = final_frame;
            
            final_frame = _TXT_getamount.frame;
            final_frame.origin.y = _lbl_currencyTYP.frame.origin.y;
            _TXT_getamount.frame = final_frame;
            
            final_frame = _BTN_deduct_wallet.frame;
            final_frame.origin.y = _TXT_getamount.frame.origin.y + _TXT_getamount.frame.size.height + 10;
            _BTN_deduct_wallet.frame = final_frame;
            
            final_frame = _LBL_arrow_wallet.frame;
            final_frame.origin.y = _BTN_deduct_wallet.frame.origin.y;
            _LBL_arrow_wallet.frame = final_frame;
            
            CGRect VW_frame = _VW_organisationdetail.frame;
            if (_VW_wallet.hidden == YES) {
                VW_frame.size.height = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height;
            }
            else
            {
                CGRect frame_lbl = _LBLwallet_balence.frame;
                frame_lbl.origin.y = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height + 10;
                _LBLwallet_balence.frame = frame_lbl;
                
                frame_lbl = _VW_wallet.frame;
                frame_lbl.origin.y = _LBLwallet_balence.frame.origin.y + _LBLwallet_balence.frame.size.height + 10;
                _VW_wallet.frame = frame_lbl;
                
                VW_frame.size.height = _VW_wallet.frame.origin.y + _VW_wallet.frame.size.height;
            }
            VW_frame.size.width = _scroll_Contents.frame.size.width;
            _VW_organisationdetail.frame = VW_frame;
            
            CGRect frame_old;
            frame_old = _lbl_address.frame;
            frame_old.origin.y= _VW_titladdress.frame.size.height+_VW_titladdress.frame.origin.y+10;
            _lbl_address.frame=frame_old;
            
            frame_old = _BTN_deposit.frame;
            frame_old.origin.y =  _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
            _BTN_deposit.frame=frame_old;
            
            original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
            
            //        [UIView beginAnimations:@"LeftFlip" context:nil];
            [UIView setAnimationDuration:0.5];
            _VW_address.frame=CGRectMake(_VW_titladdress.frame.origin.x,_VW_titladdress.frame.origin.y+40,self.scroll_Contents.frame.size.width,_VW_address.frame.size.height);
            [self.scroll_Contents addSubview:_VW_address];
            _VW_address.hidden=NO;
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
            [UIView commitAnimations];
            [UIView animateWithDuration:0.5 animations:^{
                
                /*Frame Change*/
                _lbl_address.hidden=YES;
                
                //            _proceed_TOPAY.frame=CGRectMake(_proceed_TOPAY.frame.origin.x
                //                                            ,  _VW_address.frame.origin.y+_VW_address.frame.size.height+10, _proceed_TOPAY.frame.size.width, _proceed_TOPAY.frame.size.height);
                
                _BTN_deposit.frame = CGRectMake(_BTN_deposit.frame.origin.x, _VW_address.frame.origin.y + _VW_address.frame.size.height + 15, _BTN_deposit.frame.size.width, _BTN_deposit.frame.size.height);
                
            }];
            [UIView commitAnimations];
            
            _BTN_edit.enabled=NO;
            
            original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
            [self viewDidLayoutSubviews];
        }
        else
        {
            CGRect final_frame = _TXTVW_organisationname.frame;
            final_frame.size.height = _TXTVW_organisationname.contentSize.height;
            _TXTVW_organisationname.frame = final_frame;
            
            final_frame = _lbl_titledonationAMT.frame;
            final_frame.origin.y = _TXTVW_organisationname.frame.origin.y + _TXTVW_organisationname.frame.size.height + 10;
            _lbl_titledonationAMT.frame = final_frame;
            
            final_frame = _lbl_currencyTYP.frame;
            final_frame.origin.y = _lbl_titledonationAMT.frame.origin.y + _lbl_titledonationAMT.frame.size.height + 10;
            _lbl_currencyTYP.frame = final_frame;
            
            final_frame = _TXT_getamount.frame;
            final_frame.origin.y = _lbl_currencyTYP.frame.origin.y;
            _TXT_getamount.frame = final_frame;
            
            final_frame = _BTN_deduct_wallet.frame;
            final_frame.origin.y = _TXT_getamount.frame.origin.y + _TXT_getamount.frame.size.height + 10;
            _BTN_deduct_wallet.frame = final_frame;
            
            final_frame = _LBL_arrow_wallet.frame;
            final_frame.origin.y = _BTN_deduct_wallet.frame.origin.y;
            _LBL_arrow_wallet.frame = final_frame;
            
            CGRect VW_frame = _VW_organisationdetail.frame;
            if (_VW_wallet.hidden == YES) {
                VW_frame.size.height = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height;
            }
            else
            {
                CGRect frame_lbl = _LBLwallet_balence.frame;
                frame_lbl.origin.y = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height + 10;
                _LBLwallet_balence.frame = frame_lbl;
                
                frame_lbl = _VW_wallet.frame;
                frame_lbl.origin.y = _LBLwallet_balence.frame.origin.y + _LBLwallet_balence.frame.size.height + 10;
                _VW_wallet.frame = frame_lbl;
                
                VW_frame.size.height = _VW_wallet.frame.origin.y + _VW_wallet.frame.size.height;
            }
            VW_frame.size.width = _scroll_Contents.frame.size.width;
            _VW_organisationdetail.frame = VW_frame;
            
            VW_frame = _VW_titladdress.frame;
            VW_frame.origin.y = _VW_organisationdetail.frame.origin.y + _VW_organisationdetail.frame.size.height + 10;
            VW_frame.size.width = _scroll_Contents.frame.size.width;
            _VW_titladdress.frame = VW_frame;
            
            CGRect frame_old;
            frame_old = _lbl_address.frame;
            frame_old.origin.y= _VW_titladdress.frame.size.height+_VW_titladdress.frame.origin.y+10;
            _lbl_address.frame=frame_old;
            
            frame_old = _BTN_deposit.frame;
            frame_old.origin.y =  _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
            _BTN_deposit.frame=frame_old;
            
            _VW_address.frame=CGRectMake(0, self.self.VW_titladdress.frame.origin.y+self.VW_titladdress.frame.size.height+10, self.scroll_Contents.frame.size.width, self.VW_address.frame.size.height);
            _VW_address.hidden=YES;
        }
        [[NSUserDefaults standardUserDefaults] setValue:[self.arr objectAtIndex:0] forKey:@"event_id_donate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.TXTVW_organisationname.text=[self.arr objectAtIndex:1];
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
- (IBAction)tappedToSelectOrganisation:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_organisation_list rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_organisation_list.bounds, 0.0, (CGRectGetHeight(_organisation_list.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_organisation_list]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_organisation_list selectedRowInComponent:0];
            [self pickerView:_organisation_list didSelectRow:selectedRow inComponent:0];
        }
    }
    if(_VW_address.hidden == NO)
    {
        
        CGRect final_frame = _TXTVW_organisationname.frame;
        final_frame.size.height = _TXTVW_organisationname.contentSize.height;
        _TXTVW_organisationname.frame = final_frame;
        
        final_frame = _lbl_titledonationAMT.frame;
        final_frame.origin.y = _TXTVW_organisationname.frame.origin.y + _TXTVW_organisationname.frame.size.height + 10;
        _lbl_titledonationAMT.frame = final_frame;
        
        final_frame = _lbl_currencyTYP.frame;
        final_frame.origin.y = _lbl_titledonationAMT.frame.origin.y + _lbl_titledonationAMT.frame.size.height + 10;
        _lbl_currencyTYP.frame = final_frame;
        
        final_frame = _TXT_getamount.frame;
        final_frame.origin.y = _lbl_currencyTYP.frame.origin.y;
        _TXT_getamount.frame = final_frame;
        
        final_frame = _BTN_deduct_wallet.frame;
        final_frame.origin.y = _TXT_getamount.frame.origin.y + _TXT_getamount.frame.size.height + 10;
        _BTN_deduct_wallet.frame = final_frame;
        
        final_frame = _LBL_arrow_wallet.frame;
        final_frame.origin.y = _BTN_deduct_wallet.frame.origin.y;
        _LBL_arrow_wallet.frame = final_frame;
        
        CGRect VW_frame = _VW_organisationdetail.frame;
        if (_VW_wallet.hidden == YES) {
            VW_frame.size.height = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height;
        }
        else
        {
            CGRect frame_lbl = _LBLwallet_balence.frame;
            frame_lbl.origin.y = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height + 10;
            _LBLwallet_balence.frame = frame_lbl;
            
            frame_lbl = _VW_wallet.frame;
            frame_lbl.origin.y = _LBLwallet_balence.frame.origin.y + _LBLwallet_balence.frame.size.height + 10;
            _VW_wallet.frame = frame_lbl;
            
            VW_frame.size.height = _VW_wallet.frame.origin.y + _VW_wallet.frame.size.height;
        }
        VW_frame.size.width = _scroll_Contents.frame.size.width;
        _VW_organisationdetail.frame = VW_frame;
        
        CGRect frame_old;
        frame_old = _lbl_address.frame;
        frame_old.origin.y= _VW_titladdress.frame.size.height+_VW_titladdress.frame.origin.y+10;
        _lbl_address.frame=frame_old;
        
        frame_old = _BTN_deposit.frame;
        frame_old.origin.y =  _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
        _BTN_deposit.frame=frame_old;
        
        original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
        
        
        
//        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.5];
        _VW_address.frame=CGRectMake(_VW_titladdress.frame.origin.x,_VW_titladdress.frame.origin.y+40,self.scroll_Contents.frame.size.width,_VW_address.frame.size.height);
        [self.scroll_Contents addSubview:_VW_address];
        _VW_address.hidden=NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
        [UIView commitAnimations];
        [UIView animateWithDuration:0.5 animations:^{
            
            /*Frame Change*/
            _lbl_address.hidden=YES;
            
            //            _proceed_TOPAY.frame=CGRectMake(_proceed_TOPAY.frame.origin.x
            //                                            ,  _VW_address.frame.origin.y+_VW_address.frame.size.height+10, _proceed_TOPAY.frame.size.width, _proceed_TOPAY.frame.size.height);
            
            _BTN_deposit.frame = CGRectMake(_BTN_deposit.frame.origin.x, _VW_address.frame.origin.y + _VW_address.frame.size.height + 15, _BTN_deposit.frame.size.width, _BTN_deposit.frame.size.height);
            
        }];
        [UIView commitAnimations];
        
        _BTN_edit.enabled=NO;
        
        original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
        [self viewDidLayoutSubviews];
    }
    else
    {
        CGRect final_frame = _TXTVW_organisationname.frame;
        final_frame.size.height = _TXTVW_organisationname.contentSize.height;
        _TXTVW_organisationname.frame = final_frame;
        
        final_frame = _lbl_titledonationAMT.frame;
        final_frame.origin.y = _TXTVW_organisationname.frame.origin.y + _TXTVW_organisationname.frame.size.height + 10;
        _lbl_titledonationAMT.frame = final_frame;
        
        final_frame = _lbl_currencyTYP.frame;
        final_frame.origin.y = _lbl_titledonationAMT.frame.origin.y + _lbl_titledonationAMT.frame.size.height + 10;
        _lbl_currencyTYP.frame = final_frame;
        
        final_frame = _TXT_getamount.frame;
        final_frame.origin.y = _lbl_currencyTYP.frame.origin.y;
        _TXT_getamount.frame = final_frame;
        
        final_frame = _BTN_deduct_wallet.frame;
        final_frame.origin.y = _TXT_getamount.frame.origin.y + _TXT_getamount.frame.size.height + 10;
        _BTN_deduct_wallet.frame = final_frame;
        
        final_frame = _LBL_arrow_wallet.frame;
        final_frame.origin.y = _BTN_deduct_wallet.frame.origin.y;
        _LBL_arrow_wallet.frame = final_frame;
        
        CGRect VW_frame = _VW_organisationdetail.frame;
        if (_VW_wallet.hidden == YES) {
            VW_frame.size.height = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height;
        }
        else
        {
            CGRect frame_lbl = _LBLwallet_balence.frame;
            frame_lbl.origin.y = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height + 10;
            _LBLwallet_balence.frame = frame_lbl;
            
            frame_lbl = _VW_wallet.frame;
            frame_lbl.origin.y = _LBLwallet_balence.frame.origin.y + _LBLwallet_balence.frame.size.height + 10;
            _VW_wallet.frame = frame_lbl;
            
            VW_frame.size.height = _VW_wallet.frame.origin.y + _VW_wallet.frame.size.height;
        }
        VW_frame.size.width = _scroll_Contents.frame.size.width;
        _VW_organisationdetail.frame = VW_frame;
        
        VW_frame = _VW_titladdress.frame;
        VW_frame.origin.y = _VW_organisationdetail.frame.origin.y + _VW_organisationdetail.frame.size.height+10;
        VW_frame.size.width = _scroll_Contents.frame.size.width;
        _VW_titladdress.frame = VW_frame;
        
        CGRect frame_old;
        frame_old = _lbl_address.frame;
        frame_old.origin.y= _VW_titladdress.frame.size.height+_VW_titladdress.frame.origin.y+10;
        _lbl_address.frame=frame_old;
        
        frame_old = _BTN_deposit.frame;
        frame_old.origin.y =  _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
        _BTN_deposit.frame=frame_old;
        
        _VW_address.frame=CGRectMake(0, self.self.VW_titladdress.frame.origin.y+self.VW_titladdress.frame.size.height+10, self.scroll_Contents.frame.size.width, self.VW_address.frame.size.height);
        _VW_address.hidden=YES;
    }
    [[NSUserDefaults standardUserDefaults] setValue:[self.arr objectAtIndex:0] forKey:@"event_id_donate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.TXTVW_organisationname.text=[self.arr objectAtIndex:1];
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}


#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)Deposit_Pressed
{
    
    /*if([_TXTVW_organisationname.text isEqualToString:@""])
  {
      [_TXTVW_organisationname becomeFirstResponder];
  }
    else if([_TXT_getamount.text isEqualToString:@""])
    {
        [_TXT_getamount becomeFirstResponder];
    }
    else
    {
    NSString *amount = _TXT_getamount.text;
       // int  k=[amount intValue];
        
        NSString *eventid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"event_id_donate"]];
       // int j=[eventid intValue];
        
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *number_amount = [f numberFromString:amount];
        NSNumber *number_eventID = [f numberFromString:eventid];
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
//        NSDictionary *parameters = @{ @"price": @10,
//                                      @"event_id": @55 };
        NSDictionary *parameters = @{ @"price":number_amount,
                                      @"event_id":number_eventID };
           NSLog(@"the post data is:%@",parameters);
//    self->activityIndicatorView.hidden=NO;
//    [self->activityIndicatorView startAnimating];
//    [self.view addSubview:activityIndicatorView];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@contributors/create",SERVER_URL];
        NSLog(@"The url iS:%@",urlGetuser);
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
        [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
//        self->activityIndicatorView.hidden=YES;
        NSMutableDictionary *json_DATA_one = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"error is:%@",error);
//        NSLog(@"The response %@",json_DATA_one);
        NSString *status=[json_DATA_one valueForKey:@"message"];
        if([status isEqualToString:@"Successfully donated."])
        {
            NSLog(@"The response %@",json_DATA_one);
            UIAlertController *alertcontrollerone=[UIAlertController alertControllerWithTitle: @"Details"message: @"Details Successfully Posted" preferredStyle:UIAlertControllerStyleAlert];
            [alertcontrollerone addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alertcontrollerone animated:YES completion:nil];
            
            
        }
        else
        {
            
            UIAlertController *alertcontrollertwo = [UIAlertController alertControllerWithTitle:@"Check Details" message: @"Please Check The Details" preferredStyle:UIAlertControllerStyleAlert];
            [alertcontrollertwo addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                //                [self performSegueWithIdentifier:@"success_segue" sender:self];
                
                
            }]];
            [self presentViewController:alertcontrollertwo animated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
    
    
    else
    {
        
        UIAlertController *alertcontrollertwo=[UIAlertController alertControllerWithTitle: @"Server Not Coneected"message: @"Please Check your Connection."
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertcontrollertwo addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alertcontrollertwo animated:YES completion:nil];
    }
    }*/
    
    
    
//    NSString *text_to_compare=_TXT_phonenumber.text;
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    NSString *addr_line_two = _TXT_address2.text;
    NSString *lst_name = _TXT_lastname.text;
    
    if([_TXTVW_organisationname.text isEqualToString:@"Select Event"] || [_TXTVW_organisationname.text isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Select Organisation" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

         [_TXTVW_organisationname becomeFirstResponder];
        
    }
    else if([_TXT_getamount.text isEqualToString:@"0.00"] || [_TXT_getamount.text isEqualToString:@" 0.00"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Amount" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        [_TXT_getamount becomeFirstResponder];
    }
    else if([_TXT_firstname.text isEqualToString:@""])
    {
        [self VIEWaddress];
        [_TXT_firstname becomeFirstResponder];
        [_TXT_firstname showError];
        [_TXT_firstname showErrorWithText:@" Plese enter first name"];
    }

       else if(_TXT_firstname.text.length < 2)
    {
        [self VIEWaddress];
        [_TXT_firstname becomeFirstResponder];
        [_TXT_firstname showError];
        [_TXT_firstname showErrorWithText:@" First name minimum 2 characters"];
    }
    else if([_TXT_address1.text isEqualToString:@""])
    {
        [self VIEWaddress];
        [_TXT_address1 becomeFirstResponder];
        [_TXT_address1 showError];
        [_TXT_address1 showErrorWithText:@" Please enter address line 1"];
    }
    else if (_TXT_address1.text.length < 2)
    {
        [self VIEWaddress];
        [_TXT_address1 becomeFirstResponder];
        [_TXT_address1 showError];
        [_TXT_address1 showErrorWithText:@" Address line 1 minimum 2 characters"];
    }
    else  if(addr_line_two.length != 0 && _TXT_address2.text.length < 2)
    {
        [self VIEWaddress];
        [_TXT_address2 becomeFirstResponder];
        [_TXT_address2 showError];
        [_TXT_address2 showErrorWithText:@" Address line 2 minimum 2 characters"];
    }
    else  if(lst_name.length != 0 && _TXT_lastname.text.length < 2)
    {
        [self VIEWaddress];
        [_TXT_lastname becomeFirstResponder];
        [_TXT_lastname showError];
        [_TXT_lastname showErrorWithText:@" Last name minimum 2 characters"];
    }
    else if([_TXT_city.text isEqualToString:@""])
    {
        [self VIEWaddress];
        [_TXT_city becomeFirstResponder];
        [_TXT_city showError];
        [_TXT_city showErrorWithText:@" Please enter city"];
    }
    else if(_TXT_city.text.length < 2)
    {
        [self VIEWaddress];
        [_TXT_city becomeFirstResponder];
        [_TXT_city showError];
        [_TXT_city showErrorWithText:@" City minimum 2 characters"];
    }
    else if([_TXT_country.text isEqualToString:@""])
    {
        [self VIEWaddress];
        [_TXT_country becomeFirstResponder];
        [_TXT_country showError];
        [_TXT_country showErrorWithText:@" Please Select country"];
    }
//    else if([_TXT_state.text isEqualToString:@""])
//    {
//        [_TXT_state becomeFirstResponder];
//        [_TXT_state showError];
//        [_TXT_state showErrorWithText:@" Please Select State"];
//    }

    else if([_TXT_zip.text isEqualToString:@""])
    {
        [self VIEWaddress];
        [_TXT_zip becomeFirstResponder];
        [_TXT_zip showError];
        [_TXT_zip showErrorWithText:@" Please enter zipcode"];
    }
    else if(_TXT_zip.text.length < 3)
    {
        [self VIEWaddress];
        [_TXT_zip becomeFirstResponder];
        [_TXT_zip showError];
        [_TXT_zip showErrorWithText:@" Zipcode minimum 4 characters"];
    }
    else if([_TXT_phonenumber.text isEqualToString:@""])
    {
        [self VIEWaddress];
        [_TXT_phonenumber becomeFirstResponder];
        [_TXT_phonenumber showError];
        [_TXT_phonenumber showErrorWithText:@" Please enter phone number"];
    }

    else if (_TXT_phonenumber.text.length < 5)
    {
        [self VIEWaddress];
        [_TXT_phonenumber becomeFirstResponder];
        [_TXT_phonenumber showError];
        [_TXT_phonenumber showErrorWithText:@" Phone number minimum 5 numbers"];
    }
      else
    {
        [self.view endEditing:TRUE];
        
        VW_overlay.hidden=NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(donatio_API) withObject:activityIndicatorView afterDelay:0.01];
    }
}
-(void)donatio_API
{
    NSString *fname = _TXT_firstname.text;
    NSString *lastName= _TXT_lastname.text;
    NSString *address1 = _TXT_address1.text;
    NSString *address2 = _TXT_address2.text;
    NSString *city = _TXT_city.text;
    NSString *country = _TXT_country.text;
    NSString *zip = _TXT_zip.text;
    NSString *state = _TXT_state.text;
    NSString *phonenumber = _TXT_phonenumber.text;
    
    NSString *contry_Code = [countryS valueForKey:country];
    NSString *state_code = [states valueForKey:state];
    if (!state_code) {
        state_code = @"";
    }
    
    NSString *amount = _TXT_getamount.text;
    amount = [amount stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *eventid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"event_id_donate"]];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number_amount = [f numberFromString:amount];
    NSNumber *number_eventID = [f numberFromString:eventid];
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSDictionary *parameters;
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    float Float_amt = [[fmt numberFromString:_TXT_getamount.text] floatValue];
    
    if ([_SWITCH_wallet isOn] && (Float_amt != 0)) {
        parameters = @{ @"billing_address":@{@"first_name":fname,@"last_name":lastName,@"address_line1":address1,@"address_line2":address2,@"city":city,@"country":contry_Code,@"zip_code":zip,@"state":state_code,@"phone":phonenumber},@"event_id":number_eventID,@"price":number_amount,@"fund_amount":@"yes"};
    }
    else
    {
        parameters = @{ @"billing_address":@{@"first_name":fname,@"last_name":lastName,@"address_line1":address1,@"address_line2":address2,@"city":city,@"country":contry_Code,@"zip_code":zip,@"state":state_code,@"phone":phonenumber},@"event_id":number_eventID,@"price":number_amount};
    }
    
    NSLog(@"the post data is:%@",parameters);
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@contributors/donation_order",SERVER_URL];
    NSLog(@"The url iS:%@",urlGetuser);
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSMutableDictionary *json_DATA_one = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Data from Donate VC:%@",json_DATA_one);
        
        @try
        {
            NSString *STR_error = [json_DATA_one valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                NSString *status=[json_DATA_one valueForKey:@"status"];
                if([status isEqualToString:@"Success"])
                {
                    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA_one valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    //                [alert show];
                    [[NSUserDefaults standardUserDefaults] setObject:json_DATA_one forKey:@"donate_Deatils"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    NSArray *ARR_tmp = [_LBLwallet_balence.text componentsSeparatedByString:@"$"];
                    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                    [fmt setPositiveFormat:@"0.##"];
                    float Float_amt = [[fmt numberFromString:_TXT_getamount.text] floatValue];
                    float Float_wallet_val = [[NSNumber numberWithFloat:[[ARR_tmp objectAtIndex:[ARR_tmp count]-1] floatValue]] floatValue];
                    
                    if ([_SWITCH_wallet isOn] && (Float_wallet_val > Float_amt)) {
                        VW_overlay.hidden = NO;
                        [activityIndicatorView startAnimating];
                        [self performSelector:@selector(create_payment) withObject:activityIndicatorView afterDelay:0.01];
                    }
                    else
                    {
                        [self get_client_TOKEN];
                    }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA_one valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Check your Connection." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}



-(IBAction)TAP_done
{
    _PICK_state.hidden = YES;
    _TOOL_state.hidden = YES;
    
    NSLog(@"Done Tapped");
}

-(void) ACTION_state
{
    _PICK_state.hidden = NO;
    _TOOL_state.hidden = NO;
}

-(void) get_EVENTS
{
//    NSArray *arr_TEMP = [[NSArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventsStored"] valueForKey:@"events"]];
//    NSArray *sorted_org = [arr_TEMP sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    _oraganisationpicker = [[[NSUserDefaults standardUserDefaults] valueForKey:@"eventsStored"] valueForKey:@"events"];
}


-(void) Tap_DTECt :(UITapGestureRecognizer *)sender
{
}
#pragma mark - Tap Gesture
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [_TXT_getamount resignFirstResponder];
    [_TXT_phonenumber resignFirstResponder];
    
    if ([touch.view isDescendantOfView:_BTN_edit]) {
        return NO;
    }
    else if ([touch.view isDescendantOfView:_BTN_deposit]) {
        return NO;
    }
    return YES;
}

#pragma mark - Generate Client Token
-(void) get_client_TOKEN
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *urlGetuser = [NSString stringWithFormat:@"%@contributors/client_token",SERVER_URL];
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
        
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        NSLog(@"Client Token = %@",[dict valueForKey:@"client_token"]);
        
        @try
        {
            NSString *STR_error = [dict valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                @try {
                    BTDropInRequest *request = [[BTDropInRequest alloc] init];
                    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:[dict valueForKey:@"client_token"] request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
                        
                        if (error != nil) {
                            NSLog(@"ERROR");
                        } else if (result.cancelled) {
                            NSLog(@"CANCELLED");
                            [self dismissViewControllerAnimated:YES completion:NULL];
                        } else {
                            //                    [self performSelector:@selector(dismiss_BT)
                            //                               withObject:nil
                            //                               afterDelay:1.0];
                            [self postNonceToServer:result.paymentMethod.nonce];
                            [self dismissViewControllerAnimated:YES completion:NULL];
                        }
                    }];
                    [self presentViewController:dropIn animated:YES completion:nil];
                }
                @catch (NSException *exception)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
            }
        }
        @catch (NSException *exception)
        {
            [self sessionOUT];
        }
        
      /*  self.braintree = [Braintree braintreeWithClientToken:[dict valueForKey:@"client_token"]];
        NSLog(@"dddd = %@",self.braintree);
        
        BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
        // This is where you might want to customize your Drop in. (See below.)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                              target:self
                                                                                                              action:@selector(userDidCancelPayment)];
        dropInViewController.view.tintColor = _BTN_deposit.backgroundColor;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
        UIImage *new_image = [UIImage imageNamed:@"UI_01"];
        UIImageView *temp_IMG = [[UIImageView alloc]initWithFrame:navigationController.navigationBar.frame];
        temp_IMG.image = new_image;
        
        UIImage *newImage = [temp_IMG.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIGraphicsBeginImageContextWithOptions(temp_IMG.image.size, NO, newImage.scale);
        [[UIColor blackColor] set];
        [newImage drawInRect:CGRectMake(0, 0, temp_IMG.image.size.width, newImage.size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        temp_IMG.image = newImage;
        
        [navigationController.navigationBar setBackgroundImage:temp_IMG.image
                                                 forBarMetrics:UIBarMetricsDefault];
        navigationController.navigationBar.shadowImage = [UIImage new];
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self presentViewController:navigationController animated:YES completion:nil];*/
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
    }
}
-(void)dismiss_BT
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) create_payment
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *naunce_STR = [[NSUserDefaults standardUserDefaults] valueForKey:@"NAUNCETOK"];
    NSDictionary *parameters = @{ @"nonce":naunce_STR};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@payments/create",SERVER_URL];
    NSLog(@"The url iS:%@",urlGetuser);
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    
    NSArray *ARR_tmp = [_LBLwallet_balence.text componentsSeparatedByString:@"$"];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    float Float_amt = [[fmt numberFromString:_TXT_getamount.text] floatValue];
    float Float_wallet_val = [[NSNumber numberWithFloat:[[ARR_tmp objectAtIndex:[ARR_tmp count]-1] floatValue]] floatValue];
    
    if ([_SWITCH_wallet isOn]) {
    
        if (Float_wallet_val < Float_amt) {
            [request setHTTPBody:postData];
        }

    }
    else
    {
        [request setHTTPBody:postData];
    }
    
    
    
    
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSMutableDictionary *json_DATA_one = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
//        @try
//        {
//            NSString *STR_error = [json_DATA_one valueForKey:@"error"];
//            if (STR_error)
//            {
//                [self sessionOUT];
//            }
//            else
//            {
                NSString *str = [json_DATA_one valueForKey:@"status"];
                NSLog(@"Final Payment data : \n%@",json_DATA_one);
                if([str isEqualToString:@"Failure"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA_one valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    
                }
                else
                {
                    [self performSelector:@selector(load_donatepurchase)
                               withObject:activityIndicatorView
                               afterDelay:1.0];
                }
//            }
//        }
//        @catch (NSException *exception)
//        {
//            [self sessionOUT];
//        }
    
        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Payment Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

-(void)load_donatepurchase
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    [self performSelector:@selector(donate_sucess) withObject:nil afterDelay:0.2];
}
-(void)donate_sucess
{
    [self performSegueWithIdentifier:@"donate_purchase" sender:self];
}

#pragma mark - BTViewControllerPresentingDelegate
// Required
- (void)paymentDriver:(id)paymentDriver
requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Required
- (void)paymentDriver:(id)paymentDriver
requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BTAppSwitchDelegate

// Optional - display and hide loading indicator UI
- (void)appSwitcherWillPerformAppSwitch:(id)appSwitcher {
    [self showLoadingUI];
    
    // You may also want to subscribe to UIApplicationDidBecomeActiveNotification
    // to dismiss the UI when a customer manually switches back to your app since
    // the payment button completion block will not be invoked in that case (e.g.
    // customer switches back via iOS Task Manager)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideLoadingUI:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)appSwitcherWillProcessPaymentInfo:(id)appSwitcher {
    [self hideLoadingUI:nil];
}

#pragma mark - Private methods

- (void)showLoadingUI {
    
}

- (void)hideLoadingUI:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

-(void) postNonceToServer :(NSString *)str
{
    NSLog(@"Post %@",str);
    
    if (str)
    {
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"NAUNCETOK"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(create_payment) withObject:activityIndicatorView afterDelay:0.01];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Payment Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

#pragma mark - Session OUT
- (void) sessionOUT
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session out" message:@"In some other device same user logged in. Please login again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
    [self performSelector:@selector(log_out) withObject:nil afterDelay:0.2];
}

-(void)log_out
{
    ViewController *tncView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [tncView setModalInPopover:YES];
    [tncView setModalPresentationStyle:UIModalPresentationFormSheet];
    [tncView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:tncView animated:YES completion:NULL];
}

#pragma mark - Add wallet Code
-(void) BTN_walletTAPPED
{
    NSLog(@"Wallet amout button tap detected");
    
    if ([_LBL_arrow_wallet.text isEqualToString:@""]) {
        _LBL_arrow_wallet.text = @"";
        
//        _LBLwallet_balence.hidden = YES;
//        _VW_wallet.hidden = YES;
        
        [UIView transitionWithView:_LBLwallet_balence
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:NULL
                        completion:NULL];
        [_LBLwallet_balence  setHidden:YES];
        
        [UIView transitionWithView:_VW_wallet
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:NULL
                        completion:NULL];
        [_VW_wallet  setHidden:YES];
        
//        CGRect frame_new = _LBLwallet_balence.frame;
//        frame_new.origin.y = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height + 10;
//        _LBLwallet_balence.frame = frame_new;
        
//        frame_new = _VW_wallet.frame;
//        frame_new.origin.y = _LBLwallet_balence.frame.origin.y + _LBLwallet_balence.frame.size.height + 10;
//        _VW_wallet.frame = frame_new;
        
        CGRect frame_ap = _VW_organisationdetail.frame;
        frame_ap.size.height = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height + 10;
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _VW_organisationdetail.frame = frame_ap;
                         }];
        [UIView commitAnimations];
        
        CGRect frame_bill_addr = _VW_titladdress.frame;
        frame_bill_addr.origin.y = frame_ap.origin.y + frame_ap.size.height;
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        _VW_titladdress.frame = frame_bill_addr;
        [UIView commitAnimations];
        
        
        CGRect frame_addr = _VW_address.frame;
        CGRect frme_lbl = _lbl_address.frame;
        
        if (_lbl_address.hidden == YES) {
            frame_addr.origin.y = _VW_titladdress.frame.origin.y + _VW_titladdress.frame.size.height;
        }
        else
        {
            frme_lbl.origin.y = _VW_titladdress.frame.origin.y + _VW_titladdress.frame.size.height + 10;
        }
        
        
        if (_lbl_address.hidden == NO) {
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 _lbl_address.frame = frme_lbl;
                             }];
            [UIView commitAnimations];
        }
        else
        {
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 _VW_address.frame = frame_addr;
                             }];
            [UIView commitAnimations];
        }
        
        CGRect frame_BTN = _BTN_deposit.frame;
        if (_lbl_address.hidden == YES) {
            frame_BTN.origin.y = _VW_address.frame.origin.y + _VW_address.frame.size.height + 10;
        }
        else
        {
            frame_BTN.origin.y = _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
        }
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _BTN_deposit.frame = frame_BTN;
                         }];
        [UIView commitAnimations];
        
        original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
        [self viewDidLayoutSubviews];
    }
    else
    {
        _LBL_arrow_wallet.text = @"";
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.8];
        _LBLwallet_balence.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_LBLwallet_balence cache:YES];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.8];
        _VW_wallet.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_wallet cache:YES];
        [UIView commitAnimations];
        
        
        CGRect frame_new = _LBLwallet_balence.frame;
        frame_new.origin.y = _BTN_deduct_wallet.frame.origin.y + _BTN_deduct_wallet.frame.size.height + 10;
        _LBLwallet_balence.frame = frame_new;
        
        frame_new = _VW_wallet.frame;
        frame_new.origin.y = _LBLwallet_balence.frame.origin.y + _LBLwallet_balence.frame.size.height + 10;
        _VW_wallet.frame = frame_new;
        
        CGRect frame_ap = _VW_organisationdetail.frame;
        frame_ap.size.height = _VW_wallet.frame.origin.y + _VW_wallet.frame.size.height + 10;
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _VW_organisationdetail.frame = frame_ap;
                         }];
        [UIView commitAnimations];
        
        CGRect frame_bill_addr = _VW_titladdress.frame;
        frame_bill_addr.origin.y = frame_ap.origin.y + frame_ap.size.height;
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        _VW_titladdress.frame = frame_bill_addr;
        [UIView commitAnimations];
        
        
        CGRect frame_addr = _VW_address.frame;
        CGRect frme_lbl = _lbl_address.frame;
        
        if (_lbl_address.hidden == YES) {
            frame_addr.origin.y = _VW_titladdress.frame.origin.y + _VW_titladdress.frame.size.height;
        }
        else
        {
            frme_lbl.origin.y = _VW_titladdress.frame.origin.y + _VW_titladdress.frame.size.height + 10;
        }
        
        
        if (_lbl_address.hidden == NO) {
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 _lbl_address.frame = frme_lbl;
                             }];
            [UIView commitAnimations];
        }
        else
        {
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 _VW_address.frame = frame_addr;
                             }];
            [UIView commitAnimations];
        }
        
        CGRect frame_BTN = _BTN_deposit.frame;
        if (_lbl_address.hidden == YES) {
            frame_BTN.origin.y = _VW_address.frame.origin.y + _VW_address.frame.size.height + 10;
        }
        else
        {
            frame_BTN.origin.y = _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
        }
        
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _BTN_deposit.frame = frame_BTN;
                         }];
        [UIView commitAnimations];
        
        original_height =  self.BTN_deposit.frame.origin.y + _BTN_deposit.frame.size.height + 20;
        [self viewDidLayoutSubviews];
    }
}

#pragma mark - Switch Action
- (void)Switch_ACtion:(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(@"Switch state = %@", rez);
}

@end
