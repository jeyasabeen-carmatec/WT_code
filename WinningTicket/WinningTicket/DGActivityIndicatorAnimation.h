//
//  DGActivityIndicatorAnimation.h
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DGActivityIndicatorAnimationProtocol.h"

@interface DGActivityIndicatorAnimation : NSObject <DGActivityIndicatorAnimationProtocol>

- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath;
- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath;
- (CAAnimationGroup *)createAnimationGroup;

@end
