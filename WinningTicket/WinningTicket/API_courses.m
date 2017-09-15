//
//  API_courses.m
//  WinningTicket
//
//  Created by Test User on 31/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "API_courses.h"

@implementation API_courses

-(NSDictionary *)API_courses:(NSString *)url_STR
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    
    NSURL *urlProducts=[NSURL URLWithString:url_STR];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        
        return dict;
    }
    else
    {
        NSDictionary *dictin = [[NSDictionary alloc]initWithObjectsAndKeys:@"Nodata",@"error", nil];
        return dictin;
    }
}

@end
