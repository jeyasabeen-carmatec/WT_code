//
//  Get_custom_TXTT.m
//  WinningTicket
//
//  Created by Test User on 22/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Get_custom_TXTT.h"

@implementation Get_custom_TXTT

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 5, bounds.size.width, bounds.size.height - 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 5, bounds.size.width, bounds.size.height - 10);
}

@end
