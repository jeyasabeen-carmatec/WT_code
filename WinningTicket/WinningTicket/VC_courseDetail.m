//
//  VC_courseDetail.m
//  WinningTicket
//
//  Created by Test User on 19/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_courseDetail.h"
#import "UIImageView+WebCache.h"
#import "WinningTicket_Universal-Swift.h"
#import <UIKit/UIView.h>

#import "ViewController.h"

@interface VC_courseDetail ()
{
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    
    float initial_ht,original_ht,button_ht,lbl_descrip_ht;
    CGRect initial_frame,original_frame,button_frame,map_VW_frame,scroll__VW_frame;
    float layout_height;
    
    NSMutableArray *ARR_near_courselist;
}

@end

@implementation VC_courseDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _Scroll_contents.delegate = self;
    
    _tbl_nearbycourse.estimatedRowHeight = 10.0;
    _tbl_nearbycourse.rowHeight = UITableViewAutomaticDimension;
    
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
    
    [self serialize_jsonData];
     [_BTN_more addTarget:self action:@selector(button_More_TApped) forControlEvents:UIControlEventTouchUpInside];
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
//    [_BTN_more setTitle:@"MORE " forState:UIControlStateNormal];
//    [self button_More_TApped];
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

#pragma mark - Uiview Customisation
-(void) setup_View
{
    VW_overlay.hidden = YES;
    
    _mapView.settings.compassButton = YES;
    _search_BAR.hidden = YES;
    _BTN_close.hidden = YES;
    [_BTN_back addTarget:self action:@selector(METH_back) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_search addTarget:self action:@selector(METH_search) forControlEvents:UIControlEventTouchUpInside];
    
   // _Scroll_contents.hidden = YES;
    
   /* CGRect BTN_frame = _BTN_swipeUP_DN.frame;
    BTN_frame.origin.x = _VW_course.frame.size.width/2 - _BTN_swipeUP_DN.frame.size.width/2;
    BTN_frame.origin.y = _VW_course.frame.origin.y - _BTN_swipeUP_DN.frame.size.height/2;
    _BTN_swipeUP_DN.frame = BTN_frame;*/
    
    _BTN_swipeUP_DN.layer.borderWidth = 1.0;
    _BTN_swipeUP_DN.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _BTN_swipeUP_DN.layer.cornerRadius = _BTN_swipeUP_DN.frame.size.width/2;
    _BTN_swipeUP_DN.layer.masksToBounds = YES;
    
    _IMG_course_image.layer.cornerRadius = _IMG_course_image.frame.size.width/2;
    _IMG_course_image.layer.masksToBounds = YES;
    
    [_BTN_swipeUP_DN addTarget:self action:@selector(METH_swipeUP_BTN) forControlEvents:UIControlEventAllEvents];
    lbl_descrip_ht = _Lbl_course_Description.frame.size.height;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}


#pragma mark - Uibutton Methords
-(void) METH_back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) METH_search
{
    [self performSegueWithIdentifier:@"courseDetailtosearch" sender:self];
}
-(void) METH_swipeUP_BTN
{
    NSLog(@"Tap detected ");
   // [self button_More_TApped];
    if ([_BTN_swipeUP_DN.titleLabel.text isEqualToString:@""])
    {
        CGRect frame_map = _mapView.frame;
        frame_map.size.height = _mapView.frame.size.height/4 + _VW_navBAR.frame.size.height + _BTN_swipeUP_DN.frame.size.height;
     
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _mapView.frame = frame_map;
                         }];
        
        CGRect frame_scroll = _Scroll_contents.frame;
        frame_scroll.origin.y = _VW_navBAR.frame.size.height + frame_map.size.height - _BTN_swipeUP_DN.frame.size.height;//_mapView.frame.origin.y;
        frame_scroll.size.height = [UIScreen mainScreen].bounds.size.height - frame_map.size.height;
        
        
        map_VW_frame = _mapView.frame;
        scroll__VW_frame = _Scroll_contents.frame;
   
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        _Scroll_contents.frame = frame_scroll;
        [UIView commitAnimations];
        
        float height_cell = 0.0;
        
        for (int i = 0; i < [ARR_near_courselist count]; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0] ;
            CGRect frame = [_tbl_nearbycourse rectForRowAtIndexPath:indexPath];
            NSLog(@"row height : %f", frame.size.height);
        
            height_cell = height_cell + frame.size.height;
        }
        
        CGRect frame_vw = _VW_nearby_courses.frame;
        frame_vw.size.height = _VW_nearby_courses.frame.origin.y + height_cell + _BTN_swipeUP_DN.frame.size.height/2 + 13;
        _VW_nearby_courses.frame = frame_vw;
        
        CGRect tbl_frame = _tbl_nearbycourse.frame;
        tbl_frame.size.height = _VW_nearby_courses.frame.origin.y + height_cell + _BTN_swipeUP_DN.frame.size.height/2 + 13;
        _tbl_nearbycourse.frame = tbl_frame;
        
        layout_height = _VW_nearby_courses.frame.origin.y + height_cell + _BTN_swipeUP_DN.frame.size.height/2 + 13; //30000;
        [_BTN_swipeUP_DN setTitle:@"" forState:UIControlStateNormal];
        
        
    }
    else
    {
        CGRect frame_map = _mapView.frame;
        frame_map.size.height = initial_ht;
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _mapView.frame = frame_map;
                         }];
        
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        [UIView setAnimationDuration:0.4f];
        _Scroll_contents.frame = initial_frame;
        [UIView commitAnimations];
        
        layout_height = initial_frame.size.height;
        [_BTN_swipeUP_DN setTitle:@"" forState:UIControlStateNormal];
    }
}


