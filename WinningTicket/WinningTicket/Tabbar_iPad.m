//
//  Tabbar_iPad.m
//  WinningTicket
//
//  Created by Test User on 30/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Tabbar_iPad.h"

@implementation Tabbar_iPad

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
 
}
*/

-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 60.0f;
    
    return sizeThatFits;
}
@end
