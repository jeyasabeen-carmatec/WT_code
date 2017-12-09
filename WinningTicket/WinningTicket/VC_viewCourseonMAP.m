//
//  VC_viewCourseonMAP.m
//  WinningTicket
//
//  Created by Test User on 05/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_viewCourseonMAP.h"

@interface VC_viewCourseonMAP ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation VC_viewCourseonMAP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(void)viewWillAppear:(BOOL)animated
{
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
    
    [self checkApplicationHasLocationServicesPermission];
}

#pragma mark - GET location service Enabled
-(void) checkApplicationHasLocationServicesPermission {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please allow acess to location services" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }
    else
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(setep_VIEW) withObject:activityIndicatorView afterDelay:0.01];
    }
}

#pragma mark - SETUP VIEW
-(void) setep_VIEW
{
    
    _mapView.mapType = kGMSTypeHybrid;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:47.242624
                                                            longitude:-68.201332
                                                                 zoom:12];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

#pragma mark - Button IBACTIONS
-(IBAction)BTN_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
