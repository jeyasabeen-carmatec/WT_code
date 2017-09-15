//
//  GET_states.h
//  WinningTicket
//
//  Created by Test User on 05/05/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GET_states : NSObject
{
    NSMutableArray *array;
}
@property (strong, nonatomic) NSMutableArray *array;

+ (GET_states *) sharedobject;

@end
