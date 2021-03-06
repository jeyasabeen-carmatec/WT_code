//
//  VC_item_deatail.m
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_item_deatail.h"
#import "similar_collectioncell.h"
#import "TAExampleDotView.h"
#import "TAPageControl.h"
#import "ViewController.h"
#import "cell_auction_item_detail.h"

#import "currentDATE.h"

#import <QuartzCore/CAAnimation.h>

#pragma mark - Image Cache
#import "SDWebImage/UIImageView+WebCache.h"

@interface VC_item_deatail () <UIScrollViewDelegate, TAPageControlDelegate, UITextFieldDelegate>
{
    UIAlertController * alertController;
    NSString *alert_TXT_price;
    UITextField *amount_field;
    NSMutableArray *similar_ARR;
    UILabel *LBL_stat;
}

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
//@property (strong, nonatomic) IBOutletCollection(UIScrollView) NSArray *scrollViews;

@property (weak, nonatomic) IBOutlet TAPageControl *customStoryboardPageControl;

@property (strong, nonatomic) NSMutableArray *imagesData;


@end

@implementation VC_item_deatail
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *jsonReponse;
}

//@synthesize scrollView,pageControl;

- (void)viewDidLoad
{
    [_BTN_back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"FIRST" forKey:@"Initial_STAT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:_lbl_font.font}];
    self.navigationItem.title = @"ITEM";
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"50"] forState:UIControlStateNormal];
    //    button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    //    [button setTitle:@"Settings" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(more_ACTION)forControlEvents:UIControlEventTouchUpInside];
    //    [button sizeToFit];
    CGRect btnframe = CGRectMake(0, 0, 18, 18);
    button.frame = btnframe;
    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, anotherButton ] animated:NO];
    
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height <= 480)
        {
            // iPhone Classic
            negativeSpacer1.width = 0;
        }
        else if(result.height <= 568)
        {
            // iPhone 5
            negativeSpacer1.width = -6;
        }
        else
        {
            negativeSpacer1.width = -10;
        }
    }
    else
    {
        negativeSpacer1.width = -6;
    }
    
    [self.navigationItem setRightBarButtonItems:@[negativeSpacer1,anotherButton1]animated:NO];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self add_overlay];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(GETAuction_Item_details) withObject:activityIndicatorView afterDelay:0.01];
    //    [_collection_similar_item reloadData];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.collection_IMG registerNib:[UINib nibWithNibName:@"cell_auction_item_detail~IPad" bundle:nil]  forCellWithReuseIdentifier:@"item_detail_identifier"];
    }
    else
    {
        [self.collection_IMG registerNib:[UINib nibWithNibName:@"cell_auction_item_detail" bundle:nil]  forCellWithReuseIdentifier:@"item_detail_identifier"];
    }
    
    LBL_stat = [[UILabel alloc]init];
    
    
    
}

-(void) add_overlay
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidLayoutSubviews
{
    //    float heiht = _scrollView1.frame.size.height;
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _VW_contents.frame.size.height);
    //    for (UIScrollView *scrollView in self.scrollViews) {
    //        _scrollView1.contentSize = CGSizeMake(CGRectGetWidth(_scrollView1.frame) * self.imagesData.count, heiht);
    //    }
    
}
#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    //
    //    if (scrollView == _collection_IMG) {
    //        self.customStoryboardPageControl.currentPage = _scrollView1;
    //        _lbl_count.text = [NSString stringWithFormat:@"%lu of %lu",(long)self.customStoryboardPageControl.currentPage + 1,(unsigned long)_imagesData.count];
    //
    //    }
    //    NSLog(@"scrollview frame:%@",NSStringFromCGRect(_scrollView1.frame));
}

#pragma mark - Utils
/*- (void)setupScrollViewImages
 {
 float heiht = _lbl_itemNAME.frame.origin.y - 50;
 //for (UIScrollView *scrollView in self.scrollViews) {
 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
 [self.imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView1.frame) * idx, 0, [UIScreen mainScreen].bounds.size.width, heiht)];
 //                imageView.contentMode = UIViewContentModeScaleAspectFill;
 //                imageView.image = [UIImage imageNamed:imageName];
 imageView.contentMode = UIViewContentModeScaleAspectFit;
 [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]
 placeholderImage:[UIImage imageNamed:@"Logo_WT.png"]];
 [_scrollView1 addSubview:imageView];
 }];
 
 }
 else
 {
 [self.imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView1.frame) * idx, 0, [UIScreen mainScreen].bounds.size.width, heiht)];
 //                        imageView.contentMode = UIViewContentModeScaleAspectFill;
 //                        imageView.image = [UIImage imageNamed:imageName];
 imageView.contentMode = UIViewContentModeScaleAspectFit;
 [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]
 placeholderImage:[UIImage imageNamed:@"Logo_WT.png"]];
 [_scrollView1 addSubview:imageView];
 }];
 }
 // }
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    if (!pageControlBeingUsed) {
//        // Switch the indicator when more than 50% of the previous/next page is visible
//        CGFloat pageWidth = self.scrollView.frame.size.width;
//        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//        self.pageControl.currentPage = page;
//
//        _lbl_count.text = [NSString stringWithFormat:@"%lu of %lu",(long)self.pageControl.currentPage + 1,(unsigned long)self.pageControl.numberOfPages];
//
////        [self changePage];
//
////        CGRect frame;
////        frame.origin.x = self.scrollView.frame.size.width * page;
////        frame.origin.y = 0;
////        frame.size = self.scrollView.frame.size;
////        [self.scrollView scrollRectToVisible:frame animated:YES];
//
//    }
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    pageControlBeingUsed = NO;
//}
//
/*- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
 //    pageControlBeingUsed = NO;
 if(scrollView == _collection_IMG)
 {
 for (cell_auction_item_detail *cell in [self.collection_IMG visibleCells]) {
 NSIndexPath *indexPath = [self.collection_IMG indexPathForCell:cell];
 NSLog(@"Final index %ld",(long)indexPath.row);
 }
 }
 }*/

#pragma mark - UIView Customisation
-(void) setup_VIEW
{
    [self setup_Values];
    [self setup_Values];
}
//- (void)viewDidUnload {
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//    self.scrollView = nil;
//    self.pageControl = nil;
//}

