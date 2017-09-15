//
//  DejalActivityView.m
//  WinningTicket
//
//  Created by Test User on 06/04/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//


#import "DejalActivityView.h"
#import <QuartzCore/QuartzCore.h>


@interface DejalActivityView ()

@property (nonatomic, strong) UIView *originalView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *activityLabel;

@end


// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------


@implementation DejalActivityView

@synthesize originalView, borderView, activityIndicator, activityLabel, labelWidth, showNetworkActivityIndicator;

static DejalActivityView *dejalActivityView = nil;


+ (DejalActivityView *)currentActivityView;
{
    return dejalActivityView;
}


+ (DejalActivityView *)activityViewForView:(UIView *)addToView;
{
    return [self activityViewForView:addToView withLabel:NSLocalizedString(@"Loading...", @"Default DejalActivtyView label text") width:0];
}


+ (DejalActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText;
{
    return [self activityViewForView:addToView withLabel:labelText width:0];
}

+ (DejalActivityView *)activityViewForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)aLabelWidth;
{
    // Immediately remove any existing activity view:
    if (dejalActivityView)
        [self removeView];
    
    // Remember the new view (so this is a singleton):
    dejalActivityView = [[self alloc] initForView:addToView withLabel:labelText width:aLabelWidth];
    
    return dejalActivityView;
}


- (DejalActivityView *)initForView:(UIView *)addToView withLabel:(NSString *)labelText width:(NSUInteger)aLabelWidth;
{
	if (!(self = [super initWithFrame:CGRectZero]))
		return nil;
	
    // Allow subclasses to change the view to which to add the activity view (e.g. to cover the keyboard):
    self.originalView = addToView;
    addToView = [self viewForView:addToView];
    
    // Configure this view (the background) and its subviews:
    [self setupBackground];
    self.labelWidth = aLabelWidth;
    self.borderView = [self makeBorderView];
    self.activityIndicator = [self makeActivityIndicator];
    self.activityLabel = [self makeActivityLabelWithText:labelText];
    
    // Assemble the subviews:
	[addToView addSubview:self];
    [self addSubview:self.borderView];
    [self.borderView addSubview:self.activityIndicator];
    [self.borderView addSubview:self.activityLabel];
    
	// Animate the view in, if appropriate:
	[self animateShow];
    
	return self;
}

- (void)dealloc;
{
    if ([dejalActivityView isEqual:self])
        dejalActivityView = nil;
}


+ (void)removeView;
{
    if (!dejalActivityView)
        return;
    
    if (dejalActivityView.showNetworkActivityIndicator)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [dejalActivityView removeFromSuperview];
    
    // Remove the global reference:
    dejalActivityView = nil;
}


- (UIView *)viewForView:(UIView *)view;
{
    return view;
}


- (CGRect)enclosingFrame;
{
    return self.superview.bounds;
}


- (void)setupBackground;
{
	self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (UIView *)makeBorderView;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    view.opaque = NO;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    return view;
}

- (UIActivityIndicatorView *)makeActivityIndicator;
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [indicator startAnimating];
    
    return indicator;
}

- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.text = labelText;
    
    return label;
}

