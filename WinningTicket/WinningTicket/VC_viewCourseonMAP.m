//
//  VC_viewCourseonMAP.m
//  WinningTicket
//
//  Created by Test User on 05/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_viewCourseonMAP.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "HMSegmentedControl.h"

@interface VC_viewCourseonMAP ()<CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D loc_start;
    CLLocationCoordinate2D loc_end;
    CLLocationCoordinate2D loc_middle;
    CLLocationCoordinate2D loc_m1;
    CLLocationCoordinate2D loc_m2;
}

@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;

@end


@implementation VC_viewCourseonMAP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(setep_VIEW) withObject:activityIndicatorView afterDelay:0.01];

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
//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
//        [self performSelector:@selector(setep_VIEW) withObject:activityIndicatorView afterDelay:0.01];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 100.0;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
}

-(UIGestureRecognizer *) handlePan:(UILongPressGestureRecognizer*)sender {
    NSLog(@"working");
    sender.minimumPressDuration = 0.0;
    return sender;
    
}
#pragma mark - SETUP VIEW
-(void) setep_VIEW
{
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:2.0];
//    marker.position = coordindates;
//    [CATransaction commit];
    
//    double latitude_val = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lat_STR"]] doubleValue];
//    double longitude_val = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"long_STR"]] doubleValue];
    
    _VW_score.layer.cornerRadius = 5.0f;
    _VW_score.layer.masksToBounds = YES;
    
    _lbl_par.text = _STR_parSTR;
    _lbl_hole.text = _STR_holeSTR;
    _lbl_yards.text = _STR_yards;
    
    loc_start = CLLocationCoordinate2DMake(47.38135479698122, -122.26435018374639);
    loc_end = CLLocationCoordinate2DMake(47.383449, -122.267364);
    loc_middle = [self findCenterPoint:loc_start :loc_end];
    
    loc_m1 = [self findCenterPoint:loc_start :loc_middle];
    loc_m2 = [self findCenterPoint:loc_end :loc_middle];
    
    self.mapView.mapType = kGMSTypeHybrid;
//    for (id gestureRecognizer in self.mapView.gestureRecognizers)
//    {
//        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
//        {
//            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]init];
//            longPressGestureRecognizer.minimumPressDuration = 0.0;
//            longPressGestureRecognizer.delegate = self;
//            [self.mapView addGestureRecognizer:longPressGestureRecognizer];
//        }
//    }
    
    for (UIGestureRecognizer *gestureRecognizer in self.mapView.gestureRecognizers) {
//
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        {
//            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]init];
            [gestureRecognizer addTarget:self action:@selector(handlePan:)];
//            longPressGestureRecognizer.delegate = self;
//            [self.mapView addGestureRecognizer:longPressGestureRecognizer];
        }
    }
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:loc_middle.latitude
                                                            longitude:loc_middle.longitude
                                                                 zoom:16];
    //    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    [self.mapView animateToCameraPosition:camera];
    self.mapView.settings.compassButton = YES;
    
    
