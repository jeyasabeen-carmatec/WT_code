//
//  selected_course.m
//  WinningTicket
//
//  Created by Test User on 31/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "selected_course.h"

@implementation selected_course
-(NSDictionary *)selected_course:(NSArray *)my_array :(int)indexPath
{
    NSDictionary *temp_dictin = [my_array objectAtIndex:indexPath];
    return temp_dictin;
}
@end
