//
//  VC_notificationsettings.m
//  WinningTicket
//
//  Created by Test User on 03/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_notificationsettings.h"
#import "Cell_notifications.h"

@interface VC_notificationsettings ()
{
    NSArray *ARR_title,*ARR_promotion,*ARR_events,*ARR_actions;
}
@end

@implementation VC_notificationsettings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup_VIEW];
    
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
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        label.font = [UIFont fontWithName:@"Gotham-Book" size:22.0];
    }
    else
    {
        label.font = [UIFont fontWithName:@"Gotham-Book" size:17.0];
    }
    
    label.backgroundColor = [UIColor colorWithRed:0.93 green:0.94 blue:0.96 alpha:1.0];
    
    label.text = [NSString stringWithFormat:@"    %@",[[ARR_title objectAtIndex:section] uppercaseString]];
    
    return label;
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
        
    }
    else if (indexPath.section == 1)
    {
        icon_name = [NSString stringWithFormat:@"%@",[ARR_events objectAtIndex:indexPath.row]];
    }
    else
    {
        icon_name = [NSString stringWithFormat:@"%@",[ARR_actions objectAtIndex:indexPath.row]];
    }
    
    cell.lbl_title.text = icon_name;
    cell.lbl_title.numberOfLines = 0;
    [cell.lbl_title sizeToFit];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
}

#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