- (void)layoutSubviews;
{
    self.frame = [self enclosingFrame];
    
    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    CGSize textSize;
    if ([self.activityLabel.text respondsToSelector:@selector(sizeWithAttributes:)]) {
        textSize = [self.activityLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [self.activityLabel.text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
#pragma clang diagnostic pop
    }

    // Use the fixed width if one is specified:
    if (self.labelWidth > 10)
        textSize.width = self.labelWidth;
    
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width, textSize.height);
    
    // Calculate the size and position for the border view: with the indicator to the left of the label, and centered in the receiver:
	CGRect borderFrame = CGRectZero;
    borderFrame.size.width = self.activityIndicator.frame.size.width + textSize.width + 25.0;
    borderFrame.size.height = self.activityIndicator.frame.size.height + 10.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height - 20.0));
    self.borderView.frame = borderFrame;
	
    // Calculate the position of the indicator: vertically centered and at the left of the border view:
    CGRect indicatorFrame = self.activityIndicator.frame;
	indicatorFrame.origin.x = 10.0;
	indicatorFrame.origin.y = 0.5 * (borderFrame.size.height - indicatorFrame.size.height);
    self.activityIndicator.frame = indicatorFrame;
    
    // Calculate the position of the label: vertically centered and at the right of the border view:
	CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = borderFrame.size.width - labelFrame.size.width - 10.0;
	labelFrame.origin.y = floor(0.5 * (borderFrame.size.height - labelFrame.size.height));
    self.activityLabel.frame = labelFrame;
}

- (void)animateShow;
{
    // Does nothing by default
}

- (void)animateRemove;
{
    // Does nothing by default
}


- (void)setShowNetworkActivityIndicator:(BOOL)show;
{
    showNetworkActivityIndicator = show;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = show;
}

@end


// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------


@implementation DejalWhiteActivityView

- (UIActivityIndicatorView *)makeActivityIndicator;
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [indicator startAnimating];
    
    return indicator;
}

- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
{
    UILabel *label = [super makeActivityLabelWithText:labelText];
    
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    
    return label;
}

@end


// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------


@implementation DejalBezelActivityView

- (UIView *)viewForView:(UIView *)view;
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    
    if (keyboardView)
        view = keyboardView.superview;
    
    return view;
}

- (CGRect)enclosingFrame;
{
    CGRect frame = [super enclosingFrame];
    
    if (self.superview != self.originalView)
        frame = [self.originalView convertRect:self.originalView.bounds toView:self.superview];
    
    return frame;
}

- (void)setupBackground;
{
    [super setupBackground];
    
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
}

- (UIView *)makeBorderView;
{
    UIView *view = [super makeBorderView];
    
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    view.layer.cornerRadius = 10.0;
    
    return view;
}

- (UIActivityIndicatorView *)makeActivityIndicator;
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [indicator startAnimating];
    
    return indicator;
}

- (UILabel *)makeActivityLabelWithText:(NSString *)labelText;
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = labelText;
    
    return label;
}

- (void)layoutSubviews;
{
    // If we're animating a transform, don't lay out now, as can't use the frame property when transforming:
    if (!CGAffineTransformIsIdentity(self.borderView.transform))
        return;
    
    self.frame = [self enclosingFrame];
    
    CGSize maxSize = CGSizeMake(260, 400);
    
    CGSize textSize;
    if ([self.activityLabel.text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
        para.lineBreakMode = self.activityLabel.lineBreakMode;
        textSize = [self.activityLabel.text boundingRectWithSize:maxSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
                                                                   NSParagraphStyleAttributeName:para}
                                                         context:nil].size;

    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [self.activityLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
                                       constrainedToSize:maxSize
                                           lineBreakMode:self.activityLabel.lineBreakMode];
#pragma clang diagnostic pop
    }
    
    // Use the fixed width if one is specified:
    if (self.labelWidth > 10)
        textSize.width = self.labelWidth;
    
    // Require that the label be at least as wide as the indicator, since that width is used for the border view:
    if (textSize.width < self.activityIndicator.frame.size.width)
        textSize.width = self.activityIndicator.frame.size.width + 10.0;
    
    // If there's no label text, don't need to allow height for it:
    if (self.activityLabel.text.length == 0)
        textSize.height = 0.0;
    
    self.activityLabel.frame = CGRectMake(self.activityLabel.frame.origin.x, self.activityLabel.frame.origin.y, textSize.width, textSize.height);
    
    // Calculate the size and position for the border view: with the indicator vertically above the label, and centered in the receiver:
	CGRect borderFrame = CGRectZero;
    borderFrame.size.width = textSize.width + 30.0;
    borderFrame.size.height = self.activityIndicator.frame.size.height + textSize.height + 40.0;
    borderFrame.origin.x = floor(0.5 * (self.frame.size.width - borderFrame.size.width));
    borderFrame.origin.y = floor(0.5 * (self.frame.size.height - borderFrame.size.height));
    self.borderView.frame = borderFrame;
	
    // Calculate the position of the indicator: horizontally centered and near the top of the border view:
    CGRect indicatorFrame = self.activityIndicator.frame;
	indicatorFrame.origin.x = 0.5 * (borderFrame.size.width - indicatorFrame.size.width);
	indicatorFrame.origin.y = 20.0;
    self.activityIndicator.frame = indicatorFrame;
    
    // Calculate the position of the label: horizontally centered and near the bottom of the border view:
	CGRect labelFrame = self.activityLabel.frame;
    labelFrame.origin.x = floor(0.5 * (borderFrame.size.width - labelFrame.size.width));
	labelFrame.origin.y = borderFrame.size.height - labelFrame.size.height - 10.0;
    self.activityLabel.frame = labelFrame;
}

