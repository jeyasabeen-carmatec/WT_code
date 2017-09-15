//
//  VC_termsofUSE.m
//  WinningTicket
//
//  Created by Test User on 05/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_termsofUSE.h"

@interface VC_termsofUSE ()

@end

@implementation VC_termsofUSE

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup_VIEW];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _lbl_contents.frame.size.height);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIView Custom

-(void) setup_VIEW
{
    NSString *str_update = @"Terms last update:";
    NSString *str_date = @"March 27, 2017";
    NSString *str_title = @"Important Notice:";
    NSString *str_title_contents = @"asdsa asd asd ad";
    NSString *str_heading = @"1. Acceptance of Terms";
    NSString *str_headdata = @"jasd kajshdasd asodasda bd";
    
    NSString *text = [NSString stringWithFormat:@"%@ %@\n\n%@ %@\n\n%@\n%@",str_update,str_date,str_title,str_title_contents,str_heading,str_headdata];
    
    text = [text stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
    text = [text stringByReplacingOccurrencesOfString:@"(null)" withString:@"Not Mentioned"];
    

    if ([self.lbl_contents respondsToSelector:@selector(setAttributedText:)]) {
        
    
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: self.lbl_contents.textColor,
                                  NSFontAttributeName: self.lbl_contents.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
        NSRange cmp = [text rangeOfString:str_update];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:21.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:16.0]}
                                    range:cmp];
        }
        
        NSRange ranDATE = [text rangeOfString:str_date];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Italic" size:23.0]}
                                    range:ranDATE];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Italic" size:18.0]}
                                    range:ranDATE];
        }
        
        NSRange rantitl = [text rangeOfString:str_title];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:23.0]}
                                    range:rantitl];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]}
                                    range:rantitl];
        }
        
        NSRange rantitl_content = [text rangeOfString:str_heading];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:25.0]}
                                    range:rantitl_content];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:19.0]}
                                    range:rantitl_content];
        }
        
        self.lbl_contents.attributedText = attributedText;
    }
    else
    {
        self.lbl_contents.text = text;
    }
    
    self.lbl_contents.numberOfLines = 0;
    [self.lbl_contents sizeToFit];
}

#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
