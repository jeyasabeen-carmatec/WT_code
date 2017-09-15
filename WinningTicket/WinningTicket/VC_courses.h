//
//  VC_courses.h
//  WinningTicket
//
//  Created by Test User on 02/03/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface VC_courses : UIViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate>

@property (nonatomic, retain) IBOutlet UITabBar *tab_HOME;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment_bottom;

#pragma mark - Google MAP
@property (nonatomic, retain) IBOutlet GMSMapView *mapView;

#pragma mark - List courses
@property (nonatomic, retain) IBOutlet UITableView *tbl_courses;

#pragma mark - Custom Segmented Control
@property (nonatomic, retain) IBOutlet UIView *VW_segment;

#pragma mark - Button Toggle Views
@property (nonatomic, retain) IBOutlet UIButton *BTN_toggle;

#pragma mark - Manage UI searchbar/Navigation bar
@property (nonatomic, retain) IBOutlet UILabel *Lbl_navTITLE;
@property (nonatomic, retain) IBOutlet UIButton *BTN_search;
@property (nonatomic, retain) IBOutlet UIButton *BTN_close;
@property (nonatomic, retain) IBOutlet UIView *VW_navBAR;
@property (nonatomic, retain) IBOutlet UISearchBar *search_BAR;
@property (nonatomic, retain) IBOutlet UITableView *tbl_searchResults;

#pragma mark - Swipe cells (collection view)
@property (nonatomic, retain) IBOutlet UICollectionView *Collection_course;

@end
