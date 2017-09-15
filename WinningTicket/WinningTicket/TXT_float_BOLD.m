//
//  TXT_float_BOLD.m
//  WinningTicket
//
//  Created by Test User on 04/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "TXT_float_BOLD.h"

@implementation TXT_float_BOLD

#pragma mark :- Drawing Methods
-(void)drawRect:(CGRect)rect {
    [self updateTextField:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(rect), CGRectGetHeight(rect))];
}

#pragma mark :- Loading From NIB
-(void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

#pragma mark :- Initialization Methods
-(instancetype)init {
    if (self) {
        self = [super init];
        [self initialization];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        [self initialization];
    }
    return self;
}

#pragma mark :- Drawing Text Rect
- (CGRect)textRectForBounds:(CGRect)bounds {
    if (showingError) {
        //        return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
        return CGRectMake(10, 6, bounds.size.width, bounds.size.height);
    }else{
        return CGRectMake(10, 6, bounds.size.width, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (showingError) {
        //        return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
        return CGRectMake(10, 6, bounds.size.width, bounds.size.height);
    }else{
        return CGRectMake(10, 6, bounds.size.width, bounds.size.height);
    }
}

#pragma mark:- Override Set text
-(void)setText:(NSString *)text {
    [super setText:text];
    if (text) {
        [self floatTheLabel];
    }
    [self checkForDefaulLabel];
}

-(void)initialization{
    
    self.clipsToBounds = false;
    //HIDE DEFAULT PLACEHOLDER LABEL OF UITEXTFIELD
    
    [self checkForDefaulLabel];
    
    //VARIABLE INITIALIZATIONS
    
    //1. Placeholder Color.
    if (_placeHolderColor == nil){
        _placeHolderColor = [UIColor blackColor];
    }
    
    //2. Placeholder Color When Selected.
    if (_selectedPlaceHolderColor==nil) {
        _selectedPlaceHolderColor = [UIColor blackColor];
    }
    
    //3. Bottom line Color.
    if (_lineColor==nil) {
        _lineColor = [UIColor whiteColor];
    }
    
    //4. Bottom line Color When Selected.
    if (_selectedLineColor==nil) {
        _selectedLineColor = [UIColor whiteColor];
    }
    
    //5. Bottom line error Color.
    if (_errorLineColor==nil) {
        _errorLineColor = [UIColor redColor];
    }
    
    //6. Bottom place Color When show error.
    if (_errorTextColor==nil) {
        _errorTextColor = [UIColor redColor];
    }
    
    /// Adding Bottom Line View.
    //    [self addBottomLineView];
    
    /// Adding Placeholder Label.
    [self addPlaceholderLabel];
    
    /// Adding Error Label
    if (showingError) {
        if ([self.errorText isEqualToString:@""] || self.errorText == nil) {
            self.errorText = @"Error";
        }
        [self addErrorPlaceholderLabel];
    }
    
    /// Placeholder Label Configuration.
    if (![self.text isEqualToString:@""]) {
        
        [self floatTheLabel];
    }
    
}

#pragma mark :- Private Methods
//-(void)addBottomLineView{

//    [bottomLineView removeFromSuperview];
//    bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 2)];
//    bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    bottomLineView.backgroundColor = _lineColor;
//    bottomLineView.tag = 20;
//    [self addSubview:bottomLineView];
//}
-(void)addPlaceholderLabel{
    
    [_labelPlaceholder removeFromSuperview];
    
    if (![self.placeholder isEqualToString:@""]&&self.placeholder!=nil) {
        _labelPlaceholder.text = self.placeholder;
    }
    
    NSString *placeHolderText = _labelPlaceholder.text;
    
    _labelPlaceholder = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width-5, CGRectGetHeight(self.frame))];
    _labelPlaceholder.text = placeHolderText;
    _labelPlaceholder.textAlignment = self.textAlignment;
    _labelPlaceholder.textColor = _placeHolderColor;
    _labelPlaceholder.font = self.font;
    _labelPlaceholder.tag = 21;
    _labelPlaceholder.backgroundColor = [UIColor clearColor];
    [self addSubview:_labelPlaceholder];
    
}

#pragma mark  Adding Error Label in textfield.
-(void)addErrorPlaceholderLabel{
    
    [self endEditing:YES];
    
    [_labelErrorPlaceholder removeFromSuperview];
    
    _labelErrorPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-5, CGRectGetHeight(self.frame))];
    _labelErrorPlaceholder.text = self.errorText;
    _labelErrorPlaceholder.textAlignment = self.textAlignment;
    _labelErrorPlaceholder.textColor = _errorTextColor;
    _labelErrorPlaceholder.tag = 21;
    _labelErrorPlaceholder.backgroundColor = [UIColor clearColor];
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
    {
        _labelErrorPlaceholder.font = [UIFont fontWithName:self.font.fontName size:14];
    }
    else
    {
        _labelErrorPlaceholder.font = [UIFont fontWithName:self.font.fontName size:12];
    }
    
    CGRect frameError = _labelErrorPlaceholder.frame;
    frameError.size.height = 12;
    frameError.origin.y = self.bounds.size.height - frameError.size.height;
    frameError.origin.x = 10;
    
    _labelErrorPlaceholder.frame = frameError;
    
    [self addSubview:_labelErrorPlaceholder];
    _labelErrorPlaceholder.hidden = YES;
    
}

