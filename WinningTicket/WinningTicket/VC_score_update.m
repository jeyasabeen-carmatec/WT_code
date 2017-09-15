//
//  VC_score_update.m
//  WinningTicket
//
//  Created by Test User on 16/08/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_score_update.h"
#import "VC_score_collection.h"

@interface VC_score_update ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *collection_arr,*collection_dat;
}

@end

@implementation VC_score_update

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
  

    
    collection_arr = [NSArray arrayWithObjects:@"12",@"11",@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"12",@"11",@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",nil];//
    collection_dat = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"Eagle",@"Birdie",@"parrot",@"Bogey",@"DoubleBogey",@"",@"",@"",@"",@"",@"",@"",@"Eagle",@"Birdie",@"parrot",@"Bogey",@"DoubleBogey",@"",nil];//
    
    
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
    return 15;
    
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VC_score_collection *cell = (VC_score_collection *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.num_label.text = [collection_arr objectAtIndex:indexPath.row];
    cell.des_lbl.text = [collection_dat objectAtIndex:indexPath.row];
    
    
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
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
  //  cell.layer.cornerRadius = cell.contentView.frame.size.width / 2;
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