- (void) button_More_TApped
{
    CGRect frame_oold = _Lbl_course_Description.frame;
   
   if ([_BTN_more.titleLabel.text isEqualToString:@"MORE "])
    {
        frame_oold = _Lbl_course_Description.frame;
        _Lbl_course_Description.numberOfLines = 0;
        

        [_Lbl_course_Description sizeToFit];
        
        if (frame_oold.size.height < lbl_descrip_ht) {
            _Lbl_course_Description.frame = frame_oold;
        }
        else
        {
            NSLog(@"More button");
            
            float diff = _Lbl_course_Description.frame.size.height - lbl_descrip_ht;
            if (diff > 0) {
                layout_height = layout_height + diff;
            }
            
           
           
            CGRect VW_subcouseDesc_frame = _VW_subcouseDesc.frame;
            VW_subcouseDesc_frame.size.height = _Lbl_course_Description.frame.origin.y + _Lbl_course_Description.frame.size.height + 15;
            VW_subcouseDesc_frame.size.width = _Scroll_contents.frame.size.width;
            _VW_subcouseDesc.frame = VW_subcouseDesc_frame;
            
            CGRect BTN_more_frame = _BTN_more.frame;
            BTN_more_frame.origin.y = _Lbl_course_Description.frame.origin.y  - 20;
            _BTN_more.frame = BTN_more_frame;
            
            CGRect frame_setup = _VW_couseDesc.frame;
            frame_setup.origin.y = _VW_course_Info.frame.origin.y + _VW_course_Info.frame.size.height;
            frame_setup.size.height = _VW_subcouseDesc.frame.size.height + 15;
            frame_setup.size.width = _Scroll_contents.frame.size.width;
            _VW_couseDesc.frame = frame_setup;
            
            frame_setup = _VW_nearby_courses.frame;
            frame_setup.origin.y = _VW_couseDesc.frame.origin.y + _VW_couseDesc.frame.size.height;
            frame_setup.size.width = _Scroll_contents.frame.size.width;
            frame_setup.size.height =  [_tbl_nearbycourse contentSize].height;
            _VW_nearby_courses.frame = frame_setup;
            
            
            
            
            
            //_BTN_more.titleLabel.text = @"MORE ";
            
            [_BTN_more setTitle:@"MORE " forState:UIControlStateNormal];

            }
    }
    else
    {
        
         if ([_BTN_more.titleLabel.text isEqualToString:@"MORE "])
         {
              _Lbl_course_Description.numberOfLines = 4;
           
             if (frame_oold.size.height < lbl_descrip_ht) {
                 _Lbl_course_Description.frame = frame_oold;
             }
             else
             {
                 NSLog(@"More button");
                 
                 float diff = _Lbl_course_Description.frame.size.height - lbl_descrip_ht;
                 if (diff > 0) {
                     layout_height = layout_height - diff;
                 }
             }
             
             
         CGRect lab_frame = _Lbl_course_Description.frame;
        lab_frame.size.height = lbl_descrip_ht;
     //   lab_frame.size.width = _BTN_more.frame.origin.x+_BTN_more.frame.size.width;
        _Lbl_course_Description.frame = lab_frame;

       
        
        CGRect VW_subcouseDesc_frame = _VW_subcouseDesc.frame;
        VW_subcouseDesc_frame.size.height = _Lbl_course_Description.frame.origin.y + _Lbl_course_Description.frame.size.height + 15;
        VW_subcouseDesc_frame.size.width = _Scroll_contents.frame.size.width;
        _VW_subcouseDesc.frame = VW_subcouseDesc_frame;
             
        CGRect BTN_more_frame = _BTN_more.frame;
        BTN_more_frame.origin.y = _Lbl_course_Description.frame.origin.y + _Lbl_course_Description.frame.size.height;
        _BTN_more.frame = BTN_more_frame;
   
        
             
        CGRect frame_setup = _VW_couseDesc.frame;
        frame_setup.origin.y = _VW_course_Info.frame.origin.y + _VW_course_Info.frame.size.height;
        frame_setup.size.height = _VW_subcouseDesc.frame.size.height + 13;
        frame_setup.size.width = _Scroll_contents.frame.size.width;
        _VW_couseDesc.frame = frame_setup;
        
        frame_setup = _VW_nearby_courses.frame;
        frame_setup.origin.y = _VW_couseDesc.frame.origin.y + _VW_couseDesc.frame.size.height;
        frame_setup.size.width = _Scroll_contents.frame.size.width;
             frame_setup.size.height = _tbl_nearbycourse.frame.origin.y + [_tbl_nearbycourse contentSize].height;
        _VW_nearby_courses.frame = frame_setup;
             
      
       [_BTN_more setTitle:@"MORE " forState:UIControlStateNormal];
  
         }
    }
}

