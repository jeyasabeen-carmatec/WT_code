//
//  VC_howitworks.m
//  WinningTicket
//
//  Created by Test User on 04/04/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_howitworks.h"

@interface VC_howitworks ()

@end

@implementation VC_howitworks

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup_VIEW];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - BTN Actions
-(IBAction)BTN_close:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Setup View
-(void) setup_VIEW
{
    CGRect frame_conent = _VW_contents.frame;
    frame_conent.size.width = _scroll_contents.frame.size.width;
    _VW_contents.frame = frame_conent;
    
    [_scroll_contents addSubview:_VW_contents];
}

-(void)viewDidLayoutSubviews
{
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width, _VW_contents.frame.size.height);
}

@end