//    CLLocationCoordinate2D target =
//    CLLocationCoordinate2DMake(-122.269083337, 151.208);
//    self.mapView.camera = [GMSCameraPosition cameraWithTarget:target zoom:18];
    
    
    
    
    for (int i = 0; i < 5; i ++) {
        switch (i) {
            case 0:
            {
//                UIImage *image_icon = [UIImage imageNamed:@"GOlf-Icon"];
                UIImageView *img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
                img_icon.backgroundColor = self.view.tintColor;
                img_icon.layer.cornerRadius = 8;
                img_icon.layer.masksToBounds = YES;
//                img_icon.image = [UIImage imageNamed:@"GOlf-Icon"];
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_start;
                marker.title = @"Player name";
//                marker.icon = image_icon;
                marker.iconView = img_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
//                GMSCircle *circ = [GMSCircle circleWithPosition:loc_start
//                                                         radius:20];
//                circ.map = self.mapView;
                marker.accessibilityFrame = CGRectMake(marker.accessibilityFrame.origin.x, marker.accessibilityFrame.origin.y+20, marker.accessibilityFrame.size.width, marker.accessibilityFrame.size.height);
                marker.map = self.mapView;
                marker.draggable = true;
            }
                break;
                
            case 1:
            {
                UIImageView *img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
                img_icon.backgroundColor = [UIColor whiteColor];
                img_icon.layer.cornerRadius = 11;
                img_icon.layer.masksToBounds = YES;
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_end;
                marker.title = @"Hole";
                marker.iconView = img_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
//                CGRect frame_marker = marker.iconView.frame;
//                frame_marker.origin.x = 5;
//                frame_marker.origin.y = -5;
                marker.map = self.mapView;
                marker.draggable = true;
            }
                break;
                
            case 2:
            {
                UIImageView *img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                img_icon.backgroundColor = [UIColor whiteColor];
                img_icon.layer.cornerRadius = 20;
                img_icon.layer.masksToBounds = YES;
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_middle;
                marker.title = @"Middle";
                marker.iconView = img_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
//                CGRect frame_marker = marker.iconView.frame;
//                frame_marker.origin.x = 5;
//                frame_marker.origin.y = -5;
                marker.map = self.mapView;
                marker.draggable = true;
            }
                break;
                
            case 3:
            {
                UILabel *lbl_icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                CLLocation *loc1 = [[CLLocation alloc]  initWithLatitude:loc_start.latitude longitude:loc_start.longitude];
                CLLocation *loc2 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
                CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
                lbl_icon.text = [NSString stringWithFormat:@"%3.0f",distance];
                lbl_icon.textAlignment = NSTextAlignmentCenter;
                lbl_icon.font = [UIFont fontWithName:@"GothamMedium" size:10.0];
                lbl_icon.backgroundColor = [UIColor whiteColor];
                lbl_icon.layer.cornerRadius = 15;
                lbl_icon.layer.masksToBounds = YES;
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_m1;
                marker.title = @"M1";
                marker.iconView = lbl_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
                //                CGRect frame_marker = marker.iconView.frame;
                //                frame_marker.origin.x = 5;
                //                frame_marker.origin.y = -5;
                marker.map = self.mapView;
            }
                break;
                
            case 4:
            {
                UILabel *lbl_icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                CLLocation *loc1 = [[CLLocation alloc]  initWithLatitude:loc_end.latitude longitude:loc_end.longitude];
                CLLocation *loc2 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
                CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
                lbl_icon.text = [NSString stringWithFormat:@"%3.0f",distance];
                lbl_icon.textAlignment = NSTextAlignmentCenter;
                lbl_icon.font = [UIFont fontWithName:@"GothamMedium" size:10.0];
                lbl_icon.backgroundColor = [UIColor whiteColor];
                lbl_icon.layer.cornerRadius = 15;
                lbl_icon.layer.masksToBounds = YES;
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_m2;
                marker.title = @"m2";
                marker.iconView = lbl_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
                //                CGRect frame_marker = marker.iconView.frame;
                //                frame_marker.origin.x = 5;
                //                frame_marker.origin.y = -5;
                marker.map = self.mapView;
            }
                break;
                
            default:
                break;
        }
    }
    

    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:loc_start];
    [path addCoordinate:loc_m1];
    [path addCoordinate:loc_middle];
    [path addCoordinate:loc_m2];
    [path addCoordinate:loc_end];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor whiteColor];
    polyline.strokeWidth = 3.f;
    polyline.map = self.mapView;
    
    CLLocation *loc1 = [[CLLocation alloc]  initWithLatitude:loc_start.latitude longitude:loc_start.longitude];
    CLLocation *loc2 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    
    CLLocation *loc3 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
    CLLocation *loc4 = [[CLLocation alloc]  initWithLatitude:loc_end.latitude longitude:loc_end.longitude];
    CLLocationDistance distance1 = [loc3 distanceFromLocation:loc4];
    
    _lbl_yardsToHole.text = [NSString stringWithFormat:@"%.0f",distance + distance1];
    
    CGRect frame_BTN = _BTN_viewonMAP.frame;
    frame_BTN.size.width = (self.mapView.frame.size.width / 5) + 20;
    frame_BTN.size.height = (self.mapView.frame.size.width / 5) + 20;
    _BTN_viewonMAP.frame = frame_BTN;
    
    UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame_BTN.size.width, frame_BTN.size.height)];
    lbl_title.numberOfLines = 3;
    lbl_title.textAlignment = NSTextAlignmentCenter;
    lbl_title.textColor = [UIColor whiteColor];
    lbl_title.font = [UIFont fontWithName:@"GothamMedium" size:13.0];
    lbl_title.text = @"VIEW\nCOURSE\nMAP";
    
    //    _BTN_viewonMAP.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    _BTN_viewonMAP.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _BTN_viewonMAP.titleLabel.text = STR_title;
    [_BTN_viewonMAP addSubview:lbl_title];
    
    _BTN_viewonMAP.layer.shadowColor = [UIColor blackColor].CGColor;
    _BTN_viewonMAP.layer.shadowOffset = CGSizeMake(0, 5.0f);
    _BTN_viewonMAP.layer.shadowRadius = 6.0f;
    _BTN_viewonMAP.layer.shadowOpacity = 0.5f;
    _BTN_viewonMAP.layer.cornerRadius = _BTN_viewonMAP.frame.size.width / 2;
    _BTN_viewonMAP.layer.masksToBounds = NO;
    _BTN_viewonMAP.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_BTN_viewonMAP.bounds cornerRadius:_BTN_viewonMAP.layer.cornerRadius].CGPath;
    
    [_BTN_leaveGame addTarget:self action:@selector(ACTN_leaveGame) forControlEvents:UIControlEventTouchUpInside];
    
    _lbl_navTITLE.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_name"];
    
    [self addSEgmentedControl];
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    self.segmentedControl4.userInteractionEnabled = YES;
    
}