#pragma mark - API Integration
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
    [request setValue:auth_tok forHTTPHeaderField:@"auth_token"];
    
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
        
        [[NSUserDefaults standardUserDefaults] setObject:aData forKey:@"CourseDetailcontent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self serialize_jsonData];
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

#pragma mark - JsonSerialisation
-(void) serialize_jsonData
{
    [ARR_near_courselist removeAllObjects];
    NSError *error;
    NSMutableDictionary *temp_dictin = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetailcontent"] options:kNilOptions error:&error];
    
    [self setup_View];
    NSDictionary *selected_course = [temp_dictin valueForKey:@"course_detail"];
    NSDictionary *nearby_course = [temp_dictin valueForKey:@"nearby_courses"];
    ARR_near_courselist = [[NSMutableArray alloc]init];
//    ARR_near_courselist = [nearby_course valueForKey:@"list"];
    
    NSArray *temp_arr = [nearby_course valueForKey:@"list"];
    
    for (int i = 0; i < [temp_arr count]; i++)
    {
        NSDictionary *temp_dictin = [temp_arr objectAtIndex:i];
        
        NSString *address = [NSString stringWithFormat:@"%@, %@",[temp_dictin valueForKey:@"city"],[temp_dictin valueForKey:@"state_or_province"]];
        
        NSDictionary *store_val = [NSDictionary dictionaryWithObjectsAndKeys:[temp_dictin valueForKey:@"course_type"],@"course_type",[temp_dictin valueForKey:@"name"],@"name",address,@"address",[temp_dictin valueForKey:@"course_image"],@"course_image",[temp_dictin valueForKey:@"id"],@"id", nil];
        
        [ARR_near_courselist addObject:store_val];
    }
    
    
    NSLog(@"Value from VC couse detail nearby courses = \n%@",temp_dictin);
    
    NSString *selected_coursename = [selected_course valueForKey:@"name"];
    
    
    double latitude_val = [[NSString stringWithFormat:@"%@",[selected_course valueForKey:@"lat"]] doubleValue];
    double longitude_val = [[NSString stringWithFormat:@"%@",[selected_course valueForKey:@"lng"]] doubleValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude_val
                                                            longitude:longitude_val
                                                                 zoom:16];
    
    [self.mapView animateToCameraPosition:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude_val, longitude_val);
    marker.title = selected_coursename;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:0.41 green:0.07 blue:0.07 alpha:1.0]];
    marker.map = _mapView;

    NSString *image_url = [NSString stringWithFormat:@"%@",[selected_course valueForKey:@"course_image"]];
    if (image_url)
    {
        image_url = [image_url stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        image_url = [image_url stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        image_url = [image_url stringByReplacingOccurrencesOfString:@":" withString:@""];
        image_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,image_url];
        [_IMG_course_image sd_setImageWithURL:[NSURL URLWithString:image_url]
                       placeholderImage:[UIImage imageNamed:@"profile_pic.png"]];
//        _IMG_course_image.image = [UIImage imageNamed:@"GOlf-Icon"];
    }
    
    CGRect old_frame_lbl = _Lbl_course_name.frame;
    
    NSString *course_name = [selected_course valueForKey:@"name"];
    course_name = [course_name stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    course_name = [course_name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSString *address = [NSString stringWithFormat:@"%@, %@",[selected_course valueForKey:@"city"],[selected_course valueForKey:@"state_or_province"]];
    address = [address stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    address = [address stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    NSString *couse_type = [NSString stringWithFormat:@"%@",[[selected_course valueForKey:@"course_type"] uppercaseString]];
    NSString *one_char1 = @"0";
    NSString *one_char2 = @"8";
    
    
    NSString *empty_txt = @"sampleText";
    
    NSString *text = [NSString stringWithFormat:@"%@  %@%@%@\n%@\n%@",address,one_char1,couse_type,one_char2,empty_txt,course_name];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1.5];
   
    
    // If attributed text is supported (iOS6+)
    if ([_Lbl_course_name respondsToSelector:@selector(setAttributedText:)]) {
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: _Lbl_course_name.textColor,
                                  NSFontAttributeName: [UIFont fontWithName:@"GothamBold" size:15.0],
                                  NSBaselineOffsetAttributeName : @3.0f
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:text
                                               attributes:attribs];
        
        NSRange cmp = [text rangeOfString:address];
        NSRange rnge_coursename = [text rangeOfString:couse_type];
        NSRange range_one_char1 = [text rangeOfString:one_char1];
        NSRange range_one_char2 = [text rangeOfString:one_char2];
        NSRange range_one_empty = [text rangeOfString:empty_txt];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
            UIFont *small_text_font = [UIFont fontWithName:@"GothamBold" size:13.0];
//            paragraphStyle.lineHeightMultiple = 1.0f;
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:15.0]}
                                    range:cmp];
            
            if ([couse_type isEqualToString:@"PRIVATE"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:13.0],NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:rnge_coursename];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f} range:range_one_char2];
            }
            else if ([couse_type isEqualToString:@"PUBLIC"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:13.0],NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:rnge_coursename];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f} range:range_one_char2];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamBold" size:13.0],NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:rnge_coursename];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f} range:range_one_char2];
            }
            
            [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_one_empty];
        }
        else
        {
            UIFont *small_text_font = [UIFont fontWithName:@"GothamBold" size:9.0];
//            paragraphStyle.lineHeightMultiple = 1.0f;
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:12.0]}
                                    range:cmp];
            
            
            if ([couse_type isEqualToString:@"PRIVATE"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:rnge_coursename];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char2];
            }
            else if ([couse_type isEqualToString:@"PUBLIC"])
            {
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:rnge_coursename];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char2];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:rnge_coursename];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char1];
                [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor],NSBaselineOffsetAttributeName : @3.0f,NSParagraphStyleAttributeName : paragraphStyle} range:range_one_char2];
            }
            
            [attributedText setAttributes:@{NSFontAttributeName:small_text_font,NSBackgroundColorAttributeName: [UIColor whiteColor],NSForegroundColorAttributeName : [UIColor whiteColor]} range:range_one_empty];
        }
        
        
        _Lbl_course_name.attributedText = attributedText;
    }
    else
    {
        _Lbl_course_name.text = text;
    }
    
    _IMG_course_image.layer.cornerRadius = _IMG_course_image.frame.size.width/2;
    
    _Lbl_course_name.numberOfLines = 0;
    [_Lbl_course_name sizeToFit];
    
    CGRect frame_setup = _VW_course.frame;
    frame_setup.size.width = _Scroll_contents.frame.size.width;
    

