//
//  DragRefreshTableGestureObserver_ot.h
//  WinningTicket
//
//  Created by Test User on 04/03/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DragTableGestureObserver_ot;

@protocol DragTableGestureObserverDelegate_ot <NSObject>

- (void)dragTableGestureStateWillChangeTo:(UIGestureRecognizerState)state observer:(DragTableGestureObserver_ot *)observer;
- (void)dragTableContentOffsetWillChangeTo:(CGPoint)contentOffset observer:(DragTableGestureObserver_ot *)observer;
- (void)dragTableContentSizeWillChangeTo:(CGSize)contentSize observer:(DragTableGestureObserver_ot *)observer;
- (void)dragTableFrameWillChangeTo:(CGRect)contentOffset observer:(DragTableGestureObserver_ot *)observer;

@end

@interface DragTableGestureObserver_ot : NSObject

- (id)initWithObservingTableView:(UITableView *)tableView delegate:(id<DragTableGestureObserverDelegate_ot>)delegate;

@end
