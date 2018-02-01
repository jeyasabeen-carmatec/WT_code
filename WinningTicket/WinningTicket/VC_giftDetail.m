//
//  VC_giftDetail.m
//  WinningTicket
//
//  Created by Test User on 22/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_giftDetail.h"

#import "Cell_gift_header.h"
#import "cell_giftSeperater.h"
#import "cell_giftContents.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface VC_giftDetail ()

@end

@implementation VC_giftDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup_VIEW];
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
*/  //GIFTDET

#pragma mark - Uiview Customisation
-(void) setup_VIEW
{
    self.navigationItem.hidesBackButton = YES;
    
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
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton] animated:NO];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:_lbl_nav_title.font}];
    self.navigationItem.title = @"VIRTUAL GIFT BAG";
}

#pragma mark - Back Action
-(void) backAction
{
    NSLog(@"Back tapped");
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UItableview Datasource/Deligate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        Cell_gift_header *cell = (Cell_gift_header *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_gift_header~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_gift_header" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSError *error;
        NSDictionary *Dictin_contents = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"GIFTDET"] options:NSASCIIStringEncoding error:&error];
        
        NSString *STR_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[[Dictin_contents valueForKey:@"virtual_gift_bag_details"] valueForKey:@"image"]];
        [cell.IMG_giftIcon sd_setImageWithURL:[NSURL URLWithString:STR_url]
                             placeholderImage:[UIImage imageNamed:@"square-2"]];
        
        cell.lbl_giftName.text = [[[Dictin_contents valueForKey:@"virtual_gift_bag_details"] valueForKey:@"item_name"] capitalizedString];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        cell_giftSeperater *cell = (cell_giftSeperater *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_giftSeperater~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_giftSeperater" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        cell_giftContents *cell = (cell_giftContents *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_giftContents~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_giftContents" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSError *error;
        NSDictionary *Dictin_contents = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"GIFTDET"] options:NSASCIIStringEncoding error:&error];
        
        NSDictionary *temp_dictin = [Dictin_contents valueForKey:@"virtual_gift_bag_details"];
        
        NSString *STR_expire_STAT = [NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"offer_does_not_expire"]];
        
        if ([STR_expire_STAT isEqualToString:@"0"]) {

            NSString *date_STR = [self getLocalDateTimeFromUTC:[temp_dictin valueForKey:@"offer_expires_date"]];
            cell.lbl_date.text = date_STR;
            
            NSString *STR_directions;
            @try {
                STR_directions = [temp_dictin valueForKey:@"item_directions"];
            } @catch (NSException *exception) {
                STR_directions = @" ";
            }
            
           
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[STR_directions dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            NSMutableAttributedString *res = [attrStr mutableCopy];
            
            [res beginEditing];
            __block BOOL found = NO;
            [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    UIFont *oldFont = (UIFont *)value;
                    UIFont *newFont = [oldFont fontWithSize:oldFont.pointSize + 4];
                    [res removeAttribute:NSFontAttributeName range:range];
                    [res addAttribute:NSFontAttributeName value:newFont range:range];
                    found = YES;
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [res endEditing];
            cell.lbl_directions.attributedText = res;
            
//            cell.lbl_directions.text = STR_directions;
        }
        else
        {
            NSString *STR_expire_at = @"This offer does not expire";
            cell.lbl_date.text = STR_expire_at;
            
            NSString *STR_directions;
            @try {
                STR_directions = [temp_dictin valueForKey:@"item_directions"];
            } @catch (NSException *exception) {
                STR_directions = @" ";
            }
            
            
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[STR_directions dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            NSMutableAttributedString *res = [attrStr mutableCopy];
            
            [res beginEditing];
            __block BOOL found = NO;
            [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    UIFont *oldFont = (UIFont *)value;
                    UIFont *newFont = [oldFont fontWithSize:oldFont.pointSize + 4];
                    [res removeAttribute:NSFontAttributeName range:range];
                    [res addAttribute:NSFontAttributeName value:newFont range:range];
                    found = YES;
                }
            }];
            if (!found) {
                // No font was found - do something else?
            }
            [res endEditing];
            cell.lbl_directions.attributedText = res;
        }
        
        return cell;
    }
}


- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate
{
    //    NSLog(@"Date Input tbl %@",strDate);
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    //    NSLog(@"CurrentDate:%@", currentDate);
    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    [newFormat setDateFormat:@"MMMM dd, YYYY"];
    [newFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    return [NSString stringWithFormat:@"%@",[newFormat stringFromDate:currentDate]];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 10;
    }
    else
    {
        return UITableViewAutomaticDimension;
    }
}


@end
