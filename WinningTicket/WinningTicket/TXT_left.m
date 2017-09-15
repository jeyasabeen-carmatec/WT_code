//
//  TXT_left.m
//  WinningTicket
//
//  Created by Test User on 31/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "TXT_left.h"

@implementation TXT_left

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

@end
