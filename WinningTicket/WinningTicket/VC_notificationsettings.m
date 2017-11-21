//
//  VC_notificationsettings.m
//  WinningTicket
//
//  Created by Test User on 03/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_notificationsettings.h"
#import "Cell_notifications.h"
#import "Cell_headerSection.h"

@interface VC_notificationsettings ()
{
    NSArray *ARR_title,*ARR_promotion,*ARR_events,*ARR_actions;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *json_DATA;
    NSDictionary *post_data;
}
@end

@implementation VC_notificationsettings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_get_notification) withObject:activityIndicatorView afterDelay:0.01];
    
    
    [self setup_VIEW];
    
    
    _tbl_contents.estimatedSectionHeaderHeight = 40.0f;
    _tbl_contents.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tbl_contents.estimatedRowHeight = 10.0f;
    _tbl_contents.rowHeight = UITableViewAutomaticDimension;
    
//    [_tbl_contents reloadData];
//    [_tbl_contents sizeToFit];
    _tbl_contents.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

#pragma mark - view customisation
-(void) setup_VIEW
{
    ARR_title = [[NSArray alloc] initWithObjects:@"Winning Ticket Promotions",@"Events",@"Auctions", nil];
    ARR_promotion = [[NSArray alloc] initWithObjects:@"Send me Winning Ticket news and offers", nil];
    ARR_events = [[NSArray alloc] initWithObjects:@"Send me updates on upcoming events",@"Notify me 24 hours before an event", nil];
    ARR_actions = [[NSArray alloc] initWithObjects:@"Notify me before an event begins",@"Notify me when an auction I’m interested in is sold", nil];
}

#pragma mark - UITableview Datasource/Deligate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ARR_title count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [ARR_promotion count];
    }
    else if (section == 1)
    {
        return [ARR_events count];
    }
    else
    {
        return [ARR_actions count];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    
    
    
    label.backgroundColor = [UIColor colorWithRed:0.93 green:0.94 blue:0.96 alpha:1.0];
    
    label.text = [NSString stringWithFormat:@"    %@",[[ARR_title objectAtIndex:section] uppercaseString]];
    
    return label;*/
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    Cell_headerSection *cell = (Cell_headerSection *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_headerSection~iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_headerSection" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (section == 0) {
        cell.lbl_text.text = @"TEXT";
        cell.lbl_email.text = @"EMAIL";
        cell.lbl_push.text = @"PUSH";
    }
    else
    {
        cell.lbl_text.text = @"";
        cell.lbl_email.text = @"";
        cell.lbl_push.text = @"";
    }
    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        cell.lbl_title.font = [UIFont fontWithName:@"Gotham-Book" size:20.0];
//    }
//    else
//    {
//        cell.lbl_title.font = [UIFont fontWithName:@"Gotham-Book" size:15.0];
//    }
    
    cell.lbl_title.text = [NSString stringWithFormat:@"%@",[[ARR_title objectAtIndex:section] uppercaseString]];
    
    cell.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    CGRect screenBounds = [UIScreen mainScreen].bounds;
//    CGFloat width = screenBounds.size.width;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
//    view.backgroundColor = [UIColor clearColor];
//    
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    Cell_notifications *cell = (Cell_notifications *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_notifications~iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_notifications" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    NSString *icon_name;
    if (indexPath.section == 0) {
        icon_name = [NSString stringWithFormat:@"%@",[ARR_promotion objectAtIndex:indexPath.row]];
        
        BOOL state;
        NSString *rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"news_and_offers"] valueForKey:@"push"]];
        if ([rez isEqualToString:@"0"]) {
            state = NO;
        }
        else
        {
            state = YES;
        }
        [cell.SWICTCH_push setOn:state animated:YES];
        
        rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"news_and_offers"] valueForKey:@"text_message"]];
        if ([rez isEqualToString:@"0"]) {
            state = NO;
        }
        else
        {
            state = YES;
        }
        [cell.SWICTCH_text setOn:state animated:YES];
        
        rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"news_and_offers"] valueForKey:@"email"]];
        if ([rez isEqualToString:@"0"]) {
            state = NO;
        }
        else
        {
            state = YES;
        }
        [cell.SWICTCH_email setOn:state animated:YES];
    }
    else if (indexPath.section == 1)
    {
        icon_name = [NSString stringWithFormat:@"%@",[ARR_events objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                BOOL state;
                NSString *rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"upcoming_event"] valueForKey:@"push"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_push setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"upcoming_event"] valueForKey:@"text_message"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_text setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"upcoming_event"] valueForKey:@"email"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_email setOn:state animated:YES];
                break;
            }
                
            case 1:
            {
                BOOL state;
                NSString *rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"one_day_before"] valueForKey:@"push"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_push setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"one_day_before"] valueForKey:@"text_message"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_text setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"one_day_before"] valueForKey:@"email"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_email setOn:state animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
    else
    {
        icon_name = [NSString stringWithFormat:@"%@",[ARR_actions objectAtIndex:indexPath.row]];
        switch (indexPath.row) {
            case 0:
            {
                BOOL state;
                NSString *rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"before_an_event_begin"] valueForKey:@"push"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_push setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"before_an_event_begin"] valueForKey:@"text_message"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_text setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"before_an_event_begin"] valueForKey:@"email"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_email setOn:state animated:YES];
                break;
            }
                
            case 1:
            {
                BOOL state;
                NSString *rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"auction_item_sold"] valueForKey:@"push"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_push setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"auction_item_sold"] valueForKey:@"text_message"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_text setOn:state animated:YES];
                
                rez = [NSString stringWithFormat:@"%@",[[json_DATA valueForKey:@"auction_item_sold"] valueForKey:@"email"]];
                if ([rez isEqualToString:@"0"]) {
                    state = NO;
                }
                else
                {
                    state = YES;
                }
                [cell.SWICTCH_email setOn:state animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
    
    [cell.SWICTCH_push addTarget:self action:@selector(METH_PUSH:) forControlEvents:UIControlEventValueChanged];
    [cell.SWICTCH_email addTarget:self action:@selector(METH_EMAIL:) forControlEvents:UIControlEventValueChanged];
    [cell.SWICTCH_text addTarget:self action:@selector(METH_TXT:) forControlEvents:UIControlEventValueChanged];
    
    NSLog(@"icon name %@",icon_name);
    cell.lbl_title.text = icon_name;
    cell.lbl_title.numberOfLines = 0;
//    [cell.lbl_title sizeToFit];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
/*-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}*/

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *temp_DICN = [ARR_allevent objectAtIndex:indexPath.row];
    NSString *str; //= [NSString stringWithFormat:@"%@",[temp_DICN valueForKey:@"Event_Name"]];
    
    if (indexPath.section == 0) {
        str = [NSString stringWithFormat:@"%@",[ARR_promotion objectAtIndex:indexPath.row]];
    }
    else if (indexPath.section == 1)
    {
        str = [NSString stringWithFormat:@"%@",[ARR_events objectAtIndex:indexPath.row]];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@",[ARR_actions objectAtIndex:indexPath.row]];
    }
    
    CGSize labelWidth = CGSizeMake(_tbl_contents.frame.size.width - 16, CGFLOAT_MAX); // 300 is fixed width of label. You can change this value
    CGRect textRect;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        textRect = [str boundingRectWithSize:labelWidth options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:22.0]} context:nil];
    }
    else
    {
        textRect = [str boundingRectWithSize:labelWidth options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:17.0]} context:nil];
    }
    
    
    int calculatedHeight = textRect.size.height + 10;
    
    return calculatedHeight + 30;
}*/

