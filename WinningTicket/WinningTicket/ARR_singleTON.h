//
//  ARR_singleTON.h
//  WinningTicket
//
//  Created by Test User on 08/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARR_singleTON : NSObject

@property (nonatomic, retain) NSMutableArray *ARR_colection_data;
@property (nonatomic, retain) NSMutableArray *ARR_list_data;
@property (nonatomic, retain) NSDictionary *Dictin_course;
+(ARR_singleTON*)singleton;
+(ARR_singleTON*)dictin;
+(void) clearData;

@end
