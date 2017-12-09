//
//  VC_viewYourWinningTicket.m
//  WinningTicket
//
//  Created by Test User on 22/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_viewYourWinningTicket.h"
#import "cell_view_ticket1.h"
#import "cell_view_ticket2.h"
#import "Cell_view_ticket3.h"
#import "cell_view_tcket4.h"
#import "Collection_cell_ticketSponser.h"

#import "SDWebImage/UIImageView+WebCache.h"

@interface VC_viewYourWinningTicket ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSArray *ARR_sponser_USer;
    NSDictionary *DICTIN_ticket_amenities;
    NSArray *ARR_keys;
    NSString *STR_IMG_url,*STR_event_name;
}

@end

@implementation VC_viewYourWinningTicket

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   _lbl_noSponser.hidden = YES;
    [self.collection_sponser registerNib:[UINib nibWithNibName:@"Collection_cell_ticketSponser" bundle:nil]  forCellWithReuseIdentifier:@"courseceldentifier"];
   
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(get_TicketDetail) withObject:activityIndicatorView afterDelay:0.01];
    
    [self setup_VIEW];
}

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
       NSFontAttributeName:_lbl_navFont.font}];
    self.navigationItem.title = @"WINNING TICKET";
}
#pragma mark - Back Action
-(void) backAction
{
    NSLog(@"Back tapped");
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - API Ticket detail
-(void) get_TicketDetail
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSString *urlGetuser =[NSString stringWithFormat:@"%@events/winning_ticket",SERVER_URL];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *event_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"event_id"]];
    NSDictionary *parameters = @{ @"id":  event_id};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData) {
        NSMutableDictionary *jsonRESP = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The json response ticket detail %@",jsonRESP);
        
        @try {
            STR_IMG_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[jsonRESP valueForKey:@"avatar_url"]];
        } @catch (NSException *exception) {
            NSLog(@"Exception in image %@",exception);
        }
        
        @try {
            STR_event_name = [jsonRESP valueForKey:@"event_name"];
        } @catch (NSException *exception) {
            STR_event_name = @"Not Mentioned";
        }
        
        @try {
            ARR_sponser_USer = [jsonRESP valueForKey:@"sponsor_users"];
            if ([ARR_sponser_USer count] !=0) {
                _lbl_noSponser.hidden = YES;
            }
            else
            {
                _lbl_noSponser.hidden = NO;
                _collection_sponser.hidden = YES;
            }
            
        } @catch (NSException *exception) {
            NSLog(@"Exception sponser");
            _lbl_noSponser.hidden = NO;
        }
        
        @try {
            DICTIN_ticket_amenities = [jsonRESP valueForKey:@"ticket_amenities"];
            ARR_keys = [DICTIN_ticket_amenities allKeys];
        } @catch (NSException *exception) {
            NSLog(@"Exception in ticket amenities");
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    [_TBL_offers reloadData];
    [_collection_sponser reloadData];
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

#pragma mark - UITableview Datasource / Deligate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ARR_keys count] + 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        cell_view_ticket1 *cell = (cell_view_ticket1 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_ticket1~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_ticket1" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
        [cell.IMG_logo sd_setImageWithURL:[NSURL URLWithString:STR_IMG_url]
                             placeholderImage:[UIImage imageNamed:@"square-2"]];
        cell.lbl_event_name.text = [STR_event_name capitalizedString];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width, 0, 0);
        
        return cell;
    }
    else if(indexPath.row == 1)
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        cell_view_ticket2 *cell = (cell_view_ticket2 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_ticket2~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_ticket2" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width, 0, 0);
        
        return cell;
    }
    else if(indexPath.row == 2)
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        Cell_view_ticket3 *cell = (Cell_view_ticket3 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_view_ticket3~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"Cell_view_ticket3" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.separatorInset = UIEdgeInsetsMake(0, self.view.frame.size.width, 0, 0);
            
        return cell;
    }
    else if(indexPath.row == 3)
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        cell_view_tcket4 *cell = (cell_view_tcket4 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_tcket4~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_tcket4" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.lbl_offers.text = @"Virtual Gift Bag";
        
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        cell_view_tcket4 *cell = (cell_view_tcket4 *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_tcket4~iPad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"cell_view_tcket4" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSString *STR_text = [NSString stringWithFormat:@"%@ : %@",[[DICTIN_ticket_amenities valueForKey:[ARR_keys objectAtIndex:indexPath.row-4]] capitalizedString],[[ARR_keys objectAtIndex:indexPath.row-4] capitalizedString]];
        
        cell.lbl_offers.text = STR_text;
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 110;
    }
    else
    {
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - Uicollectionview Datasource / Deligate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    @try {
        return [ARR_sponser_USer count];
    } @catch (NSException *exception) {
        return 0;
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(97, 97);
}
- (Collection_cell_ticketSponser *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Collection_cell_ticketSponser *cell = (Collection_cell_ticketSponser*)[self.collection_sponser dequeueReusableCellWithReuseIdentifier:@"courseceldentifier" forIndexPath:indexPath];
    
    [cell.IMG_sponser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[[ARR_sponser_USer objectAtIndex:indexPath.row] valueForKey:@"company_logo_avatar"]]]
                     placeholderImage:[UIImage imageNamed:@"square-2"]];
    
    NSLog(@"Img url = %@",[NSString stringWithFormat:@"%@%@",IMAGE_URL,[[ARR_sponser_USer objectAtIndex:indexPath.row] valueForKey:@"company_logo_avatar"]]);
    
    return cell;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