- (CLLocationCoordinate2D)findCenterPoint:(CLLocationCoordinate2D)c1 :(CLLocationCoordinate2D)c2
{
    c1.latitude = ToRadian(c1.latitude);
    c2.latitude = ToRadian(c2.latitude);
    CLLocationDegrees dLon = ToRadian(c2.longitude - c1.longitude);
    CLLocationDegrees bx = cos(c2.latitude) * cos(dLon);
    CLLocationDegrees by = cos(c2.latitude) * sin(dLon);
    CLLocationDegrees latitude = atan2(sin(c1.latitude) + sin(c2.latitude), sqrt((cos(c1.latitude) + bx) * (cos(c1.latitude) + bx) + by*by));
    CLLocationDegrees longitude = ToRadian(c1.longitude) + atan2(by, cos(c1.latitude) + bx);
    
    CLLocationCoordinate2D midpointCoordinate;
    midpointCoordinate.longitude = ToDegrees(longitude);
    midpointCoordinate.latitude = ToDegrees(latitude);
    
    return midpointCoordinate;
}

#pragma mark - Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:@"lat_STR"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:@"long_STR"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    manager.delegate = nil;
    
//   [self setep_VIEW];
    
   /* for (id gestureRecognizer in self.mapView.gestureRecognizers)
    {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]init];
            longPressGestureRecognizer.minimumPressDuration = 0.0;
            longPressGestureRecognizer.delegate = self;
            [self.mapView addGestureRecognizer:longPressGestureRecognizer];
        }
    }*/
    
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
//    [self performSelector:@selector(setep_VIEW) withObject:activityIndicatorView afterDelay:0.01];
    
    /* GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
     longitude:newLocation.coordinate.longitude
     zoom:6];
         _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
     [self.mapView animateToCameraPosition:camera];*/
    
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//-(void)lockLongPress
//{
//    NSLog(@"Long press");
//}

