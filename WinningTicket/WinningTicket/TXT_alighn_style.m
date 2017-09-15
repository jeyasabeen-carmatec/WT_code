//
//  TXT_alighn_style.m
//  WinningTicket
//
//  Created by Test User on 15/06/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "TXT_alighn_style.h"

@implementation TXT_alighn_style

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y + 5, bounds.size.width - 5, bounds.size.height - 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y + 5, bounds.size.width - 5, bounds.size.height - 10);
}

@end