//    CGRect frame_subview = _Lbl_course_name.frame;
    if (_Lbl_course_name.frame.size.height > _IMG_course_image.frame.size.height) {
        old_frame_lbl.origin.y = (_IMG_course_image.frame.origin.y + _IMG_course_image.frame.size.height)/2;
        _Lbl_course_name.frame = old_frame_lbl;
        frame_setup.size.height = _Lbl_course_name.frame.origin.y + _Lbl_course_name.frame.size.height + 10 + _BTN_swipeUP_DN.frame.size.height/2;
    }
    else
    {
        old_frame_lbl.origin.y = (_IMG_course_image.frame.origin.y + _IMG_course_image.frame.size.height)/2;
        _Lbl_course_name.frame = old_frame_lbl;
        if (_Lbl_course_name.frame.origin.y + _Lbl_course_name.frame.size.height + 10 > _IMG_course_image.frame.origin.y + _IMG_course_image.frame.size.height + 10) {
            frame_setup.size.height = _Lbl_course_name.frame.origin.y + _Lbl_course_name.frame.size.height + 10 + _BTN_swipeUP_DN.frame.size.height/2;
        }
        else
        {
            frame_setup.size.height = _IMG_course_image.frame.origin.y + _IMG_course_image.frame.size.height + 10 + _BTN_swipeUP_DN.frame.size.height/2;
        }
    }
    
    _VW_course.frame = frame_setup;
    
    
    frame_setup = _BTN_swipeUP_DN.frame;
    frame_setup.origin.y = 0;
    frame_setup.origin.x = _Scroll_contents.frame.size.width/2 - _BTN_swipeUP_DN.frame.size.width/2;
    _BTN_swipeUP_DN.frame = frame_setup;
    
    frame_setup = _VW_course_Info.frame;
    frame_setup.origin.y = _VW_course.frame.origin.y + _VW_course.frame.size.height;
    frame_setup.size.width = _Scroll_contents.frame.size.width;
    _VW_course_Info.frame = frame_setup;
    
    NSString *STR_address = [NSString stringWithFormat:@"%@, %@, %@, %@",[selected_course valueForKey:@"address"],[selected_course valueForKey:@"city"],[selected_course valueForKey:@"state_or_province"],[selected_course valueForKey:@"zip_code"]];
    _Lbl_address.text = STR_address;
    
    NSString *STR_phone_number = [selected_course valueForKey:@"phone_number"];
    if (STR_phone_number != (id)[NSNull null]) {
        _Lbl_phone_num.text = STR_phone_number;
    }
    else
    {
        _Lbl_phone_num.text = @"Not Mentioned";
    }
    
    NSString *STR_website_url = [selected_course valueForKey:@"website_url"];
    if (STR_website_url != (id)[NSNull null]) {
        _Lbl_url.text = STR_website_url;
    }
    else
    {
        _Lbl_url.text = @"Not Mentioned";
    }
    
    NSString *STR_description = [selected_course valueForKey:@"description"];
    if (STR_description != (id)[NSNull null]) {
        _Lbl_course_Description.text = STR_description;
    }
    else
    {
        _Lbl_course_Description.text = @"Not Mentioned";
    }
    if(_Lbl_course_Description.text.length > 70)
    {
        _BTN_more.hidden = NO;
        
    }
    else
    {
        _BTN_more.hidden = YES;
        [_Lbl_course_Description sizeToFit];
    }

    
    CGRect BTN_more_frame = _BTN_more.frame;
    BTN_more_frame.origin.y = _Lbl_course_Description.frame.origin.y + _Lbl_course_Description.frame.size.height;
    _BTN_more.frame = BTN_more_frame;
    
    CGRect VW_subcouseDesc_frame = _VW_subcouseDesc.frame;
    VW_subcouseDesc_frame.size.height = _BTN_more.frame.origin.y + _BTN_more.frame.size.height;
