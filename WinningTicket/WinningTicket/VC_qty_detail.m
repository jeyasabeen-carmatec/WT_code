//
//  VC_qty_detail.m
//  WinningTicket
//
//  Created by Test User on 19/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_qty_detail.h"
#import "purchase_Cell.h"
//#import "DejalActivityView.h"
//#import "DGActivityIndicatorView.h"
#import "ViewController.h"

@interface VC_qty_detail ()
{
    int t;
    NSMutableArray *userDetails;
    float VW_height,scrol_height,origin_Y;
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
//    UILabel *loadingLabel;
}

@end

@implementation VC_qty_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_View];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    
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
    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cross"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
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
    self.navigationItem.title = @"Add Recipients";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - button Selectors
-(void) backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) button_TAPPed
{
    NSLog(@"BTN checkout tapped Current values are %@",userDetails);
    int i;
    
    purchase_Cell *pu_cell = [[purchase_Cell alloc]init];
    for(i = 0; i < userDetails.count; i++)
        {
           NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
           dict = [userDetails objectAtIndex:i];
            
            NSString *email = [dict valueForKey:@"email"];
            NSString *fname = [dict valueForKey:@"first_name"];
            NSString *lname = [dict valueForKey:@"last_name"];
            
            if (fname.length < 2)
            {
                if([fname isEqual:@""])
                {
//                    break;
                }
                else
                {
                    NSLog(@"emailnull index %i",i);
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    NSLog(@"path  = %@",path);
                    pu_cell = [self.tbl_content cellForRowAtIndexPath:path];
                    [pu_cell.fname becomeFirstResponder];
                    [pu_cell.fname showError];
                    [pu_cell.fname showErrorWithText:@" First name minimum 2 characters"];
                    break;
                }
            }
            if (lname.length < 2)
            {
                if([lname isEqual:@""])
                {
//                    break;
                }
                else
                {
                    NSLog(@"first_namenull index %i",i);
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    NSLog(@"path  = %@",path);
                    pu_cell = [self.tbl_content cellForRowAtIndexPath:path];
                    [pu_cell.lname becomeFirstResponder];
                    [pu_cell.lname showError];
                    [pu_cell.lname showErrorWithText:@" Last name minimum 2 Character"];
                    break;
                }
            }
            
            if (email.length !=0) {
                if([email isEqual:@""])
                {
//                    break;
                }
                else
                {
                    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
                    if ([emailTest evaluateWithObject:email] == NO)
                    {
                        NSLog(@"last_namenull index %i",i);
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                        NSLog(@"path  = %@",path);
                        pu_cell = [self.tbl_content cellForRowAtIndexPath:path];
                        [pu_cell.email becomeFirstResponder];
                        [pu_cell.email showError];
                        [pu_cell.email showErrorWithText:@" Email is not valid"];
                        break;
                    }
                }
            }
            
            if (fname.length >= 2 && [email isEqual:@""])
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                NSLog(@"path  = %@",path);
                pu_cell = [self.tbl_content cellForRowAtIndexPath:path];
                [pu_cell.email becomeFirstResponder];
                [pu_cell.email showError];
                [pu_cell.email showErrorWithText:@" Please enter valid email address"];
                break;
            }
    }
    
    if (i == userDetails.count) {
//        [self qty_detailPage];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(qty_detailPage) withObject:activityIndicatorView afterDelay:0.01];
    }
    
//    [self myprofileapicalling];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(myprofileapicalling) withObject:activityIndicatorView afterDelay:0.01];
}