- (void)animateShow;
{
    self.alpha = 0.0;
    self.borderView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:5.0];            // Uncomment to see the animation in slow motion
	
    self.borderView.transform = CGAffineTransformIdentity;
    self.alpha = 1.0;
    
	[UIView commitAnimations];
}

- (void)animateRemove;
{
    if (self.showNetworkActivityIndicator)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.borderView.transform = CGAffineTransformIdentity;
    
	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:5.0];            // Uncomment to see the animation in slow motion
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
	
    self.borderView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.alpha = 0.0;
    
	[UIView commitAnimations];
}

- (void)removeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
{
    if([finished boolValue])
    {
        [[self class] removeView];
    }
}

+ (void)removeViewAnimated:(BOOL)animated;
{
    if (!dejalActivityView)
        return;
    
    if (animated)
        [dejalActivityView animateRemove];
    else
        [[self class] removeView];
}

@end


// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------


@implementation DejalKeyboardActivityView

+ (DejalKeyboardActivityView *)activityView;
{
    return [self activityViewWithLabel:NSLocalizedString(@"Loading...", @"Default DejalActivtyView label text")];
}


+ (DejalKeyboardActivityView *)activityViewWithLabel:(NSString *)labelText;
{
    UIView *keyboardView = [[UIApplication sharedApplication] keyboardView];
    
    if (!keyboardView)
        return nil;
    else
        return (DejalKeyboardActivityView *)[self activityViewForView:keyboardView withLabel:labelText];
}

- (UIView *)viewForView:(UIView *)view;
{
    return view;
}


- (void)animateShow;
{
    self.alpha = 0.0;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	
    self.alpha = 1.0;
    
	[UIView commitAnimations];
}


- (void)animateRemove;
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeAnimationDidStop:finished:context:)];
	
    self.alpha = 0.0;
    
	[UIView commitAnimations];
}

- (void)setupBackground;
{
    [super setupBackground];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
}

- (UIView *)makeBorderView;
{
    UIView *view = [super makeBorderView];
    
    view.backgroundColor = nil;
    
    return view;
}

@end


// ----------------------------------------------------------------------------------------
// MARK: -
// ----------------------------------------------------------------------------------------


@implementation UIApplication (KeyboardView)

//  keyboardView
//
//  Copyright Matt Gallagher 2009. All rights reserved.
// 
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.

- (UIView *)keyboardView;
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator])
	{
		for (UIView *view in [window subviews])
		{
            // UIPeripheralHostView is used from iOS 4.0, UIKeyboard was used in previous versions:
			if (!strcmp(object_getClassName(view), "UIPeripheralHostView") || !strcmp(object_getClassName(view), "UIKeyboard"))
			{
				return view;
			}
		}
	}
	
	return nil;
}

@end

