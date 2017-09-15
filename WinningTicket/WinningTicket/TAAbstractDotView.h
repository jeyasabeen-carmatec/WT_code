//
//  TAAbstractDotView.h
//  WinningTicket
//
//  Created by Test User on 21/03/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TAAbstractDotView : UIView


/**
 *  A method call let view know which state appearance it should take. Active meaning it's current page. Inactive not the current page.
 *
 *  @param active BOOL to tell if view is active or not
 */
- (void)changeActivityState:(BOOL)active;


@end

