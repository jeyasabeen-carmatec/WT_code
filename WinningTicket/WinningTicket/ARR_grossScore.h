//
//  ARR_grossScore.h
//  WinningTicket
//
//  Created by Test User on 04/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARR_grossScore : NSData
@property (nonatomic, retain) NSMutableArray *ARR_score;
+(ARR_grossScore *)ARR_values;
+(void)Clear_ARR;
@end
