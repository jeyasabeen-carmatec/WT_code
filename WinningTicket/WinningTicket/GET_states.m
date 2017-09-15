//
//  GET_states.m
//  WinningTicket
//
//  Created by Test User on 05/05/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "GET_states.h"

@implementation GET_states
@synthesize array;

static GET_states*  _sharedobject=nil;

+ (GET_states *)sharedobject
{
    @synchronized([GET_states class])
    {
        if (!_sharedobject)
            _sharedobject=[[self alloc] init];
        
        return _sharedobject;
    }
    
    return nil;
}

+ (id) alloc
{
    @synchronized([GET_states class])
    {
        NSAssert(_sharedobject == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedobject = [super alloc];
        return _sharedobject;
    }
    return nil;
}

@end