-(void) qty_detailPage
{
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
            NSError *err;
            NSHTTPURLResponse *response = nil;
            NSDictionary *parameters = @{ @"recipients": userDetails, @"order_item" : @{ @"id":[dict valueForKey:@"order_item_id"]}};
            NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
            NSString *urlGetuser = [NSString stringWithFormat:@"%@events/create_update_recipients",SERVER_URL];
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
                dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
                NSLog(@"Updated Status %@",dict);
                
                if ([[dict valueForKey:@"message"] isEqualToString:@"Recipient(s) created/updated successfully."]) {
                    [self performSegueWithIdentifier:@"qtydetailtoplaceorder" sender:self];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
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
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
}


#pragma mark - Uiview customisation
-(void) setup_View
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
    
    VW_height = _VW_main.frame.size.height;
    origin_Y = _VW_main.frame.origin.y;
    scrol_height = _scroll_TBL.frame.size.height;
    
    _scroll_TBL.delegate = self;
    
    
    NSError *error;
    NSMutableDictionary *dict1 = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    
    
    @try
    {
        NSString *STR_error = [dict1 valueForKey:@"error"];
        if (STR_error)
        {
            [self sessionOUT];
        }
        else
        {
            NSMutableDictionary *temp_dictin=[dict1 valueForKey:@"event"];
            
            NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"QUANTITY"] options:NSASCIIStringEncoding error:&error];
            
            _lbl_amount_des.text = [NSString stringWithFormat:@"$%.2f",[[dict1 valueForKey:@"price"] floatValue]];
            _lbl_sub_amount.text = [NSString stringWithFormat:@"$%.2f",[[dict1 valueForKey:@"price"] floatValue] * [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"QTY"]] intValue]];
            _lbl_total_amount.text = _lbl_sub_amount.text;
            
            
            self.lbl_name_ticket.text=@"Winning Ticket";
            int qtynum = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"QTY"]]intValue];
            self.lbl_qty.text=[NSString stringWithFormat:@"Qty:%d",qtynum];
            
            //    NSString *show = @"Winning Ticket";
            //    NSString *place = [NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"location"]];//@"Make A Wish Foundation of Central Florida’s 4th Annual Golf Event";
            //    if(!place)
            //    {
            //        place=@"Notmentioned";
            //    }
            //    else
            //    {
            //        place=@"Notmentioned";
            //
            //    }
            //    place = [place stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
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
            frame_NEW=_lbl_amount_des.frame;
            frame_NEW.origin.y=_lbl_des_cription.frame.origin.y;
            _lbl_amount_des.frame=frame_NEW;
            
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
            frame_NEW.size.height = _lbl_total.frame.origin.y + _lbl_total.frame.size.height + 15;
            _VW_main.frame = frame_NEW;
            
            [_scroll_TBL addSubview:_VW_main];
            
            frame_NEW = _tbl_content.frame;
            frame_NEW.origin.y = _VW_main.frame.origin.y + _VW_main.frame.size.height + 10;
            //    frame_NEW.size.height = [_tbl_content contentSize].height;
            _tbl_content.frame = frame_NEW;
            
            //    CGRect frame_NN = _tbl_content.frame;
            //    frame_NN.size.height = [_tbl_content contentSize].height;
            //    _tbl_content.frame = frame_NN;
            
            [_scroll_TBL addSubview:_tbl_content];
            
            //    NSError *error;
            //    NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"QUANTITY"] options:NSASCIIStringEncoding error:&error];
            
            NSLog(@"The value stored is %@",dict);
            t = [[dict valueForKey:@"quantity"] intValue];
            
            
            
            userDetails = [[NSMutableArray alloc] init];
            if (t-1 != 0)
            {
                for(int i=0; i < t-1; i++)
                {
                    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: @"", @"first_name", @"", @"last_name",@"", @"email", nil];
                    [userDetails addObject:userDictionary];
                }
            }
            
            [_tbl_content reloadData];
            _tbl_content.scrollEnabled = NO;
            [_BTN_checkout addTarget:self action:@selector(button_TAPPed) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
}