-(void) setup_Values
{
    
    
    NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
    
    similar_ARR = [[NSMutableArray alloc]init];
    similar_ARR = [jsonReponse valueForKey:@"similar_items"];
    
    //    NSString *STR_titl_iten_des = @"Item Description";
    NSString *STR_descrip_detail = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"description"]];
    
    self.lbl_item_descrip.text = STR_descrip_detail;
    CGRect txt_frame = _lbl_item_descrip.frame;
    txt_frame.size.width = _scroll_contents.frame.size.width - 11;
    txt_frame.size.height = _lbl_item_descrip.contentSize.height;
    _lbl_item_descrip.frame = txt_frame;
    
    
    _lbl_item_descrip.scrollEnabled = NO;
    
    [_lbl_item_descrip sizeToFit];
    //    [_lbl_item_descrip setNeedsDisplay];
    
    NSArray *auction_images = [auction_item valueForKey:@"auction_item_images"];
    NSMutableArray *temp_arr = [[NSMutableArray alloc]init];
    NSString *STR_image_url;
    
    NSString *id = [auction_item valueForKey:@"id"];
    [[NSUserDefaults standardUserDefaults] setValue:id forKey:@"auction_item_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (int i = 0; i < [auction_images count]; i++) {
        NSDictionary *temp_dictin = [auction_images objectAtIndex:i];
        NSString *STR_img = [temp_dictin valueForKey:@"image_url"];
        STR_image_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,STR_img];
        [temp_arr addObject:STR_image_url];
    }
    
    //[_imagesData removeAllObjects];
    self.imagesData = [temp_arr copy];
    [self.customStoryboardPageControl setNumberOfPages:[temp_arr count]]; //.numberOfPages = [temp_arr count];
    [_collection_IMG reloadData];
    
    _customStoryboardPageControl.center = _collection_IMG.center;
    
    NSLog(@"the collection view frame:%@",NSStringFromCGRect(_collection_IMG.frame));
    
    CGRect frame_page = _customStoryboardPageControl.frame;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        frame_page.origin.y = _collection_IMG.frame.origin.y + _collection_IMG.frame.size.height - 100;
    }
    else
    {
        frame_page.origin.y = _lbl_itemNAME.frame.origin.y - 50;
    }
    
    _customStoryboardPageControl.frame = frame_page;
    
    NSString *STR_bidSTAT = [[NSUserDefaults standardUserDefaults] valueForKey:@"STR_bidSTAT"];
    NSString *STR_event_name = [auction_item valueForKey:@"name"];
    NSString *winner_status = [NSString stringWithFormat:@"%@",[jsonReponse valueForKey:@"winner_status"]];
    NSString *pay_status = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"payment_status"]];
    //  NSString *stat = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"is_expired?"]];
    int count;
    @try
    {
        count = [[auction_item valueForKey:@"bid_count"] intValue];
    }
    @catch(NSException *exception)
    {
        count = 0;
    }
    
    NSString *STR_price;
    //    NSString *STR_bids;
    NSString *text;
    NSString *STR_watche;
    NSString *STR_Bidcc;
    
    if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
        STR_price = [NSString stringWithFormat:@"$%.2f",[[auction_item valueForKey:@"starting_bid"] floatValue]];//@"US $59.99";
        text = [NSString stringWithFormat:@"%@\n%@",STR_event_name,STR_price];
    }
    else if ([STR_bidSTAT isEqualToString:@"Current Bid"])
    {
        @try
        {
            NSString *STR_bid = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"current_bid_amount"]];
            if ([STR_bid isEqualToString:@"<null>"])
            {
                STR_price = [NSString stringWithFormat:@"$%.2f",[[auction_item valueForKey:@"starting_bid"] floatValue]];
            }
            else
            {
                STR_price = [NSString stringWithFormat:@"$%.2f",[[auction_item valueForKey:@"current_bid_amount"] floatValue]];
            }
            
            if ([[auction_item valueForKey:@"watchers_count"] doubleValue] == 0) {
                STR_watche = @"0 ";
            }
            else if ([[auction_item valueForKey:@"watchers_count"] doubleValue] < 2) {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            else
            {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] == 0) {
                STR_Bidcc = @"   NO BIDS   ";
            }
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] < 2) {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BID   ",[auction_item valueForKey:@"bid_count"]];//@"BID";
            }
            else
            {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BIDS   ",[auction_item valueForKey:@"bid_count"]];//@"BIDS";
            }
            
            //            STR_bids = [NSString stringWithFormat:@"%@ %@ | %@ %@",[auction_item valueForKey:@"bid_count"],STR_Bidcc,[auction_item valueForKey:@"watchers_count"],STR_watche];
            
        }
        @catch (NSException *exception) {
            STR_price = [NSString stringWithFormat:@"$%.2f",[[auction_item valueForKey:@"starting_bid"] floatValue]];//@"US $59.99";
            
            
            if ([[auction_item valueForKey:@"watchers_count"] doubleValue] == 0) {
                STR_watche = @"0 ";
            }
            else if ([[auction_item valueForKey:@"watchers_count"] doubleValue] < 2) {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            else
            {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] == 0) {
                STR_Bidcc = @"   NO BIDS   ";
            }
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] < 2) {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BID   ",[auction_item valueForKey:@"bid_count"]];//@"BID";
            }
            else
            {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BIDS   ",[auction_item valueForKey:@"bid_count"]];//@"BIDS";
            }
            
            //            STR_bids = [NSString stringWithFormat:@"%@ %@ | %@ %@",[auction_item valueForKey:@"bid_count"],STR_Bidcc,[auction_item valueForKey:@"watchers_count"],STR_watche];
        }
        text = [NSString stringWithFormat:@"%@\n%@ %@\n%@",STR_event_name,STR_price,STR_Bidcc,STR_watche];
    }
    else
    {
        /*User won the auction*/
        @try
        {
            _lbl_CountDown.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
            STR_price = [NSString stringWithFormat:@"$%.2f",[[auction_item valueForKey:@"current_bid_amount"] floatValue]];
            
            if ([[auction_item valueForKey:@"watchers_count"] doubleValue] == 0) {
                STR_watche = @"0 ";
            }
            else if ([[auction_item valueForKey:@"watchers_count"] doubleValue] < 2) {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            else
            {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] == 0) {
                STR_Bidcc = @"   NO BIDS   ";
            }
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] < 2) {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BID   ",[auction_item valueForKey:@"bid_count"]];//@"BID";
            }
            else
            {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BIDS   ",[auction_item valueForKey:@"bid_count"]];//@"BIDS";
            }
            
            //            STR_bids = [NSString stringWithFormat:@"%@ %@ | %@ %@",[auction_item valueForKey:@"bid_count"],STR_Bidcc,[auction_item valueForKey:@"watchers_count"],STR_watche];
            
            if([winner_status isEqualToString:@"1"])
            {
                if([pay_status isEqualToString:@"not_paid"] )
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"Congrulations! You won this item. Pay $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                    
                }
                else  if([pay_status isEqualToString:@"paid"])
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"Thanks for buying this item."];
                    _lbl_CountDown.textColor = [UIColor colorWithRed:0.00 green:0.37 blue:0.05 alpha:1.0];
                }
            }
            else  if([winner_status isEqualToString:@"0"] )
            {
                if([pay_status isEqualToString:@"not_paid"] )
                {
                    if(count > 0)
                    {
                        _lbl_CountDown.text = [NSString stringWithFormat:@"Bidding Closed. Final Bid: $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                        
                    }
                    else
                    {
                        _lbl_CountDown.text = [NSString stringWithFormat:@"No one bidded for this Item"];
                        
                    }
                    _lbl_CountDown.textColor = [UIColor grayColor];
                }
                else  if([pay_status isEqualToString:@"paid"])
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"Sold out. Final Bid: $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                    _lbl_CountDown.textColor = [UIColor redColor];
                    
                }
                else
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"No one bidded for this Item"];
                }
            }
            
            _lbl_CountDown.layer.borderWidth = 1.0f;
            _lbl_CountDown.layer.borderColor = [UIColor blackColor].CGColor;
            self.lbl_CountDown.numberOfLines = 0;
            [self.lbl_CountDown sizeToFit];
        }
        @catch (NSException *exception)
        {
            _lbl_CountDown.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
            STR_price = [NSString stringWithFormat:@"$%.2f",[[auction_item valueForKey:@"starting_bid"] floatValue]];
            if ([[auction_item valueForKey:@"watchers_count"] doubleValue] == 0) {
                STR_watche = @"0 ";
            }
            else if ([[auction_item valueForKey:@"watchers_count"] doubleValue] < 2) {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            else
            {
                STR_watche = [NSString stringWithFormat:@"%@ ",[auction_item valueForKey:@"watchers_count"]];
            }
            
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] == 0) {
                STR_Bidcc = @"   NO BIDS   ";
            }
            if ([[auction_item valueForKey:@"bid_count"] doubleValue] < 2) {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BID   ",[auction_item valueForKey:@"bid_count"]];//@"BID";
            }
            else
            {
                STR_Bidcc = [NSString stringWithFormat:@"   %@ BIDS   ",[auction_item valueForKey:@"bid_count"]];//@"BIDS";
            }
            
            //            STR_bids = [NSString stringWithFormat:@"%@ %@ | %@ %@",[auction_item valueForKey:@"bid_count"],STR_Bidcc,[auction_item valueForKey:@"watchers_count"],STR_watche];
            if([winner_status isEqualToString:@"1"])
            {
                if([pay_status isEqualToString:@"not_paid"] )
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"Congrulations! You won this Item. Pay $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                }
                else  if([pay_status isEqualToString:@"paid"])
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"Thanks for buying this Item."];
                    _lbl_CountDown.textColor = [UIColor colorWithRed:0.00 green:0.37 blue:0.05 alpha:1.0];
                }
            }
            else  if([winner_status isEqualToString:@"0"] )
            {
                if([pay_status isEqualToString:@"not_paid"] )
                {
                    if(count > 0)
                    {
                        _lbl_CountDown.text = [NSString stringWithFormat:@"Bidding Closed. Final Bid: $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                    }
                    else
                    {
                        _lbl_CountDown.text = [NSString stringWithFormat:@"No one bidded for this Item"];
                    }
                    _lbl_CountDown.textColor = [UIColor grayColor];
                }
                else  if([pay_status isEqualToString:@"paid"])
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"Sold out. Final Bid: $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                    _lbl_CountDown.textColor = [UIColor redColor];
                }
                else
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"No one bidded for this Item"];
                }
            }
            _lbl_CountDown.layer.borderWidth = 1.0f;
            _lbl_CountDown.layer.borderColor = [UIColor blackColor].CGColor;
            self.lbl_CountDown.numberOfLines = 0;
            [self.lbl_CountDown sizeToFit];
        }
        text = [NSString stringWithFormat:@"%@\n%@ %@\n%@",STR_event_name,STR_price,STR_Bidcc,STR_watche];
    }
    if(_imagesData.count == 0)
    {
        _lbl_count.text = [NSString stringWithFormat:@"0 of %lu",(unsigned long)_imagesData.count];
        
    }
    else{
        _lbl_count.text = [NSString stringWithFormat:@"1 of %lu",(unsigned long)_imagesData.count];
        
    }
    
    //    self.lbl_itemNAME.text = @"";
    
    
    for (UIView *view_T in [_lbl_itemNAME subviews]) {
        if (view_T.tag == 1) {
            [view_T removeFromSuperview];
        }
    }
    
    if ([self.lbl_itemNAME respondsToSelector:@selector(setAttributedText:)]) {
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:21.0];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.paragraphSpacing = 0.25 * font.lineHeight;
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSFontAttributeName: [UIFont fontWithName:@"GothamBook" size:17.0]
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        NSRange ename = [text rangeOfString:STR_event_name];
        NSRange cmp = [text rangeOfString:STR_price];
        
        NSRange RAN_Bids;
        NSRange RAN_wat;
        if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
        }
        else
        {
            RAN_Bids = [text rangeOfString:STR_Bidcc];
            RAN_wat = [text rangeOfString:STR_watche];
        }
        
        
        
        
        //        UIImage *image = [UIImage imageNamed:@"Untitled_1"];
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            CGRect codeRect = [self frameOfTextRange:RAN_Bids];
            codeRect.origin.y = codeRect.origin.y + 3;
            codeRect.size.height = codeRect.size.height - 3;
            UIView *highlightView = [[UIView alloc] initWithFrame:codeRect];
            highlightView.layer.cornerRadius = 4;
            highlightView.backgroundColor = [UIColor blackColor];
            highlightView.tag = 1;
            [_lbl_itemNAME insertSubview:highlightView atIndex:0];
            
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:19.0]}
                                    range:ename];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21.0]}
                                    range:cmp];
            if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:_lbl_font_small.font,NSForegroundColorAttributeName:[UIColor whiteColor]}
                                        range:RAN_Bids];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:14.0]}
                                        range:RAN_wat];
            }
            
        }
        else
        {
            CGRect codeRect = [self frameOfTextRange:RAN_Bids];
            codeRect.origin.y = codeRect.origin.y + 3;
            codeRect.size.height = codeRect.size.height - 3;
            UIView *highlightView = [[UIView alloc] initWithFrame:codeRect];
            highlightView.layer.cornerRadius = 4;
            highlightView.backgroundColor = [UIColor blackColor];
            highlightView.tag = 1;
            [_lbl_itemNAME insertSubview:highlightView atIndex:0];
            
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:19.0]}
                                    range:ename];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21.0]}
                                    range:cmp];
            if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:_lbl_font_small.font,NSForegroundColorAttributeName:[UIColor whiteColor]}
                                        range:RAN_Bids];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:14.0]}
                                        range:RAN_wat];
            }
            
        }
        
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:cmp];
        paragraphStyle.paragraphSpacing = 0.0f;
        if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
        }
        else
        {
            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:RAN_Bids];
        }
        
        
        self.lbl_itemNAME.attributedText = attributedText;
    }
    else
    {
        self.lbl_itemNAME.text = text;
    }
    
    CGRect txt_frame1 = _lbl_itemNAME.frame;
    txt_frame1.origin.x = _lbl_item_descrip.frame.origin.x;
    txt_frame1.size.width = self.view.frame.size.width - _lbl_item_descrip.frame.origin.x - 5;
    txt_frame1.size.height = _lbl_itemNAME.contentSize.height;
    _lbl_itemNAME.frame = txt_frame1;
    
    //    _lbl_itemNAME.scrollEnabled = NO;
    
    // self.lbl_itemNAME.numberOfLines = 0;
    //    [self.lbl_itemNAME sizeToFit];
    //    self.lbl_CountDown.numberOfLines = 0;
    //    [self.lbl_CountDown sizeToFit];
    
    
    
    NSString *user_watching_status = [NSString stringWithFormat:@"%@",[jsonReponse valueForKey:@"user_watching_status"]];
    if ([user_watching_status isEqualToString:@"1"]) {
        [_BTN_watech setTitle:@"WATCHING" forState:UIControlStateNormal];
    }
    else
    {
        [_BTN_watech setTitle:@"WATCH" forState:UIControlStateNormal];
    }
    
    
    NSString *STR_Expired = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"is_expired?"]];
    NSString *STR_live = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"is_live?"]];
    
    if ([STR_live isEqualToString:@"0"] && [STR_Expired isEqualToString:@"0"]) {
        [[NSUserDefaults standardUserDefaults] setValue:[auction_item valueForKey:@"event_start_date"] forKey:@"bid_date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        golfTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target: self selector: @selector(count_downTimer) userInfo: nil repeats: YES];
    }
    else if ([STR_live isEqualToString:@"1"])
    {
        _BTN_place_BID.hidden = NO;
        [_BTN_place_BID setTitle:@"PLACE BID" forState:UIControlStateNormal];
        [_BTN_place_BID addTarget:self action:@selector(place_BID_VW) forControlEvents:UIControlEventTouchUpInside];
        [[NSUserDefaults standardUserDefaults] setValue:[auction_item valueForKey:@"event_end_date"] forKey:@"bid_date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        golfTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target: self selector: @selector(count_downTimer) userInfo: nil repeats: YES];
    }
    else
    {
        _lbl_CountDown.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        
        
        if([winner_status isEqualToString:@"1"])
        {
            if([pay_status isEqualToString:@"not_paid"] )
            {
                _lbl_CountDown.text = [NSString stringWithFormat:@"Congrulations! You won this Item. Pay $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                
            }
            else  if([pay_status isEqualToString:@"paid"])
            {
                _lbl_CountDown.text = [NSString stringWithFormat:@"Thanks for buying this item."];
                _lbl_CountDown.textColor = [UIColor colorWithRed:0.00 green:0.37 blue:0.05 alpha:1.0];
            }
        }
        else  if([winner_status isEqualToString:@"0"] )
        {
            if([pay_status isEqualToString:@"not_paid"] )
            {
                if(count > 0)
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"Bidding Closed. Final Bid: $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                }
                else
                {
                    _lbl_CountDown.text = [NSString stringWithFormat:@"No one bidded for this Item"];
                }
                
                _lbl_CountDown.textColor = [UIColor grayColor];
            }
            else  if([pay_status isEqualToString:@"paid"])
            {
                _lbl_CountDown.text = [NSString stringWithFormat:@"Sold out. Final Bid: $%.2f",[[auction_item valueForKey:@"current_bid_amount"]floatValue]];
                _lbl_CountDown.textColor = [UIColor redColor];
            }
            
            else
            {
                _lbl_CountDown.text = [NSString stringWithFormat:@"No one bidded for this Item"];
            }
        }
        
        _lbl_CountDown.layer.borderWidth = 1.0f;
        _lbl_CountDown.layer.borderColor = [UIColor blackColor].CGColor;
        self.lbl_CountDown.numberOfLines = 0;
        [self.lbl_CountDown sizeToFit];
    }
    
    //    if ([STR_bidSTAT isEqualToString:@"Starting Bid"])
    //    {
    //
    //
    //    }
    //    else if ([STR_bidSTAT isEqualToString:@"Current Bid"])
    //    {
    //
    //    }
    //    else
    //    {
    //
    //
    //    }
    
    
    if ([winner_status isEqualToString:@"1"])
    {
        [_BTN_place_BID setTitle:@"CHECKOUT" forState:UIControlStateNormal];
        [_BTN_place_BID addTarget:self action:@selector(checkout_API) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString *Initial_STAT = [[NSUserDefaults standardUserDefaults] valueForKey:@"Initial_STAT"];
    if (Initial_STAT) {
        //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Initial_STAT"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _lbl_count.layer.cornerRadius = 5.0f;
        _lbl_count.layer.masksToBounds = YES;
        _lbl_count.layer.backgroundColor = [UIColor whiteColor].CGColor;
        CGRect new_frame;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            
            new_frame=self.collection_IMG.frame;
            new_frame.origin.y =0 ;   // _nav_Bar.frame.origin.y + _nav_Bar.frame.size.height;
            _collection_IMG.frame=new_frame;
        }
        else
        {
            
            new_frame=self.collection_IMG.frame;
            new_frame.origin.y = 0;
            _collection_IMG.frame=new_frame;
        }
        
        
        
        new_frame=self.lbl_itemNAME.frame;
        new_frame.origin.y = self.collection_IMG.frame.origin.y + self.collection_IMG.frame.size.height + 10;
        new_frame.size.width = _VW_line1.frame.size.width - 13;
        
        _lbl_itemNAME.frame=new_frame;
        
        //        self.lbl_CountDown.numberOfLines = 0;
        //        [self.lbl_CountDown sizeToFit];
        if ([STR_bidSTAT isEqualToString:@"Starting Bid"] || [STR_bidSTAT isEqualToString:@"Current Bid"])
        {
            new_frame = _lbl_CountDown.frame;
            new_frame.origin.y = _lbl_itemNAME.frame.origin.y + _lbl_itemNAME.frame.size.height - 3;
            _lbl_CountDown.frame = new_frame;
            _lbl_CountDown.textAlignment = NSTextAlignmentLeft;
            
        }
        else
        {
            new_frame = _lbl_CountDown.frame;
            new_frame.origin.y = _lbl_itemNAME.frame.origin.y + _lbl_itemNAME.frame.size.height + 5;
            new_frame.size.height = _BTN_place_BID.frame.size.height;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                new_frame.size.width = _VW_line1.frame.size.width - 23;
            }
            else
            {
                new_frame.size.width = _VW_line1.frame.size.width - 13;
            }
            _lbl_CountDown.frame = new_frame;
            _lbl_CountDown.textAlignment = NSTextAlignmentCenter;
        }
        
        
        new_frame = _BTN_place_BID.frame;
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 15;
        }
        else
        {
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 5;
        }
        _BTN_place_BID.frame = new_frame;
        
        new_frame = _BTN_watech.frame;
        new_frame.origin.y = _BTN_place_BID.frame.origin.y + _BTN_place_BID.frame.size.height + 12;
        
        
        _BTN_watech.frame = new_frame;
        //        _BTN_watech.layer.borderWidth = 2.0f;
        //        _BTN_watech.layer.borderColor = [UIColor blackColor].CGColor;
        [_BTN_watech addTarget:self action:@selector(showActionSHEET) forControlEvents:UIControlEventTouchUpInside];
        
        new_frame = _VW_line1.frame;
        
        if ([STR_live isEqualToString:@"0"] && [STR_Expired isEqualToString:@"0"])//([STR_bidSTAT isEqualToString:@"Current Bid"])
        {
            _BTN_watech.hidden = YES;
            _BTN_place_BID.hidden = YES;
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
            
            //            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
        }
        else if ([STR_live isEqualToString:@"1"])//([STR_bidSTAT isEqualToString:@"Starting Bid"])
        {
            [_BTN_place_BID setTitle:@"PLACE BID" forState:UIControlStateNormal];
            [_BTN_place_BID addTarget:self action:@selector(place_BID_VW) forControlEvents:UIControlEventTouchUpInside];
            _BTN_watech.hidden = NO;
            _BTN_place_BID.hidden = NO;
            new_frame.origin.y = _BTN_watech.frame.origin.y + _BTN_watech.frame.size.height + 10;
            
        }
        else
        {
            _BTN_watech.hidden = YES;
            _BTN_place_BID.hidden = YES;
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
        }
        
        if ([winner_status isEqualToString:@"1"])
        {
            
            if([pay_status isEqualToString:@"not_paid"])
            {
                //                if([stat isEqualToString:@"1"])
                //                {
                _BTN_watech.hidden = YES;
                _BTN_place_BID.hidden = NO;
                new_frame.origin.y = _BTN_place_BID.frame.origin.y + _BTN_place_BID.frame.size.height + 10;
                //                }
                
            }
            else
            {
                _BTN_watech.hidden = YES;
                _BTN_place_BID.hidden = YES;
                new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
            }
        }
        
        
        
        
        /*if (_BTN_place_BID.hidden == YES && _BTN_watech.hidden == YES) {
         new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
         }
         else if (_BTN_watech.hidden == YES)
         {
         new_frame.origin.y = _BTN_place_BID.frame.origin.y + _BTN_place_BID.frame.size.height + 10;
         }
         else
         {
         new_frame.origin.y = _BTN_watech.frame.origin.y + _BTN_watech.frame.size.height + 10;
         }*/
        
        /* if ([STR_live isEqualToString:@"0"] && [STR_Expired isEqualToString:@"0"]) {
         [[NSUserDefaults standardUserDefaults] setValue:[auction_item valueForKey:@"event_start_date"] forKey:@"bid_date"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         golfTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target: self selector: @selector(count_downTimer) userInfo: nil repeats: YES];
         }
         else if ([STR_live isEqualToString:@"1"])
         {
         _BTN_place_BID.hidden = NO;
         [_BTN_place_BID setTitle:@"PLACE BID" forState:UIControlStateNormal];
         [_BTN_place_BID addTarget:self action:@selector(place_BID_VW) forControlEvents:UIControlEventTouchUpInside];
         [[NSUserDefaults standardUserDefaults] setValue:[auction_item valueForKey:@"event_end_date"] forKey:@"bid_date"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         golfTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target: self selector: @selector(count_downTimer) userInfo: nil repeats: YES];
         }
         else
         {
         }*/
        
        _VW_line1.frame = new_frame;
        
        new_frame = _lbl_titl_item_descrip.frame;
        new_frame.origin.y = _VW_line1.frame.origin.y + _VW_line1.frame.size.height + 10;
        _lbl_titl_item_descrip.frame = new_frame;
        
        new_frame = _lbl_item_descrip.frame;
        new_frame.origin.y = _lbl_titl_item_descrip.frame.origin.y + _lbl_titl_item_descrip.frame.size.height;
        //        new_frame.size.height = _lbl_item_descrip.contentSize.height;
        _lbl_item_descrip.frame = new_frame;
        
        new_frame = _VW_line2.frame;
        new_frame.origin.y = _lbl_item_descrip.frame.origin.y + _lbl_item_descrip.frame.size.height + 10;
        _VW_line2.frame = new_frame;
        
        new_frame = _lbl_title_silar_item.frame;
        new_frame.origin.y = _VW_line2.frame.origin.y + _VW_line2.frame.size.height + 10;
        _lbl_title_silar_item.frame = new_frame;
        
        new_frame  = LBL_stat.frame;
        new_frame.origin.x = _lbl_title_silar_item.frame.origin.x;
        new_frame.origin.y = _lbl_title_silar_item.frame.origin.y + _lbl_title_silar_item.frame.size.height + 10;
        new_frame.size.width = _VW_line2.frame.size.width;
        new_frame.size.height = _lbl_title_silar_item.frame.size.height;
        LBL_stat.frame = new_frame;
        [_VW_contents addSubview:LBL_stat];
        LBL_stat.hidden =YES;
        
        
        if(similar_ARR.count == 0)
        {
            _collection_similar_item.hidden = YES;
            
            LBL_stat.hidden = NO;
            LBL_stat.font = _lbl_title_silar_item.font;
            LBL_stat.text = @"No Items found";
            LBL_stat.textColor = [UIColor grayColor];
            
            
            CGRect frame_content;
            frame_content = _VW_contents.frame;
            frame_content.size.width = _scroll_contents.frame.size.width;
            frame_content.size.height = LBL_stat.frame.origin.y + LBL_stat.frame.size.height + 20;
            _VW_contents.frame = frame_content;
            
        }
        else
        {
            
            _collection_similar_item.hidden = NO;
            [_collection_similar_item reloadData];
            
            LBL_stat.hidden = YES;
            new_frame = _collection_similar_item.frame;
            new_frame.origin.y = _lbl_title_silar_item.frame.origin.y + _lbl_title_silar_item.frame.size.height + 10;
            _collection_similar_item.frame = new_frame;
            
            CGRect frame_content;
            frame_content = _VW_contents.frame;
            frame_content.size.width = _scroll_contents.frame.size.width;
            frame_content.size.height = _collection_similar_item.frame.origin.y + _collection_similar_item.frame.size.height;
            _VW_contents.frame = frame_content;
            
        }
        
        
        [_scroll_contents addSubview:_VW_contents];
        [self viewDidLayoutSubviews];
    }
    else
    {
        CGRect new_frame = _lbl_itemNAME.frame;
        new_frame.origin.y = _collection_IMG.frame.origin.y + _collection_IMG.frame.size.height;
        new_frame.size.width = _lbl_CountDown.frame.size.width + 10;
        new_frame.size.width = _VW_line1.frame.size.width - 13;
        _lbl_itemNAME.frame = new_frame;
        
        //        self.lbl_CountDown.numberOfLines = 0;
        //        [self.lbl_CountDown sizeToFit];
        
        if ([STR_bidSTAT isEqualToString:@"Starting Bid"] || [STR_bidSTAT isEqualToString:@"Current Bid"])
        {
            new_frame = _lbl_CountDown.frame;
            new_frame.origin.y = _lbl_itemNAME.frame.origin.y + _lbl_itemNAME.frame.size.height - 3;
            _lbl_CountDown.frame = new_frame;
            _lbl_CountDown.textAlignment = NSTextAlignmentLeft;
            
        }
        else
        {
            new_frame = _lbl_CountDown.frame;
            new_frame.origin.y = _lbl_itemNAME.frame.origin.y + _lbl_itemNAME.frame.size.height + 5;
            new_frame.size.height = _BTN_place_BID.frame.size.height;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                new_frame.size.width = _VW_line1.frame.size.width - 23;
            }
            else
            {
                new_frame.size.width = _VW_line1.frame.size.width - 13;
            }
            _lbl_CountDown.frame = new_frame;
            _lbl_CountDown.textAlignment = NSTextAlignmentCenter;
        }
        
        
        new_frame = _BTN_place_BID.frame;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 15;
        }
        else
        {
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 5;
        }
        _BTN_place_BID.frame = new_frame;
        
        new_frame = _BTN_watech.frame;
        new_frame.origin.y = _BTN_place_BID.frame.origin.y + _BTN_place_BID.frame.size.height + 12;
        
        
        _BTN_watech.frame = new_frame;
        //        _BTN_watech.layer.borderWidth = 2.0f;
        //        _BTN_watech.layer.borderColor = [UIColor blackColor].CGColor;
        [_BTN_watech addTarget:self action:@selector(showActionSHEET) forControlEvents:UIControlEventTouchUpInside];
        
        new_frame = _VW_line1.frame;
        
        if ([STR_bidSTAT isEqualToString:@"Current Bid"])
        {
            _BTN_watech.hidden = NO;
            _BTN_place_BID.hidden = NO;
            new_frame.origin.y = _BTN_watech.frame.origin.y + _BTN_watech.frame.size.height + 10;
            //            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
        }
        else if ([STR_bidSTAT isEqualToString:@"Starting Bid"])
        {
            _BTN_watech.hidden = YES;
            _BTN_place_BID.hidden = YES;
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
        }
        else
        {
            _BTN_watech.hidden = YES;
            _BTN_place_BID.hidden = YES;
            new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
        }
        
        
        if ([winner_status isEqualToString:@"1"])
        {
            if([pay_status isEqualToString:@"not_paid"])
            {
                //                if([stat isEqualToString:@"1"])
                //                {
                _BTN_watech.hidden = YES;
                _BTN_place_BID.hidden = NO;
                new_frame.origin.y = _BTN_place_BID.frame.origin.y + _BTN_place_BID.frame.size.height + 10;
                // }
                
                
            }
            else
            {
                _BTN_watech.hidden = YES;
                _BTN_place_BID.hidden = YES;
                new_frame.origin.y = _lbl_CountDown.frame.origin.y + _lbl_CountDown.frame.size.height + 10;
            }
        }
        
        
        
        _VW_line1.frame = new_frame;
        
        new_frame = _lbl_titl_item_descrip.frame;
        new_frame.origin.y = _VW_line1.frame.origin.y + _VW_line1.frame.size.height + 10;
        _lbl_titl_item_descrip.frame = new_frame;
        
        new_frame = _lbl_item_descrip.frame;
        new_frame.origin.y = _lbl_titl_item_descrip.frame.origin.y + _lbl_titl_item_descrip.frame.size.height;
        //        new_frame.size.height = _lbl_item_descrip.contentSize.height;
        _lbl_item_descrip.frame = new_frame;
        
        new_frame = _VW_line2.frame;
        new_frame.origin.y = _lbl_item_descrip.frame.origin.y + _lbl_item_descrip.frame.size.height + 10;
        _VW_line2.frame = new_frame;
        
        
        
        new_frame = _lbl_title_silar_item.frame;
        new_frame.origin.y = _VW_line2.frame.origin.y + _VW_line2.frame.size.height + 10;
        _lbl_title_silar_item.frame = new_frame;
        
        new_frame  = LBL_stat.frame;
        new_frame.origin.x = _lbl_title_silar_item.frame.origin.x;
        new_frame.origin.y = _lbl_title_silar_item.frame.origin.y + _lbl_title_silar_item.frame.size.height + 10;
        new_frame.size.width = _VW_line2.frame.size.width;
        new_frame.size.height = _lbl_title_silar_item.frame.size.height;
        LBL_stat.frame = new_frame;
        [_VW_contents addSubview:LBL_stat];
        LBL_stat.hidden =YES;
        
        
        if(similar_ARR.count == 0)
        {
            _collection_similar_item.hidden = YES;
            LBL_stat.hidden = NO;
            LBL_stat.font = _lbl_title_silar_item.font;
            LBL_stat.text = @"No Items found";
            LBL_stat.textColor = [UIColor grayColor];
            
            CGRect frame_content;
            frame_content = _VW_contents.frame;
            frame_content.size.width = _scroll_contents.frame.size.width;
            frame_content.size.height = LBL_stat.frame.origin.y + LBL_stat.frame.size.height + 20;
            _VW_contents.frame = frame_content;
            
        }
        else
        {
            _collection_similar_item.hidden = NO;
            [_collection_similar_item reloadData];
            LBL_stat.hidden = YES;
            new_frame = _collection_similar_item.frame;
            new_frame.origin.y = _lbl_title_silar_item.frame.origin.y + _lbl_title_silar_item.frame.size.height + 10;
            _collection_similar_item.frame = new_frame;
            
            CGRect frame_content;
            frame_content = _VW_contents.frame;
            frame_content.size.width = _scroll_contents.frame.size.width;
            frame_content.size.height = _collection_similar_item.frame.origin.y + _collection_similar_item.frame.size.height;
            _VW_contents.frame = frame_content;
            
            
        }
        
        [_scroll_contents addSubview:_VW_contents];
        [self viewDidLayoutSubviews];
        
    }
    
}


