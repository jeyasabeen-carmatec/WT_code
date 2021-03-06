//
//  VC_courses.m
//  WinningTicket
//
//  Created by Test User on 02/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_courses.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "HMSegmentedControl.h"
#import "course_service.h"
#import "ARR_singleTON.h"

#import "UIImageView+WebCache.h"
#import "WinningTicket_Universal-Swift.h"

#import "ViewController.h"

//@interface ARR_singleTON : NSObject
//@property (nonatomic, retain) NSMutableArray *ARR_colection_data;
//@property (nonatomic, retain) NSMutableArray *ARR_list_data;
//@property (nonatomic, retain) NSDictionary *Dictin_course;
//+(ARR_singleTON*)singleton;
//+(void) clearData;
//@end
//@implementation ARR_singleTON
//@synthesize ARR_colection_data,ARR_list_data,Dictin_course;
//+(ARR_singleTON *)singleton {
//    static dispatch_once_t pred;
//    static ARR_singleTON *shared = nil;
//    dispatch_once(&pred, ^{
//        shared = [[ARR_singleTON alloc] init];
//        shared.ARR_colection_data = [[NSMutableArray alloc]init];
//        shared.ARR_list_data = [[NSMutableArray alloc]init];
//        shared.Dictin_course = [[NSDictionary alloc]init];
//    });
//    return shared;
//}
//+(void) clearData {
//    ARR_singleTON *appData = [ARR_singleTON singleton];
//    [appData.ARR_colection_data removeAllObjects];
//    [appData.ARR_list_data removeAllObjects];
//}
//
//@end

@interface VC_courses ()<CLLocationManagerDelegate>
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    CLLocationManager *locationManager;
    
    UIColor *color_OLD;
    
    NSArray *ARR_map_data;
    //    NSDictionary *Dictin_course;
    //    NSMutableArray *ARR_colection_data,*ARR_list_data;
    
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;
//@property (nonatomic, retain) IBOutlet courseCollectionCELL *Collection_cell;

@end

@implementation VC_courses

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _Collection_course.hidden = YES;
    [self setup_VIEW];
    
    color_OLD = _VW_navBAR.backgroundColor;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.Collection_course registerNib:[UINib nibWithNibName:@"courseCollectionCELL~iPad" bundle:nil]  forCellWithReuseIdentifier:@"courseceldentifier"];
    }
    else
    {
        [self.Collection_course registerNib:[UINib nibWithNibName:@"courseCollectionCELL" bundle:nil]  forCellWithReuseIdentifier:@"courseceldentifier"];
    }
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

-(void) setup_VIEW
{
    [[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor:[UIColor blackColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: _tab_HOME.tintColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    UIView *topShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tab_HOME.bounds.size.width, 2)];
    CAGradientLayer *topShadow = [CAGradientLayer layer];
    topShadow.frame = CGRectMake(0, -1, _tab_HOME.bounds.size.width, 2);
    topShadow.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor], (id)[[UIColor blackColor] CGColor], nil];
    [topShadowView.layer insertSublayer:topShadow atIndex:0];
    
    [_tab_HOME addSubview:topShadowView];
    
    [_segment_bottom setSelectedSegmentIndex:1];
    [_tab_HOME setSelectedItem:[_tab_HOME.items objectAtIndex:1]];
    for (int i=0; i<[self.segment_bottom.subviews count]; i++)
    {
        [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
        if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
        {
            UIColor *tintcolor=[UIColor clearColor];
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            //            UIColor *tintcolor=[UIColor blueColor];
            //            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
    }
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    
    
    //    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 200, 22)];
    //    loadingLabel.backgroundColor = [UIColor clearColor];
    //    loadingLabel.textColor = [UIColor whiteColor];
    //    loadingLabel.adjustsFontSizeToFitWidth = YES;
    //    loadingLabel.textAlignment = NSTextAlignmentCenter;
    //    loadingLabel.text = @"Loading...";
    //
    //    [VW_overlay addSubview:loadingLabel];
    
    
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
    
    [self addSEgmentedControl];
    
    NSString *vw_stat = [[NSUserDefaults standardUserDefaults] valueForKey:@"SEARCH_STAT"];
    if (vw_stat) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SEARCH_STAT"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        _tbl_courses.hidden = YES;
        [self ADD_marker];
        
        //        if ([ARR_map_data count] != 0) {
        //            _Collection_course.hidden = NO;
        //        }
        //        else
        //        {
        //            _Collection_course.hidden = YES;
        //        }
    }
    else
    {
        [self add_GMAP];
    }
    
    
    _tbl_courses.estimatedRowHeight = 10.0;
    _tbl_courses.rowHeight = UITableViewAutomaticDimension;
    _tbl_courses.hidden = YES;
    
    _tbl_searchResults.estimatedRowHeight = 10.0;
    _tbl_searchResults.rowHeight = UITableViewAutomaticDimension;
    _tbl_searchResults.hidden = YES;
    
    _search_BAR.hidden = YES;
    [_BTN_close addTarget:self action:@selector(MET_nav_Close) forControlEvents:UIControlEventTouchUpInside];
    _BTN_close.hidden = YES;
    
    [_BTN_toggle setTitle:@"VIEW LIST\t" forState:UIControlStateNormal];
    [_BTN_toggle addTarget:self action:@selector(MET_toggle_TAP) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_search addTarget:self action:@selector(MET_serch_TAP) forControlEvents:UIControlEventTouchUpInside];
}