#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) METH_PUSH :(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"true" : @"false";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tbl_contents];
    NSIndexPath *indexPath = [self.tbl_contents indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.section == 0) {
        post_data = @{@"notification_type":@"push",@"news_and_offers":rez};
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                post_data = @{@"notification_type":@"push",@"upcoming_event":rez};
                break;
                
            case 1:
                post_data = @{@"notification_type":@"push",@"one_day_before":rez};
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                post_data = @{@"notification_type":@"push",@"before_an_event_begin":rez};
                break;
                
            case 1:
                post_data = @{@"notification_type":@"push",@"auction_item_sold":rez};
                break;
                
            default:
                break;
        }
    }
    
//    [self API_notification_Upadte];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_notification_Upadte) withObject:activityIndicatorView afterDelay:0.01];
    
}
-(void) METH_EMAIL :(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"true" : @"false";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tbl_contents];
    NSIndexPath *indexPath = [self.tbl_contents indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.section == 0) {
        post_data = @{@"notification_type":@"email",@"news_and_offers":rez};
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                post_data = @{@"notification_type":@"email",@"upcoming_event":rez};
                break;
                
            case 1:
                post_data = @{@"notification_type":@"email",@"one_day_before":rez};
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                post_data = @{@"notification_type":@"email",@"before_an_event_begin":rez};
                break;
                
            case 1:
                post_data = @{@"notification_type":@"email",@"auction_item_sold":rez};
                break;
                
            default:
                break;
        }
    }
    
//    [self API_notification_Upadte];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_notification_Upadte) withObject:activityIndicatorView afterDelay:0.01];
}
-(void) METH_TXT :(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"true" : @"false";
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tbl_contents];
    NSIndexPath *indexPath = [self.tbl_contents indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.section == 0) {
        post_data = @{@"notification_type":@"text_message",@"news_and_offers":rez};
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
                post_data = @{@"notification_type":@"text_message",@"upcoming_event":rez};
                break;
                
            case 1:
                post_data = @{@"notification_type":@"text_message",@"one_day_before":rez};
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                post_data = @{@"notification_type":@"text_message",@"before_an_event_begin":rez};
                break;
                
            case 1:
                post_data = @{@"notification_type":@"text_message",@"auction_item_sold":rez};
                break;
                
            default:
                break;
        }
    }
    
//    [self API_notification_Upadte];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_notification_Upadte) withObject:activityIndicatorView afterDelay:0.01];
}


#pragma mark - API Integration
-(void) API_get_notification
{
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *url_STR = [NSString stringWithFormat:@"%@notification_settings/all_settings",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:url_STR];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"Json dictionary from get notification list %@",json_DATA);
        [_tbl_contents reloadData];
    }
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

-(void) API_notification_Upadte
{
    NSLog(@"Post contents update switch %@",post_data);
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:post_data options:NSASCIIStringEncoding error:&error];
    
    NSString *url_STR = [NSString stringWithFormat:@"%@notification_settings/update_setting",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:url_STR];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth_token"];
    [request setHTTPBody:postData];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        NSMutableDictionary *jsonResp = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        NSLog(@"Json dictionary from get notification update %@",jsonResp);
        [_tbl_contents reloadData];
    }
    
    [self API_get_notification];
}

@end
