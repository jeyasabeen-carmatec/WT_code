//
//  LBL_verALIGHN.m
//  WinningTicket
//
//  Created by Test User on 26/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "LBL_verALIGHN.h"

@implementation LBL_verALIGHN

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect) rect
{
    NSAttributedString *attributedText = [[NSAttributedString alloc]     initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
    rect.size.height = [attributedText boundingRectWithSize:rect.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil].size.height;
    if (self.numberOfLines != 0) {
        rect.size.height = MIN(rect.size.height, self.numberOfLines * self.font.lineHeight);
    }
    [super drawTextInRect:rect];
}

@end
