//
//  DGActivityIndicatorAnimation.m
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import "DGActivityIndicatorAnimation.h"

@implementation DGActivityIndicatorAnimation

- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAAnimationGroup *)createAnimationGroup {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.removedOnCompletion = NO;
    return animationGroup;
}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
}

@end