//- (IBAction)changePage{
//    // update the scroll view to the appropriate page
//    CGRect frame;
//    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
//    frame.origin.y = 0;
//    frame.size = self.scrollView.frame.size;
//    [self.scrollView scrollRectToVisible:frame animated:YES];
//    pageControlBeingUsed = YES;
//
//    _lbl_count.text = [NSString stringWithFormat:@"%lu of %lu",(long)self.pageControl.currentPage + 1,(unsigned long)self.pageControl.numberOfPages];
//}

- (CGRect)frameOfTextRange:(NSRange)range
{
    self.lbl_itemNAME.selectedRange = range;
    UITextRange *textRange = [self.lbl_itemNAME selectedTextRange];
    CGRect rect = [self.lbl_itemNAME firstRectForRange:textRange];
    return rect;
}


#pragma mark - Back Action
-(void) backAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void) more_ACTION
{
    NSLog(@"More actions tapped");
    NSString *user_watching_status = [NSString stringWithFormat:@"%@",[jsonReponse valueForKey:@"user_watching_status"]];
    if ([user_watching_status isEqualToString:@"1"]) {
        user_watching_status = @"Watching";
    }
    else
    {
        user_watching_status = @"Watch";
    }
    
    NSLog(@"Show action sheet tapped");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:user_watching_status,@"View Bidding History", @"Share This Item", nil];
    
    //    [actionSheet showInView:self.view];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        //  [actionSheet showFromRect:[(UIButton *)_BTN_watech frame] inView:self.view animated:YES];
        VW_overlay.hidden = NO;
        [actionSheet addButtonWithTitle:@"Cancel"];
        [actionSheet showInView:self.view];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
}


