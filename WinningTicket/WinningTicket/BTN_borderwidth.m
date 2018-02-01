//
//  BTN_borderwidth.m
//  WinningTicket
//
//  Created by Test User on 25/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "BTN_borderwidth.h"

@implementation BTN_borderwidth

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