#pragma add _ Custom Segmentcontrol
-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    self.segmentedControl4.sectionTitles = @[@"  ALL  ", @" PUBLIC ",@"PRIVATE"];
    
    self.segmentedControl4.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1.0];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : _segment_bottom.tintColor,NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:15]};
    self.segmentedControl4.selectionIndicatorColor = _segment_bottom.tintColor;
    //    self.segmentedControl4.selectionIndicatorColor
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.selectionIndicatorHeight = 7.0f;
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl4];
}
#pragma mark - Segment Button IBACTION
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged) aaa", (long)segmentedControl4.selectedSegmentIndex);
    [self ADD_marker];
    //    switch (segmentedControl4.selectedSegmentIndex) {
    //        case 0:
    //            NSLog(@"Index 0");
    //            break;
    //
    //        case 1:
    //            NSLog(@"Index 1");
    //            break;
    //
    //        case 2:
    //            NSLog(@"Index 2");
    //            break;
    //
    //        default:
    //            break;
    //    }
}

#pragma mark - Tabbar deligate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"EVENTS"])
    {
        NSLog(@"Events selected");
        [_segment_bottom setSelectedSegmentIndex:0];
        for (int i=0; i<[self.segment_bottom.subviews count]; i++)
        {
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
            if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
            {
                UIColor *tintcolor=[UIColor clearColor];
                [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
            else
            {
                //            UIColor *tintcolor=[UIColor blueColor];
                //            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
        }
        [self performSegueWithIdentifier:@"eventssegueidentifier" sender:self];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(parse_listEvents_api) withObject:activityIndicatorView afterDelay:0.01];
    }
    else if ([item.title isEqualToString:@"COURSES"])
    {
        NSLog(@"COURSES selected");
        [_segment_bottom setSelectedSegmentIndex:1];
        for (int i=0; i<[self.segment_bottom.subviews count]; i++)
        {
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
            if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
            {
                UIColor *tintcolor=[UIColor clearColor];
                [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
            else
            {
                //            UIColor *tintcolor=[UIColor blueColor];
                //            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
        }
    }
    else
    {
        NSLog(@"ACCOUNT selected");
        [_segment_bottom setSelectedSegmentIndex:2];
        for (int i=0; i<[self.segment_bottom.subviews count]; i++)
        {
            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:nil];
            if (![[self.segment_bottom.subviews objectAtIndex:i]isSelected])
            {
                UIColor *tintcolor=[UIColor clearColor];
                [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
            else
            {
                //            UIColor *tintcolor=[UIColor blueColor];
                //            [[self.segment_bottom.subviews objectAtIndex:i] setTintColor:tintcolor];
            }
        }
        [self performSegueWithIdentifier:@"accountidentifier" sender:self];
    }
}

-(void) parse_listEvents_api
{
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    NSString *auth_TOK = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@events",SERVER_URL];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_TOK forHTTPHeaderField:@"auth-token"];
    //    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSString *STR_error;
        
        @try {
            STR_error = [dict valueForKey:@"error"];
            if (STR_error) {
                [self sessionOUT];
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception in courses %@",exception);
            [self sessionOUT];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"JsonEventlist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        [self performSegueWithIdentifier:@"logintohomeidentifier" sender:self];
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Interrupted" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

#pragma mark - Google Maps
-(void) add_GMAP
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 100.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    
    /* if ([CLLocationManager locationServicesEnabled]){
     
     NSLog(@"Location Services Enabled");
     
     if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
     alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
     message:@"To re-enable, please go to Settings and turn on Location Service for this app."
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];
     }
     }*/
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
    
    
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_getCOURSES) withObject:activityIndicatorView afterDelay:0.01];
    
    /* GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
     longitude:newLocation.coordinate.longitude
     zoom:6];
     //    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
     [self.mapView animateToCameraPosition:camera];*/
    
}

#pragma mark - UIButton Methords
-(void) MET_toggle_TAP
{
    if (_tbl_courses.hidden == YES)
    {
        [UIView transitionWithView:_mapView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _mapView.hidden = YES;
                        }
                        completion:NULL];
        
        [UIView transitionWithView:_Collection_course
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _Collection_course.hidden = YES;
                        }
                        completion:NULL];
        
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.4];
        _tbl_courses.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_tbl_courses cache:YES];
        [UIView commitAnimations];
        
        
        [UIView transitionWithView:_BTN_toggle duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [_BTN_toggle setTitle:@"VIEW MAP\t" forState:UIControlStateNormal];
            
        } completion:nil];
        
    }
    else
    {
        [UIView transitionWithView:_tbl_courses
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _tbl_courses.hidden = YES;
                        }
                        completion:NULL];
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.4];
        _mapView.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_mapView cache:YES];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"LeftFlip" context:nil];
        [UIView setAnimationDuration:0.4];
        _Collection_course.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_Collection_course cache:YES];
        [UIView commitAnimations];
        
        
        [UIView transitionWithView:_BTN_toggle duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [_BTN_toggle setTitle:@"VIEW LIST\t" forState:UIControlStateNormal];
            
        } completion:nil];
        
    }
}

