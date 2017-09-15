//
//  VC_billingAddr.m
//  WinningTicket
//
//  Created by Test User on 09/05/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_billingAddr.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"

#import "ViewController.h"

#import "BraintreeCore.h"
#import "BraintreeDropIn.h"

@interface VC_billingAddr ()
{
    float original_height;
    float BTN_originY,total;
    
    CGRect lbl_origin_FRAME;
    NSMutableDictionary *states,*countryS;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
    NSArray *sorted_STAES,*sorted_Contry;
}
@property (nonatomic, strong) NSArray *countrypicker,*statepicker;
@end

@implementation VC_billingAddr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSError *error;
//    NSMutableDictionary *json_DAT = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"state_response"] options:NSASCIIStringEncoding error:&error];
//    NSLog(@"The response %@",json_DAT);
//    self.ARR_states=[json_DAT allKeys];
    
   /* NSURL *clientTokenURL = [NSURL URLWithString:@"https://braintree-sample-merchant.herokuapp.com/client_token"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:clientTokenRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle errors
        NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        tok = clientToken;
        
        NSLog(@"Client Tok = %@",tok);
        
        // Initialize `Braintree` once per checkout session
        self.braintree = [Braintree braintreeWithClientToken:clientToken];
        
        NSLog(@"dddd = %@",self.braintree);
        
        
        // As an example, you may wish to present our Drop-in UI at this point.
        // Continue to the next section to learn more...
    }] resume];*/
    
