//
//  VC_viewYourWinningTicket.h
//  WinningTicket
//
//  Created by Test User on 22/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_viewYourWinningTicket : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lbl_navFont;
@property (weak, nonatomic) IBOutlet UITableView *TBL_offers;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_sponser;

@property (weak, nonatomic) IBOutlet UILabel *lbl_noSponser;

@property (weak, nonatomic) IBOutlet UIButton *BTN_back;


@end

