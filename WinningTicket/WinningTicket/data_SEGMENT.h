//
//  data_SEGMENT.h
//  WinningTicket
//
//  Created by Test User on 18/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol data_SEGMENT <NSObject>

@optional

-(void) get_segment_index : (int)i;
-(void) leave_game_tapped : (NSString *)str;

@end