#pragma mark - Uitableview datasource/deligate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return t-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    purchase_Cell *pu_cell = (purchase_Cell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (pu_cell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"purchase_Cell~iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"purchase_Cell" owner:self options:nil];
        }
        pu_cell = [nib objectAtIndex:0];
    }
    
    pu_cell.VW_contentcell.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    pu_cell.VW_contentcell.layer.borderWidth = 1;
    pu_cell.VW_contentcell.layer.cornerRadius=10;
    pu_cell.VW_contentcell.layer.masksToBounds=YES;
    
    NSDictionary *temp_dictin = [userDetails objectAtIndex:indexPath.row];
    
    pu_cell.fname.layer.cornerRadius=5;
    pu_cell.fname.layer.borderWidth = 1;
    pu_cell.fname.tag = 1;
    pu_cell.fname.text = [temp_dictin valueForKey:@"first_name"];
    
    pu_cell.fname.delegate = self;
    [pu_cell.fname setTag:indexPath.row];
    [pu_cell.fname addTarget:self action:@selector(TXT_Fname:) forControlEvents:UIControlEventEditingChanged];
    
    pu_cell.lname.layer.cornerRadius=5;
    pu_cell.lname.layer.borderWidth = 1;
    pu_cell.lname.text = [temp_dictin valueForKey:@"last_name"];
    
    pu_cell.lname.delegate = self;
    [pu_cell.lname setTag:indexPath.row];
    [pu_cell.lname addTarget:self action:@selector(TXT_Lname:) forControlEvents:UIControlEventEditingChanged];
    
    pu_cell.email.layer.cornerRadius=5;
    pu_cell.email.layer.borderWidth = 1;
    pu_cell.email.text = [temp_dictin valueForKey:@"email"];
    
    pu_cell.email.delegate = self;
    [pu_cell.email setTag:indexPath.row];
    [pu_cell.email addTarget:self action:@selector(TXT_Email:) forControlEvents:UIControlEventEditingChanged];
    
    pu_cell.stat_lbl.text=[NSString stringWithFormat:@"Extra Ticket  %d",indexPath.row + 1];
    
    return pu_cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  @"Add Recipients";
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
//    // 4 * 69 (width of label) + 3 * 8 (distance between labels) = 300
//    UILabel *label1 = [[UILabel alloc] initWithFrame:headerView.frame];
//    label1.text = @"Add Recipients";
//
//    return headerView;
//}


//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *customSectionHeaderView;
//    UILabel *titleLabel;
//    
//    customSectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width, 24)];
//    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width, 24)];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    [titleLabel setTextColor:[UIColor blackColor]];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    titleLabel.text =  @"Add Recipients";
//    
//    [customSectionHeaderView addSubview:titleLabel];
//    
//    return customSectionHeaderView;
//}

#pragma mark - UITextfiel Deligate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    
    purchase_Cell *pu_cell;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        pu_cell = (purchase_Cell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        pu_cell = (purchase_Cell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    
    NSIndexPath *index_NN = [_tbl_content indexPathForCell:pu_cell];
    NSInteger row = index_NN.row;
    if (row == t - 2 || row == 0)
    {
        [UIView beginAnimations:nil context:NULL];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
//            float new_Y = _tbl_content.frame.origin.y;
//            if (new_Y < 0)
//            {
//                _scroll_TBL.frame = CGRectMake(_scroll_TBL.frame.origin.x, _scroll_TBL.frame.origin.y + 310,_scroll_TBL.frame.size.width,self.view.frame.size.height);
//            }
//            
//            _scroll_TBL.frame = CGRectMake(_scroll_TBL.frame.origin.x, _scroll_TBL.frame.origin.y - 310,_scroll_TBL.frame.size.width,self.view.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            // [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,- 310,self.view.frame.size.width,self.view.frame.size.height);
//            [UIView commitAnimations];
        }
        else
        {
//            float new_Y = _scroll_TBL.frame.origin.y;
//            if (new_Y < 0)
//            {
//                _scroll_TBL.frame = CGRectMake(_scroll_TBL.frame.origin.x, _scroll_TBL.frame.origin.y + 310,_scroll_TBL.frame.size.width,self.view.frame.size.height);
//            }
//            _scroll_TBL.frame = CGRectMake(_scroll_TBL.frame.origin.x, _scroll_TBL.frame.origin.y - 250,_tbl_content.frame.size.width,self.view.frame.size.height);
            [UIView beginAnimations:nil context:NULL];
            // [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,- 212,self.view.frame.size.width,self.view.frame.size.height);
//            [UIView commitAnimations];
        }
        [UIView commitAnimations];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
   /* purchase_Cell *pu_cell;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        pu_cell = (purchase_Cell *) textField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        pu_cell = (purchase_Cell *) textField.superview.superview.superview;
        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
    }
    
    NSIndexPath *index_NN = [_tbl_content indexPathForCell:pu_cell];
    NSInteger row = index_NN.row;
    if (row == t - 2 && row != 0)
    {
        _scroll_TBL.frame = main_Frame;
        [UIView commitAnimations];
    }*/
//    _scroll_TBL.frame = main_Frame;
//    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    // [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,00,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void) TXT_Fname : (UITextField *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    purchase_Cell *pu_cell;
    pu_cell = [self.tbl_content cellForRowAtIndexPath:buttonIndexPath];
    
    NSString *store_TXT = [NSString stringWithFormat:@"%@",pu_cell.fname.text];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[userDetails objectAtIndex:buttonIndexPath.row];
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setObject:store_TXT forKey:@"first_name"];
    [userDetails replaceObjectAtIndex:buttonIndexPath.row withObject:newDict];
    
    [newDict release];
}
-(void) TXT_Lname : (UITextField *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    purchase_Cell *pu_cell;
    pu_cell = [self.tbl_content cellForRowAtIndexPath:buttonIndexPath];
    
    NSString *store_TXT = [NSString stringWithFormat:@"%@",pu_cell.lname.text];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[userDetails objectAtIndex:buttonIndexPath.row];
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setObject:store_TXT forKey:@"last_name"];
    [userDetails replaceObjectAtIndex:buttonIndexPath.row withObject:newDict];
    
    [newDict release];
}
-(void) TXT_Email : (UITextField *) sender
{
    NSIndexPath *buttonIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    purchase_Cell *pu_cell;
    pu_cell = [self.tbl_content cellForRowAtIndexPath:buttonIndexPath];
    
    NSString *store_TXT = [NSString stringWithFormat:@"%@",pu_cell.email.text];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    NSDictionary *oldDict = (NSDictionary *)[userDetails objectAtIndex:buttonIndexPath.row];
    [newDict addEntriesFromDictionary:oldDict];
    [newDict setObject:store_TXT forKey:@"email"];
    [userDetails replaceObjectAtIndex:buttonIndexPath.row withObject:newDict];
    
    [newDict release];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_TBL layoutIfNeeded];
    
    [_tbl_content layoutIfNeeded];
    
    CGRect frame_NN = _tbl_content.frame;
    frame_NN.size.height = [_tbl_content contentSize].height;
    _tbl_content.frame = frame_NN;
    
