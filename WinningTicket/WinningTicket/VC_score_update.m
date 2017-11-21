//
//  VC_score_update.m
//  WinningTicket
//
//  Created by Test User on 16/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_score_update.h"
#import "VC_score_collection.h"
#import "ARR_grossScore.h"

@interface VC_score_update ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *collection_arr;
    NSIndexPath *INDX_selecterdl;
    
    
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation VC_score_update

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
   

    NSLog(@"Data from prev vc %@",_STR_parSTR);
    
    collection_arr = [NSArray arrayWithObjects:@"12",@"11",@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"12",@"11",@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",nil];//
//    collection_dat = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"Eagle",@"Birdie",@"parrot",@"Bogey",@"DoubleBogey",@"",@"",@"",@"",@"",@"",@"",@"Eagle",@"Birdie",@"parrot",@"Bogey",@"DoubleBogey",@"",nil];//
    
    
    [_num_vw reloadData];
    [self update_frame];
    
   _num_vw.transform = CGAffineTransformMakeRotation(-M_PI);
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - COllection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
    
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VC_score_collection *cell = (VC_score_collection *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.num_label.text = [collection_arr objectAtIndex:indexPath.row];
    
    int par_VAL = [_STR_parSTR intValue];
    int hole_vAL = [[collection_arr objectAtIndex:indexPath.row] intValue];
    
    if (par_VAL-2 == hole_vAL)
    {
        cell.des_lbl.text = @"Eagle";
    }
    else if (par_VAL-1 == hole_vAL)
    {
        cell.des_lbl.text = @"Birdie";
    }
    else if (par_VAL == hole_vAL)
    {
        cell.des_lbl.text = @"Par";
    }
    else if (par_VAL + 1 == hole_vAL)
    {
        cell.des_lbl.text = @"Bogey";
    }
    else if (par_VAL +2 == hole_vAL)
    {
        cell.des_lbl.text = @"Double Bogey";
    }
    else
    {
        cell.des_lbl.text = @"";
    }
    
    //= [collection_dat objectAtIndex:indexPath.row];
    
    
    cell.transform = CGAffineTransformMakeRotation(-M_PI);
    
    
    
     return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return CGSizeMake(self.view.frame.size.width/3 -10 , 120);
        
    }
    else
    {
        return CGSizeMake(self.view.frame.size.width/3 -10 , 80);
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //cell.layer.cornerRadius = cell.contentView.frame.size.width / 2;
    cell.contentView.backgroundColor = _name_vw.backgroundColor;
    
    INDX_selecterdl = indexPath;
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(dismiss_COntroller) withObject:activityIndicatorView afterDelay:0.01];
}

-(void) dismiss_COntroller
{
    ARR_grossScore *store_ARR = [ARR_grossScore ARR_values];
    [store_ARR.ARR_score addObject:[collection_arr objectAtIndex:INDX_selecterdl.row]];
    
    if(_delegate && [_delegate respondsToSelector:@selector(get_SCORE:)])
    {
        [_delegate get_SCORE:[NSString stringWithFormat:@"%@",[collection_arr objectAtIndex:INDX_selecterdl.row]]]; //[ARR_grossScore ARR_values].ARR_score
    }
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.0];
}


#pragma mark - Button Actions
-(IBAction)BTN_back:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)update_frame
{
    [_num_vw layoutIfNeeded];
    float collection_ht =_num_vw.contentSize.height;
    
    
    CGRect myframe;
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
        float difference = collection_ht - (_num_vw.frame.origin.y + _num_vw.frame.size.height);
            myframe = _num_vw.frame;
            myframe.origin.y = - difference ;
            myframe.size.height = collection_ht;
          _num_vw.frame = myframe;
    
    
        if(myframe.origin.y < (_name_vw.frame.origin.y + _name_vw.frame.size.height))
        {
          
            myframe = _LBL_gross.frame ;
            myframe.origin.y = _name_vw.frame.origin.y+_name_vw.frame.size.height + 10;
            _LBL_gross.frame = myframe;
            myframe = _num_vw.frame;
            myframe.origin.y = _LBL_gross.frame.origin.y + _LBL_gross.frame.size.height + 20;
            myframe.size.height = self.view.frame.size.height - myframe.origin.y; //- (_LBL_gross .frame.origin.y + _name_vw.frame.size.height + _LBL_gross.frame.size.height);
            _num_vw.frame = myframe;

        }
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
       
        myframe = _LBL_gross.frame ;
        myframe.origin.y = _num_vw.frame.origin.y - 50;
        _LBL_gross.frame = myframe;
    }
    else
    {
        myframe = _LBL_gross.frame ;
        myframe.origin.y = _num_vw.frame.origin.y - 30;
        _LBL_gross.frame = myframe;
    }
    
    NSString *hole_name = @"Hole - 2";
    NSString *par_name = @"par - 4";
    NSString *Hole_text = [NSString stringWithFormat:@"%@ - %@",hole_name,par_name];
    
    if ([self.LBL_Heading respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName: self.LBL_Heading.textColor,
                                  NSFontAttributeName: self.LBL_Heading.font
                                  };
        NSMutableAttributedString *attributedText =
        [[NSMutableAttributedString alloc] initWithString:Hole_text
                                               attributes:attribs];
        
        // Red text attributes
        //            UIColor *redColor = [UIColor redColor];
        NSRange cmp = [Hole_text rangeOfString:par_name];// * Notice that usage of rangeOfString in this case may cause some bugs - I use it here only for demonstration
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:25.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"GothamMedium" size:19.0f],NSForegroundColorAttributeName : [UIColor blackColor]}
                                    range:cmp];

        }
        
        
        self.LBL_Heading.attributedText = attributedText;
    }
    else
    {
        self.LBL_Heading.text = Hole_text;
    }

        
       
        
    //}
   
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