-(void) MET_serch_TAP
{
    
    /* [UIView transitionWithView:_Lbl_navTITLE
     duration:0.4
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^{
     _Lbl_navTITLE.hidden = YES;
     }
     completion:NULL];
     
     [UIView transitionWithView:_BTN_search
     duration:0.4
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^{
     _BTN_search.hidden = YES;
     }
     completion:NULL];
     
     
     //    _VW_navBAR.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
     [UIView animateWithDuration:0.4 animations:^{
     _VW_navBAR.layer.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0].CGColor;
     } completion:NULL];
     
     [UIView beginAnimations:@"LeftFlip" context:nil];
     [UIView setAnimationDuration:0.4];
     _search_BAR.hidden = NO;
     [UIView setAnimationCurve:UIViewAnimationCurveLinear];
     [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_search_BAR cache:YES];
     [UIView commitAnimations];
     
     [UIView beginAnimations:@"LeftFlip" context:nil];
     [UIView setAnimationDuration:0.4];
     _BTN_close.hidden = NO;
     [UIView setAnimationCurve:UIViewAnimationCurveLinear];
     [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_BTN_close cache:YES];
     [UIView commitAnimations];
     
     [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];*/
    
    [self performSegueWithIdentifier:@"coursestosearch" sender:self];
}

