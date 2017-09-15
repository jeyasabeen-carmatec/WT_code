//
//  DGActivityIndicatorAnimationProtocol.h
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DGActivityIndicatorAnimationProtocol <NSObject>

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor;

@end