#pragma mark - CollectionView Deligate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if(view == _collection_IMG)
    {
        return self.imagesData.count;
    }
    else
    {
        
        return [similar_ARR count];
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath %ld", (long)indexPath.row); // returns as expected
    static NSString *identifier = @"cellIdentifier";
    
    
    if(collectionView == _collection_IMG)
    {
        cell_auction_item_detail *cell = (cell_auction_item_detail *)[collectionView dequeueReusableCellWithReuseIdentifier:@"item_detail_identifier" forIndexPath:indexPath];
        
        
        [ cell.auction_image sd_setImageWithURL:[NSURL URLWithString:[_imagesData objectAtIndex:indexPath.row]]
                               placeholderImage:[UIImage imageNamed:@"Logo_WT.png"]];
        cell.auction_image.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        return cell;
        
    }
    else
    {
        @try
        {
            
            
            similar_collectioncell *similar_cell = (similar_collectioncell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            NSDictionary *similar_Dict = [similar_ARR objectAtIndex:indexPath.row];
            
            [similar_cell.IMG_similar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,[similar_Dict valueForKey:@"item_image"]]]
                                        placeholderImage:[UIImage imageNamed:@"Logo_WT.png"]];
            
            similar_cell.LBl_item_name.text = [similar_Dict objectForKey:@"name"];
            
            
            
            NSString *STR_price,*STR_stat;
            NSString *STR_Expired = [NSString stringWithFormat:@"%@",[similar_Dict valueForKey:@"is_expired?"]];
            NSString *STR_live = [NSString stringWithFormat:@"%@",[similar_Dict valueForKey:@"is_live?"]];
            
            if ([STR_live isEqualToString:@"0"] && [STR_Expired isEqualToString:@"0"]) {
                STR_stat = @"Starting Bid";
                STR_price = [NSString stringWithFormat:@"%.2f",[[similar_Dict valueForKey:@"starting_bid"] floatValue]];
            }
            else if ([STR_live isEqualToString:@"1"])
            {
                STR_stat = @"Current Bid";
                NSString *STR_bid = [NSString stringWithFormat:@"%@",[similar_Dict valueForKey:@"current_bid_amount"]];
                if ([STR_bid isEqualToString:@"<null>"])
                {
                    STR_price = [NSString stringWithFormat:@"%.2f",[[similar_Dict valueForKey:@"starting_bid"] floatValue]];
                }
                else
                {
                    STR_price = [NSString stringWithFormat:@"%.2f",[[similar_Dict valueForKey:@"current_bid_amount"] floatValue]];
                }
                
            }
            else
            {
                STR_stat = @"Sold";
                
                NSString *STR_bid = [NSString stringWithFormat:@"%@",[similar_Dict valueForKey:@"current_bid_amount"]];
                if ([STR_bid isEqualToString:@"<null>"])
                {
                    STR_price = [NSString stringWithFormat:@"%.2f",[[similar_Dict valueForKey:@"starting_bid"] floatValue]];
                }
                else
                {
                    STR_price = [NSString stringWithFormat:@"%.2f",[[similar_Dict valueForKey:@"current_bid_amount"] floatValue]];
                }
                
            }
            
            NSString *text = [NSString stringWithFormat:@"$%@\n%@",STR_price,STR_stat];
            if ([similar_cell.price respondsToSelector:@selector(setAttributedText:)])
            {
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName: similar_cell.price.textColor,
                                          NSFontAttributeName: similar_cell.price.font
                                          };
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:text
                                                       attributes:attribs];
                NSRange ename = [text rangeOfString:STR_price];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25.0]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:21.0]}
                                            range:ename];
                }
                
                
                
                NSRange cmp = [text rangeOfString:STR_stat];
                if([STR_stat isEqualToString:@"Sold"])
                {
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:21.0], NSForegroundColorAttributeName:[UIColor redColor]} range:cmp];
                        
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:17.0], NSForegroundColorAttributeName:[UIColor redColor]} range:cmp];
                        
                    }
                    
                }
                else{
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:21.0]} range:cmp];
                        
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBook" size:17.0]}
                                                range:cmp];
                    }
                    
                    
                }
                similar_cell.price.attributedText = attributedText;
            }
            else
            {
                similar_cell.price.text = text;
            }
            similar_cell.LBl_item_name.numberOfLines = 0;
            // [similar_cell.LBl_item_name sizeToFit];
            
            similar_cell.price.numberOfLines = 0;
            //  [similar_cell.price sizeToFit];
            return similar_cell;
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception %@",exception);
            
        }
        
        
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collection_similar_item)
    {
        NSDictionary *cpy_dict = [similar_ARR objectAtIndex:indexPath.row];
        NSString *STR_Expired = [NSString stringWithFormat:@"%@",[cpy_dict objectForKey:@"is_expired?"]];
        NSString *STR_live = [NSString stringWithFormat:@"%@",[cpy_dict objectForKey:@"is_live?"]];
        NSString *STR_bidSTAT;
        
        if (![[NSString stringWithFormat:@"%@",[cpy_dict objectForKey:@"bid_count"]] isEqualToString:@"0"] && [STR_live isEqualToString:@"1"])
        {
            STR_bidSTAT = @"Current Bid";
        }
        else
        {
            STR_bidSTAT = @"Starting Bid";
        }
        
        
        
        if ([[cpy_dict objectForKey:@"payment_status"] isEqualToString:@"paid"] && [STR_Expired isEqualToString:@"1"]) {
            STR_bidSTAT = @"Closed";
        }
        if ([STR_Expired isEqualToString:@"1"] && [[cpy_dict objectForKey:@"payment_status"] isEqualToString:@"not_paid"]) {
            STR_bidSTAT = @"Closed";
        }
        
        NSDictionary *temp_DICTIN = [similar_ARR objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setValue:STR_bidSTAT forKey:@"STR_bidSTAT"];
        [[NSUserDefaults standardUserDefaults] setValue:[temp_DICTIN valueForKey:@"id"] forKey:@"prev_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(GETAuction_Item_details) withObject:activityIndicatorView afterDelay:0.01];
    }
    
}