//    main_Frame = _scroll_TBL.frame;
    
    _scroll_TBL.contentSize = CGSizeMake(_scroll_TBL.frame.size.width, _VW_main.frame.size.height + 10 + [_tbl_content contentSize].height + 10);
    
//    [self.scroll_TBL setContentInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
//    [self.scroll_TBL scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
//    
//    float headerImageYOffset = origin_Y;
//    CGRect headerImageFrame = _VW_main.frame;
//    headerImageFrame.origin.y = headerImageYOffset;
    
//    [self.scroll_TBL setContentInset:UIEdgeInsetsMake(self.VW_main.bounds.size.height, 0.f, 0.f, 0.f)];
//    [self.scroll_TBL scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
//    float headerImageYOffset = self.VW_main.bounds.size.height - self.scroll_TBL.bounds.size.height;
//    CGRect headerImageFrame = _VW_main.frame;
//    headerImageFrame.origin.y = headerImageYOffset;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat scrollOffset = -scrollView.contentOffset.y;
//    CGFloat yPos = scrollOffset -_VW_main.bounds.size.height;
//    _VW_main.frame = CGRectMake(0, yPos, _VW_main.frame.size.width, _VW_main.frame.size.height);
//    float alpha=1.0-(-yPos/ _VW_main.frame.size.height);
//    _lbl_total.alpha=alpha;
//    _lbl_total_amount.alpha=alpha;
//    float fontSize=24-(-yPos/20);
//    _lbl_total.font=[UIFont systemFontOfSize:fontSize];
//    _lbl_total_amount.font=[UIFont systemFontOfSize:fontSize];
    
    CGRect frame = _VW_main.frame;
    frame.size.height = 0;
    _VW_main.frame = frame;
}

-(void)myprofileapicalling
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@view_profile",SERVER_USR];
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
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;

        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        NSLog(@" THe user data is :%@",[[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"User_data"]);
//        [self performSegueWithIdentifier:@"accountstoeditprofileidentifier" sender:self];
        
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

- (void) dealloc
{
//    [_tbl_content release];
    [self.tbl_content setDelegate:nil];
    [self.tbl_content setDataSource:nil];
    [super dealloc];
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
