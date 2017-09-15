//
//  course_service.m
//  WinningTicket
//
//  Created by Test User on 31/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "course_service.h"
#import "API_courses.h"

@implementation course_service

-(NSDictionary *)get_ID:(NSString *)get_url
{
    NSLog(@"Received Url %@",get_url);
    API_courses *get_JSONDATA = [[API_courses alloc] init];
    
//    NSLog(@"Dictionary from nsobject = %@",[get_JSONDATA API_courses:get_url]);
    return [get_JSONDATA API_courses:get_url];
}


@end
