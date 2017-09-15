//
//  VC_item_deatail.h
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_item_deatail : UIViewController <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate>
{
     NSTimer* golfTimer;
}
//{
//    UIScrollView *scrollView;
//    UIPageControl *pageControl;
//    
//    BOOL pageControlBeingUsed;
//}

@property (weak, nonatomic) IBOutlet UIView *VW_contents;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_contents;
@property (weak,nonatomic) IBOutlet UICollectionView *collection_IMG;
@property(nonatomic,weak) IBOutlet UIView *nav_Bar;
//@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

//- (IBAction)changePage;
@property (weak, nonatomic) UIAlertAction *submit_action;

@property (weak, nonatomic) IBOutlet UILabel *lbl_itemNAME;

@property (weak, nonatomic) IBOutlet UIButton *BTN_place_BID;
@property (weak, nonatomic) IBOutlet UIButton *BTN_watech;

@property (weak, nonatomic) IBOutlet UIView *VW_line1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_titl_item_descrip;
@property (weak, nonatomic) IBOutlet UITextView *lbl_item_descrip;
@property (weak, nonatomic) IBOutlet UIView *VW_line2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title_silar_item;

@property (weak, nonatomic) IBOutlet UICollectionView *collection_similar_item;
@property (weak, nonatomic) IBOutlet UILabel *lbl_count;

@property (retain, nonatomic) IBOutlet UILabel *lbl_CountDown;

@end