//    VW_subcouseDesc_frame.size.width = _Scroll_contents.frame.size.width;
    _VW_subcouseDesc.frame = VW_subcouseDesc_frame;

    frame_setup = _VW_couseDesc.frame;
    frame_setup.origin.y = _VW_course_Info.frame.origin.y + _VW_course_Info.frame.size.height;
    frame_setup.size.height = _VW_subcouseDesc.frame.size.height + 13;
    frame_setup.size.width = _Scroll_contents.frame.size.width;
    _VW_couseDesc.frame = frame_setup;
    
//    _tbl_nearbycourse.scrollEnabled = NO;
    [_tbl_nearbycourse layoutIfNeeded];
    
    
//    CGRect frame_tbl = _tbl_nearbycourse.frame;
//    frame_tbl.size.height = 250000.0f;
//    _tbl_nearbycourse.frame = frame_tbl;
    
    frame_setup = _VW_nearby_courses.frame;
    frame_setup.origin.y = _VW_couseDesc.frame.origin.y + _VW_couseDesc.frame.size.height;
    frame_setup.size.width = _Scroll_contents.frame.size.width;
    frame_setup.size.height = _tbl_nearbycourse.frame.origin.y + [_tbl_nearbycourse contentSize].height;
    _VW_nearby_courses.frame = frame_setup;
    
    CGRect frame_scroll = _Scroll_contents.frame;
    frame_scroll.origin.y = _VW_navBAR.frame.size.height + _mapView.frame.size.height - _VW_course.frame.size.height;
    frame_scroll.size.height = _VW_course.frame.size.height;
    frame_scroll.size.width = _Scroll_contents.frame.size.width;
    _Scroll_contents.frame = frame_scroll;
    
    [_Scroll_contents addSubview:_VW_course];
    [_Scroll_contents addSubview:_VW_course_Info];
    [_Scroll_contents addSubview:_VW_couseDesc];
    [_Scroll_contents addSubview:_VW_nearby_courses];
    
    initial_frame = _Scroll_contents.frame;
    initial_ht = _mapView.frame.size.height;
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];

    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width, layout_height);
}