//    [self get_client_TOKEN];
  [self setup_VIEW];
    
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width,original_height+50);
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
    
    lbl_origin_FRAME = _lbl_agree.frame;
    
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
    //_TXT_country.backgroundColor = [UIColor whiteColor];
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
    //_TXT_zip.backgroundColor = [UIColor whiteColor];
    _TXT_zip.tintColor = self.TXT_city.tintColor;
    _TXT_zip.tag = 8;
    _TXT_zip.delegate=self;
    
    _TXT_phonenumber.layer.cornerRadius = 5.0f;
    _TXT_phonenumber.layer.masksToBounds = YES;
    _TXT_phonenumber.layer.borderWidth = 2.0f;
    _TXT_phonenumber.layer.borderColor = [UIColor grayColor].CGColor;
   // _TXT_phonenumber.backgroundColor = [UIColor whiteColor];
    _TXT_phonenumber.tag = 9;
      _TXT_phonenumber.tintColor = self.TXT_city.tintColor;
    _TXT_phonenumber.delegate=self;
    

    NSError *error;
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    @try
    {
        NSString *STR_error = [dict valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            NSMutableDictionary *temp_dictin = [dict valueForKey:@"event"];
            _lbl_amount_des.text = [NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"] floatValue]];
            _lbl_sub_amount.text = [NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"] floatValue] * [[[NSUserDefaults standardUserDefaults] valueForKey:@"QTY"] intValue]];
            _lbl_total_amount.text = _lbl_sub_amount.text;
            
            NSMutableDictionary *user=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"User_data"] options:NSASCIIStringEncoding error:&error];
            NSLog(@"the user data is:%@",user);
            
            NSDictionary *user_data = [user valueForKey:@"user"];
            
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
            
            [self.navigationController.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName:[UIColor whiteColor],
               NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]}];
            self.navigationItem.title = @"Billing Address";
            
            self.lbl_name_ticket.text=@"Winning Ticket";
            int qtynum = [[[NSUserDefaults standardUserDefaults] valueForKey:@"QTY"]intValue];
            self.lbl_qty.text=[NSString stringWithFormat:@"Qty:%d",qtynum];
            
            
            NSString *ticketnumber = [temp_dictin valueForKey:@"code"];
            NSString *club_name = [[temp_dictin valueForKey:@"name"] capitalizedString];
            NSString *org_name = [[temp_dictin valueForKey:@"organization_name"] capitalizedString];
            
            NSString *text = [NSString stringWithFormat:@"%@\n%@ - %@",org_name,ticketnumber,club_name];
            
            text = [text stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
            
            
            if ([self.lbl_des_cription respondsToSelector:@selector(setAttributedText:)])
            {
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: self.lbl_des_cription.textColor,
                                          NSFontAttributeName: self.lbl_des_cription.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                
                NSRange org = [text rangeOfString:org_name];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:17.0]}range:org];
                
                NSRange plce = [text rangeOfString:club_name];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:15.0]}range:plce];
                
                NSRange codeR = [text rangeOfString:ticketnumber];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:15.0]}range:codeR];
                
                self.lbl_des_cription.attributedText = attributedText;
            }
            else
            {
                self.lbl_des_cription.text = [text capitalizedString];
            }
            
            _lbl_des_cription.numberOfLines = 0;
            [_lbl_des_cription sizeToFit];
            CGRect frame_NEW;
            //    frame_NEW=_lbl_amount_des.frame;
            //    frame_NEW.origin.y=_lbl_des_cription.frame.origin.y;
            //    _lbl_amount_des.frame=frame_NEW;
            
            frame_NEW = _VW_line1.frame;
            frame_NEW.origin.y = _lbl_des_cription.frame.origin.y + _lbl_des_cription.frame.size.height + 10;
            _VW_line1.frame = frame_NEW;
            
            frame_NEW = _lbl_sub_total.frame;
            frame_NEW.origin.y = _VW_line1.frame.origin.y + _VW_line1.frame.size.height + 10;
            _lbl_sub_total.frame = frame_NEW;
            
            frame_NEW = _lbl_sub_amount.frame;
            frame_NEW.origin.y = _VW_line1.frame.origin.y + _VW_line1.frame.size.height + 10;
            _lbl_sub_amount.frame = frame_NEW;
            
            frame_NEW = _VW_line2.frame;
            frame_NEW.origin.y = _lbl_sub_total.frame.origin.y + _lbl_sub_total.frame.size.height + 10;
            _VW_line2.frame = frame_NEW;
            
            frame_NEW = _lbl_total.frame;
            frame_NEW.origin.y = _VW_line2.frame.origin.y + _VW_line2.frame.size.height + 10;
            _lbl_total.frame = frame_NEW;
            
            frame_NEW = _lbl_total_amount.frame;
            frame_NEW.origin.y = _VW_line2.frame.origin.y + _VW_line2.frame.size.height + 10;
            _lbl_total_amount.frame = frame_NEW;
            
            frame_NEW = _VW_main.frame;
            frame_NEW.size.height = _lbl_total.frame.origin.y + _VW_line2.frame.size.height + 15;
            _VW_main.frame = frame_NEW;
            
            float heiht1 = _VW_main.frame.size.height;
            
            self.VW_main.frame = CGRectMake(0,0,
                                            self.scroll_contents.bounds.size.width,_lbl_des_cription.frame.size.height);
            [self.scroll_contents addSubview:self.VW_main];
            
            _lbl_agree.text = @"You will not be charged until you confirm your order";
            _lbl_agree.numberOfLines = 0;
            [_lbl_agree sizeToFit];
            
            
            [_BTN_edit addTarget:self action:@selector(edit_BTN_action:) forControlEvents:UIControlEventTouchUpInside];
            
            frame_NEW = _VW_titladdress.frame;
            frame_NEW.origin.y = _scroll_contents.frame.origin.y + heiht1-50;
            frame_NEW.size.width = _scroll_contents.frame.size.width;
            _VW_titladdress.frame = frame_NEW;
            [self.scroll_contents addSubview:self.VW_titladdress];
            
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
            NSString *STR_cntry = [NSString stringWithFormat:@"%@",[user valueForKey:@"country"]];
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
            
            NSLog(@"Testing Addr = \n%@",str_TST);
            
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
            
            frame_NEW=_lbl_address.frame;
            frame_NEW.origin.x=_VW_titladdress.frame.origin.x+10;
            frame_NEW.origin.y=_VW_titladdress.frame.origin.y+_VW_titladdress.frame.size.height+10;
            _lbl_address.frame=frame_NEW;
            
            [_BTN_checkout addTarget:self action:@selector(chckout_ACtin:) forControlEvents:UIControlEventTouchUpInside];
            
            
            //    frame_NEW=_proceed_TOPAY.frame;
            //    frame_NEW.origin.y=_lbl_address.frame.origin.y+_lbl_address.frame.size.height+30;
            //    _proceed_TOPAY.frame=frame_NEW;
            
            frame_NEW = _BTN_checkout.frame;
            frame_NEW.origin.y = _lbl_address.frame.origin.y + _lbl_address.frame.size.height + 10;
            _BTN_checkout.frame = frame_NEW;
            
            
            
            frame_NEW = _lbl_agree.frame;
            frame_NEW.size.width = lbl_origin_FRAME.size.width;
            _lbl_agree.frame = frame_NEW;
            
            //    frame_NEW = _lbl_agree.frame;
            
            frame_NEW.origin.y = _BTN_checkout.frame.origin.y + _BTN_checkout.frame.size.height + 10;
            _lbl_agree.frame = frame_NEW;
            
            original_height= _lbl_agree.frame.origin.y + _lbl_agree.frame.size.height;
            
            _VW_address.frame=CGRectMake(_VW_titladdress.frame.origin.x,_VW_titladdress.frame.origin.y+_VW_titladdress.frame.size.height,self.scroll_contents.frame.size.width,_VW_address.frame.size.height);
            [self.scroll_contents addSubview:_VW_address];
            _VW_address.hidden=YES;
            
            _contry_pickerView = [[UIPickerView alloc] init];
            _contry_pickerView.delegate = self;
            _contry_pickerView.dataSource = self;
            
            _state_pickerView=[[UIPickerView alloc]init];
            _state_pickerView.dataSource=self;
            _state_pickerView.delegate=self;
            
            
            
            UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                         action:@selector(tappedToSelectRow:)];
            tapToSelect.delegate = self;
            [_contry_pickerView addGestureRecognizer:tapToSelect];
            
            _TXT_country.inputView=_contry_pickerView;
            
            UITapGestureRecognizer *satetap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                     action:@selector(tappedToSelectRowstate:)];
            satetap.delegate = self;
            [_state_pickerView addGestureRecognizer:satetap];
            
            
            
            
            UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            conutry_close.barStyle = UIBarStyleBlackTranslucent;
            [conutry_close sizeToFit];
            
            UIButton *btn=[[UIButton alloc]init];
            btn.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
            [btn setTitle:@"close" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(closebuttonClick) forControlEvents:UIControlEventTouchUpInside];
            //    [numberToolbar setItems:[NSArray arrayWithObjects:close, nil]];
            [conutry_close addSubview:btn];
            _TXT_country.inputAccessoryView=conutry_close;
            
            
            
            
            
            UIToolbar* state_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            state_close.barStyle = UIBarStyleBlackTranslucent;
            [state_close sizeToFit];
            //    UILabel *statelbl=[[UILabel alloc]initWithFrame:CGRectMake(state_close.frame.size.width-250, 0, 100, state_close.frame.size.height)];
            //    [state_close addSubview:statelbl];
            //    statelbl.text=@"Select State";
            //    statelbl.textColor=[UIColor redColor];
            //    statelbl.backgroundColor=[UIColor clearColor];
            
            UIButton *close=[[UIButton alloc]init];
            close.frame=CGRectMake(state_close.frame.size.width - 100, 0, 100, state_close.frame.size.height);
            [close setTitle:@"close" forState:UIControlStateNormal];
            [close addTarget:self action:@selector(closebuttonClick) forControlEvents:UIControlEventTouchUpInside];
            //    [numberToolbar setItems:[NSArray arrayWithObjects:close, nil]];
            [state_close addSubview:close];
            _TXT_state.inputView=_state_pickerView;
            _TXT_state.inputAccessoryView=state_close;
            
            [self Country_api];
            [self State_api];
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


