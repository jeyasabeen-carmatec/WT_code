//
//  ScoreCell2.m
//  WinningTicket
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ScoreCell2.h"

@implementation ScoreCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected == YES && animated == YES) {
        UIView * selectedBackgroundView = [[UIView alloc] init];
        [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:0.5]]; // set color here
        selectedBackgroundView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y
, [UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height);
        [self.contentView addSubview:selectedBackgroundView];
    }
    
}

@end