#pragma mark - Google map deligate
-(void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker{
//    if ([marker.userData isEqualToString:@"xMark"])
        NSLog(@"marker dragged to location: %f,%f", marker.position.latitude, marker.position.longitude);
    if ([marker.title isEqualToString:@"Hole"])
    {
        loc_end = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude);
    }
    else if ([marker.title isEqualToString:@"Middle"])
    {
        loc_middle = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude);
    }
    else
    {
        loc_start = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude);
    }
}
- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    [self.mapView clear];
    
    if ([marker.title isEqualToString:@"Hole"])
    {
        loc_end = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude);
    }
    else if ([marker.title isEqualToString:@"Middle"])
    {
        loc_middle = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude);
    }
    else
    {
        loc_start = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude);
    }
    
    loc_m1 = [self findCenterPoint:loc_start :loc_middle];
    loc_m2 = [self findCenterPoint:loc_end :loc_middle];
    
    for (int i = 0; i < 5; i ++) {
        switch (i) {
            case 0:
            {
                UIImageView *img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
                img_icon.backgroundColor = self.view.tintColor;
                img_icon.layer.cornerRadius = 8;
                img_icon.layer.masksToBounds = YES;
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_start;
                marker.title = @"Player name";
                marker.iconView = img_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
                marker.map = self.mapView;
                marker.draggable = true;
            }
                break;
                
            case 1:
            {
                UIImageView *img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
                img_icon.backgroundColor = [UIColor whiteColor];
                img_icon.layer.cornerRadius = 11;
                img_icon.layer.masksToBounds = YES;
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_end;
                marker.title = @"Hole";
                marker.iconView = img_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
                marker.map = self.mapView;
                marker.draggable = true;
            }
                break;
                
            case 2:
            {
                UIImageView *img_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                img_icon.backgroundColor = [UIColor whiteColor];
                img_icon.layer.cornerRadius = 20;
                img_icon.layer.masksToBounds = YES;
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_middle;
                marker.title = @"Middle";
                marker.iconView = img_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
                marker.map = self.mapView;
                marker.draggable = true;
            }
                break;
                
            case 3:
            {
                UILabel *lbl_icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                CLLocation *loc1 = [[CLLocation alloc]  initWithLatitude:loc_start.latitude longitude:loc_start.longitude];
                CLLocation *loc2 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
                CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
                lbl_icon.text = [NSString stringWithFormat:@"%3.0f",distance];
                lbl_icon.textAlignment = NSTextAlignmentCenter;
                lbl_icon.font = [UIFont fontWithName:@"GothamMedium" size:10.0];
                lbl_icon.backgroundColor = [UIColor whiteColor];
                lbl_icon.layer.cornerRadius = 15;
                lbl_icon.layer.masksToBounds = YES;
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_m1;
                marker.title = @"M1";
                marker.iconView = lbl_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
                //                CGRect frame_marker = marker.iconView.frame;
                //                frame_marker.origin.x = 5;
                //                frame_marker.origin.y = -5;
                marker.map = self.mapView;
            }
                break;
                
            case 4:
            {
                UILabel *lbl_icon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                CLLocation *loc1 = [[CLLocation alloc]  initWithLatitude:loc_end.latitude longitude:loc_end.longitude];
                CLLocation *loc2 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
                CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
                lbl_icon.text = [NSString stringWithFormat:@"%3.0f",distance];
                lbl_icon.textAlignment = NSTextAlignmentCenter;
                lbl_icon.font = [UIFont fontWithName:@"GothamMedium" size:10.0];
                lbl_icon.backgroundColor = [UIColor whiteColor];
                lbl_icon.layer.cornerRadius = 15;
                lbl_icon.layer.masksToBounds = YES;
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = loc_m2;
                marker.title = @"m2";
                marker.iconView = lbl_icon;
                marker.groundAnchor = CGPointMake(0.5, 0.5);
                //    [marker setDraggable: YES];
                //                CGRect frame_marker = marker.iconView.frame;
                //                frame_marker.origin.x = 5;
                //                frame_marker.origin.y = -5;
                marker.map = self.mapView;
            }
                break;
                
            default:
                break;
        }
    }
    
    CLLocation *loc1 = [[CLLocation alloc]  initWithLatitude:loc_start.latitude longitude:loc_start.longitude];
    CLLocation *loc2 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    
    CLLocation *loc3 = [[CLLocation alloc]  initWithLatitude:loc_middle.latitude longitude:loc_middle.longitude];
    CLLocation *loc4 = [[CLLocation alloc]  initWithLatitude:loc_end.latitude longitude:loc_end.longitude];
    CLLocationDistance distance1 = [loc3 distanceFromLocation:loc4];
    
    _lbl_yardsToHole.text = [NSString stringWithFormat:@"%.0f",distance + distance1];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:loc_start];
    [path addCoordinate:loc_m1];
    [path addCoordinate:loc_middle];
    [path addCoordinate:loc_m2];
    [path addCoordinate:loc_end];;
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor whiteColor];
    polyline.strokeWidth = 3.f;
    polyline.map = self.mapView;
    
    NSLog(@"marker dragging to location: %f,%f", marker.position.latitude, marker.position.longitude);
}


