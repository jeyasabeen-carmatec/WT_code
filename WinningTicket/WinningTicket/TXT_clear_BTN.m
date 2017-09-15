//
//  TXT_clear_BTN.m
//  WinningTicket
//
//  Created by Test User on 02/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "TXT_clear_BTN.h"

@implementation TXT_clear_BTN

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
}


-(CGRect)rightViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.size.width - 30, bounds.origin.y+5, 20, 20);
}

@end
