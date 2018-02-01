//
//  ARR_grossScore.m
//  WinningTicket
//
//  Created by Test User on 04/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ARR_grossScore.h"

@implementation ARR_grossScore
+(ARR_grossScore *)ARR_values
{
    static dispatch_once_t pred;
    static ARR_grossScore *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ARR_grossScore alloc] init];
        shared.ARR_score = [[NSMutableArray alloc]init];
    });
    return shared;
}
+(void) Clear_ARR {
    ARR_grossScore *appData = [ARR_grossScore ARR_values];
    [appData.ARR_score removeAllObjects];
}
@end
