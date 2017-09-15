//
//  TableViewController.h
//  Test
//
//  Created by Test User on 23/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *population;

@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@end