/*
 
 //    cell.contentView.backgroundColor = [UIColor colorWithRed:0.953 green:0.976 blue:0.98 alpha:1];
 UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.cnt_VW.bounds];
 cell.cnt_VW.backgroundColor = [UIColor colorWithRed:0.953 green:0.976 blue:0.98 alpha:1];
 cell.cnt_VW.layer.masksToBounds = NO;
 cell.cnt_VW.layer.shadowColor = [UIColor lightGrayColor].CGColor;
 cell.cnt_VW.layer.shadowOffset = CGSizeMake(0.5f, 0.0f);
 cell.cnt_VW.layer.shadowOpacity = 0.5f;
 //    cell.cnt_VW.layer.cornerRadius = 7.0f;
 cell.cnt_VW.layer.shadowPath = shadowPath.CGPath;
 
 NSLog(@"Contents in cell %@",[L_category objectAtIndex:indexPath.row]);
 
 cell.lbl_CAT_name.text = [NSString stringWithFormat:@"%@",[[L_category objectAtIndex:indexPath.row] valueForKey:@"NAME"]];
 
 CGRect frame = cell.lbl_CAT_name.frame;
 frame.size.width = self.navigationController.navigationBar.frame.size.width/2 - 30;
 frame.size.height = cell.contentView.frame.size.height - 8;
 
 frame.origin.x = 8;
 frame.origin.y = 8;
 
 [cell.lbl_CAT_name setFrame:frame];
 
 cell.lbl_CAT_name.numberOfLines = 0;
 cell.lbl_CAT_name.textAlignment = NSTextAlignmentCenter; */
