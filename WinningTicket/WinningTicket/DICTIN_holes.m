//
//  DICTIN_holes.m
//  WinningTicket
//
//  Created by Test User on 04/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "DICTIN_holes.h"

@implementation DICTIN_holes

+(DICTIN_holes *)dictionary_VAL
{
    static dispatch_once_t pred;
    static DICTIN_holes *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[DICTIN_holes alloc] init];
        shared.Dictin_course = [[NSDictionary alloc]init];
    });
    return shared;
}

@end
