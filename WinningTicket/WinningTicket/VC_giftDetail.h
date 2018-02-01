//
//  VC_giftDetail.h
//  WinningTicket
//
//  Created by Test User on 22/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_giftDetail : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *TBL_content;

@property (weak, nonatomic) IBOutlet UILabel *lbl_nav_title;

@end