//    cell.lbl_CAT_name.adjustsFontSizeToFitWidth = YES;
//    [cell.lbl_CAT_name sizeToFit];




-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -
#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    UIDeviceOrientation devOrientation = [UIDevice currentDevice].orientation;
    //    if (UIDeviceOrientationIsLandscape(devOrientation))
    //    {
    //        return CGSizeMake(130, 90);
    //    }
    //    else if (UIDeviceOrientationIsPortrait(devOrientation))
    //    {
    if(collectionView == _collection_IMG)
    {
        return CGSizeMake(_collection_IMG.frame.size.width ,_collection_IMG.frame.size.height);
    }
    else
    {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            return CGSizeMake(self.view.frame.size.width/2.2f, 491);
        }
        else
        {
            return CGSizeMake(self.view.frame.size.width/2.2f, 258);
        }
    }
    //    }
    //    return CGSizeMake(self.view.frame.size.width/2, 95);
}




- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(collectionView == _collection_IMG)
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else
    {
        return UIEdgeInsetsMake(0, 10, 0, 9);
    }
}

#pragma mark - Show action sheet
-(void) showActionSHEET
{
    NSString *user_watching_status = [NSString stringWithFormat:@"%@",[jsonReponse valueForKey:@"user_watching_status"]];
    if ([user_watching_status isEqualToString:@"1"]) {
        //                [_BTN_watech addTarget:self action:@selector(watching_API) forControlEvents:UIControlEventTouchUpInside];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(watch_API_call_remove) withObject:activityIndicatorView afterDelay:0.01];
    }
    else
    {
        //                [_BTN_watech addTarget:self action:@selector(Watch_API) forControlEvents:UIControlEventTouchUpInside];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Watch_API_call) withObject:activityIndicatorView afterDelay:0.01];
    }
}

-(void) navigation_action_sheet
{
    
}

#pragma mark - Actionsheet deligate
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    VW_overlay.hidden = YES;
    
    switch (buttonIndex) {
            
        case 0:
        {
            NSString *user_watching_status = [NSString stringWithFormat:@"%@",[jsonReponse valueForKey:@"user_watching_status"]];
            if ([user_watching_status isEqualToString:@"1"]) {
                //                [_BTN_watech addTarget:self action:@selector(watching_API) forControlEvents:UIControlEventTouchUpInside];
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(watch_API_call_remove) withObject:activityIndicatorView afterDelay:0.01];
            }
            else
            {
                //                [_BTN_watech addTarget:self action:@selector(Watch_API) forControlEvents:UIControlEventTouchUpInside];
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(Watch_API_call) withObject:activityIndicatorView afterDelay:0.01];
            }
            break;
        }
            
        case 1:
        {
            [self performSegueWithIdentifier:@"itmdtailtobidhstryidentifier" sender:self];
        }
            break;
            
        case 2:
        {
            NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
            NSString *str_share;
            @try {
                str_share = [auction_item valueForKey:@"unique_url_key"];
            } @catch (NSException *exception) {
                str_share = @"";
            }
            
            NSString *STR_share_URL = [NSString stringWithFormat:@"%@/%@",IMAGE_URL,str_share];
            NSArray *postItems=@[STR_share_URL];
            
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
            
            //if iPhone
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:controller animated:YES completion:nil];
            }
            //if iPad
            else {
                // Change Rect to position Popover
                //            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
                //            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
                controller.popoverPresentationController.sourceView = self.BTN_watech;
                controller.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
                //        activityViewController.popoverPresentationController.sourceRect = self.frame;
                [self presentViewController:controller
                                   animated:YES
                                 completion:nil];
            }
        }
            
        default:
            break;
    }
    
    //    if (buttonIndex == 1)
    //    {
    //
    //    }
}


#pragma mark - Date Detail
-(NSString *) change_date : (NSString *) date_STR
{
    //Getting date from string
    NSString *dateString = @"09-03-2015";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:dateString];
    // converting into our required date format
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    NSString *reqDateString = [dateFormatter stringFromDate:date];
    NSLog(@"date is %@", reqDateString);
    return reqDateString;
}

#pragma mark - Date Convert
-(NSDate *)getLocalDateFromUTC:(NSString *)strDate
{
    strDate = @"2017-09-02T10:32:00.000-04:00";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    NSLog(@"CurrentDate:%@", currentDate);
    //    NSDateFormatter *newFormat = [[NSDateFormatter alloc] init];
    //    [newFormat setDateFormat:@"EEEE, MMMM dd, yyyy"];
    return currentDate;
}
-(NSString *)getLocalTimeFromUTC:(NSString *)strDate
{
    NSLog(@"Input Date %@",strDate);
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:strDate];
    NSLog(@"CurrentDate:%@", currentDate);
    
    NSDateFormatter *userFormatter = [[NSDateFormatter alloc] init];
    [userFormatter setDateFormat:@"h:mm a"];
    [userFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    
    return [userFormatter stringFromDate:currentDate];
}

/*#pragma mark - Timer methods
 -(void) updateCountdown
 {
 int hours, minutes, seconds;
 
 secondsLeft--;
 hours = secondsLeft / 3600;
 minutes = (secondsLeft % 3600) / 60;
 seconds = (secondsLeft %3600) % 60;
 NSString *STR_temp = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
 NSLog(@"time updated %@",STR_temp);
 }*/

/*
 
 - (void)startTimer {
 ...
 // Set the date you want to count from
 self.countdownDate = [NSDate date...]; ///< Get this however you need
 
 // Create a timer that fires every second repeatedly and save it in an ivar
 self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
 ...
 }
 
 - (void)updateLabel {
 NSTimeInterval timeInterval = [self.countdownDate timeIntervalSinceNow]; ///< Assuming this is in the future for now.
 
 
 // Work out the number of days, months, years, hours, minutes, seconds from timeInterval.
 
 
 self.countdownLabel.text = [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@", days, months, years, hours, minutes, seconds];
 }
 
 */
-(void)Timer_Stopped
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Closed" forKey:@"STR_bidSTAT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Timer Stopped");
}