#pragma mark - button Selectors
-(void) backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) edit_BTN_action : (id) sender
{
    if(_VW_address.hidden==YES)
    {

    [self showViewAddress];
    }
    
}

-(void)showViewAddress
{
    if(_VW_address.hidden == YES)
    {
        BTN_originY = _BTN_checkout.frame.origin.y;
        
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.5];
        _VW_address.frame=CGRectMake(_VW_titladdress.frame.origin.x,_VW_titladdress.frame.origin.y+_VW_titladdress.frame.size.height,self.scroll_contents.frame.size.width,_VW_address.frame.size.height);
        [self.scroll_contents addSubview:_VW_address];
        _VW_address.hidden=NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
        [UIView commitAnimations];
        [UIView animateWithDuration:0.5 animations:^{
            
            /*Frame Change*/
            _lbl_address.hidden=YES;
            
            //            _proceed_TOPAY.frame=CGRectMake(_proceed_TOPAY.frame.origin.x
            //                                            ,  _VW_address.frame.origin.y+_VW_address.frame.size.height+10, _proceed_TOPAY.frame.size.width, _proceed_TOPAY.frame.size.height);
            
            _BTN_checkout.frame = CGRectMake(_BTN_checkout.frame.origin.x, _VW_address.frame.origin.y+_VW_address.frame.size.height+10, _BTN_checkout.frame.size.width, _BTN_checkout.frame.size.height);
            
            _lbl_agree.frame = CGRectMake(_lbl_agree.frame.origin.x, _BTN_checkout.frame.origin.y + _BTN_checkout.frame.size.height+10 , lbl_origin_FRAME.size.width, _lbl_agree.frame.size.height+10);
            
        }];
        [UIView commitAnimations];
        original_height =  self.BTN_checkout.frame.origin.y + _BTN_checkout.frame.size.height + 20;
        [self viewDidLayoutSubviews];
        
    }
    
}