#pragma mark - UITableview Datasource/Deligate
//ARR_near_courselist
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ARR_near_courselist count];
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
    
    @try {
        NSDictionary *temp_dictin = [ARR_near_courselist objectAtIndex:indexPath.row];
        NSString *course_type = [temp_dictin valueForKey:@"course_type"];
        course_type = [course_type stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        course_type = [course_type stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSString *course_name = [temp_dictin valueForKey:@"name"];
        course_name = [course_name stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        course_name = [course_name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSString *address_sel = [NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"address"]];
        
        //    NSString *address = address_sel;
        address_sel = [address_sel stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        address_sel = [address_sel stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSString *text = [NSString stringWithFormat:@"%@\n%@",course_name,address_sel];
        
        
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
            NSRange cmp = [text rangeOfString:address_sel];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Gotham-MediumItalic" size:15.0]}
                                        range:cmp];
            }
            else
            {
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
        //    [cell.lbl_courseName sizeToFit];
        
        cell.lbl_id.text = [NSString stringWithFormat:@"%@",[temp_dictin valueForKey:@"id"]];
        
        if ([course_type isEqualToString:@"private"])
        {
            UIImage *newImage = [cell.IMG_privacy.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
            [[UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.0] set];
            [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.IMG_privacy.image = newImage;
        }
        else if ([course_type isEqualToString:@"public"])
        {
            UIImage *newImage = [cell.IMG_privacy.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
            [[UIColor colorWithRed:0.00 green:0.65 blue:0.32 alpha:1.0] set];
            [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.IMG_privacy.image = newImage;
        }
        else
        {
            UIImage *newImage = [cell.IMG_privacy.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIGraphicsBeginImageContextWithOptions(cell.IMG_privacy.image.size, NO, newImage.scale);
            [[UIColor whiteColor] set];
            [newImage drawInRect:CGRectMake(0, 0, cell.IMG_privacy.image.size.width, newImage.size.height)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.IMG_privacy.image = newImage;
        }
        
        cell.lbl_privacy.text = [course_type uppercaseString];
        
        NSString *website_url = [temp_dictin valueForKey:@"course_image"];
        if (website_url)
        {
            website_url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,[temp_dictin valueForKey:@"course_image"]];
            [cell.IMG_courseimage sd_setImageWithURL:[NSURL URLWithString:website_url]
                                    placeholderImage:[UIImage imageNamed:@"profile_pic.png"]];
        }
        
        cell.IMG_courseimage.layer.cornerRadius = cell.IMG_courseimage.frame.size.width/2;
        cell.IMG_courseimage.layer.masksToBounds = YES;
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception in course detail table cell for row");
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame_map = _mapView.frame;
    frame_map.size.height = initial_ht;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         _mapView.frame = frame_map;
                     }];
    
    [UIView beginAnimations:@"bucketsOff" context:NULL];
    [UIView setAnimationDuration:0.4f];
    _Scroll_contents.frame = initial_frame;
    [UIView commitAnimations];
    
    layout_height = initial_frame.size.height;
    [_BTN_swipeUP_DN setTitle:@"" forState:UIControlStateNormal];
    
   /* NSLog(@"Cell selected at indexpath %ld",(long)indexPath.row);
    NSDictionary *temp_dictin = [ARR_near_courselist objectAtIndex:indexPath.row];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(get_selectedCourse:) withObject:[temp_dictin valueForKey:@"id"] afterDelay:0.01];*/
    
    Course_tblCELL *cell = (Course_tblCELL *)[_tbl_nearbycourse cellForRowAtIndexPath:indexPath];
    NSLog(@"Cell property = %@",cell.lbl_id.text);
    
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(get_selectedCourse:) withObject:cell.lbl_id.text afterDelay:0.01];
   //  [_BTN_more setTitle:@"MORE " forState:UIControlStateNormal];
    [self mydirection_map];
}

#pragma mark - Scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Scroll view called");
    
    CGFloat yVelocity = [scrollView.panGestureRecognizer velocityInView:scrollView].y;
    CGRect map_frame,scroll_frame;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([ARR_near_courselist count] - 1) inSection:0];
//    
//    CGRect myRect = [_tbl_nearbycourse rectForRowAtIndexPath:indexPath];
    if (yVelocity < 0)
    {
        NSLog(@"Up");
        if (_mapView.frame.size.height >= _mapView.frame.size.height/4)
        {
            
            map_frame = _mapView.frame;
            map_frame.size.height = 0;
           
            scroll_frame = _Scroll_contents.frame;
            scroll_frame.origin.y = _VW_navBAR.frame.origin.y + _VW_navBAR.frame.size.height;
            
           
            scroll_frame.size.height =[UIScreen mainScreen].bounds.size.height - map_frame.origin.y;
                       [UIView animateWithDuration:0.4f
                             animations:^{
                                 _mapView.frame = map_frame;
                                 _Scroll_contents.frame = scroll_frame;
                             }];
            [UIView beginAnimations:@"bucketsOff" context:NULL];
            [UIView commitAnimations];
            
//            float height_cell = 0.0;
//            
//            for (int i = 0; i < [ARR_near_courselist count]; i++)
//            {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0] ;
//                CGRect frame = [_tbl_nearbycourse rectForRowAtIndexPath:indexPath];
//                NSLog(@"row height : %f", frame.size.height);
//                
//                height_cell = height_cell + frame.size.height;
//            }
//            CGRect frame_vw = _VW_nearby_courses.frame;
//            frame_vw.size.height = _VW_nearby_courses.frame.origin.y + height_cell + _BTN_swipeUP_DN.frame.size.height/2 + 13;
//            _VW_nearby_courses.frame = frame_vw;
//            
//            CGRect tbl_frame = _tbl_nearbycourse.frame;
//            tbl_frame.size.height = _VW_nearby_courses.frame.origin.y + height_cell + _BTN_swipeUP_DN.frame.size.height/2 + 13;
//            _tbl_nearbycourse.frame = tbl_frame;
//  
//            layout_height = [UIScreen mainScreen].bounds.size.height + height_cell - scroll_frame.origin.y ;//30000;

           
        }
    }
    else if (yVelocity > 0)
    {
        NSLog(@"Down");
        if (_Scroll_contents.frame.origin.y <= (_VW_navBAR.frame.origin.y + _VW_navBAR.frame.size.height))
        {
            scroll_frame = _Scroll_contents.frame;
            scroll_frame.origin.y = scroll__VW_frame.origin.y;
            
            
   scroll_frame.size.height = [UIScreen mainScreen].bounds.size.height - scroll_frame.origin.y;
            
            
        [UIView animateWithDuration:0.4f
                         animations:^{
                             _mapView.frame = map_VW_frame;
                             _Scroll_contents.frame = scroll_frame;
                         }];
        
        
        [UIView beginAnimations:@"bucketsOff" context:NULL];
        // layout_height = _Scroll_contents.frame.size.height;
        [UIView commitAnimations];
        
          
     
        }
    }
}
#pragma mark swipe gestures
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe
{
     CGRect map_frame,scroll_frame;
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"Swipe Up");
        
        if (_mapView.frame.size.height <= _mapView.frame.size.height/4)
        {
            
            map_frame = _mapView.frame;
            map_frame.size.height = 0;
            scroll_frame = _Scroll_contents.frame;
            scroll_frame.origin.y = _VW_navBAR.frame.origin.y + _VW_navBAR.frame.size.height;
            scroll_frame.size.height = [UIScreen mainScreen].bounds.size.height - scroll_frame.origin.y;
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 _mapView.frame = map_frame;
                                 _Scroll_contents.frame = scroll_frame;
                             }];
            
            
            [UIView beginAnimations:@"bucketsOff" context:NULL];
            // [UIView setAnimationDuration:0.25];
            // _scroll_content.frame = frame_scroll;
            [UIView commitAnimations];
        }

    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        if (_Scroll_contents.frame.origin.y >= (_VW_navBAR.frame.origin.y + _VW_navBAR.frame.size.height))
        {
            scroll_frame = _Scroll_contents.frame;
            scroll_frame.origin.y = scroll__VW_frame.origin.y;
           scroll_frame.size.height = [UIScreen mainScreen].bounds.size.height - scroll_frame.origin.y;
            
            
            [UIView animateWithDuration:0.4f
                             animations:^{
                                 _mapView.frame = map_VW_frame;
                                 _Scroll_contents.frame = scroll_frame;
                             }];
            
            
            [UIView beginAnimations:@"bucketsOff" context:NULL];
            // [UIView setAnimationDuration:0.25];
            // _scroll_content.frame = frame_scroll;
            [UIView commitAnimations];
            
        }
    }
}