//#pragma mark - Button IBACTIONS
//-(IBAction)BTN_back:(id)sender
//{
//    [self dismiss_COntroller];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


-(void) dismiss_COntroller
{

//    [activityIndicatorView stopAnimating];
//    VW_overlay.hidden = YES;
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - ACTION Buttons
-(void) ACTN_leaveGame
{
    
    self.segmentedControl4.userInteractionEnabled = NO;
    _BTN_viewonMAP.userInteractionEnabled = NO;
    
    _VW_end_Game.center = self.view.center;
    _VW_end_Game.layer.cornerRadius = 5.0f;
    _VW_end_Game.layer.masksToBounds = YES;
    
    VW_overlay.hidden= NO;
    _VW_end_Game.hidden = NO;
    [VW_overlay addSubview:_VW_end_Game];
    
    [_BTN_End_game addTarget:self action:@selector(ACT_leave_game) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_continue_playing addTarget:self action:@selector(ACT_continue_playing) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void) ACT_leave_game
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(_segmentdelegate && [_segmentdelegate respondsToSelector:@selector(leave_game_tapped:)])
    {
        [_segmentdelegate leave_game_tapped:@"leave_Game"]; 
    }
}
-(void) ACT_continue_playing
{
    self.segmentedControl4.userInteractionEnabled = YES;
       
    _VW_end_Game.hidden = YES;
    VW_overlay.hidden = YES;
}
#pragma mark - add Custom Segmentcontrol
-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    self.segmentedControl4.sectionTitles = @[@"SCOREBOARD  \t",@"  \tLEADERBOARD"];
    
    UIFont *font_name = [UIFont fontWithName:@"GothamBold" size:12];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 0.50 * font_name.lineHeight;
    self.segmentedControl4.backgroundColor = [UIColor blackColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:font_name};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:font_name};
    self.segmentedControl4.selectionIndicatorColor = [UIColor blackColor];
    //    self.segmentedControl4.selectionIndicatorColor
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.selectionIndicatorHeight = 7.0f;
    
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl4];
    _BTN_viewonMAP.center = _VW_segment.center;
    
    CGRect rect_BTN = _BTN_viewonMAP.frame;
    rect_BTN.origin.y = _BTN_viewonMAP.frame.origin.y - 10;
    _BTN_viewonMAP.frame = rect_BTN;
    
    [self.view addSubview:_BTN_viewonMAP];
    
    [self.segmentedControl4 setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
//    self.segmentedControl4.userInteractionEnabled = NO;
    _BTN_viewonMAP.userInteractionEnabled = NO;
}

#pragma mark - Segment Button IBACTION
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged) aaa", (long)segmentedControl4.selectedSegmentIndex);
    switch (segmentedControl4.selectedSegmentIndex) {
        case 0:
            NSLog(@"Index 0");
            [self dismissViewControllerAnimated:YES completion:nil];
            if(_segmentdelegate && [_segmentdelegate respondsToSelector:@selector(get_segment_index:)])
            {
                [_segmentdelegate get_segment_index:0];
            }
            break;
            
        case 1:
            [self dismissViewControllerAnimated:YES completion:nil];
            if(_segmentdelegate && [_segmentdelegate respondsToSelector:@selector(get_segment_index:)])
            {
                [_segmentdelegate get_segment_index:1];
            }
            break;
            
        case 2:
            NSLog(@"Index 2");
            break;
            
        default:
            break;
    }
}

@end