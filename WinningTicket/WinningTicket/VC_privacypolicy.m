//
//  VC_privacypolicy.m
//  WinningTicket
//
//  Created by Test User on 05/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_privacypolicy.h"

@interface VC_privacypolicy ()

@end

@implementation VC_privacypolicy

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup_view];
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
-(void) setup_view
{
    NSString *str_update = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.\n\nQuisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc\n\nCras id dui. Aenean ut eros et nisl sagittis vestibulum. Nullam nulla eros, ultricies sit amet, nonummy id, imperdiet feugiat, pede. Sed lectus. Donec mollis hendrerit risus. Phasellus nec sem in justo pellentesque facilisis. Etiam imperdiet imperdiet orci. Nunc nec neque. Phasellus leo dolor, tempus non, auctor et, hendrerit quis, nisi. Curabitur ligula sapien, tincidunt non, euismod vitae, posuere imperdiet, leo. Maecenas malesuada. Praesent congue erat at massa. Sed cursus turpis vitae tortor. Donec posuere vulputate arcu. Phasellus accumsan cursus velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed aliquam, nisi quis porttitor congue, elit erat euismod orci, ac placerat dolor lectus quis orci. Phasellus consectetuer vestibulum elit. Aenean tellus metus, bibendum sed, posuere ac, mattis non, nunc. Vestibulum fringilla pede sit amet augue. In turpis. Pellentesque posuere. Praesent turpis. Aenean posuere, tortor sed cursus feugiat, nunc augue blandit nunc, eu sollicitudin urna dolor sagittis lacus. Donec elit libero, sodales nec, volutpat a, suscipit non, turpis. Nullam sagittis. Suspendisse pulvinar, augue ac venenatis condimentum, sem libero volutpat nibh, nec pellentesque velit pede quis nunc.\n\nVestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Fusce id purus. Ut varius tincidunt libero. Phasellus dolor. Maecenas vestibulum mollis diam. Pellentesque ut neque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. In dui magna, posuere eget, vestibulum et, tempor auctor, justo. In ac felis quis tortor malesuada pretium. Pellentesque auctor neque nec urna. Proin sapien ipsum, porta a, auctor quis, euismod ut, mi. Aenean viverra rhoncus pede. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Ut non enim eleifend felis pretium feugiat. Vivamus quis mi. Phasellus a est. Phasellus magna. In hac habitasse platea dictumst. Curabitur at lacus ac velit ornare lobortis. Curabitur a felis in nunc fringilla tristique.";
//    NSString *str_date = @"March 27, 2017";
//    NSString *str_title = @"Important Notice:";
//    NSString *str_title_contents = @"asdsa asd asd ad";
//    NSString *str_heading = @"1. Acceptance of Terms";
//    NSString *str_headdata = @"jasd kajshdasd asodasda bd";
    
    NSString *text = [NSString stringWithFormat:@"%@",str_update];
    
    text = [text stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
    text = [text stringByReplacingOccurrencesOfString:@"(null)" withString:@"Not Mentioned"];
    
    
//    if ([self.lbl_contents respondsToSelector:@selector(setAttributedText:)]) {
//        
//        
//        NSDictionary *attribs = @{
//                                  NSForegroundColorAttributeName: self.lbl_contents.textColor,
//                                  NSFontAttributeName: self.lbl_contents.font
//                                  };
//        NSMutableAttributedString *attributedText =
//        [[NSMutableAttributedString alloc] initWithString:text
//                                               attributes:attribs];
//        
//        NSRange cmp = [text rangeOfString:str_update];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:21.0]}
//                                    range:cmp];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:16.0]}
//                                    range:cmp];
//        }
//        
//        NSRange ranDATE = [text rangeOfString:str_date];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Italic" size:23.0]}
//                                    range:ranDATE];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Italic" size:18.0]}
//                                    range:ranDATE];
//        }
//        
//        NSRange rantitl = [text rangeOfString:str_title];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:23.0]}
//                                    range:rantitl];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]}
//                                    range:rantitl];
//        }
//        
//        NSRange rantitl_content = [text rangeOfString:str_heading];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:25.0]}
//                                    range:rantitl_content];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:19.0]}
//                                    range:rantitl_content];
//        }
//        
//        self.lbl_contents.attributedText = attributedText;
//    }
//    else
//    {
        self.lbl_contents.text = text;
//    }
    
    self.lbl_contents.numberOfLines = 0;
    [self.lbl_contents sizeToFit];
}

#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