-(void)mydirection_map
{
      if ([_BTN_more.titleLabel.text isEqualToString:@"MORE "])
    {
          CGRect frame_oold = _Lbl_course_Description.frame;
  
        
        _Lbl_course_Description.numberOfLines = 4;
        //  [_Lbl_course_Description sizeToFit];
        
        if (frame_oold.size.height > lbl_descrip_ht)
        {
            _Lbl_course_Description.frame = frame_oold;
        }
        else
        {
            NSLog(@"More button");
            
            float diff = _Lbl_course_Description.frame.size.height - lbl_descrip_ht;
            if (diff > 0)
            {
                layout_height = layout_height + diff;
            }
        }
        
        CGRect lab_frame = _Lbl_course_Description.frame;
        lab_frame.size.height = lbl_descrip_ht;
     //   lab_frame.size.width = _BTN_more.frame.origin.x+_BTN_more.frame.size.width;
        _Lbl_course_Description.frame = lab_frame;
        
        
        
        CGRect VW_subcouseDesc_frame = _VW_subcouseDesc.frame;
        VW_subcouseDesc_frame.size.height = _Lbl_course_Description.frame.origin.y + _Lbl_course_Description.frame.size.height + 15;
         VW_subcouseDesc_frame.size.width = _Scroll_contents.frame.size.width;
        _VW_subcouseDesc.frame = VW_subcouseDesc_frame;
        
        CGRect BTN_more_frame = _BTN_more.frame;
        BTN_more_frame.origin.y = _Lbl_course_Description.frame.origin.y + _Lbl_course_Description.frame.size.height;
        _BTN_more.frame = BTN_more_frame;
        
        
        
        CGRect frame_setup = _VW_couseDesc.frame;
        frame_setup.origin.y = _VW_course_Info.frame.origin.y + _VW_course_Info.frame.size.height;
        frame_setup.size.height = _VW_subcouseDesc.frame.size.height + 13;
        frame_setup.size.width = _Scroll_contents.frame.size.width;
        _VW_couseDesc.frame = frame_setup;
        
        frame_setup = _VW_nearby_courses.frame;
        frame_setup.origin.y = _VW_couseDesc.frame.origin.y + _VW_couseDesc.frame.size.height;
        frame_setup.size.width = _Scroll_contents.frame.size.width;
        frame_setup.size.height = _tbl_nearbycourse.frame.origin.y + [_tbl_nearbycourse contentSize].height;
        _VW_nearby_courses.frame = frame_setup;
        
        

        
        [_BTN_more setTitle:@"MORE " forState:UIControlStateNormal];
       
    }

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
