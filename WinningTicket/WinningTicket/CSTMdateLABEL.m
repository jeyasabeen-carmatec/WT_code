//
//  CSTMdateLABEL.m
//  WinningTicket
//
//  Created by Test User on 08/06/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "CSTMdateLABEL.h"

@implementation CSTMdateLABEL

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    rect = CGRectMake(rect.origin.x + 10, rect.origin.y, rect.size.width, rect.size.height);
    [super drawTextInRect:rect];
}

@end