#pragma mark  Method to show Error Label.
-(void)showErrorPlaceHolder{
    
    //    _disableFloatingErrorLabel = NO;
    _labelPlaceholder.hidden = YES;
    _labelErrorPlaceholder.hidden = NO;
    
    //    CGRect bottmLineFrame = bottomLineView.frame;
    //    bottmLineFrame.origin.y = _labelErrorPlaceholder.frame.origin.y-1;
    
    _labelErrorPlaceholder.alpha = 0;
    _labelErrorPlaceholder.frame = CGRectMake(_labelPlaceholder.frame.origin.x + 10, _labelPlaceholder.frame.origin.y-5, _labelPlaceholder.frame.size.width, _labelPlaceholder.frame.size.height);
    
    //    CGRect labelErrorFrame = _labelErrorPlaceholder.frame;
    //    labelErrorFrame.origin.y = labelErrorFrame.origin.y + 6;
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        //        bottomLineView.frame  =  bottmLineFrame;
        //        bottomLineView.backgroundColor = _errorLineColor;
        _labelErrorPlaceholder.alpha = 1;
        _labelErrorPlaceholder.frame = _labelPlaceholder.frame;
        
    }];
    
}

#pragma mark  Method to Hide Error Label.
-(void)hideErrorPlaceHolder
{
    _labelPlaceholder.hidden = NO;
    showingError = NO;
    
    CGRect labelErrorFrame = _labelErrorPlaceholder.frame;
    labelErrorFrame.origin.y = labelErrorFrame.origin.y - 6;
    
    [UIView animateWithDuration:0.2 animations:^{
        _labelErrorPlaceholder.alpha = 0;
        _labelErrorPlaceholder.frame = labelErrorFrame;
    }];
    
}

/// Hadling The Default Placeholder Label
-(void)checkForDefaulLabel{
    
    if ([self.text isEqualToString:@""]) {
        
        for (UIView *view in self.subviews) {
            //            NSLog(@"Frame for view %@ frame :%@",view,NSStringFromCGRect(view.frame));
            
            if ([view isKindOfClass:[UILabel class]]) {
                
                UILabel *newLabel = (UILabel *)view;
                
                if (newLabel.tag!=21) {
                    newLabel.hidden = YES;
                }
            }
        }
    }else{
        
        for (UIView *view in self.subviews) {
            //            NSLog(@"Frame for view %@ frame :%@",view,NSStringFromCGRect(view.frame));
            
            
            if ([view isKindOfClass:[UILabel class]]) {
                
                UILabel *newLabel = (UILabel *)view;
                if (newLabel.tag!=21) {
                    newLabel.hidden = NO;
                }
            }
        }
    }
}

#pragma mark  Update and Manage Subviews
-(void)updateTextField:(CGRect )frame {
    
    self.frame = frame;
    [self initialization];
}

