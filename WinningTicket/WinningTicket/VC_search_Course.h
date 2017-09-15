//
//  VC_search_Course.h
//  WinningTicket
//
//  Created by Test User on 31/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_search_Course : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *TBL_places;
@property (nonatomic, retain) IBOutlet UITableView *TBL_courses;

@property (nonatomic, retain) IBOutlet UITextField *TXT_places;
@property (nonatomic, retain) IBOutlet UITextField *TXT_courses;

@property (nonatomic, retain) IBOutlet UIButton *BTN_search_course;

@end
