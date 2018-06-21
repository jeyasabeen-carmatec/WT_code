//
//  VC_Virtualbag_list.h
//  WinningTicket
//
//  Created by Test User on 22/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_Virtualbag_list : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *TBL_listGIFTS;
@property (weak, nonatomic) IBOutlet UILabel *lbl_nogift;

@property (weak, nonatomic) IBOutlet UILabel *lbl_nav_font;
@property (weak, nonatomic) IBOutlet UIButton *BTN_back;

@end