#pragma mark  Float UITextfield Placeholder Label.
-(void)floatPlaceHolder:(BOOL)selected {
    
    if (selected)
    {
        _disableFloatingErrorLabel = YES;
        if (self.disableFloatingLabel){
            _labelPlaceholder.hidden = YES;
            
            
            //            CGRect bottmLineFrame = bottomLineView.frame;
            //            bottmLineFrame.origin.y = CGRectGetHeight(self.frame)-2;
            //            [UIView animateWithDuration:0.2 animations:^{
            //                bottomLineView.frame  =  bottmLineFrame;
            //            }];
            
            return;
            
        }
        
        CGRect frame = _labelPlaceholder.frame;
        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
        {
            frame.origin.y = 3;
            frame.size.height = 15;
        }
        else
        {
            frame.origin.y = 5;
            frame.size.height = 13;
        }
        
        //        CGRect bottmLineFrame = bottomLineView.frame;
        //        bottmLineFrame.origin.y = CGRectGetHeight(self.frame)-2;
        [UIView animateWithDuration:0.2 animations:^{
            _labelPlaceholder.frame = frame;
            if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
            {
                _labelPlaceholder.font = [UIFont fontWithName:@"GothamBold" size:12.0];
            }
            else
            {
                _labelPlaceholder.font = [UIFont fontWithName:@"GothamBold" size:10.0];
            }
            _labelPlaceholder.textColor = _selectedPlaceHolderColor;
            //            bottomLineView.frame  =  bottmLineFrame;
            
        }];
        
    }
    else{
        
        
        
        //        bottomLineView.backgroundColor = _lineColor;
        
        
        if (self.disableFloatingLabel){
            
            _labelPlaceholder.hidden = YES;
            //            CGRect bottmLineFrame = bottomLineView.frame;
            //            bottmLineFrame.origin.y = CGRectGetHeight(self.frame)-2;
            //            [UIView animateWithDuration:0.2 animations:^{
            //                bottomLineView.frame  =  bottmLineFrame;
            //            }];
            
            return;
            
        }
        
        
        CGRect frame = _labelPlaceholder.frame;
        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
        {
            frame.origin.y = 3;
            frame.size.height = 15;
        }
        else
        {
            frame.origin.y = 5;
            frame.size.height = 13;
        }
        //        CGRect bottmLineFrame = bottomLineView.frame;
        //        bottmLineFrame.origin.y = CGRectGetHeight(self.frame)-1;
        [UIView animateWithDuration:0.2 animations:^{
            _labelPlaceholder.frame = frame;
            if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad)
            {
                _labelPlaceholder.font = [UIFont fontWithName:@"GothamBold" size:12.0];
            }
            else
            {
                _labelPlaceholder.font = [UIFont fontWithName:@"GothamBold" size:10.0];
            }
            _labelPlaceholder.textColor = _placeHolderColor;
            //            bottomLineView.frame  =  bottmLineFrame;
            
        }];        
    }
    
}
-(void)resignPlaceholder{
    
    //    bottomLineView.backgroundColor = _lineColor;
    
    if (self.disableFloatingLabel){
        
        _labelPlaceholder.hidden = NO;
        _labelPlaceholder.textColor = _placeHolderColor;
        //        CGRect bottmLineFrame = bottomLineView.frame;
        //        bottmLineFrame.origin.y = CGRectGetHeight(self.frame)-1;
        //        [UIView animateWithDuration:0.2 animations:^{
        //            bottomLineView.frame  =  bottmLineFrame;
        //        }];
        
        return;
        
    }
    
    
    CGRect frame = CGRectMake(10, 5, self.frame.size.width-5, self.frame.size.height-10);
    //    CGRect bottmLineFrame = bottomLineView.frame;
    //    bottmLineFrame.origin.y = CGRectGetHeight(self.frame)-1;
    [UIView animateWithDuration:0.2 animations:^{
        _labelPlaceholder.frame = frame;
        _labelPlaceholder.font = self.font;
        _labelPlaceholder.textColor = _placeHolderColor;
        //        bottomLineView.frame  =  bottmLineFrame;
    }];
    
}
#pragma mark  UITextField Begin Editing.

-(void)textFieldDidBeginEditing {
    if (showingError) {
        [self hideErrorPlaceHolder];
    }
    [self floatTheLabel];
    [self layoutSubviews];
}

#pragma mark  UITextField End Editing.
-(void)textFieldDidEndEditing {
    
    [self floatTheLabel];
    
}

#pragma mark  Float & Resign

-(void)floatTheLabel{
    
    if ([self.text isEqualToString:@""] && self.isFirstResponder) {
        
        [self floatPlaceHolder:YES];
        
    }else if ([self.text isEqualToString:@""] && !self.isFirstResponder) {
        
        [self resignPlaceholder];
        
    }else if (![self.text isEqualToString:@""] && !self.isFirstResponder) {
        
        [self floatPlaceHolder:NO];
        
    }else if (![self.text isEqualToString:@""] && self.isFirstResponder) {
        
        [self floatPlaceHolder:YES];
    }
    
    [self checkForDefaulLabel];
    
}


#pragma mark  Set Placeholder Text On Labels
-(void)setTextFieldPlaceholderText:(NSString *)placeholderText {
    
    self.labelPlaceholder.text = placeholderText;
    [self textFieldDidEndEditing];
}
-(void)setPlaceholder:(NSString *)placeholder {
    
    self.labelPlaceholder.text = placeholder;
    [self textFieldDidEndEditing];
    
}

#pragma mark  Set Placeholder Text On Error Labels
-(void)showError {
    showingError = YES;
    [self updateTextField:self.frame];
    [self showErrorPlaceHolder];
}
-(void)showErrorWithText:(NSString *)errorText {
    _errorText = errorText;
    showingError = YES;
    [self updateTextField:self.frame];
    [self showErrorPlaceHolder];
}
-(void)setErrorText:(NSString *)errorText {
    _errorText = errorText;
}

#pragma mark  UITextField Responder Overide
-(BOOL)becomeFirstResponder {
    
    BOOL result = [super becomeFirstResponder];
    [self textFieldDidBeginEditing];
    return result;
}

-(BOOL)resignFirstResponder {
    
    BOOL result = [super resignFirstResponder];
    [self textFieldDidEndEditing];
    return result;
}

@end
