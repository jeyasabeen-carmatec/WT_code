//
//  VC_addFUNDS.m
//  WinningTicket
//
//  Created by Test User on 30/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_addFUNDS.h"
#import "ADD_Funds_CollectionViewCell.h"
//#import "DGActivityIndicatorView.h"
//#import "DejalActivityView.h"
#import "ViewController.h"




@interface VC_addFUNDS ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
{
    NSMutableDictionary *states,*countryS;
    NSArray* asc_denomarr;
    NSString *amount_str;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
}
@property (nonatomic, strong) NSArray *countrypicker,*statepicker,*denom_arr;

@end

@implementation VC_addFUNDS
{
    float content_height;
    float original_height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSError *error;
//    NSMutableDictionary *json_DAT = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"state_response"] options:NSASCIIStringEncoding error:&error];
//    NSLog(@"The response %@",json_DAT);
//    self.ARR_states=[json_DAT allKeys];
   
    [self setup_VIEW];
    
//    NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:1];
//    [self collectionView:_amount_collection didDeselectItemAtIndexPath:index];
//    [self collectionView:_amount_collection didSelectItemAtIndexPath:index];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([asc_denomarr count] != 0)
    {
        NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.amount_collection selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.amount_collection didSelectItemAtIndexPath:indexPathForFirstRow];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [_scroll_Contents layoutIfNeeded];
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        _scroll_Contents.contentSize = CGSizeMake(_scroll_Contents.frame.size.width, original_height);
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

-(void) setup_VIEW
{
    @try
    {
        _denom_arr=[[[NSUserDefaults standardUserDefaults] valueForKey:@"denom_collection"] valueForKey:@"denominations"];
    }
    @catch (NSException *exception)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    asc_denomarr = [_denom_arr sortedArrayUsingComparator:^NSComparisonResult(NSNumber* n1, NSNumber* n2) {
        return [n1 compare:n2];
    }];
    NSLog(@"Ascending: %@", asc_denomarr);
    
    if ([asc_denomarr count] == 0) {
        _amount_collection.hidden = YES;
    }
    else
    {
        [_amount_collection reloadData];
    }
    
//    [self.amount_collection
//     s];
    

    _VW_contents.frame=CGRectMake(0,0, self.scroll_Contents.frame.size.width, self.VW_contents.frame.size.height);
    [self.scroll_Contents addSubview:_VW_contents];
    
    float org_height = _VW_contents.frame.origin.y + _VW_contents.frame.size.height;
    NSLog(@"the original height:%f",org_height);
    
    //    _TXTVW_organisationname.text = @"dshgfdsf dshgfsdf udsgfgsdf sdiufgsd as\nuyatsuyd asuyduyagsd
    float framehight = _VW_contents.frame.origin.y + _VW_contents.frame.size.height;
    NSLog(@"the original height:%f",framehight);
    
    
//    _VW_titladdress.frame = CGRectMake(0, framehight+10, self.scroll_Contents.frame.size.width, self.VW_titladdress.frame.size.height);
    
////    [self.scroll_Contents addSubview:_VW_titladdress];
//    CGRect frame_old;
//    frame_old = _lbl_address.frame;
//    frame_old.origin.y= _VW_contents.frame.size.height+_VW_contents.frame.origin.y+10;
//    _lbl_address.frame=frame_old;
    
//    _VW_address.frame=CGRectMake(0, self.self.VW_titladdress.frame.origin.y+self.VW_titladdress.frame.size.height+10, self.scroll_Contents.frame.size.width, self.VW_address.frame.size.height);
//    [self.scroll_Contents addSubview:_VW_address];
//    _VW_address.hidden=YES;

    
//    [_BTN_edit addTarget:self action:@selector(edit_BTN_action:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    NSData *aData=[[NSUserDefaults standardUserDefaults]valueForKey:@"User_data"] ;
//    NSError *error;
//    
//    if(aData)
//    {
//        NSMutableDictionary *user_DICTIN = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"User_data"] options:NSASCIIStringEncoding error:&error];
//        NSDictionary *user_data = [user_DICTIN valueForKey:@"user"];
//        NSLog(@"VC donate display Address:%@",user_data);
//        NSString *address_str=[NSString stringWithFormat:@"%@ %@\n%@,%@\n%@,%@\n%@,%@.\nPhone:%@",[user_data valueForKey:@"first_name"],[user_data valueForKey:@"last_name"],[user_data valueForKey:@"address1"],[user_data valueForKey:@"address2"],[user_data valueForKey:@"city"],[user_data valueForKey:@"state"],[user_data valueForKey:@"country"],[user_data valueForKey:@"zipcode"],[user_data valueForKey:@"phone"]];
//        _lbl_address.text = address_str;
//        _lbl_address.numberOfLines=0;
//        [_lbl_address sizeToFit];
//        
//    }
//    
//    else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//        
//    }
//    
//    
//
       CGRect frame_old;
    frame_old=_ADD_funds.frame;
    frame_old.origin.y=_VW_contents.frame.origin.y+_VW_contents.frame.size.height+10;
    _ADD_funds.frame=frame_old;
    /*setting the frames for address label and button in old*/

//    [self Country_api];
//    [self State_api];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap_DTECt:)];
    [tap setCancelsTouchesInView:NO];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];


    
    _TXT_amount.layer.cornerRadius = 5.0f;
    _TXT_amount.layer.masksToBounds = YES;
    _TXT_amount.layer.borderWidth = 2.0f;
    _TXT_amount.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
//    _TXT_amount.titleLabel.textColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0];
      _TXT_amount.delegate=self;
//    
//   
//    
//    _TXT_firstname.layer.cornerRadius = 5.0f;
//    _TXT_firstname.layer.masksToBounds = YES;
//    _TXT_firstname.layer.borderWidth = 2.0f;
//    _TXT_firstname.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_firstname.backgroundColor = [UIColor whiteColor];
//    _TXT_firstname.tag=1;
//    _TXT_firstname.delegate=self;
//    
//    
//    _TXT_lastname.layer.cornerRadius = 5.0f;
//    _TXT_lastname.layer.masksToBounds = YES;
//    _TXT_lastname.layer.borderWidth = 2.0f;
//    _TXT_lastname.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_lastname.backgroundColor = [UIColor whiteColor];
//    _TXT_lastname.tag=2;
//    _TXT_lastname.delegate=self;
//    
//    _TXT_address1.layer.cornerRadius = 5.0f;
//    _TXT_address1.layer.masksToBounds = YES;
//    _TXT_address1.layer.borderWidth = 2.0f;
//    _TXT_address1.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_address1.backgroundColor = [UIColor whiteColor];
//    _TXT_address1.tag=3;
//    _TXT_address1.delegate=self;
//    
//    _TXT_address2.layer.cornerRadius = 5.0f;
//    _TXT_address2.layer.masksToBounds = YES;
//    _TXT_address2.layer.borderWidth = 2.0f;
//    _TXT_address2.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_address2.backgroundColor = [UIColor whiteColor];
//    _TXT_address2.tag=4;
//    _TXT_address2.delegate=self;
//    
//    _TXT_city.layer.cornerRadius = 5.0f;
//    _TXT_city.layer.masksToBounds = YES;
//    _TXT_city.layer.borderWidth = 2.0f;
//    _TXT_city.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_city.backgroundColor = [UIColor whiteColor];
//    _TXT_city.tag=5;
//    _TXT_city.delegate=self;
//    
//    _TXT_country.layer.cornerRadius = 5.0f;
//    _TXT_country.layer.masksToBounds = YES;
//    _TXT_country.layer.borderWidth = 2.0f;
//    _TXT_country.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_country.backgroundColor = [UIColor whiteColor];
//    _TXT_country.tag=6;
//    _TXT_country.delegate=self;
//    
//    
//    _TXT_state.layer.cornerRadius = 5.0f;
//    _TXT_state.layer.masksToBounds = YES;
//    _TXT_state.layer.borderWidth = 2.0f;
//    _TXT_state.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_state.backgroundColor = [UIColor whiteColor];
//    _TXT_state.tag=7;
//    _TXT_state.delegate=self;
//    
//    _TXT_zip.layer.cornerRadius = 5.0f;
//    _TXT_zip.layer.masksToBounds = YES;
//    _TXT_zip.layer.borderWidth = 2.0f;
//    _TXT_zip.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_zip.backgroundColor = [UIColor whiteColor];
//    _TXT_zip.tag=8;
//    _TXT_zip.delegate=self;
//    
//    _TXT_phonenumber.layer.cornerRadius = 5.0f;
//    _TXT_phonenumber.layer.masksToBounds = YES;
//    _TXT_phonenumber.layer.borderWidth = 2.0f;
//    _TXT_phonenumber.layer.borderColor = [UIColor grayColor].CGColor;
//    _TXT_phonenumber.backgroundColor = [UIColor whiteColor];
//    _TXT_phonenumber.tag=9;
//    _TXT_phonenumber.delegate=self;
//    
//    CGRect frame_rct = _VW_contents.frame;
//    frame_rct.size.width = _scroll_Contents.frame.size.width;
//    _VW_contents.frame = frame_rct;
//    
//    [_scroll_Contents addSubview:_VW_contents];
//    
//    
//    _contry_pickerView = [[UIPickerView alloc] init];
//    _contry_pickerView.delegate = self;
//    _contry_pickerView.dataSource = self;
//    _state_pickerView = [[UIPickerView alloc] init];
//    _state_pickerView.delegate = self;
//    _state_pickerView.dataSource = self;
//    
//    
//    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
//                                                                                 action:@selector(tappedToSelectRow:)];
//    tapToSelect.delegate = self;
//    [_contry_pickerView addGestureRecognizer:tapToSelect];
//    UITapGestureRecognizer *satetap = [[UITapGestureRecognizer alloc]initWithTarget:self
//                                                                             action:@selector(tappedToSelectRowstate:)];
//    satetap.delegate = self;
//    [_state_pickerView addGestureRecognizer:satetap];
//
//    
//    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    conutry_close.barStyle = UIBarStyleBlackTranslucent;
//    [conutry_close sizeToFit];
//    
//    UIButton *close=[[UIButton alloc]init];
//    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
//    [close setTitle:@"close" forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(closebuttonClick) forControlEvents:UIControlEventTouchUpInside];
//    //    [numberToolbar setItems:[NSArray arrayWithObjects:close, nil]];
//    [conutry_close addSubview:close];
//    _TXT_country.inputAccessoryView=conutry_close;
//    _TXT_state.inputAccessoryView=conutry_close;
//    self.TXT_country.inputView = _contry_pickerView;
//    self.TXT_state.inputView=_state_pickerView;
//    _TXT_country.tintColor=[UIColor clearColor];
//    _TXT_state.tintColor=[UIColor clearColor];
    [_ADD_funds addTarget:self action:@selector(add_funds_tapped) forControlEvents:UIControlEventTouchUpInside];
    
    
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
//-(void)closebuttonClick
//{
//    [_TXT_state resignFirstResponder];
//    [_TXT_country resignFirstResponder];
//}
#pragma mark - Collection View Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _denom_arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADD_Funds_CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.LBL_amount.layer.cornerRadius = 5.0f;
    cell.LBL_amount.layer.masksToBounds = YES;
    cell.LBL_amount.layer.borderWidth = 2.0f;
    cell.LBL_amount.layer.borderColor = [UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0].CGColor;
//    [cell.LBL_amount setTitleColor:[UIColor colorWithRed:0.43 green:0.48 blue:0.51 alpha:1.0] forState:UIControlStateNormal];

    if ([_denom_arr count] == 0) {
        cell.LBL_amount.text=[NSString stringWithFormat:@"$0"];
    }
    cell.LBL_amount.text=[NSString stringWithFormat:@"$%i",[[asc_denomarr objectAtIndex:indexPath.row]intValue]];
//    [cell.LBL_amount sizeToFit];
//    cell.LBL_amount.numberOfLines=0;
    
//    cell.LBL_amount.backgroundColor = [UIColor redColor];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADD_Funds_CollectionViewCell  *cell = (ADD_Funds_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    cell.LBL_amount.backgroundColor = [UIColor lightGrayColor];
    cell.LBL_amount.textColor = [UIColor whiteColor];
    
    
    [_TXT_amount resignFirstResponder];
       amount_str = [NSString stringWithFormat:@"%.2f",[[asc_denomarr objectAtIndex:indexPath.row]floatValue]];
    
    _TXT_amount.text = @"";
    NSLog(@"called index path:%ld",(long)indexPath.row);
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADD_Funds_CollectionViewCell  *cell = (ADD_Funds_CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
     cell.LBL_amount.backgroundColor = [UIColor whiteColor];
     cell.LBL_amount.textColor = [UIColor lightGrayColor];
    amount_str=@"";
    
    NSLog(@"VC add funds Called collection view deselect");
}

//#pragma mark - Edit button Clicked
//
//-(void) edit_BTN_action : (id) sender
//{
//    if(_VW_address.hidden==YES)
//    {
//        original_height =  self.ADD_funds.frame.origin.y + _ADD_funds.frame.size.height + 20;
//        
//        
//        
//        [UIView beginAnimations:@"LeftFlip" context:nil];
//        [UIView setAnimationDuration:0.5];
//        _VW_address.frame=CGRectMake(_VW_titladdress.frame.origin.x,_VW_titladdress.frame.origin.y+40,self.scroll_Contents.frame.size.width,_VW_address.frame.size.height);
//        [self.scroll_Contents addSubview:_VW_address];
//        _VW_address.hidden=NO;
//        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_VW_address cache:YES];
//        [UIView commitAnimations];
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            /*Frame Change*/
//            _lbl_address.hidden=YES;
//            
//            //            _proceed_TOPAY.frame=CGRectMake(_proceed_TOPAY.frame.origin.x
//            //                                            ,  _VW_address.frame.origin.y+_VW_address.frame.size.height+10, _proceed_TOPAY.frame.size.width, _proceed_TOPAY.frame.size.height);
//            
//            _ADD_funds.frame = CGRectMake(_ADD_funds.frame.origin.x, _VW_address.frame.origin.y + _VW_address.frame.size.height + 15, _ADD_funds.frame.size.width, _ADD_funds.frame.size.height);
//            
//        }];
//        [UIView commitAnimations];
//        _BTN_edit.enabled=NO;
//        original_height =  self.ADD_funds.frame.origin.y + _ADD_funds.frame.size.height + 20;
//        [self viewDidLayoutSubviews];
//        
//    }
//    else{
//        //        [self hideview];
//        original_height = original_height - 100;
//        _lbl_address.hidden=NO;
//        [self viewDidLayoutSubviews];
//    }
//    
//}
//
//
//#pragma mark PickerView DataSource

#pragma mark - UIPickerViewDataSource

// #3
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    if (pickerView == _contry_pickerView) {
//        return 1;
//    }if(pickerView==_state_pickerView)
//    {
//        return 1;
//    }
//    
//    return 0;
//}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (pickerView == _contry_pickerView) {
//        return [self.countrypicker count];
//    }
//    if (pickerView == _state_pickerView) {
//        return [self.statepicker count];
//    }
//    
//    
//    return 0;
//}
//#pragma mark - UIPickerViewDataSource
//-(void)Country_api
//{
//    NSHTTPURLResponse *response = nil;
//    NSError *error;
//    NSString *urlGetuser =[NSString stringWithFormat:@"%@city_states/countries",SERVER_URL];
//    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:urlProducts];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPShouldHandleCookies:NO];
//    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (aData) {
//        countryS = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
//        NSLog(@"The response %@",countryS);
//        self.countrypicker=[countryS allKeys];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//    }
//    
//    
//    
//    
//}
//-(void)State_api
//{
//    NSHTTPURLResponse *response = nil;
//    NSError *error;
//    NSString *urlGetuser =[NSString stringWithFormat:@"%@city_states/states?country=%@",SERVER_URL,[countryS valueForKey:_TXT_country.text]];
//    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:urlProducts];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPShouldHandleCookies:NO];
//    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (aData) {
//        states = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
//        NSLog(@"The response %@",states);
//        self.statepicker=[states allKeys];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//    }
//    
//    
//    
//    
//}

//#pragma mark - UIPickerViewDelegate
//
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (pickerView == _contry_pickerView) {
//        return self.countrypicker[row];
//    }
//    if (pickerView == _state_pickerView) {
//        return self.statepicker[row];
//    }
//    
//    return nil;
//}
//
//// #6
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (pickerView == _contry_pickerView) {
//        self.TXT_country.text = self.countrypicker[row];
//        [self State_api];
//        self.TXT_state.enabled=YES;
//    }
//    if (pickerView == _state_pickerView) {
//        
//        self.TXT_state.text=self.statepicker[row];
////        self.TXT_email.enabled=YES;
//    }
//}
//
//
//

#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - IBAction Actions
-(IBAction)TAP_done
{
//    _PICK_state.hidden = YES;
//    _TOOL_state.hidden = YES;
    
    NSLog(@"Done Tapped");
}

#pragma mark - UITextFieldDeligate/UITextFieldDatasource

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _TXT_amount)
    {
        amount_str = @"";
        _TXT_amount.text=@"";
        _TXT_amount.placeholder=@"0.00";
        
        if([_TXT_amount.placeholder isEqualToString:@"0.00"])
        {
            NSArray *ary = _amount_collection.visibleCells;
            for (ADD_Funds_CollectionViewCell *cell in ary)
            {
                NSIndexPath *path = [_amount_collection indexPathForCell:cell];
                NSLog(@"indexPath of cell: Section: %d , Row: %d", (int)path.section, (int)path.row);
                cell.LBL_amount.backgroundColor = [UIColor whiteColor];
                cell.LBL_amount.textColor =[UIColor grayColor];
                amount_str=@"";
//                _amount_collection.userInteractionEnabled=NO;
                
            }

        }
    }
    
//
//    if(textField.tag == 3 || textField.tag == 8 || textField.tag == 9)
//    {
//        [textField setTintColor:[UIColor whiteColor]];
//        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        // {
//        //Keyboard becomes visible
//        [UIView beginAnimations:nil context:NULL];
//        // [UIView setAnimationDuration:0.25];
//        self.view.frame = CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height);
//        [UIView commitAnimations];
//        //}
//    }
    

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    [UIView beginAnimations:nil context:NULL];
//    
//    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
//    [UIView commitAnimations];
//    [UIView beginAnimations:nil context:NULL];
//    
//    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
//    [UIView commitAnimations];
//    // }
//
//    
//    if (textField == _TXT_amount) {
//        NSString *new_STR= _TXT_amount.text;
//        NSArray *ARR_str = [new_STR componentsSeparatedByString:@"."];
//        if (ARR_str.count == 1)
//        {
//            //        self.lbl.text = [NSString stringWithFormat:@"%@.00",new_STR];
//            //        _txtfld.text = self.lbl.text;
////            _TXT_amount.text = [NSString stringWithFormat:@"%@.00",new_STR];
//        }
//        else
//        {
//            NSString *temp_STR = [ARR_str objectAtIndex:1];
//            if (temp_STR.length == 1) {
//                //            self.lbl.text = [NSString stringWithFormat:@"%@0",new_STR];
//                //            _txtfld.text = self.lbl.text;
//                _TXT_amount.text = [NSString stringWithFormat:@"%@0",new_STR];
//            }
//            else
//            {
//                //            self.lbl.text = new_STR;
//                //            _txtfld.text = self.lbl.text;
//                _TXT_amount.text = new_STR;
//            }
//        }
//    }
}

//-(void) check_TXT_stat :(id)sender
//{
////    NSString *str = _TXT_amount.text;
////    _TXT_amount.text = [NSString stringWithFormat:@"%.02f",[str floatValue]];
//    NSString *newContents = self.TXT_amount.text;
//    newContents = [newContents stringByReplacingOccurrencesOfString:@"." withString:@""];
//
//   }

//- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
//{
//    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGFloat rowHeight = [_contry_pickerView rowSizeForComponent:0].height;
//        CGRect selectedRowFrame = CGRectInset(_contry_pickerView.bounds, 0.0, (CGRectGetHeight(_contry_pickerView.frame) - rowHeight) / 2.0 );
//        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_contry_pickerView]));
//        if (userTappedOnSelectedRow) {
//            NSInteger selectedRow = [_contry_pickerView selectedRowInComponent:0];
//            [self pickerView:_contry_pickerView didSelectRow:selectedRow inComponent:0];
//        }
//    }
//}
//- (IBAction)tappedToSelectRowstate:(UITapGestureRecognizer *)tapRecognizer
//{
//    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGFloat rowHeight = [_state_pickerView rowSizeForComponent:0].height;
//        CGRect selectedRowFrame = CGRectInset(_state_pickerView.bounds, 0.0, (CGRectGetHeight(_state_pickerView.frame) - rowHeight) / 2.0 );
//        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_state_pickerView]));
//        if (userTappedOnSelectedRow) {
//            NSInteger selectedRow = [_state_pickerView selectedRowInComponent:0];
//            [self pickerView:_state_pickerView didSelectRow:selectedRow inComponent:0];
//        }
//    }
//}

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
//        [self create_payment];
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

-(void)paymentMethodCreator:(id)sender didFailWithError:(NSError *)error
{
    NSLog(@"Error = %@",error);
}

-(void)paymentMethodCreator:(id)sender requestsPresentationOfViewController:(UIViewController *)viewController
{
    NSLog(@"BT Request Presentation Braintree UI");
}
-(void)paymentMethodCreator:(id)sender requestsDismissalOfViewController:(UIViewController *)viewController
{
    NSLog(@"BT Request Dismissal Braintree UI");
}
-(void)paymentMethodCreatorWillPerformAppSwitch:(id)sender
{
    NSLog(@"BT performing app switch");
}
-(void)paymentMethodCreatorWillProcess:(id)sender
{
    NSLog(@"BT Payment methord creator process");
}
-(void)paymentMethodCreatorDidCancel:(id)sender
{
    NSLog(@"BT user did cancel");
}
//-(void)paymentMethodCreator:(id)sender didCreatePaymentMethod:(BTPaymentMethod *)paymentMethod
//{
//    NSLog(@"BT Payment methord created");
//}

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
                
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                
                
                /* self.braintree = [Braintree braintreeWithClientToken:[dict valueForKey:@"client_token"]];
                 NSLog(@"dddd = %@",self.braintree);
                 
                 BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
                 // This is where you might want to customize your Drop in. (See below.)
                 
                 // The way you present your BTDropInViewController instance is up to you.
                 // In this example, we wrap it in a new, modally presented navigation controller:
                 dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                 target:self
                 action:@selector(userDidCancelPayment)];
                 dropInViewController.view.tintColor = _ADD_funds.backgroundColor;
                 
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
                
                @try
                {
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
                            //                               afterDelay:0.0];
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
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Conncetion failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}
-(void) dismiss_BT
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void) create_payment
{
    NSString  *temp_str;
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *naunce_STR = [[NSUserDefaults standardUserDefaults] valueForKey:@"NAUNCETOK"];
    
    if([amount_str isEqualToString:@""])
    {
        temp_str = _TXT_amount.text ;
    }
    else if(amount_str.length > 0)
    {
        _TXT_amount.text=@"";
        temp_str=[amount_str stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number_amount = [f numberFromString:temp_str];
    NSDictionary *parameters;
    
    parameters = @{ @"nonce":naunce_STR ,
                       @"transaction_type": @"add_funds",
                       @"price":number_amount  };

    
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
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        NSMutableDictionary *json_DATA_one = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"Data from Donate VC generate client TOK : \n%@",json_DATA_one);
        
        @try
        {
            NSString *STR_error = [json_DATA_one valueForKey:@"error"];
            if (STR_error)
            {
                [self sessionOUT];
            }
            else
            {
                NSString *str = [json_DATA_one valueForKey:@"status"];
                NSString *error = [json_DATA_one valueForKey:@"error"];
                if([str isEqualToString:@"Failure"])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA_one valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
                else if(error)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA_one valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
                else
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Funds added successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                }
            }
        }
        @catch (NSException *exception)
        {
            [self sessionOUT];
        }
    }
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}
#pragma Add_funds Tapped

-(void)add_funds_tapped
{
    NSString *temp_str = _TXT_amount.text;
    
//    NSLog(@"Amount Str = %@",amount_str);
    
    if (![amount_str isEqualToString:@""]) {
        VW_overlay.hidden=NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(get_client_TOKEN) withObject:activityIndicatorView afterDelay:0.01];
    }
    else if(![amount_str isEqualToString:@""]  && ![temp_str isEqualToString:@"0.00"])
    {
        
        // temp_str=amount_str;
        /* int i=[temp_str intValue];
         if(i < [[asc_denomarr valueForKeyPath:@"@max.intValue"] intValue])
         {
         _TXT_amount.placeholder=@"0.00";
         UIAlertController  *alertControllerAction = [UIAlertController alertControllerWithTitle:@"" message:@"Amount Should be Grater than Maximum." preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         
         //            [self dismissViewControllerAnimated:YES completion:nil];
         
         }];
         [alertControllerAction addAction:okaction];
         
         [self presentViewController:alertControllerAction animated:YES completion:nil];
         }
         else
         {*/
        
        VW_overlay.hidden=NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(get_client_TOKEN) withObject:activityIndicatorView afterDelay:0.01];
        
        //}
    }
    else if(amount_str.length == 0  &&  [_TXT_amount.text isEqualToString:@" 0.00"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Enter Any amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [_TXT_amount becomeFirstResponder];
    }
    else
    {
        VW_overlay.hidden=NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(get_client_TOKEN) withObject:activityIndicatorView afterDelay:0.01];
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
        
        //        NSLog(@" THe user data is :%@",[[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"]);
        //        [self performSegueWithIdentifier:@"accountstoeditprofileidentifier" sender:self];
//        [self myprofileapicalling];
    }
    else
    {
//        [activityIndicatorView stopAnimating];
//        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

//- (void)alertView:(UIAlertView *)alertView
//clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == [alertView firstOtherButtonIndex]){
//        
//        [self myaccount_API_calling];
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }
//}

#pragma mark - Tap Gesture
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [_TXT_amount resignFirstResponder];
    
        return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}
-(void) Tap_DTECt :(UITapGestureRecognizer *)sender
{
}
//-(void)denom_API
//{
//    
//    @try{
//        NSHTTPURLResponse *response = nil;
//        NSError *error;
//        NSString *urlGetuser =[NSString stringWithFormat:@"%@contributors/denominations",SERVER_URL];
//        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:urlProducts];
//        [request setHTTPMethod:@"GET"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
//        [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
//        [request setHTTPShouldHandleCookies:NO];
//        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//        if(aData)
//        {
//            NSMutableDictionary *json_DICTIn = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
//            NSLog(@"Denominations dictionary is:%@",json_DICTIn);
//            _denom_arr=[json_DICTIn valueForKey:@"denominations"];
//        }
//    }
//    @catch(NSException *exception)
//    {
//       
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[exception reason]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"" , nil];
//            [alert show];
//           }
//    
//        
//    
//
//    
//}

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
