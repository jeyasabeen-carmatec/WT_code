//
//  VC_liveAuctions.h
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_liveAuctions : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tbl_search;
@property (nonatomic, retain) IBOutlet UILabel *lbl_NoData;
@property (nonatomic, retain) IBOutlet UITableView *auctiontab;

@property (nonatomic, retain) IBOutlet UILabel *lbl_nav_font;
@property (nonatomic, retain) IBOutlet UILabel *lbl_font_small;

@end