-(NSDate *)_dateFromUtcString:(NSString *)utcString{
    if(!utcString){
        return nil;
    }
    static NSDateFormatter *df = nil;
    if (df == nil) {
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    NSArray* parts = [utcString componentsSeparatedByString:@"."];
    NSDate *utcDate = [df dateFromString:parts[0]];
    if(parts.count > 1){
        double microseconds = [parts[1] doubleValue];
        utcDate = [utcDate dateByAddingTimeInterval:microseconds / 1000000];
    }
    return utcDate;
}

#pragma mark - Countdown timer
-(void)count_downTimer
{
    /*int hours, minutes, seconds;
     
     secondsLeft--;
     hours = secondsLeft / 3600;
     minutes = (secondsLeft % 3600) / 60;
     seconds = (secondsLeft %3600) % 60;
     NSString *STR_time = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
     _lbl_CountDown.text = [NSString stringWithFormat:@"Starting bid | %@",STR_time];*/
    
    NSDateFormatter *dateStringParser = [[NSDateFormatter alloc] init];
    [dateStringParser setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateStringParser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    
    NSString *STR_bidDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"bid_date"];
    NSDate *date = [dateStringParser dateFromString:STR_bidDate];//@"2017-09-02T10:32:00.000-04:00"
    
    NSDateFormatter *labelFormatter = [[NSDateFormatter alloc] init];
    [labelFormatter setDateFormat:@"HH-dd-MM"];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    //    dateFormatter.timeZone = destinationTimeZone;
    //    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    
    //    NSString *STR_date = [dateFormatter stringFromDate:[NSDate date]];
    //    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    //    currentDATE *get_DATE = [[currentDATE alloc] init];
    
    
    //    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    //    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    //    dateFormatter1.timeZone = destinationTimeZone;
    //    [dateFormatter1 setDateStyle:NSDateFormatterLongStyle];
    //    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //    [dateFormatter1 dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    
    //    NSLog(@"Before convert %@ After convert %@",[dateFormatter stringFromDate:[NSDate date]],[dateFormatter dateFromString:STR_date]);
    
    NSDate* currentDate = [NSDate date];//[self _dateFromUtcString:STR_date];//[dateFormatter dateFromString:STR_date];//[NSDate date];
    
    //    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    //
    //    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    //    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    //
    //    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    //    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    
    NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
    NSString *STR_live = [NSString stringWithFormat:@"%@",[auction_item objectForKey:@"is_live?"]];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:currentDate];
    
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date];
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitSecond;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date  toDate:date2  options:0];
    
    NSString *STR_bidSTAT = [[NSUserDefaults standardUserDefaults] valueForKey:@"STR_bidSTAT"];
    //Starting Bid,Current Bid,Closed
    
    if (![STR_bidSTAT isEqualToString:@"Starting Bid"] && ![STR_bidSTAT isEqualToString:@"Current Bid"]) {
        _lbl_CountDown.text = @"Auction Closed";
    }
    else
    {
        NSString *STR_timeRe;
        
        if ([breakdownInfo day] <= 0 ) {
            if ([STR_live isEqualToString:@"1"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d H : %02d M : %02d S left",(int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
            else if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d H : %02d M : %02d S remaining",(int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
            else
            {
                STR_timeRe = [NSString stringWithFormat:@" | %02d H : %02d M : %02d S left",(int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
            
        }
        else if ([breakdownInfo day] <= 0 && [breakdownInfo hour] <= 0)
        {
            if ([STR_live isEqualToString:@"1"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d M : %02d S left",(int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
            else if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d M : %02d S remaining",(int)[breakdownInfo minute], (int)[breakdownInfo second]];
                
            }
            else
            {
                STR_timeRe = [NSString stringWithFormat:@" | %02d M : %02d S left",(int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
        }
        else if ([breakdownInfo day] <= 0 && [breakdownInfo hour] <= 0 && [breakdownInfo minute] <= 0)
        {
            if ([STR_live isEqualToString:@"1"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d S left", (int)[breakdownInfo second]];
            }
            else if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d S remaining", (int)[breakdownInfo second]];
            }
            else
            {
                STR_timeRe = [NSString stringWithFormat:@" | %02d S left", (int)[breakdownInfo second]];
            }
            
        }
        else
        {
            if ([STR_live isEqualToString:@"1"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d D : %02d H : %02d M : %02d S left", (int)[breakdownInfo day], (int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
            if ([STR_bidSTAT isEqualToString:@"Starting Bid"]) {
                STR_timeRe = [NSString stringWithFormat:@" | %02d D : %02d H : %02d M : %02d S remaining", (int)[breakdownInfo day], (int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
            else
            {
                STR_timeRe = [NSString stringWithFormat:@" | %02d D : %02d H : %02d M : %02d S left", (int)[breakdownInfo day], (int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
        }
        //        else
        
        
        
        NSString *text = [NSString stringWithFormat:@"%@%@",STR_bidSTAT,STR_timeRe];
        
        if ([_lbl_CountDown respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName: _lbl_CountDown.textColor,
                                      NSFontAttributeName: _lbl_font_normal.font
                                      };
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:text
                                                   attributes:attribs];
            
            // Red text attributes
            //            UIColor *redColor = [UIColor redColor];
            NSRange cmp = [text rangeOfString:STR_bidSTAT];
            
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [attributedText setAttributes:@{NSFontAttributeName:_lbl_font_small.font}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:_lbl_font_small.font}
                                        range:cmp];
            }
            _lbl_CountDown.attributedText = attributedText;
        }
        else
        {
            _lbl_CountDown.text = text;
        }
        
        if ([breakdownInfo day] <= 0 && [breakdownInfo hour] <= 0 && [breakdownInfo minute] <= 0 && [breakdownInfo second] <= 0) {
            [self Timer_Stopped];
            [self GETAuction_Item_details];
        }
        //        else
        //        {
        //
        //        }
    }
}

- (void) countdown: (NSTimer*) timer
{
    if( [[self getLocalDateFromUTC:@""] timeIntervalSinceNow] <= 0)
    {
        [timer invalidate];
        return;
    }
    //    NSDateComponents* comp= [[NSCalendar currentCalendar] components: NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond startingDate: [NSDate date] toDate: [self getLocalDateFromUTC:@""] options: 0];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self getLocalDateFromUTC:@""]];
    //    NSLog(@"%lu:%lu:%lu", comp.hour,comp.minute.comp.second);
    NSString *STR_time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)comp.hour, (long)comp.minute, (long)comp.second];
    _lbl_CountDown.text = [NSString stringWithFormat:@"Starting bid | %@",STR_time];
}

#pragma mark - API Calling
-(void) GETAuction_Item_details
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    
    //    NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"upcoming_events"] options:NSASCIIStringEncoding error:&error];
    //    NSDictionary *Dictin_event = [dict valueForKey:@"event"];
    
    NSString *prev_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"prev_ID"];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/item_detail/%@",SERVER_URL,prev_id];//[Dictin_event valueForKey:@"id"]
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth-token"];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData) {
        jsonReponse = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response VC auction detail page %@",jsonReponse);
        
        NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
        
        NSString *STR_Expired = [NSString stringWithFormat:@"%@",[auction_item objectForKey:@"is_expired?"]];
        NSString *STR_live = [NSString stringWithFormat:@"%@",[auction_item objectForKey:@"is_live?"]];
        NSString *STR_bidSTAT;
        
        
        
        if (![[NSString stringWithFormat:@"%@",[auction_item objectForKey:@"bid_count"]] isEqualToString:@"0"] && [STR_live isEqualToString:@"1"])
        {
            STR_bidSTAT = @"Current Bid";
        }
        else
        {
            STR_bidSTAT = @"Starting Bid";
        }
        
        
        
        if ([[auction_item objectForKey:@"payment_status"] isEqualToString:@"paid"] && [STR_Expired isEqualToString:@"1"]) {
            STR_bidSTAT = @"Closed";
        }
        if ([STR_Expired isEqualToString:@"1"] && [[auction_item objectForKey:@"payment_status"] isEqualToString:@"not_paid"]) {
            STR_bidSTAT = @"Closed";
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:STR_bidSTAT forKey:@"STR_bidSTAT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self setup_VIEW];
}

/*
 #pragma mark - Date Comparison
 -(void) Check_Date :(NSString *)start_Date :(NSString *)end_DAte
 {
 NSDateFormatter *dateStartParser = [[NSDateFormatter alloc] init];
 [dateStartParser setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
 [dateStartParser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
 
 NSDate *start_date = [dateStartParser dateFromString:start_Date];
 
 NSDate* currentDate = [NSDate date];
 
 
 if( [start_date timeIntervalSinceDate:currentDate] > 0 ) {
 [[NSUserDefaults standardUserDefaults] setValue:start_Date forKey:@"bid_date"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 else
 {
 [[NSUserDefaults standardUserDefaults] setValue:end_DAte forKey:@"bid_date"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 }
 */

#pragma mark - Place Bid
-(void) place_BID_VW
{
    //    NSString *STR_bidSTAT = [[NSUserDefaults standardUserDefaults] valueForKey:@"STR_bidSTAT"];
    
    //Starting Bid,Current Bid,Closed
    
    NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
    NSString *minimum_bid_increment = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"minimum_bid_increment"]];
    
    
    NSString *alert_title = [NSString stringWithFormat:@"Amount should be increment of $%.2f",[minimum_bid_increment floatValue]];
    alertController = [UIAlertController alertControllerWithTitle: @"Place Bid Amount"
                                                          message: alert_title
                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    __weak VC_item_deatail *weakSelf = self;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Amount";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        [textField addTarget:weakSelf action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    self.submit_action = [UIAlertAction actionWithTitle:@"PLACE BID"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    alert_TXT_price= alertController.textFields[0].text;
                                                    //                                                    [self forgot_PWD];
                                                    VW_overlay.hidden = NO;
                                                    [activityIndicatorView startAnimating];
                                                    [self performSelector:@selector(place_bid) withObject:activityIndicatorView afterDelay:0.01];
                                                }];
    
    [alertController addAction:self.submit_action];
    self.submit_action.enabled = NO;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    //    }
    //    else
    //    {
    NSLog(@"Bid closed");
    //    }
    [self.view endEditing:YES];
}

-(void)textDidChange:(UITextField *)textField {
    NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
    NSString *minimum_bid_increment = [NSString stringWithFormat:@"%@",[auction_item valueForKey:@"minimum_bid_increment"]];
    
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    nf.positiveFormat = @"0.##";
    
    float min_BID = [nf numberFromString:minimum_bid_increment].floatValue;
    
    float amount  = [textField.text floatValue];
    float strt_bid = [[auction_item valueForKey:@"starting_bid"] floatValue];
    float current_bid;
    
    @try {
        current_bid = [[auction_item valueForKey:@"current_bid_amount" ] floatValue];
    } @catch (NSException *exception) {
        current_bid = 0.00;
    }
    
    
    if(current_bid == 0)
    {
        if (amount >= strt_bid + min_BID)
        {
            self.submit_action.enabled = YES;
        }
        else
        {
            self.submit_action.enabled = NO;
        }
    }
    else
    {
        if(amount >= current_bid + min_BID)
        {
            self.submit_action.enabled = YES;
        }
        else
        {
            self.submit_action.enabled = NO;
        }
    }
    
}

#pragma mark - Place bid API
-(void)place_bid
{
    //    UITextField *amount_field = alertController.textFields[0];
    //    [amount_field resignFirstResponder];
    [alertController dismissViewControllerAnimated:NO completion:nil];
    
    @try {
        
        NSString *amount_bid = alert_TXT_price;
        amount_bid = [amount_bid stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:amount_bid];
        NSLog(@"the number is:%@",myNumber);
        
        
        //  NSString *email = _TXT_email.text;
        
        
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
        NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
        NSDictionary *parameters = @{@"current_bid":myNumber};
        NSLog(@"the post data is:%@",parameters);
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
        NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/place_bid/%@",SERVER_URL,[auction_item valueForKey:@"id"]];
        
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:auth_TOK forHTTPHeaderField:@"auth-token"];
        [request setHTTPBody:postData];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (aData)
        {
            //        self->activityIndicatorView.hidden=YES;
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response %@",json_DATA);
            
            
            
            @try
            {
                NSString *STR_error1 = [json_DATA valueForKey:@"error"];
                if (STR_error1)
                {
                    [self sessionOUT];
                }
                else
                {
                    NSString *status=[json_DATA valueForKey:@"status"];
                    NSString *error=[json_DATA valueForKey:@"errors"];
                    NSString *message=[json_DATA valueForKey:@"message"];
                    
                    if([status isEqualToString:@"Success"])
                    {
                        [activityIndicatorView stopAnimating];
                        VW_overlay.hidden=YES;
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Bidding has been done successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        
                        
                        [self GETAuction_Item_details];
                        
                        
                    }
                    else if(error)
                    {
                        [activityIndicatorView stopAnimating];
                        VW_overlay.hidden=YES;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    else
                    {
                        [activityIndicatorView stopAnimating];
                        VW_overlay.hidden=YES;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
            VW_overlay.hidden=YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
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

#pragma mark - Checkout Action
-(void) checkout_API
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Checkout api" message:@"Continue checkout" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    //    [alert show];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(checkout_withActivity) withObject:activityIndicatorView afterDelay:0.01];
}

-(void) checkout_withActivity
{
    @try {
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
        NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
        
        NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/auction_order/%@",SERVER_URL,[auction_item valueForKey:@"id"]];
        
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:auth_TOK forHTTPHeaderField:@"auth-token"];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (aData)
        {
            //        self->activityIndicatorView.hidden=YES;
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            
            
            
            NSLog(@"The response checkout api item detail %@",json_DATA);
            
            
            
            @try
            {
                NSString *STR_error1 = [json_DATA valueForKey:@"error"];
                if (STR_error1)
                {
                    [self sessionOUT];
                }
                else
                {
                    NSString *status=[json_DATA valueForKey:@"status"];
                    NSString *error=[json_DATA valueForKey:@"errors"];
                    NSString *message=[json_DATA valueForKey:@"message"];
                    
                    if([status isEqualToString:@"Success"])
                    {
                        [activityIndicatorView stopAnimating];
                        VW_overlay.hidden=YES;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"checkout_data"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        [self performSegueWithIdentifier:@"conf_order" sender:self];
                    }
                    else if(error)
                    {
                        [activityIndicatorView stopAnimating];
                        VW_overlay.hidden=YES;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    else
                    {
                        [activityIndicatorView stopAnimating];
                        VW_overlay.hidden=YES;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
            VW_overlay.hidden=YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden=YES;
}

#pragma mark - Watch & Waching API
-(void) Watch_API_call
{
    @try {
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
        NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
        
        NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/add_watch/%@",SERVER_URL,[auction_item valueForKey:@"id"]];
        
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:auth_TOK forHTTPHeaderField:@"auth-token"];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (aData)
        {
            //        self->activityIndicatorView.hidden=YES;
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response %@",json_DATA);
            
            
            
            //            @try
            //            {
            //                NSString *STR_error1 = [json_DATA valueForKey:@"error"];
            //                if (STR_error1)
            //                {
            //                    [self sessionOUT];
            //                }
            //                else
            //                {
            if(!json_DATA)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            NSString *status=[json_DATA valueForKey:@"status"];
            //                    NSString *error=[json_DATA valueForKey:@"errors"];
            //                    NSString *message=[json_DATA valueForKey:@"message"];
            
            if([status isEqualToString:@"Success"])
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden=YES;
                
                
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:status delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                //                        [alert show];
                
                [self GETAuction_Item_details];
                
                
            }
            //                    else if(error)
            //                    {
            //                        [activityIndicatorView stopAnimating];
            //                        VW_overlay.hidden=YES;
            //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //                        [alert show];
            //                    }
            //
            //                    else
            //                    {
            //                        [activityIndicatorView stopAnimating];
            //                        VW_overlay.hidden=YES;
            //
            //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //                        [alert show];
            //                    }
            //                }
            //            }
            //            @catch (NSException *exception)
            //            {
            //                [self sessionOUT];
            //            }
            
        }
        else
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden=YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
}

-(void) watch_API_call_remove
{
    @try {
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
        NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
        
        NSDictionary *auction_item = [jsonReponse valueForKey:@"auction_item"];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@auction/remove_watch/%@",SERVER_URL,[auction_item valueForKey:@"id"]];
        
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:auth_TOK forHTTPHeaderField:@"auth-token"];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (aData)
        {
            //        self->activityIndicatorView.hidden=YES;
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response %@",json_DATA);
            
            
            
            //            @try
            //            {
            //                NSString *STR_error1 = [json_DATA valueForKey:@"error"];
            //                if (STR_error1)
            //                {
            //                    [self sessionOUT];
            //                }
            //                else
            //                {
            if(!json_DATA)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
            NSString *status=[json_DATA valueForKey:@"status"];
            //                    NSString *error=[json_DATA valueForKey:@"errors"];
            //                    NSString *message=[json_DATA valueForKey:@"message"];
            
            if([status isEqualToString:@"Success"])
            {
                [activityIndicatorView stopAnimating];
                VW_overlay.hidden=YES;
                
                
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:status delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                //                        [alert show];
                
                [self GETAuction_Item_details];
                
                
            }
            //
            
            //                    {
            //                        [activityIndicatorView stopAnimating];
            //                        VW_overlay.hidden=YES;
            //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //                        [alert show];
            //                    }
            //
            //                    else
            //                    {
            //                        [activityIndicatorView stopAnimating];
            //                        VW_overlay.hidden=YES;
            //
            //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //                        [alert show];
            //                    }
            //                }
            //            }
            //            @catch (NSException *exception)
            //            {
            //                [self sessionOUT];
            //            }
            
        }
        else
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden=YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    @catch (NSException *exception)
    {
        [self sessionOUT];
    }
}
#pragma mark scroll view delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    for(UIScrollView *scroll in _collection_IMG.subviews)
    {
        scrollView = scroll;
    }
    
    if (scrollView) {
        float pageWidth = _collection_IMG.frame.size.width; // width + space
        
        float currentOffset = _collection_IMG.contentOffset.x;
        float targetOffset = targetContentOffset->x;
        float newTargetOffset = 0;
        
        if (targetOffset > currentOffset)
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
        else
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
        
        if (newTargetOffset < 0)
            newTargetOffset = 0;
        else if (newTargetOffset > _collection_IMG.contentSize.width)
            newTargetOffset = _collection_IMG.contentSize.width;
        
        targetContentOffset->x = currentOffset;
        [_collection_IMG setContentOffset:CGPointMake(newTargetOffset  , _collection_IMG.contentOffset.y) animated:YES];
        //        CGRect visibleRect = (CGRect){.origin = self.collection_IMG.contentOffset, .size = self.collection_IMG.bounds.size};
        CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_IMG.contentOffset.y);
        NSIndexPath *visibleIndexPath = [self.collection_IMG indexPathForItemAtPoint:visiblePoint];
        
        
        self.customStoryboardPageControl.currentPage = visibleIndexPath.row;
        if(_imagesData.count == 0)
        {
            _lbl_count.text = [NSString stringWithFormat:@"%lu of %lu",(long)self.customStoryboardPageControl.currentPage,(unsigned long)_imagesData.count];
        }
        else{
            _lbl_count.text = [NSString stringWithFormat:@"%lu of %lu",(long)self.customStoryboardPageControl.currentPage + 1,(unsigned long)_imagesData.count];
        }
        
    }
    
}


@end

