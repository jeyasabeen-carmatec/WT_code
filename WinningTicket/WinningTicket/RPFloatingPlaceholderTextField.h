//
//  RPFloatingPlaceholderTextField.h
//  WinningTicket
//
//  Created by Test User on 21/03/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPFloatingPlaceholderConstants.h"

@interface RPFloatingPlaceholderTextField : UITextField

/**
 Enum to switch between upward and downward animation of the floating label.
 */
@property (nonatomic) RPFloatingPlaceholderAnimationOptions animationDirection;

/**
 The floating label that is displayed above the text field when there is other
 text in the text field.
 */
@property (nonatomic, strong, readonly) UILabel *floatingLabel;

/**
 The color of the floating label displayed above the text field when it is in
 an active state (i.e. the associated text view is first responder).
 
 @discussion Note: Tint color is used by default if this is nil.
 */
@property (nonatomic, strong) UIColor *floatingLabelActiveTextColor;

/**
 The color of the floating label displayed above the text field when it is in
 an inactive state (i.e. the associated text view is not first responder).
 
 @discussion Note: 70% gray is used by default if this is nil.
 */
@property (nonatomic, strong) UIColor *floatingLabelInactiveTextColor;

/**
 The default color of the text field's placeholder text
 
 @discussion Note: 70% gray is used by default if this is nil.
 */
@property (nonatomic, strong) UIColor *defaultPlaceholderColor;

@end