-(void) MET_nav_Close
{
    [self.view endEditing:YES];
    [UIView beginAnimations:@"LeftFlip" context:nil];
    [UIView setAnimationDuration:0.4];
    _Lbl_navTITLE.hidden = NO;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_Lbl_navTITLE cache:YES];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"LeftFlip" context:nil];
    [UIView setAnimationDuration:0.4];
    _BTN_search.hidden = NO;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_BTN_search cache:YES];
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.4 animations:^{
        _VW_navBAR.layer.backgroundColor = color_OLD.CGColor;
    } completion:NULL];
    
    [UIView transitionWithView:_search_BAR
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _search_BAR.hidden = YES;
                    }
                    completion:NULL];
    
    [UIView transitionWithView:_BTN_close
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _BTN_close.hidden = YES;
                    }
                    completion:NULL];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Tableview Datasource/Deligate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ARR_singleTON singleton].ARR_list_data count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    Course_tblCELL *cell = (Course_tblCELL *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Course_tblCELL~iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"Course_tblCELL" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *temp_dictin = [[ARR_singleTON singleton].ARR_list_data objectAtIndex:indexPath.row];
    NSString *course_type = [temp_dictin valueForKey:@"course_type"];
    course_type = [course_type stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    course_type = [course_type stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    NSString *course_name = [temp_dictin valueForKey:@"name"];
    course_name = [course_name stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    course_name = [course_name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSString *address = [NSString stringWithFormat:@"%@, %@",[temp_dictin valueForKey:@"address"],[temp_dictin valueForKey:@"state_or_province"]];
    address = [address stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[[temp_dictin valueForKey:@"lat"] doubleValue] longitude:[[temp_dictin valueForKey:@"lng"] doubleValue]];
    CLLocation *LOC_main = [[CLLocation alloc] initWithLatitude:[[[NSUserDefaults standardUserDefaults] valueForKey:@"lat_STR"] doubleValue] longitude:[[[NSUserDefaults standardUserDefaults] valueForKey:@"long_STR"] doubleValue]];
    
    CLLocationDistance distance = [LOC_main distanceFromLocation:location2];
    
    NSLog(@"Distance in miles %f",distance * 0.000621371);
    
    
    CLLocationCoordinate2D c2D_from;
    c2D_from.latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lat_STR"] doubleValue];
    c2D_from.longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"long_STR"] doubleValue];
    
    CLLocationCoordinate2D c2D_to;
    c2D_to.latitude = [[temp_dictin valueForKey:@"lat"] doubleValue];
    c2D_to.longitude = [[temp_dictin valueForKey:@"lng"] doubleValue];
    
    
    NSNumber *new_distance = [self calculateDistanceInMetersBetweenCoord:c2D_from coord:c2D_to];
    double disT = ([new_distance doubleValue] * 0.000621371f) - 0.4f;
    
    NSString *miles = [NSString stringWithFormat:@"%.1f MILES",disT];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@ %@",course_name,address,miles];
    UIImage *newImage = [UIImage alloc];// = [cell.IMG_privacy.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    // If attributed text is supported (iOS6+)
    if ([cell.lbl_courseName respondsToSelector:@selector(setAttributedText:)]) {
        // Define general attributes for the entire text
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: cell.lbl_courseName.textColor,
                                  NSFontAttributeName: cell.lbl_courseName.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
        // Red text attributes
        //            UIColor *redColor = [UIColor redColor];
        NSRange cmp = [text rangeOfString:address];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        NSRange RAN_miles = [text rangeOfString:miles];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if ([course_type isEqualToString:@"private"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.09 green:0.64 blue:0.91 alpha:1.0]}
                                        range:RAN_miles];
                
                // UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //  [[UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0] set];
                // [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PRIVATE_1.png"];// UIGraphicsGetImageFromCurrentImageContext();
                // UIGraphicsEndImageContext();
                
            }
            else if ([course_type isEqualToString:@"public"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.67 blue:0.20 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PUBLIC.png"];//UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor whiteColor] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage new];//UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:15.0]}
                                    range:cmp];
            
        }
        else
        {
            if ([course_type isEqualToString:@"private"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.09 green:0.64 blue:0.91 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PRIVATE_1.png"]; //UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
                
            }
            else if ([course_type isEqualToString:@"public"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.67 blue:0.20 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PUBLIC.png"]; //UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor whiteColor] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage new]; //UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:12.0]}
                                    range:cmp];
        }
        cell.lbl_courseName.attributedText = attributedText;
    }
    else
    {
        cell.lbl_courseName.text = text;
    }
    
    
    cell.lbl_courseName.numberOfLines = 0;
    [cell.lbl_courseName sizeToFit];
    
    cell.IMG_privacy.image = newImage;
    //cell.lbl_privacy.text = @"";
    
    NSString *website_url = [temp_dictin valueForKey:@"course_image"];
    UIImage *IMG_placeholder;
    
    if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AL"]) {
        IMG_placeholder = [UIImage imageNamed:@"ALABAMA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AK"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ALASKA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AZ"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ARIZONA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AR"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ARKANSAS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"CA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"CALIFORNIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"CO"])
    {
        IMG_placeholder = [UIImage imageNamed:@"COLORADO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"CT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"CONNECTICUT"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"DE"])
    {
        IMG_placeholder = [UIImage imageNamed:@"DELAWARE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"FL"])
    {
        IMG_placeholder = [UIImage imageNamed:@"FLORIDA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"GA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"GEORGIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"HI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"HAWAII"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"ID"])
    {
        IMG_placeholder = [UIImage imageNamed:@"IDAHO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"IL"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ILLINOIS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"IN"])
    {
        IMG_placeholder = [UIImage imageNamed:@"INDIANA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"IA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"IOWA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"KS"])
    {
        IMG_placeholder = [UIImage imageNamed:@"KANSAS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"KY"])
    {
        IMG_placeholder = [UIImage imageNamed:@"KENTUCKY"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"LA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"LOUISIANA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"ME"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MAINE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MD"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MARYLAND"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"Massachusetts"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MICHIGAN"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MN"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MINNESOTA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MS"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MISSISSIPPI"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MO"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MISSOURI"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MONTANA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NE"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEBRASKA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NV"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEVADA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NH"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWHAMPSHIRE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NJ"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWJERSEY"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NM"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWMEXICO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NY"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWYORK"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NC"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NORTHCAROLINA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"ND"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NORTHDAKOTA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"OH"])
    {
        IMG_placeholder = [UIImage imageNamed:@"OHIO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"OK"])
    {
        IMG_placeholder = [UIImage imageNamed:@"OKLAHOMA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"OR"])
    {
        IMG_placeholder = [UIImage imageNamed:@"OREGON"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"PA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"PENNSYLVANIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"RI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"RHODEISLAND"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"SC"])
    {
        IMG_placeholder = [UIImage imageNamed:@"SOUTHCAROLINA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"SD"])
    {
        IMG_placeholder = [UIImage imageNamed:@"SOUTHDAKOTA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"TN"])
    {
        IMG_placeholder = [UIImage imageNamed:@"TENNESSEE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"TX"])
    {
        IMG_placeholder = [UIImage imageNamed:@"TEXAS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"UT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"UTAH"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"VT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"VERMONT"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"VA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"VIRGINIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WASHINGTON"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WV"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WESTVIRGINIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WISCONSIN"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WY"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WYOMING"];
    }
    else
    {
        IMG_placeholder = [UIImage imageNamed:@"WT_default_Course"];
    }
    
    
    website_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[temp_dictin valueForKey:@"course_image"]];
    [cell.IMG_courseimage sd_setImageWithURL:[NSURL URLWithString:website_url]
                            placeholderImage:IMG_placeholder];
    
    cell.IMG_courseimage.layer.cornerRadius = cell.IMG_courseimage.frame.size.width/2;
    cell.IMG_courseimage.layer.masksToBounds = YES;
    
    //    else
    //    {
    //
    //    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (NSNumber*)calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2 {
    NSInteger nRadius = 6371; // Earth's radius in Kilometers
    double latDiff = (coord2.latitude - coord1.latitude) * (M_PI/180);
    double lonDiff = (coord2.longitude - coord1.longitude) * (M_PI/180);
    double lat1InRadians = coord1.latitude * (M_PI/180);
    double lat2InRadians = coord2.latitude * (M_PI/180);
    double nA = pow ( sin(latDiff/2), 2 ) + cos(lat1InRadians) * cos(lat2InRadians) * pow ( sin(lonDiff/2), 2 );
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = nRadius * nC;
    // convert to meters
    return @(nD*1000);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *temp_dictin = [[ARR_singleTON singleton].ARR_list_data objectAtIndex:indexPath.row];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(get_selectedCourse:) withObject:[temp_dictin valueForKey:@"id"] afterDelay:0.01];
}

#pragma mark - UIsearchbar Deligates
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Uicollection view Datasource/ Deligate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[ARR_singleTON singleton].ARR_colection_data count];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_Collection_course.frame.size.width - 20, _Collection_course.frame.size.height - 20);
}
- (courseCollectionCELL *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    courseCollectionCELL *cell = (courseCollectionCELL*)[self.Collection_course dequeueReusableCellWithReuseIdentifier:@"courseceldentifier" forIndexPath:indexPath];
    
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    NSDictionary *temp_dictin = [[ARR_singleTON singleton].ARR_colection_data objectAtIndex:indexPath.row];
    NSString *course_type = [temp_dictin valueForKey:@"course_type"];
    course_type = [course_type stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    course_type = [course_type stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    NSString *course_name = [temp_dictin valueForKey:@"name"];
    course_name = [course_name stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    course_name = [course_name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSString *address = [NSString stringWithFormat:@"%@, %@",[temp_dictin valueForKey:@"address"],[temp_dictin valueForKey:@"state_or_province"]];
    
    
    CLLocationCoordinate2D c2D_from;
    c2D_from.latitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lat_STR"] doubleValue];
    c2D_from.longitude = [[[NSUserDefaults standardUserDefaults] valueForKey:@"long_STR"] doubleValue];
    
    CLLocationCoordinate2D c2D_to;
    c2D_to.latitude = [[temp_dictin valueForKey:@"lat"] doubleValue];
    c2D_to.longitude = [[temp_dictin valueForKey:@"lng"] doubleValue];
    
    
    
    NSNumber *new_distance = [self calculateDistanceInMetersBetweenCoord:c2D_from coord:c2D_to];
    double disT = ([new_distance doubleValue] * 0.000621371f) - 0.4f;
    
    NSString *miles = [NSString stringWithFormat:@"%.1f MILES",disT];
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@ %@",course_name,address,miles];
    UIImage *newImage = [UIImage alloc]; //= [cell.IMG_privacy.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    // If attributed text is supported (iOS6+)
    if ([cell.lbl_courseName respondsToSelector:@selector(setAttributedText:)]) {
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: cell.lbl_courseName.textColor,
                                  NSFontAttributeName: cell.lbl_courseName.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
        // Red text attributes
        //            UIColor *redColor = [UIColor redColor];
        NSRange cmp = [text rangeOfString:address];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        NSRange RAN_miles = [text rangeOfString:miles];
        
        //        NSLog(@"The font = %@",cell.l);
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if ([course_type isEqualToString:@"private"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.09 green:0.64 blue:0.91 alpha:1.0]}
                                        range:RAN_miles];
                
                // UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //  [[UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0] set];
                // [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PRIVATE_1.png"];// UIGraphicsGetImageFromCurrentImageContext();
                // UIGraphicsEndImageContext();
                
            }
            else if ([course_type isEqualToString:@"public"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.67 blue:0.20 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PUBLIC.png"];//UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor whiteColor] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage new];//UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:15.0]}
                                    range:cmp];
            
        }
        else
        {
            if ([course_type isEqualToString:@"private"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.09 green:0.64 blue:0.91 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PRIVATE_1.png"]; //UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
                
            }
            else if ([course_type isEqualToString:@"public"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.67 blue:0.20 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage imageNamed:@"PUBLIC.png"]; //UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:_Lbl_font_distance.font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.74 green:0.74 blue:0.75 alpha:1.0]}
                                        range:RAN_miles];
                
                //                UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
                //                [[UIColor whiteColor] set];
                //                [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
                newImage = [UIImage new]; //UIGraphicsGetImageFromCurrentImageContext();
                //                UIGraphicsEndImageContext();
            }
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:12.0]}
                                    range:cmp];
        }
        cell.lbl_courseName.attributedText = attributedText;
    }
    else
    {
        cell.lbl_courseName.text = text;
    }
    
    
    cell.lbl_courseName.numberOfLines = 0;
    [cell.lbl_courseName sizeToFit];
    
    cell.IMG_privacy.image = newImage;
    // cell.lbl_privacy.text = @"";
    
    NSString *website_url = [temp_dictin valueForKey:@"course_image"];
    UIImage *IMG_placeholder;
    
    if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AL"]) {
        IMG_placeholder = [UIImage imageNamed:@"ALABAMA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AK"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ALASKA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AZ"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ARIZONA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"AR"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ARKANSAS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"CA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"CALIFORNIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"CO"])
    {
        IMG_placeholder = [UIImage imageNamed:@"COLORADO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"CT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"CONNECTICUT"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"DE"])
    {
        IMG_placeholder = [UIImage imageNamed:@"DELAWARE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"FL"])
    {
        IMG_placeholder = [UIImage imageNamed:@"FLORIDA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"GA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"GEORGIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"HI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"HAWAII"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"ID"])
    {
        IMG_placeholder = [UIImage imageNamed:@"IDAHO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"IL"])
    {
        IMG_placeholder = [UIImage imageNamed:@"ILLINOIS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"IN"])
    {
        IMG_placeholder = [UIImage imageNamed:@"INDIANA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"IA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"IOWA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"KS"])
    {
        IMG_placeholder = [UIImage imageNamed:@"KANSAS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"KY"])
    {
        IMG_placeholder = [UIImage imageNamed:@"KENTUCKY"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"LA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"LOUISIANA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"ME"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MAINE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MD"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MARYLAND"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"Massachusetts"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MICHIGAN"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MN"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MINNESOTA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MS"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MISSISSIPPI"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MO"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MISSOURI"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"MT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"MONTANA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NE"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEBRASKA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NV"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEVADA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NH"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWHAMPSHIRE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NJ"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWJERSEY"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NM"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWMEXICO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NY"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NEWYORK"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"NC"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NORTHCAROLINA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"ND"])
    {
        IMG_placeholder = [UIImage imageNamed:@"NORTHDAKOTA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"OH"])
    {
        IMG_placeholder = [UIImage imageNamed:@"OHIO"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"OK"])
    {
        IMG_placeholder = [UIImage imageNamed:@"OKLAHOMA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"OR"])
    {
        IMG_placeholder = [UIImage imageNamed:@"OREGON"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"PA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"PENNSYLVANIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"RI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"RHODEISLAND"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"SC"])
    {
        IMG_placeholder = [UIImage imageNamed:@"SOUTHCAROLINA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"SD"])
    {
        IMG_placeholder = [UIImage imageNamed:@"SOUTHDAKOTA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"TN"])
    {
        IMG_placeholder = [UIImage imageNamed:@"TENNESSEE"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"TX"])
    {
        IMG_placeholder = [UIImage imageNamed:@"TEXAS"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"UT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"UTAH"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"VT"])
    {
        IMG_placeholder = [UIImage imageNamed:@"VERMONT"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"VA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"VIRGINIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WA"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WASHINGTON"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WV"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WESTVIRGINIA"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WI"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WISCONSIN"];
    }
    else if ([[temp_dictin valueForKey:@"state_or_province"] isEqualToString:@"WY"])
    {
        IMG_placeholder = [UIImage imageNamed:@"WYOMING"];
    }
    else
    {
        IMG_placeholder = [UIImage imageNamed:@"WT_default_Course"];
    }
    
    
    website_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[temp_dictin valueForKey:@"course_image"]];
    [cell.IMG_courseimage sd_setImageWithURL:[NSURL URLWithString:website_url]
                            placeholderImage:IMG_placeholder];
    
    cell.IMG_courseimage.layer.cornerRadius = cell.IMG_courseimage.frame.size.width/2;
    cell.IMG_courseimage.layer.masksToBounds = YES;
    
    
    //    else
    //    {
    //
    //    }
    
    
    
    return cell;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *temp_dictin = [[ARR_singleTON singleton].ARR_colection_data objectAtIndex:indexPath.row];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(get_selectedCourse:) withObject:[temp_dictin valueForKey:@"id"] afterDelay:0.01];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Collection_course.collectionViewLayout invalidateLayout];
    
    if ([self.tbl_courses respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tbl_courses setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tbl_courses respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tbl_courses setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    for (UIScrollView *scroll in _Collection_course.subviews) {
        scrollView = scroll;
    }
    
    if (scrollView) {
        float pageWidth = _Collection_course.frame.size.width - 10; // width + space
        
        float currentOffset = _Collection_course.contentOffset.x;
        float targetOffset = targetContentOffset->x;
        float newTargetOffset = 0;
        
        if (targetOffset > currentOffset)
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
        else
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
        
        if (newTargetOffset < 0)
            newTargetOffset = 0;
        else if (newTargetOffset > _Collection_course.contentSize.width)
            newTargetOffset = _Collection_course.contentSize.width;
        
        targetContentOffset->x = currentOffset;
        [_Collection_course setContentOffset:CGPointMake(newTargetOffset, _Collection_course.contentOffset.y) animated:YES];
    }
}

#pragma mark - API Calling
-(void) API_getCOURSES
{
    //    NSHTTPURLResponse *response = nil;
    //    NSError *error; //@"26.7307";// //@"-80.1001";//
    
    double latitude_val = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lat_STR"]] doubleValue];
    double longitude_val = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"long_STR"]] doubleValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude_val
                                                            longitude:longitude_val
                                                                 zoom:12];
    //    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self.mapView animateToCameraPosition:camera];
    self.mapView.settings.compassButton = YES;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@golfcourse/search_courses?lat=%@&lng=%@",SERVER_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"lat_STR"],[[NSUserDefaults standardUserDefaults] valueForKey:@"long_STR"]];
    
    
    course_service *API_course = [[course_service alloc]init];
    //    Dictin_course =
    ARR_singleTON *globals = [ARR_singleTON dictin];
    globals.Dictin_course = [API_course get_ID:urlGetuser];
    NSString *STR_error;
    
    @try {
        STR_error = [globals.Dictin_course valueForKey:@"error"];
        if (STR_error) {
            [self sessionOUT];
        }
        else
        {
            [self ADD_marker];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception in courses %@",exception);
        [self sessionOUT];
    }
    
    //    NSLog(@"Course url = \n%@",urlGetuser);
    
    /* NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:urlProducts];
     [request setHTTPMethod:@"GET"];
     [request setHTTPShouldHandleCookies:NO];
     NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setValue:auth_tok forHTTPHeaderField:@"auth-token"];
     
     NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
     if(aData)
     {
     [activityIndicatorView stopAnimating];
     VW_overlay.hidden = YES;
     
     NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
     
     
     
     
     [[NSUserDefaults standardUserDefaults] setValue:aData forKey:@"COURSESDICTIN"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     [self ADD_marker];
     }*/
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

-(void) get_selectedCourse:(NSString *)course_ID
{
    NSHTTPURLResponse *response = nil;
    NSError *error;
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@golfcourse/course_detail?id=%@",SERVER_URL,course_ID];
    
    NSLog(@"Course url = \n%@",urlGetuser);
    
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"GET"];
    [request setHTTPShouldHandleCookies:NO];
    NSString *auth_tok = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:auth_tok forHTTPHeaderField:@"auth-token"];
    
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSString *STR_error;
        
        @try {
            STR_error = [dict valueForKey:@"error"];
            if (STR_error) {
                [self sessionOUT];
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception in courses %@",exception);
            [self sessionOUT];
        }
        
        // NSMutableDictionary *temp_dictin = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:&error];
        //NSLog(@"Selected course \n%@",temp_dictin); //coursetocousedetail
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"CourseDetailcontent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"coursetocousedetail" sender:self];
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

#pragma mark - Add Marker on GMAP
-(void) ADD_marker
{
    //    NSError *error;
    //    NSMutableDictionary *temp_dictin = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"COURSESDICTIN"] options:kNilOptions error:&error];
    
    //    ARR_colection_data = [[NSMutableArray alloc] init];
    //    ARR_list_data = [[NSMutableArray alloc] init];
    
    UIImage *image_icon = [UIImage imageNamed:@"GOlf-Icon"];
    [ARR_singleTON clearData];
    ARR_singleTON *globals_dictin = [ARR_singleTON dictin];
    ARR_singleTON *globals = [ARR_singleTON singleton];
    
    NSLog(@"Dictin all coures %@",globals_dictin.Dictin_course);
    NSDictionary *all_course_arr = [globals_dictin.Dictin_course valueForKey:@"courses"];
    
    
    
    switch (_segmentedControl4.selectedSegmentIndex) {
        case 0:
            ARR_map_data = [all_course_arr valueForKey:@"all"];
            break;
            
        case 1:
            ARR_map_data = [all_course_arr valueForKey:@"public"];
            break;
            
        case 2:
            ARR_map_data = [all_course_arr valueForKey:@"private"];
            break;
            
        default:
            break;
    }
    [self.mapView clear];
    
    for (int i = 0; i < [ARR_map_data count]; i++)
    {
        NSDictionary *temp_dictin = [ARR_map_data objectAtIndex:i];
        
        double latitude_val = [[NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"lat"]] doubleValue];
        double longitude_val = [[NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"lng"]] doubleValue];
        
        if (i == 0) {
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude_val
                                                                    longitude:longitude_val
                                                                         zoom:12];
            [self.mapView animateToCameraPosition:camera];
            self.mapView.settings.compassButton = YES;
        }
        
        //        NSString *address = [NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"city"]];
        
        NSDictionary *store_val = [NSDictionary dictionaryWithObjectsAndKeys:[temp_dictin valueForKey:@"course_type"],@"course_type",[temp_dictin valueForKey:@"name"],@"name",[temp_dictin valueForKey:@"city"],@"address",[temp_dictin valueForKey:@"course_image"],@"course_image",[temp_dictin valueForKey:@"id"],@"id",[temp_dictin valueForKey:@"lat"],@"lat",[temp_dictin valueForKey:@"lng"],@"lng",[temp_dictin valueForKey:@"state_or_province"],@"state_or_province" ,nil];
        
        [globals.ARR_list_data addObject:store_val];
        [globals.ARR_colection_data addObject:store_val];
        
        NSError *err;
        NSDictionary *parameters = @{ @"index":[NSString stringWithFormat:@"%i",i]};
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude_val, longitude_val);
        marker.title = [temp_dictin valueForKey:@"name"];
        marker.userData = postData;
        marker.icon = image_icon;
        marker.map = _mapView;
    }
    
    if ([ARR_map_data count] != 0)
    {
        if (_tbl_courses.hidden == NO) {
            _Collection_course.hidden = YES;
        }
        else
        {
            _Collection_course.hidden = NO;
        }
        
        [_tbl_courses reloadData];
        [_Collection_course reloadData];
        [_Collection_course scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        _BTN_toggle.enabled = YES;
    }
    else
    {
        _BTN_toggle.enabled = NO;
        _tbl_courses.hidden = YES;
        _Collection_course.hidden = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No course found" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

#pragma mark - Google map Deligate
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSError *error;
    NSMutableDictionary *dict=(NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:marker.userData options:NSASCIIStringEncoding error:&error];
    //    NSLog(@"Marker tapped Gmap :%@",dict);
    [_Collection_course scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[dict valueForKey:@"index"] intValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    return NO;
}

#pragma mark - Dealloc
-(void)dealloc
{
    [super dealloc];
    _tbl_courses.delegate = nil;
    _Collection_course.delegate = nil;
    _mapView.delegate = nil;
    
}

#pragma mark - Session OUT
- (void) sessionOUT
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session out" message:@"In some other device same user logged in. Please login again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
    ViewController *tncView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [tncView setModalInPopover:YES];
    [tncView setModalPresentationStyle:UIModalPresentationFormSheet];
    [tncView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:tncView animated:YES completion:NULL];
}

@end

