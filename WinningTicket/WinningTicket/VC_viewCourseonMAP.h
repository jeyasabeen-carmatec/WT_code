//
//  VC_viewCourseonMAP.h
//  WinningTicket
//
//  Created by Test User on 05/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface VC_viewCourseonMAP : UIViewController <GMSMapViewDelegate>

@property (nonatomic, retain) IBOutlet GMSMapView *mapView;
-(IBAction)BTN_back:(id)sender;

@end
