//
//  ARR_singleTON.m
//  WinningTicket
//
//  Created by Test User on 08/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ARR_singleTON.h"

@implementation ARR_singleTON

@synthesize ARR_colection_data,ARR_list_data,Dictin_course;
+(ARR_singleTON *)singleton {
    static dispatch_once_t pred;
    static ARR_singleTON *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ARR_singleTON alloc] init];
        shared.ARR_colection_data = [[NSMutableArray alloc]init];
        shared.ARR_list_data = [[NSMutableArray alloc]init];
    });
    return shared;
}
+(ARR_singleTON*)dictin
{
    static dispatch_once_t pred;
    static ARR_singleTON *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[ARR_singleTON alloc] init];
        shared.Dictin_course = [[NSDictionary alloc]init];
    });
    return shared;
}
+(void) clearData {
    ARR_singleTON *appData = [ARR_singleTON singleton];
    [appData.ARR_colection_data removeAllObjects];
    [appData.ARR_list_data removeAllObjects];
}

@end
