//
//  VC_courseDetail.h
//  WinningTicket
//
//  Created by Test User on 19/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface VC_courseDetail : UIViewController <GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource>

#pragma mark - Manage UI searchbar/Navigation bar
@property (nonatomic, retain) IBOutlet UILabel *Lbl_navTITLE;
@property (nonatomic, retain) IBOutlet UIButton *BTN_search;
@property (nonatomic, retain) IBOutlet UIButton *BTN_close;
@property (nonatomic, retain) IBOutlet UIButton *BTN_back;
@property (nonatomic, retain) IBOutlet UIView *VW_navBAR;
@property (nonatomic, retain) IBOutlet UISearchBar *search_BAR;
@property (nonatomic, retain) IBOutlet UITableView *tbl_searchResults;

#pragma mark - Google map Customisation
@property (nonatomic, retain) IBOutlet GMSMapView *mapView;

#pragma mark - Swipe gesture Customize
@property (nonatomic, retain) IBOutlet UIButton *BTN_swipeUP_DN;
@property (nonatomic, retain) IBOutlet UIScrollView *Scroll_contents;
@property (nonatomic, retain) IBOutlet UIView *VW_course;
@property (nonatomic, retain) IBOutlet UILabel *Lbl_course_name;
@property (nonatomic, retain) IBOutlet UIImageView *IMG_course_image;

#pragma mark - Content Set course Info
@property (nonatomic, retain) IBOutlet UIView *VW_course_Info;
@property (nonatomic, retain) IBOutlet UILabel *Lbl_address;
@property (nonatomic, retain) IBOutlet UILabel *Lbl_phone_num;
@property (nonatomic, retain) IBOutlet UILabel *Lbl_url;

#pragma mark - Corse Description
@property (nonatomic, retain) IBOutlet UIView *VW_couseDesc;
@property (nonatomic, retain) IBOutlet UIView *VW_subcouseDesc;
@property (nonatomic, retain) IBOutlet UILabel *Lbl_course_Description; //MORE 
@property (nonatomic, retain) IBOutlet UIButton *BTN_more;

#pragma mark - Nearby Courses
@property (nonatomic, retain) IBOutlet UIView *VW_nearby_courses;
@property (nonatomic, retain) IBOutlet UITableView *tbl_nearbycourse;

@end
