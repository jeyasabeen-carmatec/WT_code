//
//  CSTM_cell_LBL.m
//  WinningTicket
//
//  Created by Test User on 09/06/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "CSTM_cell_LBL.h"

@implementation CSTM_cell_LBL

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setMyLineSpacing:(CGFloat)myLineSpacing
{
    _myLineSpacing = myLineSpacing;
    self.text = self.text;
}

- (void)setText:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = _myLineSpacing;
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:attributes];
    self.attributedText = attributedText;
}

@end