-(void) chckout_ACtin : (id) sender
{
//    if(_VW_address.hidden == YES)
//    {
//      [self showViewAddress];
//    }
//    NSString *text_to_compare_email = _txt.text;
//    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
//    NSLog(@"Sighn UP");
    
    
    
    if([_TXT_firstname.text isEqualToString:@""])
    {
        [self showViewAddress];
        [_TXT_firstname becomeFirstResponder];
        [_TXT_firstname showError];
        [_TXT_firstname showErrorWithText:@" Please enter first name"];
//        [self showViewAddress];
    }
    else if (_TXT_firstname.text.length < 2)
    {
        [self showViewAddress];
        [_TXT_firstname becomeFirstResponder];
        [_TXT_firstname showError];
        [_TXT_firstname showErrorWithText:@" First name minimum 2 characters"];
//        [self showViewAddress];
    }
//    else  if([_TXT_lastname.text isEqualToString:@""])
//    {
//        [_TXT_lastname becomeFirstResponder];
//        [_TXT_lastname showError];
//        [_TXT_lastname showErrorWithText:@" Please enter More than  2 Chracters"];
//    }
//    else if (_TXT_lastname.text.length < 2)
//    {
//        
//    }
    else if([_TXT_address1.text isEqualToString:@""])
    {
        [self showViewAddress];
        [_TXT_address1 becomeFirstResponder];
        [_TXT_address1 showError];
        [_TXT_address1 showErrorWithText:@" Please enter address line 1"];
//        [self showViewAddress];
    }
    else if (_TXT_address1.text.length < 2)
    {
        [self showViewAddress];
        [_TXT_address1 becomeFirstResponder];
        [_TXT_address1 showError];
        [_TXT_address1 showErrorWithText:@" Address line 1 minimum 2 characters"];
//        [self showViewAddress];
    }
//    else  if([_TXT_address2.text isEqualToString:@""] || _TXT_address2.text.length <= 2 || _TXT_address2.text.length > 30)
//    {
//        [_TXT_address2 becomeFirstResponder];
//        [_TXT_address2 showError];
//        [_TXT_address2 showErrorWithText:@" Please enter More than  2 Chracters"];
//        
//    }
    else if([_TXT_city.text isEqualToString:@""])
    {
        [self showViewAddress];
        [_TXT_city becomeFirstResponder];
        [_TXT_city showError];
        [_TXT_city showErrorWithText:@" Please enter city"];
//        [self showViewAddress];
    }
    else if (_TXT_city.text.length < 2)
    {
        [self showViewAddress];
        [_TXT_city becomeFirstResponder];
        [_TXT_city showError];
        [_TXT_city showErrorWithText:@" City minimum 2 characters"];
//        [self showViewAddress];
    }
    
    else if([_TXT_country.text isEqualToString:@""])
    {
        [self showViewAddress];
        [_TXT_country becomeFirstResponder];
        [_TXT_country showError];
        [_TXT_country showErrorWithText:@" Please select country"];
        
    }
//    else if([_TXT_state.text isEqualToString:@""])
//    {
//        [_TXT_state becomeFirstResponder];
//        [_TXT_state showError];
//        [_TXT_state showErrorWithText:@" Please Select State"];
//        
//    }
    else if([_TXT_zip.text isEqualToString:@""])
    {
        [self showViewAddress];
        [_TXT_zip becomeFirstResponder];
        [_TXT_zip showError];
        [_TXT_zip showErrorWithText:@" Please enter zipcode code"];
    }
    else if (_TXT_zip.text.length < 4)
    {
        [self showViewAddress];
        [_TXT_zip becomeFirstResponder];
        [_TXT_zip showError];
        [_TXT_zip showErrorWithText:@" Zipcode minimum 4 characters"];
    }
    else if (_TXT_phonenumber.text.length < 5)
    {
        [self showViewAddress];
        [_TXT_phonenumber becomeFirstResponder];
        [_TXT_phonenumber showError];
        [_TXT_phonenumber showErrorWithText:@" Please enter more than 5 numbers"];
    }
    

//    else if([_TXT_email.text isEqualToString:@""] || [emailTest evaluateWithObject:text_to_compare_email] == NO)
//    {
//        [_TXT_email becomeFirstResponder];
//        [_TXT_email showError];
//        [_TXT_email showErrorWithText:@" Please Enter Correct Email"];
//    }
    else
    {
        [self.view endEditing:TRUE];
        
        
      VW_overlay.hidden = NO;
      [activityIndicatorView startAnimating];
        
       total = [[[NSUserDefaults standardUserDefaults] valueForKey:@"total_balance"] floatValue];
       NSString *switch_STAT = [[NSUserDefaults standardUserDefaults] valueForKey:@"SWITCHSTAT"];
        
      if(total == 0.00 && [switch_STAT isEqualToString:@"SWITCH_ON"])
      {
          [self performSelector:@selector(billing_Address) withObject:activityIndicatorView afterDelay:0.01];
      }
      else
      {
          [self performSelector:@selector(get_client_TOKEN) withObject:activityIndicatorView afterDelay:0.01];

      }
        
    }
}

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
        
        @try
        {
            NSString *STR_error = [dict valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                NSLog(@"Client Token = %@",[dict valueForKey:@"client_token"]);
                [self braintree_Dropin_UI:[dict valueForKey:@"client_token"]];
            }
        }
        @catch (NSException *exception)
        {
            [self sessionOUT];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please retry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

-(void) braintree_Dropin_UI :(NSString *) client_TOK
{
   /* BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    // This is where you might want to customize your Drop in. (See below.)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally presented navigation controller:
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                          target:self
                                                                                                          action:@selector(userDidCancelPayment)];
    dropInViewController.view.tintColor = _BTN_checkout.backgroundColor;
    
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
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];*/
    
    @try
    {
        BTDropInRequest *request = [[BTDropInRequest alloc] init];
        BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:client_TOK request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
            
            if (error != nil) {
                NSLog(@"ERROR");
            } else if (result.cancelled) {
                NSLog(@"CANCELLED");
                [self dismissViewControllerAnimated:YES completion:NULL];
            } else {
//                [self performSelector:@selector(dismiss_BT)
//                           withObject:nil
//                           afterDelay:0.0];
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


-(void) dismiss_BT
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark textfieldDelegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
       [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 3 || textField.tag == 8 || textField.tag == 9)
    {
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        // {
        //Keyboard becomes visible
        [UIView beginAnimations:nil context:NULL];
        // [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        //}
    }
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if(textField.tag==8)
//    {
        [UIView beginAnimations:nil context:NULL];
   
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
                [UIView beginAnimations:nil context:NULL];
  
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
//    }
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
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
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
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    
//    if(textField.tag==6)
//    {
//        NSInteger inte = textField.text.length;
//        if(inte >= 12)
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
//    if(textField.tag==7)
//    {
//        NSInteger inte = textField.text.length;
//        if(inte >= 60)
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
    if(textField.tag==8)
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
    if(textField.tag==9)
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
//            if (inte <= 2)
//            {
//                return YES;
//    
//            }
//            else if(inte >= 12)
//            {
//                return NO;
//            }
//    
//    
//            return YES;
    }
    return YES;
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
    if (aData) {
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
//        self.TXT_email.enabled=YES;
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
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nonce" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//    [alert show];
    
    if (str)
    {
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"NAUNCETOK"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self billing_Address];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(billing_Address) withObject:activityIndicatorView afterDelay:0.01];
//         [self dismissViewControllerAnimated:YES completion:NULL];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Payment Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

-(void) billing_Address
{
   // [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSError *error;
    NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"QUANTITY"] options:NSASCIIStringEncoding error:&error];
    
    @try
    {
        NSString *STR_error = [dict valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            NSString *order_ID = [dict valueForKey:@"order_id"];
            NSString *first_name = _TXT_firstname.text;
            NSString *last_name = _TXT_lastname.text;
            NSString *address_line1 = _TXT_address1.text;
            NSString *address_line2 = _TXT_address2.text;
            NSString *city = _TXT_city.text;
            NSString *country = _TXT_country.text;
            NSString *zip_code = _TXT_zip.text;
            NSString *state = _TXT_state.text;
            NSString *phone = _TXT_phonenumber.text;
            
            NSString *contry_Code = [countryS valueForKey:country];
            NSString *state_code = [states valueForKey:state];
            if (!state_code) {
                state_code = @"";
            }
            
            NSHTTPURLResponse *response = nil;
            NSDictionary *parameters;
            
            
            NSString *switch_STAT = [[NSUserDefaults standardUserDefaults] valueForKey:@"SWITCHSTAT"];
            
            if([switch_STAT isEqualToString:@"SWITCH_ON"])
            {
                 parameters = @{@"billing_address":@{ @"first_name": first_name,@"last_name": last_name,@"address_line1": address_line1,@"address_line2": address_line2,@"city": city,@"country": contry_Code,@"zip_code": zip_code,@"state": state_code,@"order_id": order_ID,@"phone": phone},@"fund_amount":@"yes"};
                
                
            }
            else
            {
                 parameters = @{@"billing_address":@{ @"first_name": first_name,@"last_name": last_name,@"address_line1": address_line1,@"address_line2": address_line2,@"city": city,@"country": contry_Code,@"zip_code": zip_code,@"state": state_code,@"order_id": order_ID,@"phone": phone }};
            }
            
            NSLog(@"Post contents VC Billing Address %@",parameters);
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
            NSString *urlGetuser =[NSString stringWithFormat:@"%@events/billing_address",SERVER_URL];
            NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
            NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:urlProducts];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
            [request setHTTPBody:postData];
            [request setHTTPShouldHandleCookies:NO];
            NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (aData)
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
                
//                @try
//                {
//                    NSString *STR_error1 = [aData valueForKey:@"error"];
//                    if (STR_error1)
//                    {
//                        [self sessionOUT];
//                    }
//                    else
//                    {
                        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"CHKOUTDETAIL"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self performSegueWithIdentifier:@"billaddretocheckoutdetail" sender:self];
                        [self  parse_listEvents_api];
//                    }
//                }
//                @catch (NSException *exception)
//                {
//                    [self sessionOUT];
//                }
            }
            else
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            }
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
    
    
    
}
-(void) parse_listEvents_api
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@events",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    //    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"JsonEventlist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [self performSegueWithIdentifier:@"logintohomeidentifier" sender:self];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
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
